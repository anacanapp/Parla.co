import 'package:flutter/foundation.dart';
import 'package:parla_admin/api/admin_api.dart';

/// In-memory server for the panel tests.
class FakeAdminApi implements AdminApi {
  final _auth = ValueNotifier<int>(0);
  bool signedIn = false;
  StaffMe? meValue;
  AdminError? meError;
  String inviteCode = 'GOODCODE';
  final staff = <StaffSummary>[];
  final invites = <StaffInviteSummary>[];
  final calls = <String>[];

  @override
  bool get isSignedIn => signedIn;

  @override
  Listenable get authChanges => _auth;

  @override
  Future<StaffMe?> me() async {
    final error = meError;
    if (error != null) {
      // Like the real client: an expired sign-in signs out first.
      if (error.code == 'staff.sign_in_again') await signOut();
      throw error;
    }
    return meValue;
  }

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
      signInExpiresAt: DateTime.now().toUtc().add(const Duration(hours: 12)),
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

  final content = <ContentAdminItem>[];
  var _nextId = 1;

  ContentAdminItem _find(int id) => content.firstWhere((c) => c.id == id);

  ContentAdminItem _put(ContentAdminItem item) {
    content
      ..removeWhere((c) => c.id == item.id)
      ..add(item);
    return item;
  }

  final List<MediaAdminItem> images = [];
  final Map<int, Uint8List> imageBytes = {};

  @override
  Future<MediaAdminItem> uploadImage(
    Uint8List bytes,
    String license,
    String? source,
    String altJson,
  ) async {
    calls.add('upload:${bytes.length}:$license:$altJson');
    final item = MediaAdminItem(
      id: _nextId++,
      pixelWidth: 40,
      pixelHeight: 30,
      bytes: bytes.length,
      license: license,
      source: source,
      altJson: altJson,
      public: false,
      createdAt: DateTime.utc(2026, 11, 16),
    );
    images.add(item);
    imageBytes[item.id] = bytes;
    return item;
  }

  @override
  Future<List<MediaAdminItem>> listImages() async => List.of(images);

  @override
  Future<Uint8List> imagePreview(int id) async => imageBytes[id]!;

  @override
  Future<MediaAdminItem> updateImage(
    int id,
    String license,
    String? source,
    String altJson,
  ) async {
    calls.add('updateImage:$id:$altJson');
    final i = images.indexWhere((m) => m.id == id);
    images[i] = images[i].copyWith(
      license: license,
      source: source,
      altJson: altJson,
    );
    return images[i];
  }

  @override
  Future<void> deleteImage(int id) async {
    images.removeWhere((m) => m.id == id);
  }

  @override
  Future<ContentAdminItem> setContentHidden(int id, bool hidden) async {
    calls.add('hidden:$id:$hidden');
    return _put(_find(id).copyWith(hidden: hidden));
  }

  /// App accounts by email, for the users section.
  final Map<String, UserAdminView> users = {};

  @override
  Future<UserAdminView?> findUser(String email) async {
    calls.add('findUser:$email');
    return users[email.trim().toLowerCase()];
  }

  @override
  Future<UserAdminView> setUserBlocked(UuidValue userId, bool blocked) async {
    calls.add('block:$userId:$blocked');
    final e = users.entries.firstWhere((e) => e.value.userId == userId);
    return users[e.key] = e.value.copyWith(blocked: blocked);
  }

  @override
  Future<void> deleteUserOnRequest(
    UuidValue userId,
    String confirmEmail,
  ) async {
    final e = users.entries.firstWhere((e) => e.value.userId == userId);
    if (e.key != confirmEmail.trim().toLowerCase()) {
      throw const AdminError('users.confirm_mismatch');
    }
    calls.add('deleteUser:$userId');
    users.remove(e.key);
  }

  StatsReport? stats;

  final Map<int, List<SupportEntry>> supportByThread = {};
  final List<SupportThreadSummary> threads = [];

  @override
  Future<List<SupportThreadSummary>> supportThreads() async => List.of(threads);

  @override
  Future<List<SupportEntry>> openSupportThread(int id) async {
    calls.add('openSupport:$id');
    return List.of(supportByThread[id] ?? const []);
  }

  @override
  Future<void> replySupport(int id, String text) async {
    calls.add('reply:$id:$text');
    (supportByThread[id] ??= []).add(
      SupportEntry(
        fromStaff: true,
        text: text,
        createdAt: DateTime.utc(2026, 11, 17),
      ),
    );
  }

  @override
  Future<void> closeSupportThread(int id) async {
    calls.add('close:$id');
    final i = threads.indexWhere((t) => t.id == id);
    threads[i] = threads[i].copyWith(open: false);
  }

  @override
  Future<StatsReport> statsReport() async => stats!;

  DashboardReport? dashboardReport;
  final dashboardDays = <int>[];

  @override
  Future<DashboardReport> dashboard(int days) async {
    dashboardDays.add(days);
    return dashboardReport!;
  }

  @override
  Future<int> publishImportedArticles() async {
    calls.add('publish-imported');
    var n = 0;
    for (final c in [...content]) {
      if (c.kind != 'article' || c.status != ContentStatus.draft) continue;
      _put(c.copyWith(status: ContentStatus.published, live: true));
      n++;
    }
    return n;
  }

  /// What [importSheet] adds: (kind, slug, category, json).
  List<(String, String, String, String)> sheet = [];

  @override
  Future<int> importSheet() async {
    calls.add('import');
    var added = 0;
    for (final (kind, slug, category, json) in sheet) {
      if (content.any((c) => c.kind == kind && c.slug == slug)) continue;
      _put(
        ContentAdminItem(
          id: _nextId++,
          kind: kind,
          slug: slug,
          category: category,
          status: ContentStatus.draft,
          draftJson: json,
          live: false,
          consentRecorded: false,
          hidden: false,
          updatedAt: DateTime.utc(2026, 11, 16),
        ),
      );
      added++;
    }
    return added;
  }

  @override
  Future<List<ContentAdminItem>> listContent(String kind) async => [
    for (final c in content)
      if (c.kind == kind) c,
  ];

  @override
  Future<ContentAdminItem> createContent(
    String kind,
    String slug,
    String category,
  ) async {
    if (!RegExp(r'^[a-z0-9-]+$').hasMatch(slug)) {
      throw const AdminError('content.invalid');
    }
    return _put(
      ContentAdminItem(
        id: _nextId++,
        kind: kind,
        slug: slug,
        category: category,
        status: ContentStatus.draft,
        draftJson: '{}',
        live: false,
        consentRecorded: false,
        hidden: false,
        updatedAt: DateTime.utc(2026, 11, 16),
      ),
    );
  }

  @override
  Future<ContentAdminItem> saveContent(
    int id,
    String json,
    String category,
  ) async {
    calls.add('save:$id:$json');
    return _put(
      _find(id).copyWith(
        draftJson: json,
        category: category,
        status: ContentStatus.draft,
      ),
    );
  }

  @override
  Future<ContentAdminItem> submitContent(int id) async =>
      _put(_find(id).copyWith(status: ContentStatus.inReview));

  @override
  Future<ContentAdminItem> approveContent(int id) async =>
      _put(_find(id).copyWith(status: ContentStatus.approved));

  @override
  Future<ContentAdminItem> returnContent(int id, String note) async => _put(
    _find(id).copyWith(status: ContentStatus.draft, reviewNote: note),
  );

  @override
  Future<ContentAdminItem> recordConsent(int id, String reference) async =>
      _put(_find(id).copyWith(consentRecorded: true));

  @override
  Future<ContentAdminItem> publishContent(int id) async {
    calls.add('publish:$id');
    return _put(
      _find(id).copyWith(status: ContentStatus.published, live: true),
    );
  }

  @override
  Future<ContentAdminItem> unpublishContent(int id) async =>
      _put(_find(id).copyWith(status: ContentStatus.draft, live: false));

  @override
  Future<void> deleteContent(int id) async =>
      content.removeWhere((c) => c.id == id);
}
