import 'package:flutter/foundation.dart';
import 'package:parla_client/parla_client.dart';

export 'package:parla_client/parla_client.dart'
    show
        StaffRole,
        StaffMe,
        StaffSummary,
        StaffInviteSummary,
        ContentAdminItem,
        ContentStatus,
        MediaAdminItem,
        UserAdminView,
        AuditLogEntry,
        PushJobView,
        ConsentState,
        ConsentType,
        StatsReport,
        DashboardReport,
        StatsGroup,
        StatsCount,
        SupportThreadSummary,
        SupportEntry,
        Advertiser,
        AdCampaign,
        AdCampaignOption,
        AdReport,
        AdReportRow,
        ShopOrderView,
        ShopOrderStatus,
        UuidValue;

/// A rule the server refused, with its stable code.
class AdminError implements Exception {
  const AdminError(this.code);

  final String code;

  @override
  String toString() => 'AdminError($code)';
}

/// Everything the panel needs from the server. Screens depend on this,
/// not on the generated client, so widget tests run without a server.
abstract interface class AdminApi {
  bool get isSignedIn;

  /// Notifies when the sign-in state changes.
  Listenable get authChanges;

  Future<StaffMe?> me();
  Future<StaffMe> claimFirstAdmin();
  Future<StaffMe> acceptInvite(String code);

  /// Signs out of this browser.
  Future<void> signOut();

  Future<List<StaffSummary>> listStaff();
  Future<List<StaffInviteSummary>> listInvites();
  Future<void> invite(String email, StaffRole role);
  Future<void> revokeInvite(int id);
  Future<void> setRole(UuidValue user, StaffRole role);
  Future<void> setActive(UuidValue user, bool active);

  // Content (phase B1). [kind] is a ContentKind name.
  Future<List<ContentAdminItem>> listContent(String kind);
  Future<ContentAdminItem> createContent(
    String kind,
    String slug,
    String category,
  );
  Future<ContentAdminItem> saveContent(int id, String json, String category);
  Future<ContentAdminItem> submitContent(int id);
  Future<ContentAdminItem> approveContent(int id);
  Future<ContentAdminItem> returnContent(int id, String note);
  Future<ContentAdminItem> recordConsent(int id, String reference);
  Future<ContentAdminItem> publishContent(int id);

  /// How far a sent push campaign has got, or `null` before it is sent.
  Future<PushJobView?> pushStatus(int id);
  Future<ContentAdminItem> unpublishContent(int id);
  Future<void> deleteContent(int id);

  // Audit log (admins only), read-only, newest first, 100 per page.
  Future<List<AuditLogEntry>> listAudit(AuditFilter filter, {int? beforeId});

  // Users (phase C, admins only). Exact email look-up only.
  Future<UserAdminView?> findUser(String email);
  Future<UserAdminView> setUserBlocked(UuidValue userId, bool blocked);
  Future<void> deleteUserOnRequest(UuidValue userId, String confirmEmail);

  // Support conversations (phase D2; support role and admins).
  Future<List<SupportThreadSummary>> supportThreads();
  Future<List<SupportEntry>> openSupportThread(int id);
  Future<void> replySupport(int id, String text);
  Future<void> closeSupportThread(int id);

  // Anonymous statistics (phase C).
  Future<StatsReport> statsReport();

  /// The website's totals of the last [days] days (admins only).
  Future<StatsReport> siteReport(int days);

  /// The dashboard for the last [days] days (7, 30 or 90; admins only).
  Future<DashboardReport> dashboard(int days);

  // Ads (admins only, except [adCampaignOptions] for the banner editor).
  Future<List<Advertiser>> advertisers();
  Future<Advertiser> saveAdvertiser(Advertiser advertiser);
  Future<void> deleteAdvertiser(int id);
  Future<List<AdCampaign>> adCampaigns();
  Future<AdCampaign> saveAdCampaign(AdCampaign campaign);
  Future<void> deleteAdCampaign(int id);
  Future<List<AdCampaignOption>> adCampaignOptions();
  Future<AdReport> adReport(int campaignId);

  // Shop orders (admins only).
  Future<List<ShopOrderView>> shopOrders();
  Future<ShopOrderView> setShopOrderStatus(
    String number,
    ShopOrderStatus status,
  );
  Future<ShopOrderView> refundShopOrder(String number);

  /// Hides or shows a catalogue item in the app at once.
  Future<ContentAdminItem> setContentHidden(int id, bool hidden);

  /// Imports the content sheet's articles and recipes as drafts (admins);
  /// returns how many were added.
  Future<int> importSheet();

  /// Publishes the imported blog and recipe drafts without expert review
  /// (admins).
  Future<int> publishImported();

  // Images (phase B2b). The panel shrinks an image before upload; the
  // server re-encodes it and drops all metadata.
  Future<MediaAdminItem> uploadImage(
    Uint8List bytes,
    String license,
    String? source,
    String altJson,
  );
  Future<List<MediaAdminItem>> listImages();
  Future<Uint8List> imagePreview(int id);
  Future<MediaAdminItem> updateImage(
    int id,
    String license,
    String? source,
    String altJson,
  );
  Future<void> deleteImage(int id);

  /// Uploads an exercise video (MP4, MOV, WebM or GIF) in chunks; the
  /// server re-encodes it without sound or metadata. [onProgress] gets the
  /// share sent, 0 to 1.
  Future<MediaAdminItem> uploadVideo(
    Uint8List bytes,
    String license,
    String? source,
    String altJson, {
    void Function(double sent)? onProgress,
  });

  /// Email and password. Throws [AdminError] `auth.failed` when refused.
  Future<void> login(String email, String password);

  /// Registration: emails a code, returns the request id.
  Future<UuidValue> startRegistration(String email);

  /// Checks the emailed code; returns a token for [finishRegistration].
  Future<String> verifyRegistrationCode(UuidValue requestId, String code);

  /// Sets the password and signs in.
  Future<void> finishRegistration(String token, String password);

  /// Sign-in with a one-time code instead of the password: emails a code,
  /// returns the request id.
  Future<UuidValue> startCodeLogin(String email);

  /// Checks the emailed code and signs in. Fails for an email without an
  /// account (the panel never creates one this way).
  Future<void> finishCodeLogin(UuidValue requestId, String code);

  /// Password reset: emails a code, returns the request id.
  Future<UuidValue> startPasswordReset(String email);
  Future<String> verifyPasswordResetCode(UuidValue requestId, String code);
  Future<void> finishPasswordReset(String token, String password);
}

/// The filters of the audit log view; empty means "any".
@immutable
class AuditFilter {
  const AuditFilter({
    this.actionPrefix = '',
    this.actorRole = '',
    this.objectId = '',
    this.from,
    this.to,
  });

  /// The start of the action, for example `content.`.
  final String actionPrefix;
  final String actorRole;
  final String objectId;

  /// From this day (inclusive) to this day (inclusive), local time.
  final DateTime? from;
  final DateTime? to;
}
