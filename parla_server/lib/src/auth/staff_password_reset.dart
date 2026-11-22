import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../generated/protocol.dart';
import 'verification_code_sender.dart';

/// Passwords exist only for the admin panel, so a password reset code is
/// emailed only to an active staff member. For any other address nothing is
/// sent, but the caller gets the same answer, so the reset form does not
/// reveal who is on the team.
Future<void> sendStaffPasswordResetCode(
  Session session,
  VerificationCodeSender sender, {
  required String email,
  required String code,
  Transaction? transaction,
}) async {
  if (!await isActiveStaffEmail(session, email, transaction: transaction)) {
    return;
  }
  await sender.sendStaffPasswordReset(session, email: email, code: code);
}

/// Whether [email] belongs to the sign-in account of an active staff member.
Future<bool> isActiveStaffEmail(
  Session session,
  String email, {
  Transaction? transaction,
}) async {
  final clean = email.trim().toLowerCase();
  if (clean.isEmpty) return false;
  final account = await EmailAccount.db.findFirstRow(
    session,
    where: (t) => t.email.equals(clean),
    transaction: transaction,
  );
  if (account == null) return false;
  final staff = await StaffMember.db.findFirstRow(
    session,
    where: (t) => t.authUserId.equals(account.authUserId),
    transaction: transaction,
  );
  return staff != null && staff.active;
}
