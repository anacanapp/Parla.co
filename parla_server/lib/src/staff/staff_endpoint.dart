import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../audit/audit.dart';
import '../generated/protocol.dart';
import '../health/health_crypto.dart';
import 'staff_crypto.dart';
import 'staff_guard.dart';
import 'totp.dart';

/// Joining the admin panel and the second factor. Any signed-in account
/// can call these; they only ever act on the caller's own staff row.
class StaffEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The caller's staff state, or `null` for someone who is not staff.
  Future<StaffMe?> me(Session session) async {
    final member = await staffOf(session);
    if (member == null || !member.active) return null;
    return StaffMe(
      role: member.role,
      totpEnrolled: member.totpConfirmedAt != null,
      verified: await isStaffVerified(session),
    );
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
          failedTotp: 0,
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
      return StaffMe(role: invite.role, totpEnrolled: false, verified: false);
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
          failedTotp: 0,
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
      return StaffMe(
        role: StaffRole.admin,
        totpEnrolled: false,
        verified: false,
      );
    });
  }

  /// Starts setting up the authenticator app. Replaces an unconfirmed
  /// secret; refused once a secret is confirmed (an admin resets it).
  Future<TotpEnrollment> startTotp(Session session) async {
    final member = await _activeMember(session);
    if (member.totpConfirmedAt != null) {
      throw ParlaException(code: StaffErrors.already);
    }
    final secret = Totp.newSecret();
    final sealed = await (await StaffCrypto.of(
      session,
    )).seal(secret, member.authUserId);
    await StaffMember.db.updateRow(
      session,
      member.copyWith(totpSecret: sealed.ciphertext, totpNonce: sealed.nonce),
    );
    final encoded = Totp.base32(secret);
    return TotpEnrollment(
      secret: encoded,
      uri: Totp.uri(encoded, await callerEmail(session) ?? 'staff'),
    );
  }

  /// Confirms the authenticator app with a first code and verifies this
  /// sign-in session.
  Future<StaffMe> confirmTotp(Session session, String code) async {
    final member = await _activeMember(session);
    if (member.totpConfirmedAt != null || member.totpSecret == null) {
      throw ParlaException(code: StaffErrors.totpRequired);
    }
    await _check(session, member, code, enrolling: true);
    return StaffMe(role: member.role, totpEnrolled: true, verified: true);
  }

  /// The second factor for this sign-in session.
  Future<StaffMe> verifyTotp(Session session, String code) async {
    final member = await _activeMember(session);
    if (member.totpConfirmedAt == null) {
      throw ParlaException(code: StaffErrors.totpRequired);
    }
    await _check(session, member, code, enrolling: false);
    return StaffMe(role: member.role, totpEnrolled: true, verified: true);
  }

  /// Ends the second-factor check of this sign-in session.
  Future<void> endSession(Session session) async {
    final auth = session.authenticated!;
    await StaffSession.db.deleteWhere(
      session,
      where: (t) => t.authId.equals(auth.authId),
    );
  }

  Future<StaffMember> _activeMember(Session session) async {
    final member = await staffOf(session);
    if (member == null) throw ParlaException(code: StaffErrors.notStaff);
    if (!member.active) throw ParlaException(code: StaffErrors.inactive);
    return member;
  }

  Future<void> _check(
    Session session,
    StaffMember member,
    String code, {
    required bool enrolling,
  }) async {
    final now = DateTime.now().toUtc();
    final lockedUntil = member.lockedUntil;
    if (lockedUntil != null && lockedUntil.isAfter(now)) {
      throw ParlaException(code: StaffErrors.locked);
    }
    final secret = await (await StaffCrypto.of(session)).open(
      Sealed(ciphertext: member.totpSecret!, nonce: member.totpNonce!),
      member.authUserId,
    );
    final step = await Totp.verify(
      secret,
      code,
      now,
      lastStep: member.lastTotpStep,
    );
    if (step == null) {
      final failures = member.failedTotp + 1;
      await StaffMember.db.updateRow(
        session,
        member.copyWith(
          failedTotp: failures >= staffMaxFailures ? 0 : failures,
          lockedUntil: failures >= staffMaxFailures
              ? now.add(staffLockLength)
              : member.lockedUntil,
        ),
      );
      await writeAudit(
        session,
        actorId: member.authUserId,
        actorRole: AuditActor.staff,
        action: 'staff.totp_failed',
        objectType: 'staff_member',
        objectId: member.authUserId.toString(),
      );
      throw ParlaException(
        code: failures >= staffMaxFailures
            ? StaffErrors.locked
            : StaffErrors.totpInvalid,
      );
    }
    final authId = session.authenticated!.authId;
    await session.db.transaction((transaction) async {
      await StaffMember.db.updateRow(
        session,
        member.copyWith(
          lastTotpStep: step,
          failedTotp: 0,
          lockedUntil: null,
          totpConfirmedAt: member.totpConfirmedAt ?? now,
        ),
        transaction: transaction,
      );
      await StaffSession.db.deleteWhere(
        session,
        where: (t) => t.authId.equals(authId),
        transaction: transaction,
      );
      await StaffSession.db.insertRow(
        session,
        StaffSession(
          authUserId: member.authUserId,
          authId: authId,
          verifiedAt: now,
          expiresAt: now.add(staffSessionLength),
        ),
        transaction: transaction,
      );
      await writeAudit(
        session,
        actorId: member.authUserId,
        actorRole: AuditActor.staff,
        action: enrolling ? 'staff.totp_enrolled' : 'staff.verified',
        objectType: 'staff_member',
        objectId: member.authUserId.toString(),
        transaction: transaction,
      );
    });
  }
}
