import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:parla_client/parla_client.dart';
import 'package:parla_shared/parla_shared.dart';
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
  Future<void> signOut() async {
    try {
      await _client.auth.signOutDevice();
    } on Object {
      // The session may already be gone; it is signed out locally anyway.
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
  Future<List<ShopOrderView>> shopOrders() => _guard(_client.shopAdmin.orders);

  @override
  Future<ShopOrderView> setShopOrderStatus(
    String number,
    ShopOrderStatus status,
  ) => _guard(() => _client.shopAdmin.setStatus(number, status));

  @override
  Future<ShopOrderView> refundShopOrder(String number) =>
      _guard(() => _client.shopAdmin.refund(number));

  @override
  Future<List<Advertiser>> advertisers() => _guard(_client.adAdmin.advertisers);

  @override
  Future<Advertiser> saveAdvertiser(Advertiser advertiser) =>
      _guard(() => _client.adAdmin.saveAdvertiser(advertiser));

  @override
  Future<void> deleteAdvertiser(int id) =>
      _guard(() => _client.adAdmin.deleteAdvertiser(id));

  @override
  Future<List<AdCampaign>> adCampaigns() => _guard(_client.adAdmin.campaigns);

  @override
  Future<AdCampaign> saveAdCampaign(AdCampaign campaign) =>
      _guard(() => _client.adAdmin.saveCampaign(campaign));

  @override
  Future<void> deleteAdCampaign(int id) =>
      _guard(() => _client.adAdmin.deleteCampaign(id));

  @override
  Future<List<AdCampaignOption>> adCampaignOptions() =>
      _guard(_client.adAdmin.campaignOptions);

  @override
  Future<AdReport> adReport(int campaignId) =>
      _guard(() => _client.adAdmin.report(campaignId));

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
  Future<MediaAdminItem> uploadVideo(
    Uint8List bytes,
    String license,
    String? source,
    String altJson, {
    void Function(double sent)? onProgress,
  }) async {
    if (bytes.isEmpty || bytes.length > MediaRules.maxVideoUploadBytes) {
      throw const AdminError('media.not_video');
    }
    final upload = _uploadId();
    const size = MediaRules.videoChunkBytes;
    final chunks = (bytes.length + size - 1) ~/ size;
    try {
      for (var i = 0; i < chunks; i++) {
        final end = (i + 1) * size > bytes.length
            ? bytes.length
            : (i + 1) * size;
        await _guard(
          () => _client.mediaAdmin.uploadVideoChunk(
            upload,
            i,
            ByteData.sublistView(bytes, i * size, end),
          ),
        );
        onProgress?.call((i + 1) / chunks);
      }
      return await _guard(
        () => _client.mediaAdmin.finishVideoUpload(
          upload,
          chunks,
          license,
          source,
          altJson,
        ),
      );
    } on Object {
      // The server removes the chunks itself once finishing was tried;
      // this covers a failure while sending them.
      try {
        await _client.mediaAdmin.abortVideoUpload(upload, chunks);
      } on Object {
        // Best effort.
      }
      rethrow;
    }
  }

  /// A random UUID v4 naming one upload.
  static String _uploadId() {
    final r = Random.secure();
    final b = List<int>.generate(16, (_) => r.nextInt(256));
    b[6] = (b[6] & 0x0f) | 0x40;
    b[8] = (b[8] & 0x3f) | 0x80;
    final h = b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
    return '${h.substring(0, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}-'
        '${h.substring(16, 20)}-${h.substring(20)}';
  }

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
  Future<List<SupportThreadSummary>> supportThreads() =>
      _guard(_client.supportAdmin.threads);

  @override
  Future<List<SupportEntry>> openSupportThread(int id) =>
      _guard(() => _client.supportAdmin.open(id));

  @override
  Future<void> replySupport(int id, String text) =>
      _guard(() => _client.supportAdmin.reply(id, text));

  @override
  Future<void> closeSupportThread(int id) =>
      _guard(() => _client.supportAdmin.close(id));

  @override
  Future<StatsReport> statsReport() => _guard(_client.statsAdmin.report);

  @override
  Future<DashboardReport> dashboard(int days) =>
      _guard(() => _client.dashboardAdmin.report(days));

  @override
  Future<ContentAdminItem> setContentHidden(int id, bool hidden) =>
      _guard(() => _client.contentAdmin.setHidden(id, hidden));

  @override
  Future<int> importSheet() => _guard(() => _client.contentAdmin.importSheet());

  @override
  Future<int> publishImported() =>
      _guard(() => _client.contentAdmin.publishImported());

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
  Future<UuidValue> startCodeLogin(String email) =>
      _auth(() => _client.emailIdp.startOtpLogin(email: email.trim()));

  @override
  Future<void> finishCodeLogin(UuidValue requestId, String code) =>
      _auth(() async {
        final result = await _client.emailIdp.verifyOtpLoginCode(
          otpLoginRequestId: requestId,
          verificationCode: code.trim(),
        );
        // Staff accounts are created by invitation only.
        if (!result.accountExists) throw const AdminError('auth.failed');
        final success = await _client.emailIdp.finishOtpLogin(
          otpLoginToken: result.token,
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
      // 12 hours after the password sign-in the server refuses every admin
      // call; signing out sends the panel back to the sign-in page.
      if (e.code == 'staff.sign_in_again') await signOut();
      throw AdminError(e.code);
    }
  }
}
