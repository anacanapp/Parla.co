import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

/// Error codes of the admin panel. The panel translates them.
abstract final class StaffErrors {
  static const notStaff = 'staff.not_staff';
  static const inactive = 'staff.inactive';
  static const totpRequired = 'staff.totp_required';
  static const totpInvalid = 'staff.totp_invalid';
  static const locked = 'staff.locked';
  static const forbidden = 'staff.forbidden';
  static const inviteInvalid = 'staff.invite_invalid';
  static const already = 'staff.already';
  static const lastAdmin = 'staff.last_admin';
  static const emailInvalid = 'staff.email_invalid';
}

/// How long a second-factor check lasts.
const staffSessionLength = Duration(hours: 8);

/// Failed codes before the account is locked for [staffLockLength].
const staffMaxFailures = 5;
const staffLockLength = Duration(minutes: 15);

/// The staff row of the caller, or `null`.
Future<StaffMember?> staffOf(Session session, {Transaction? transaction}) {
  final userId = session.authenticated!.authUserId;
  return StaffMember.db.findFirstRow(
    session,
    where: (t) => t.authUserId.equals(userId),
    transaction: transaction,
  );
}

/// Whether the caller's sign-in session passed the second factor.
Future<bool> isStaffVerified(Session session) async {
  final auth = session.authenticated!;
  final row = await StaffSession.db.findFirstRow(
    session,
    where: (t) =>
        t.authId.equals(auth.authId) &
        t.authUserId.equals(auth.authUserId) &
        (t.expiresAt > DateTime.now().toUtc()),
  );
  return row != null;
}

/// The caller as an active staff member who passed the second factor in
/// this sign-in session and has one of [roles]. Throws otherwise. Every
/// admin endpoint starts with this.
Future<StaffMember> requireStaff(
  Session session, {
  Set<StaffRole> roles = const {
    StaffRole.admin,
    StaffRole.editor,
    StaffRole.expert,
  },
}) async {
  final member = await staffOf(session);
  if (member == null) throw ParlaException(code: StaffErrors.notStaff);
  if (!member.active) throw ParlaException(code: StaffErrors.inactive);
  if (member.totpConfirmedAt == null || !await isStaffVerified(session)) {
    throw ParlaException(code: StaffErrors.totpRequired);
  }
  if (!roles.contains(member.role)) {
    throw ParlaException(code: StaffErrors.forbidden);
  }
  return member;
}

/// The caller's email address (lower case), or `null`.
Future<String?> callerEmail(Session session) async {
  final account = await EmailAccount.db.findFirstRow(
    session,
    where: (t) => t.authUserId.equals(session.authenticated!.authUserId),
  );
  return account?.email.toLowerCase();
}

/// A random invitation code: 10 characters without look-alikes.
String newInviteCode([Random? random]) {
  const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  final r = random ?? Random.secure();
  return List.generate(10, (_) => alphabet[r.nextInt(alphabet.length)]).join();
}

/// SHA-256 of a normalised invitation code.
Future<String> hashInviteCode(String code) async {
  final hash = await Sha256().hash(utf8.encode(code.trim().toUpperCase()));
  return base64.encode(hash.bytes);
}
