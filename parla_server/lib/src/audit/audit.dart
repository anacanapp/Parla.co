import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Actor roles written to the audit log.
abstract final class AuditActor {
  static const user = 'user';
}

/// Appends one audit entry (checklist AUD-1).
///
/// Pass ids only. Never pass health answers, emails or tokens (AUD-3).
Future<void> writeAudit(
  Session session, {
  required UuidValue? actorId,
  required String actorRole,
  required String action,
  required String objectType,
  String? objectId,
  Transaction? transaction,
}) async {
  await AuditLogEntry.db.insertRow(
    session,
    AuditLogEntry(
      actorId: actorId,
      actorRole: actorRole,
      action: action,
      objectType: objectType,
      objectId: objectId,
      createdAt: DateTime.now().toUtc(),
    ),
    transaction: transaction,
  );
}
