import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../audit/audit.dart';
import '../auth/verification_code_sender.dart';
import '../generated/protocol.dart';
import 'staff_guard.dart';

/// Staff accounts, for admins only (second factor required).
class StaffAdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  static const inviteLength = Duration(hours: 72);

  Future<List<StaffSummary>> listStaff(Session session) async {
    await requireStaff(session, roles: {StaffRole.admin});
    final members = await StaffMember.db.find(
      session,
      orderBy: (t) => t.createdAt,
    );
    final emails = await EmailAccount.db.find(
      session,
      where: (t) => t.authUserId.inSet({for (final m in members) m.authUserId}),
    );
    final byUser = {for (final e in emails) e.authUserId: e.email};
    return [
      for (final m in members)
        StaffSummary(
          authUserId: m.authUserId,
          email: byUser[m.authUserId] ?? '',
          role: m.role,
          active: m.active,
          totpEnrolled: m.totpConfirmedAt != null,
          createdAt: m.createdAt,
        ),
    ];
  }

  Future<List<StaffInviteSummary>> listInvites(Session session) async {
    await requireStaff(session, roles: {StaffRole.admin});
    final invites = await StaffInvite.db.find(
      session,
      where: (t) =>
          t.usedAt.equals(null) & (t.expiresAt > DateTime.now().toUtc()),
      orderBy: (t) => t.createdAt,
    );
    return [
      for (final i in invites)
        StaffInviteSummary(
          id: i.id!,
          email: i.email,
          role: i.role,
          expiresAt: i.expiresAt,
        ),
    ];
  }

  /// Emails a one-time code that lets [email] join with [role].
  Future<void> invite(Session session, String email, StaffRole role) async {
    final admin = await requireStaff(session, roles: {StaffRole.admin});
    final clean = email.trim().toLowerCase();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(clean) ||
        clean.length > 254) {
      throw ParlaException(code: StaffErrors.emailInvalid);
    }
    final code = newInviteCode();
    final now = DateTime.now().toUtc();
    final row = await StaffInvite.db.insertRow(
      session,
      StaffInvite(
        email: clean,
        role: role,
        codeHash: await hashInviteCode(code),
        invitedBy: admin.authUserId,
        expiresAt: now.add(inviteLength),
        createdAt: now,
      ),
    );
    await writeAudit(
      session,
      actorId: admin.authUserId,
      actorRole: AuditActor.staff,
      action: 'staff.invited',
      objectType: 'staff_invite',
      objectId: row.id.toString(),
    );
    await verificationCodeSenderFor(
      session.serverpod.runMode,
      session.serverpod.getPassword,
    ).sendStaffInvite(session, email: clean, code: code);
  }

  Future<void> revokeInvite(Session session, int inviteId) async {
    final admin = await requireStaff(session, roles: {StaffRole.admin});
    await StaffInvite.db.deleteWhere(
      session,
      where: (t) => t.id.equals(inviteId),
    );
    await writeAudit(
      session,
      actorId: admin.authUserId,
      actorRole: AuditActor.staff,
      action: 'staff.invite_revoked',
      objectType: 'staff_invite',
      objectId: inviteId.toString(),
    );
  }

  Future<void> setRole(
    Session session,
    UuidValue authUserId,
    StaffRole role,
  ) => _update(
    session,
    authUserId,
    'staff.role_changed',
    (m) => m.copyWith(role: role),
    removesAdmin: role != StaffRole.admin,
  );

  Future<void> setActive(Session session, UuidValue authUserId, bool active) =>
      _update(
        session,
        authUserId,
        active ? 'staff.activated' : 'staff.deactivated',
        (m) => m.copyWith(active: active),
        removesAdmin: !active,
        endSessions: !active,
      );

  /// Clears the authenticator of a staff member who lost their phone; they
  /// set it up again at the next sign-in.
  Future<void> resetTotp(Session session, UuidValue authUserId) => _update(
    session,
    authUserId,
    'staff.totp_reset',
    (m) => m.copyWith(
      totpSecret: null,
      totpNonce: null,
      totpConfirmedAt: null,
      lastTotpStep: null,
      failedTotp: 0,
      lockedUntil: null,
    ),
    endSessions: true,
  );

  Future<void> _update(
    Session session,
    UuidValue authUserId,
    String action,
    StaffMember Function(StaffMember) change, {
    bool removesAdmin = false,
    bool endSessions = false,
  }) async {
    final admin = await requireStaff(session, roles: {StaffRole.admin});
    await session.db.transaction((transaction) async {
      final member = await StaffMember.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(authUserId),
        transaction: transaction,
      );
      if (member == null) throw ParlaException(code: StaffErrors.notStaff);
      if (removesAdmin && member.role == StaffRole.admin && member.active) {
        final admins = await StaffMember.db.count(
          session,
          where: (t) => t.role.equals(StaffRole.admin) & t.active.equals(true),
          transaction: transaction,
        );
        if (admins <= 1) throw ParlaException(code: StaffErrors.lastAdmin);
      }
      await StaffMember.db.updateRow(
        session,
        change(member),
        transaction: transaction,
      );
      if (endSessions) {
        await StaffSession.db.deleteWhere(
          session,
          where: (t) => t.authUserId.equals(authUserId),
          transaction: transaction,
        );
      }
      await writeAudit(
        session,
        actorId: admin.authUserId,
        actorRole: AuditActor.staff,
        action: action,
        objectType: 'staff_member',
        objectId: authUserId.toString(),
        transaction: transaction,
      );
    });
  }
}
