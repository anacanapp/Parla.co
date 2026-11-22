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
  static const signInAgain = 'staff.sign_in_again';
  static const forbidden = 'staff.forbidden';
  static const inviteInvalid = 'staff.invite_invalid';
  static const already = 'staff.already';
  static const lastAdmin = 'staff.last_admin';
  static const emailInvalid = 'staff.email_invalid';
}

/// How long a password sign-in lets a staff member use the panel. After
/// that every admin call is refused until the password is entered again
/// (a new sign-in session, by password or by an emailed one-time code).
/// There is no second factor (decision of 2026-11-18); repeated wrong
/// passwords and codes are limited by the email sign-in (5 per 5 minutes
/// for passwords, 5 code requests per 15 minutes) and by WAF.
const staffSignInLength = Duration(hours: 12);

/// The staff row of the caller, or `null`.
Future<StaffMember?> staffOf(Session session, {Transaction? transaction}) {
  final userId = session.authenticated!.authUserId;
  return StaffMember.db.findFirstRow(
    session,
    where: (t) => t.authUserId.equals(userId),
    transaction: transaction,
  );
}

/// When the caller's sign-in session (its refresh token, created by the
/// password sign-in) stops being accepted for admin calls, or `null` when
/// it is unknown or already expired.
Future<DateTime?> staffSignInExpiry(Session session) async {
  final authId = UuidValue.withValidation(session.authenticated!.authId);
  final token = await RefreshToken.db.findById(session, authId);
  if (token == null) return null;
  if (token.authUserId != session.authenticated!.authUserId) return null;
  final expires = token.createdAt.toUtc().add(staffSignInLength);
  return expires.isAfter(DateTime.now().toUtc()) ? expires : null;
}

/// The caller as an active staff member, signed in with the password in the
/// last [staffSignInLength], with one of [roles]. Throws otherwise. Every
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
  if (await staffSignInExpiry(session) == null) {
    throw ParlaException(code: StaffErrors.signInAgain);
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
