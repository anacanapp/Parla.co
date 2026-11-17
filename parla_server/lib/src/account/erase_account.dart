import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../audit/audit.dart';
import '../generated/protocol.dart';
import '../health/health_store.dart';
import '../stats/activity.dart';
import '../support/support.dart';
import 'pseudonym.dart';

/// Deletes the account [userId] (checklist DEL-1, DEL-2), by the user in
/// the app or, on the user's request, by an admin ([staffActorId]).
///
/// In one transaction: health data, own routines, care list, sport and
/// nutrition documents and their key (crypto-shredding), quiz answers,
/// profile, today's activity marks and the sign-in account with its
/// sessions and tokens are deleted. Consent records and audit rows are kept
/// as proof but the user's id in them is replaced by a pseudonym.
Future<UuidValue> eraseAccount(
  Session session,
  UuidValue userId, {
  UuidValue? staffActorId,
}) async {
  final pseudonym = await pseudonymFor(session, userId);

  await session.db.transaction((transaction) async {
    await HealthStore.of(
      session,
    ).erase(session, userId, transaction: transaction);
    // A staff member's panel access ends with the account.
    await StaffSession.db.deleteWhere(
      session,
      where: (t) => t.authUserId.equals(userId),
      transaction: transaction,
    );
    await StaffMember.db.deleteWhere(
      session,
      where: (t) => t.authUserId.equals(userId),
      transaction: transaction,
    );
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
    await eraseActivityMarks(session, userId, transaction: transaction);
    await eraseSupport(session, userId, transaction: transaction);
    await DeviceToken.db.deleteWhere(
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
    // The user as actor, and as the object of staff actions (for example
    // an admin looking the account up).
    final audit = await AuditLogEntry.db.find(
      session,
      where: (t) =>
          t.actorId.equals(userId) | t.objectId.equals(userId.toString()),
      transaction: transaction,
    );
    for (final entry in audit) {
      await AuditLogEntry.db.updateRow(
        session,
        entry.copyWith(
          actorId: entry.actorId == userId ? pseudonym : entry.actorId,
          objectId: entry.objectId == userId.toString()
              ? pseudonym.toString()
              : entry.objectId,
        ),
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
        DeletedAccount(pseudonym: pseudonym, deletedAt: DateTime.now().toUtc()),
        transaction: transaction,
      );
    }
    await writeAudit(
      session,
      actorId: staffActorId ?? pseudonym,
      actorRole: staffActorId == null ? AuditActor.user : AuditActor.staff,
      action: staffActorId == null
          ? 'account.deleted'
          : 'account.deleted_on_request',
      objectType: 'account',
      objectId: staffActorId == null ? null : pseudonym.toString(),
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
  return pseudonym;
}
