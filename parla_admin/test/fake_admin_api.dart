import 'package:flutter/foundation.dart';
import 'package:parla_admin/api/admin_api.dart';

/// In-memory server for the panel tests.
class FakeAdminApi implements AdminApi {
  final _auth = ValueNotifier<int>(0);
  bool signedIn = false;
  StaffMe? meValue;
  String inviteCode = 'GOODCODE';
  String totpCode = '123456';
  final staff = <StaffSummary>[];
  final invites = <StaffInviteSummary>[];
  final calls = <String>[];

  @override
  bool get isSignedIn => signedIn;

  @override
  Listenable get authChanges => _auth;

  @override
  Future<StaffMe?> me() async => meValue;

  @override
  Future<StaffMe> claimFirstAdmin() async =>
      throw const AdminError('staff.invite_invalid');

  @override
  Future<StaffMe> acceptInvite(String code) async {
    if (code.trim().toUpperCase() != inviteCode) {
      throw const AdminError('staff.invite_invalid');
    }
    return meValue = StaffMe(
      role: StaffRole.admin,
      totpEnrolled: false,
      verified: false,
    );
  }

  @override
  Future<TotpEnrollment> startTotp() async =>
      TotpEnrollment(secret: 'ABCDEFGH', uri: 'otpauth://totp/x?secret=AB');

  @override
  Future<StaffMe> confirmTotp(String code) => verifyTotp(code);

  @override
  Future<StaffMe> verifyTotp(String code) async {
    if (code != totpCode) throw const AdminError('staff.totp_invalid');
    return meValue = StaffMe(
      role: meValue!.role,
      totpEnrolled: true,
      verified: true,
    );
  }

  @override
  Future<void> signOut() async {
    signedIn = false;
    meValue = null;
    calls.add('signOut');
    _auth.value++;
  }

  @override
  Future<List<StaffSummary>> listStaff() async => List.of(staff);

  @override
  Future<List<StaffInviteSummary>> listInvites() async => List.of(invites);

  @override
  Future<void> invite(String email, StaffRole role) async {
    calls.add('invite:$email:${role.name}');
    invites.add(
      StaffInviteSummary(
        id: invites.length + 1,
        email: email,
        role: role,
        expiresAt: DateTime.utc(2026, 11, 20),
      ),
    );
  }

  @override
  Future<void> revokeInvite(int id) async {
    calls.add('revoke:$id');
    invites.removeWhere((i) => i.id == id);
  }

  @override
  Future<void> setRole(UuidValue user, StaffRole role) async {
    calls.add('role:$user:${role.name}');
    throw const AdminError('staff.last_admin');
  }

  @override
  Future<void> setActive(UuidValue user, bool active) async {
    calls.add('active:$user:$active');
  }

  @override
  Future<void> resetTotp(UuidValue user) async => calls.add('reset:$user');

  String password = 'correct horse battery';

  @override
  Future<void> login(String email, String pw) async {
    if (pw != password) throw const AdminError('auth.failed');
    signedIn = true;
    _auth.value++;
  }

  @override
  Future<UuidValue> startRegistration(String email) async {
    calls.add('register:$email');
    return UuidValue.fromString('11111111-1111-4111-8111-111111111111');
  }

  @override
  Future<String> verifyRegistrationCode(UuidValue id, String code) async {
    if (code != '4242') throw const AdminError('auth.failed');
    return 'token';
  }

  @override
  Future<void> finishRegistration(String token, String pw) async {
    password = pw;
    signedIn = true;
    _auth.value++;
  }

  @override
  Future<UuidValue> startPasswordReset(String email) async =>
      UuidValue.fromString('22222222-2222-4222-8222-222222222222');

  @override
  Future<String> verifyPasswordResetCode(UuidValue id, String code) async =>
      'reset';

  @override
  Future<void> finishPasswordReset(String token, String pw) async {
    password = pw;
  }
}
