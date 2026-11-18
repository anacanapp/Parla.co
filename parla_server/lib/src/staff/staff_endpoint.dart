import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../audit/audit.dart';
import '../generated/protocol.dart';
import 'staff_guard.dart';

/// Joining the admin panel. Any signed-in account can call these; they only
/// ever act on the caller's own staff row.
class StaffEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The caller's staff state, or `null` for someone who is not staff.
  /// Refused with `staff.sign_in_again` once the password sign-in is older
  /// than 12 hours.
  Future<StaffMe?> me(Session session) async {
    final member = await staffOf(session);
    if (member == null || !member.active) return null;
    return _me(session, member.role);
  }

  Future<StaffMe> _me(Session session, StaffRole role) async {
    final expires = await staffSignInExpiry(session);
    if (expires == null) throw ParlaException(code: StaffErrors.signInAgain);
    return StaffMe(role: role, signInExpiresAt: expires);
  }

  /// Turns an invitation for the caller's email into a staff role.
  Future<StaffMe> acceptInvite(Session session, String code) async {
    final userId = session.authenticated!.authUserId;
    final email = await callerEmail(session);
    if (email == null) throw ParlaException(code: StaffErrors.inviteInvalid);
    final hash = await hashInviteCode(code);
    return session.db.transaction((transaction) async {
      if (await staffOf(session, transaction: transaction) != null) {
        throw ParlaException(code: StaffErrors.already);
      }
      final invite = await StaffInvite.db.findFirstRow(
        session,
        where: (t) =>
            t.email.equals(email) &
            t.codeHash.equals(hash) &
            t.usedAt.equals(null) &
            (t.expiresAt > DateTime.now().toUtc()),
        transaction: transaction,
      );
      if (invite == null) throw ParlaException(code: StaffErrors.inviteInvalid);
      final now = DateTime.now().toUtc();
      await StaffInvite.db.updateRow(
        session,
        invite.copyWith(usedAt: now),
        transaction: transaction,
      );
      await StaffMember.db.insertRow(
        session,
        StaffMember(
          authUserId: userId,
          role: invite.role,
          active: true,
          invitedBy: invite.invitedBy,
          createdAt: now,
        ),
        transaction: transaction,
      );
      await writeAudit(
        session,
        actorId: userId,
        actorRole: AuditActor.staff,
        action: 'staff.joined',
        objectType: 'staff_member',
        objectId: userId.toString(),
        transaction: transaction,
      );
      return _me(session, invite.role);
    });
  }

  /// The first admin: allowed only while there is no staff at all, and
  /// only for the email in the `staffBootstrapEmail` password.
  Future<StaffMe> claimFirstAdmin(Session session) async {
    final userId = session.authenticated!.authUserId;
    final allowed = session.passwords['staffBootstrapEmail']?.toLowerCase();
    final email = await callerEmail(session);
    if (allowed == null || allowed.isEmpty || email != allowed) {
      throw ParlaException(code: StaffErrors.inviteInvalid);
    }
    return session.db.transaction((transaction) async {
      if (await StaffMember.db.count(session, transaction: transaction) > 0) {
        throw ParlaException(code: StaffErrors.inviteInvalid);
      }
      await StaffMember.db.insertRow(
        session,
        StaffMember(
          authUserId: userId,
          role: StaffRole.admin,
          active: true,
          createdAt: DateTime.now().toUtc(),
        ),
        transaction: transaction,
      );
      await writeAudit(
        session,
        actorId: userId,
        actorRole: AuditActor.staff,
        action: 'staff.first_admin',
        objectType: 'staff_member',
        objectId: userId.toString(),
        transaction: transaction,
      );
      return _me(session, StaffRole.admin);
    });
  }
}
