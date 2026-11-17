import 'package:flutter/foundation.dart';
import 'package:parla_client/parla_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'admin_api.dart';

class ServerpodAdminApi implements AdminApi {
  ServerpodAdminApi(this._client);

  final Client _client;

  @override
  bool get isSignedIn => _client.auth.isAuthenticated;

  @override
  Listenable get authChanges => _client.auth.authInfoListenable;

  @override
  Future<StaffMe?> me() => _guard(_client.staff.me);

  @override
  Future<StaffMe> claimFirstAdmin() => _guard(_client.staff.claimFirstAdmin);

  @override
  Future<StaffMe> acceptInvite(String code) =>
      _guard(() => _client.staff.acceptInvite(code));

  @override
  Future<TotpEnrollment> startTotp() => _guard(_client.staff.startTotp);

  @override
  Future<StaffMe> confirmTotp(String code) =>
      _guard(() => _client.staff.confirmTotp(code));

  @override
  Future<StaffMe> verifyTotp(String code) =>
      _guard(() => _client.staff.verifyTotp(code));

  @override
  Future<void> signOut() async {
    try {
      await _client.staff.endSession();
    } on Object {
      // The session may already be gone; sign out locally either way.
    }
    try {
      await _client.auth.signOutDevice();
    } on Object {
      // Same as above.
    }
  }

  @override
  Future<List<StaffSummary>> listStaff() =>
      _guard(_client.staffAdmin.listStaff);

  @override
  Future<List<StaffInviteSummary>> listInvites() =>
      _guard(_client.staffAdmin.listInvites);

  @override
  Future<void> invite(String email, StaffRole role) =>
      _guard(() => _client.staffAdmin.invite(email, role));

  @override
  Future<void> revokeInvite(int id) =>
      _guard(() => _client.staffAdmin.revokeInvite(id));

  @override
  Future<void> setRole(UuidValue user, StaffRole role) =>
      _guard(() => _client.staffAdmin.setRole(user, role));

  @override
  Future<void> setActive(UuidValue user, bool active) =>
      _guard(() => _client.staffAdmin.setActive(user, active));

  @override
  Future<void> resetTotp(UuidValue user) =>
      _guard(() => _client.staffAdmin.resetTotp(user));

  @override
  Future<List<ContentAdminItem>> listContent(String kind) =>
      _guard(() => _client.contentAdmin.list(kind));

  @override
  Future<ContentAdminItem> createContent(
    String kind,
    String slug,
    String category,
  ) => _guard(() => _client.contentAdmin.create(kind, slug, category));

  @override
  Future<ContentAdminItem> saveContent(int id, String json, String category) =>
      _guard(() => _client.contentAdmin.saveDraft(id, json, category));

  @override
  Future<ContentAdminItem> submitContent(int id) =>
      _guard(() => _client.contentAdmin.submitForReview(id));

  @override
  Future<ContentAdminItem> approveContent(int id) =>
      _guard(() => _client.contentAdmin.approve(id));

  @override
  Future<ContentAdminItem> returnContent(int id, String note) =>
      _guard(() => _client.contentAdmin.returnToWriter(id, note));

  @override
  Future<ContentAdminItem> recordConsent(int id, String reference) =>
      _guard(() => _client.contentAdmin.recordConsent(id, reference));

  @override
  Future<ContentAdminItem> publishContent(int id) =>
      _guard(() => _client.contentAdmin.publish(id));

  @override
  Future<ContentAdminItem> unpublishContent(int id) =>
      _guard(() => _client.contentAdmin.unpublish(id));

  @override
  Future<void> deleteContent(int id) =>
      _guard(() => _client.contentAdmin.delete(id));

  @override
  Future<MediaAdminItem> uploadImage(
    Uint8List bytes,
    String license,
    String? source,
    String altJson,
  ) => _guard(
    () => _client.mediaAdmin.upload(
      ByteData.sublistView(bytes),
      license,
      source,
      altJson,
    ),
  );

  @override
  Future<List<MediaAdminItem>> listImages() => _guard(_client.mediaAdmin.list);

  @override
  Future<Uint8List> imagePreview(int id) async {
    final data = await _guard(() => _client.mediaAdmin.preview(id));
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  @override
  Future<MediaAdminItem> updateImage(
    int id,
    String license,
    String? source,
    String altJson,
  ) => _guard(
    () => _client.mediaAdmin.update(id, license, source, altJson),
  );

  @override
  Future<void> deleteImage(int id) =>
      _guard(() => _client.mediaAdmin.delete(id));

  @override
  Future<UserAdminView?> findUser(String email) =>
      _guard(() => _client.userAdmin.find(email));

  @override
  Future<UserAdminView> setUserBlocked(UuidValue userId, bool blocked) =>
      _guard(() => _client.userAdmin.setBlocked(userId, blocked));

  @override
  Future<void> deleteUserOnRequest(UuidValue userId, String confirmEmail) =>
      _guard(() => _client.userAdmin.deleteOnRequest(userId, confirmEmail));

  @override
  Future<StatsReport> statsReport() => _guard(_client.statsAdmin.report);

  @override
  Future<ContentAdminItem> setContentHidden(int id, bool hidden) =>
      _guard(() => _client.contentAdmin.setHidden(id, hidden));

  @override
  Future<int> importSheet() => _guard(() => _client.contentAdmin.importSheet());

  @override
  Future<void> login(String email, String password) => _auth(() async {
    final success = await _client.emailIdp.login(
      email: email.trim(),
      password: password,
    );
    await _client.auth.updateSignedInUser(success);
  });

  @override
  Future<UuidValue> startRegistration(String email) =>
      _auth(() => _client.emailIdp.startRegistration(email: email.trim()));

  @override
  Future<String> verifyRegistrationCode(UuidValue requestId, String code) =>
      _auth(
        () => _client.emailIdp.verifyRegistrationCode(
          accountRequestId: requestId,
          verificationCode: code.trim(),
        ),
      );

  @override
  Future<void> finishRegistration(String token, String password) =>
      _auth(() async {
        final success = await _client.emailIdp.finishRegistration(
          registrationToken: token,
          password: password,
        );
        await _client.auth.updateSignedInUser(success);
      });

  @override
  Future<UuidValue> startPasswordReset(String email) =>
      _auth(() => _client.emailIdp.startPasswordReset(email: email.trim()));

  @override
  Future<String> verifyPasswordResetCode(UuidValue requestId, String code) =>
      _auth(
        () => _client.emailIdp.verifyPasswordResetCode(
          passwordResetRequestId: requestId,
          verificationCode: code.trim(),
        ),
      );

  @override
  Future<void> finishPasswordReset(String token, String password) => _auth(
    () => _client.emailIdp.finishPasswordReset(
      finishPasswordResetToken: token,
      newPassword: password,
    ),
  );

  /// Sign-in errors are not told apart, so a wrong password and an unknown
  /// email look the same.
  Future<T> _auth<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on Object {
      throw const AdminError('auth.failed');
    }
  }

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on ParlaException catch (e) {
      throw AdminError(e.code);
    }
  }
}
