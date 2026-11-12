import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Retention periods (data map; proposals pending legal review).
abstract final class Retention {
  /// Audit log rows (AUD-4).
  static const auditLog = Duration(days: 365);

  /// Consent records of a deleted account, counted from the deletion.
  static const consentAfterDeletion = Duration(days: 3 * 365);
}

/// What one retention run deleted.
class RetentionResult {
  const RetentionResult({
    required this.auditRows,
    required this.consentRows,
    required this.deletedAccounts,
  });

  final int auditRows;
  final int consentRows;
  final int deletedAccounts;
}

/// Deletes everything past its retention period (RET-1, RET-2). Safe to run
/// any number of times and on several servers at once.
Future<RetentionResult> runRetention(Session session, {DateTime? now}) async {
  final today = (now ?? DateTime.now()).toUtc();
  return session.db.transaction((transaction) async {
    final audit = await AuditLogEntry.db.deleteWhere(
      session,
      where: (t) => t.createdAt < today.subtract(Retention.auditLog),
      transaction: transaction,
    );

    final expired = await DeletedAccount.db.find(
      session,
      where: (t) =>
          t.deletedAt < today.subtract(Retention.consentAfterDeletion),
      transaction: transaction,
    );
    var consents = 0;
    for (final account in expired) {
      consents += (await ConsentRecord.db.deleteWhere(
        session,
        where: (t) => t.authUserId.equals(account.pseudonym),
        transaction: transaction,
      )).length;
      await DeletedAccount.db.deleteRow(
        session,
        account,
        transaction: transaction,
      );
    }

    return RetentionResult(
      auditRows: audit.length,
      consentRows: consents,
      deletedAccounts: expired.length,
    );
  });
}

/// Runs [runRetention] shortly after start-up and then once a day.
Timer scheduleDailyRetention(Serverpod pod) {
  Future<void> runOnce() async {
    final session = await pod.createSession(enableLogging: true);
    try {
      final result = await runRetention(session);
      session.log(
        'Retention: ${result.auditRows} audit rows, '
        '${result.consentRows} consent rows, '
        '${result.deletedAccounts} deleted accounts expired.',
        level: LogLevel.info,
      );
    } on Object catch (error, stackTrace) {
      session.log(
        'Retention run failed',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
      );
    } finally {
      await session.close();
    }
  }

  Timer(const Duration(minutes: 1), runOnce);
  return Timer.periodic(const Duration(days: 1), (_) => runOnce());
}
