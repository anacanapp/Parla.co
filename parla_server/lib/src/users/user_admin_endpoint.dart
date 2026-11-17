import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../account/erase_account.dart';
import '../audit/audit.dart';
import '../consent/consent_endpoint.dart';
import '../generated/protocol.dart';
import '../staff/staff_guard.dart';

/// Error codes of the users section.
abstract final class UserAdminErrors {
  static const notFound = 'users.not_found';
  static const confirmMismatch = 'users.confirm_mismatch';
  static const isStaff = 'users.is_staff';
}

/// App accounts in the admin panel (admins only): look one up by its exact
/// email, block or unblock it, or delete it on the user's request. Shows
/// account data and consent decisions only, never health data. Every
/// look-up and action is audited (ids only).
class UserAdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The account with exactly this email, or `null`. There is no list or
  /// partial search on purpose.
  Future<UserAdminView?> find(Session session, String email) async {
    final staff = await requireStaff(session, roles: {StaffRole.admin});
    final clean = email.trim().toLowerCase();
    if (clean.isEmpty || clean.length > 254) return null;
    final account = await EmailAccount.db.findFirstRow(
      session,
      where: (t) => t.email.equals(clean),
    );
    if (account == null) return null;
    await writeAudit(
      session,
      actorId: staff.authUserId,
      actorRole: AuditActor.staff,
      action: 'user.viewed',
      objectType: 'account',
      objectId: account.authUserId.toString(),
    );
    return _view(session, account.authUserId, account.email);
  }

  /// Blocks or unblocks sign-in. Blocking also ends the user's sessions;
  /// no data is deleted.
  Future<UserAdminView> setBlocked(
    Session session,
    UuidValue userId,
    bool blocked,
  ) async {
    final staff = await requireStaff(session, roles: {StaffRole.admin});
    final email = await _email(session, userId);
    if (await StaffMember.db.findFirstRow(
          session,
          where: (t) => t.authUserId.equals(userId),
        ) !=
        null) {
      // Staff accounts are managed in the staff section.
      throw ParlaException(code: UserAdminErrors.isStaff);
    }
    await const AuthUsers().update(
      session,
      authUserId: userId,
      blocked: blocked,
    );
    if (blocked) {
      await _revokeTokens(session, userId);
      await session.messages.authenticationRevoked(
        userId.toString(),
        RevokedAuthenticationUser(),
      );
    }
    await writeAudit(
      session,
      actorId: staff.authUserId,
      actorRole: AuditActor.staff,
      action: blocked ? 'user.blocked' : 'user.unblocked',
      objectType: 'account',
      objectId: userId.toString(),
    );
    return _view(session, userId, email);
  }

  /// Deletes the account on the user's request (for example by email), with
  /// the same deletion as in the app. [confirmEmail] must repeat the
  /// account's email.
  Future<void> deleteOnRequest(
    Session session,
    UuidValue userId,
    String confirmEmail,
  ) async {
    final staff = await requireStaff(session, roles: {StaffRole.admin});
    final email = await _email(session, userId);
    if (email.toLowerCase() != confirmEmail.trim().toLowerCase()) {
      throw ParlaException(code: UserAdminErrors.confirmMismatch);
    }
    if (await StaffMember.db.findFirstRow(
          session,
          where: (t) => t.authUserId.equals(userId),
        ) !=
        null) {
      throw ParlaException(code: UserAdminErrors.isStaff);
    }
    await eraseAccount(session, userId, staffActorId: staff.authUserId);
  }

  Future<String> _email(Session session, UuidValue userId) async {
    final account = await EmailAccount.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    if (account == null) throw ParlaException(code: UserAdminErrors.notFound);
    return account.email;
  }

  Future<void> _revokeTokens(Session session, UuidValue userId) async {
    try {
      await AuthServices.instance.tokenManager.revokeAllTokens(
        session,
        authUserId: userId,
      );
    } on StateError {
      // Auth services are not set up (unit tests): nothing to revoke.
    }
  }

  Future<UserAdminView> _view(
    Session session,
    UuidValue userId,
    String email,
  ) async {
    final user = await AuthUser.db.findById(session, userId);
    final profile = await MemberProfile.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    final staff = await StaffMember.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    return UserAdminView(
      userId: userId,
      email: email,
      registeredAt: profile?.createdAt ?? user?.createdAt,
      countryCode: profile?.countryCode,
      language: profile?.language,
      blocked: user?.blocked ?? false,
      isStaff: staff != null,
      consents: await currentConsents(session, userId),
    );
  }
}
