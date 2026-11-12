import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../audit/audit.dart';
import '../generated/protocol.dart';
import '../health/health_store.dart';
import 'pseudonym.dart';

/// Export format version, written into every export.
const exportFormat = 'parla-export-v1';

/// The user's rights over their own data (privacy centre, M-27 to M-33).
class AccountEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Everything Parla stores about the caller, as JSON (GDPR Art. 15 and 20,
  /// checklist EXP-1). Health answers are decrypted for the export.
  ///
  /// The file is built on request and returned directly; it is never stored
  /// on the server.
  Future<String> exportMyData(Session session) async {
    final userId = session.authenticated!.authUserId;

    final profile = await MemberProfile.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    final emails = await EmailAccount.db.find(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    final consents = await ConsentRecord.db.find(
      session,
      where: (t) => t.authUserId.equals(userId),
      orderBy: (t) => t.createdAt,
    );
    final quiz = await QuizAnswer.db.find(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    final health = await HealthStore.of(session).read(session, userId);

    await writeAudit(
      session,
      actorId: userId,
      actorRole: AuditActor.user,
      action: 'account.exported',
      objectType: 'account',
    );

    return const JsonEncoder.withIndent('  ').convert({
      'format': exportFormat,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'account': {
        'id': userId.toString(),
        'emails': [for (final e in emails) e.email],
      },
      'profile': profile == null
          ? null
          : {
              'birthYear': profile.birthYear,
              'countryCode': profile.countryCode,
              'language': profile.language,
              'createdAt': profile.createdAt.toIso8601String(),
            },
      'consents': [
        for (final c in consents)
          {
            'type': c.consentType.name,
            'granted': c.granted,
            'textVersion': c.textVersion,
            'language': c.language,
            'source': c.source,
            'at': c.createdAt.toIso8601String(),
          },
      ],
      'quizAnswers': [
        for (final a in quiz)
          {
            'question': a.questionId,
            'options': a.optionIds,
            'contentVersion': a.contentVersion,
            'at': a.answeredAt.toIso8601String(),
          },
      ],
      'healthAnswers': [
        for (final a in health.values)
          {
            'question': a.questionId,
            'options': a.optionIds,
            'declined': a.declined,
          },
      ],
    });
  }

  /// Deletes the caller's account (checklist DEL-1, DEL-2).
  ///
  /// In one transaction: health data and its key (crypto-shredding), quiz
  /// answers, profile and the sign-in account with its sessions and tokens
  /// are deleted. Consent records and audit rows are kept as proof but
  /// their user id is replaced by a pseudonym.
  Future<void> deleteAccount(Session session) async {
    final userId = session.authenticated!.authUserId;
    final pseudonym = await pseudonymFor(session, userId);

    await session.db.transaction((transaction) async {
      await HealthStore.of(
        session,
      ).erase(session, userId, transaction: transaction);
      await QuizAnswer.db.deleteWhere(
        session,
        where: (t) => t.authUserId.equals(userId),
        transaction: transaction,
      );
      await MemberProfile.db.deleteWhere(
        session,
        where: (t) => t.authUserId.equals(userId),
        transaction: transaction,
      );

      final consents = await ConsentRecord.db.find(
        session,
        where: (t) => t.authUserId.equals(userId),
        transaction: transaction,
      );
      for (final c in consents) {
        await ConsentRecord.db.updateRow(
          session,
          c.copyWith(authUserId: pseudonym),
          transaction: transaction,
        );
      }
      final audit = await AuditLogEntry.db.find(
        session,
        where: (t) => t.actorId.equals(userId),
        transaction: transaction,
      );
      for (final entry in audit) {
        await AuditLogEntry.db.updateRow(
          session,
          entry.copyWith(actorId: pseudonym),
          transaction: transaction,
        );
      }

      final alreadyDeleted = await DeletedAccount.db.findFirstRow(
        session,
        where: (t) => t.pseudonym.equals(pseudonym),
        transaction: transaction,
      );
      if (alreadyDeleted == null) {
        await DeletedAccount.db.insertRow(
          session,
          DeletedAccount(
            pseudonym: pseudonym,
            deletedAt: DateTime.now().toUtc(),
          ),
          transaction: transaction,
        );
      }
      await writeAudit(
        session,
        actorId: pseudonym,
        actorRole: AuditActor.user,
        action: 'account.deleted',
        objectType: 'account',
        transaction: transaction,
      );

      try {
        await const AuthUsers().delete(
          session,
          authUserId: userId,
          transaction: transaction,
        );
      } on AuthUserNotFoundException {
        // Already gone (for example a retried request): nothing to delete.
      }
    });

    // Ends the user's open connections. Short-lived access tokens expire on
    // their own; refresh tokens were deleted with the account.
    await session.messages.authenticationRevoked(
      userId.toString(),
      RevokedAuthenticationUser(),
    );
  }
}
