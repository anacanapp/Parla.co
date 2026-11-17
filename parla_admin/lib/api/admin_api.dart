import 'package:flutter/foundation.dart';
import 'package:parla_client/parla_client.dart';

export 'package:parla_client/parla_client.dart'
    show
        StaffRole,
        StaffMe,
        StaffSummary,
        StaffInviteSummary,
        TotpEnrollment,
        ContentAdminItem,
        ContentStatus,
        MediaAdminItem,
        UserAdminView,
        ConsentState,
        ConsentType,
        StatsReport,
        StatsGroup,
        StatsCount,
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
  Future<TotpEnrollment> startTotp();
  Future<StaffMe> confirmTotp(String code);
  Future<StaffMe> verifyTotp(String code);

  /// Ends the second-factor check and signs out of this browser.
  Future<void> signOut();

  Future<List<StaffSummary>> listStaff();
  Future<List<StaffInviteSummary>> listInvites();
  Future<void> invite(String email, StaffRole role);
  Future<void> revokeInvite(int id);
  Future<void> setRole(UuidValue user, StaffRole role);
  Future<void> setActive(UuidValue user, bool active);
  Future<void> resetTotp(UuidValue user);

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
  Future<ContentAdminItem> unpublishContent(int id);
  Future<void> deleteContent(int id);

  // Users (phase C, admins only). Exact email look-up only.
  Future<UserAdminView?> findUser(String email);
  Future<UserAdminView> setUserBlocked(UuidValue userId, bool blocked);
  Future<void> deleteUserOnRequest(UuidValue userId, String confirmEmail);

  // Anonymous statistics (phase C).
  Future<StatsReport> statsReport();

  /// Hides or shows a catalogue item in the app at once.
  Future<ContentAdminItem> setContentHidden(int id, bool hidden);

  /// Imports the content sheet's articles and recipes as drafts (admins);
  /// returns how many were added.
  Future<int> importSheet();

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

  /// Email and password. Throws [AdminError] `auth.failed` when refused.
  Future<void> login(String email, String password);

  /// Registration: emails a code, returns the request id.
  Future<UuidValue> startRegistration(String email);

  /// Checks the emailed code; returns a token for [finishRegistration].
  Future<String> verifyRegistrationCode(UuidValue requestId, String code);

  /// Sets the password and signs in.
  Future<void> finishRegistration(String token, String password);

  /// Password reset: emails a code, returns the request id.
  Future<UuidValue> startPasswordReset(String email);
  Future<String> verifyPasswordResetCode(UuidValue requestId, String code);
  Future<void> finishPasswordReset(String token, String password);
}
