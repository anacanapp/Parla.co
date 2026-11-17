import 'package:flutter/material.dart';
import 'package:parla/services/parla_api.dart';
import 'package:parla_shared/parla_shared.dart';

/// In-memory backend: records what the app sends.
class FakeApi implements ParlaApi {
  bool signedIn = false;
  ProfileSummary? profile;
  final createdProfiles = <Map<String, Object?>>[];
  final consentCalls = <(ConsentKind, bool, String, String)>[];

  @override
  bool get isSignedIn => signedIn;

  String userId = 'user-1';

  @override
  String? get accountId => signedIn ? userId : null;

  @override
  Future<ProfileSummary?> myProfile() async => profile;

  @override
  Future<void> createProfile({
    required int birthYear,
    bool? birthdayPassedThisYear,
    required String countryCode,
    required String language,
  }) async {
    createdProfiles.add({
      'birthYear': birthYear,
      'birthdayPassedThisYear': birthdayPassedThisYear,
      'countryCode': countryCode,
      'language': language,
    });
    profile = ProfileSummary(countryCode: countryCode, language: language);
  }

  @override
  Future<void> decideConsent({
    required ConsentKind kind,
    required bool granted,
    required String textVersion,
    required String language,
  }) async {
    consentCalls.add((kind, granted, textVersion, language));
    consents[kind] = granted;
    if (kind == ConsentKind.health) {
      healthConsent = granted;
      if (!granted) {
        quizAnswers = null; // Mirrors the server's erase.
        routines = null;
        careList = null;
        sport = null;
        nutrition = null;
      }
    }
  }

  bool healthConsent = false;
  QuizAnswers? quizAnswers;
  final savedQuizAnswers = <QuizAnswers>[];

  @override
  Future<bool> hasHealthConsent() async => healthConsent;

  @override
  Future<void> saveQuizAnswers(QuizAnswers answers) async {
    // Mirror the real API: drop answers that must never leave the device,
    // and health answers without consent.
    bool keep(String id) {
      final q = quizQuestion(id)!;
      return q.stored && (!q.sensitive || healthConsent);
    }

    final sent = QuizAnswers(
      chosen: {
        for (final e in answers.chosen.entries)
          if (keep(e.key)) e.key: e.value,
      },
      declined: answers.declined.where(keep).toSet(),
    );
    savedQuizAnswers.add(sent);
    quizAnswers = sent;
  }

  @override
  Future<QuizAnswers?> myQuizAnswers() async => quizAnswers;

  /// Own routines as the server keeps them; [routineError] makes the
  /// calls fail like an offline phone.
  String? routines;
  int routineSaves = 0;
  Object? routineError;

  /// The care list as the server keeps it.
  String? careList;
  int careListSaves = 0;

  @override
  Future<String?> myCareList() async {
    if (routineError != null) throw routineError!;
    return healthConsent ? careList : null;
  }

  @override
  Future<void> saveCareList(String json) async {
    if (routineError != null) throw routineError!;
    if (!healthConsent) throw const ApiError('consent.health_required');
    if (!CareListRules.isValid(json)) {
      throw const ApiError('care_list.invalid');
    }
    careListSaves++;
    careList = json;
  }

  /// Published content per kind.
  final published = <String, List<PublishedItem>>{};
  Object? contentError;

  @override
  Future<List<PublishedItem>> publishedContent(String kind) async {
    if (contentError != null) throw contentError!;
    return published[kind] ?? const [];
  }

  /// The plate entries as the server keeps them.
  String? nutrition;

  int activeMarks = 0;

  final List<SupportItem> support = [];
  bool supportUnread = false;

  @override
  Future<List<SupportItem>> supportMessages() async {
    supportUnread = false;
    return List.of(support);
  }

  @override
  Future<void> sendSupport(String text) async => support.add(
    SupportItem(fromTeam: false, text: text, at: DateTime.utc(2026, 11, 16)),
  );

  @override
  Future<bool> hasUnreadSupportReply() async => supportUnread;

  /// Push tokens registered for this account.
  final Set<String> pushTokens = {};

  @override
  Future<void> registerPush(String token, String platform) async =>
      pushTokens.add(token);

  @override
  Future<void> unregisterPush(String token) async => pushTokens.remove(token);

  @override
  Future<void> markActive() async => activeMarks++;

  @override
  Future<String?> myNutrition() async {
    if (routineError != null) throw routineError!;
    return healthConsent ? nutrition : null;
  }

  @override
  Future<void> saveNutrition(String json) async {
    if (routineError != null) throw routineError!;
    if (!healthConsent) throw const ApiError('consent.health_required');
    if (!NutritionRules.isValid(json)) {
      throw const ApiError('nutrition.invalid');
    }
    nutrition = json;
  }

  /// The sport document as the server keeps it.
  String? sport;

  @override
  Future<String?> mySport() async {
    if (routineError != null) throw routineError!;
    return healthConsent ? sport : null;
  }

  @override
  Future<void> saveSport(String json) async {
    if (routineError != null) throw routineError!;
    if (!healthConsent) throw const ApiError('consent.health_required');
    if (!SportRules.isValid(json)) throw const ApiError('sport.invalid');
    sport = json;
  }

  @override
  Future<String?> myRoutines() async {
    if (routineError != null) throw routineError!;
    return healthConsent ? routines : null;
  }

  @override
  Future<void> saveRoutines(String json) async {
    if (routineError != null) throw routineError!;
    if (!healthConsent) throw const ApiError('consent.health_required');
    if (!CustomRoutineRules.isValid(json)) {
      throw const ApiError('routines.invalid');
    }
    routineSaves++;
    routines = json;
  }

  final consents = <ConsentKind, bool>{
    for (final kind in ConsentKind.values) kind: false,
  };
  int exports = 0;
  bool deleted = false;

  @override
  Future<Map<ConsentKind, bool>> consentStates() async => {
    ...consents,
    ConsentKind.health: healthConsent,
  };

  @override
  Future<String> exportMyData() async {
    exports++;
    return '{"format":"parla-export-v1"}';
  }

  @override
  Future<void> deleteAccount() async {
    deleted = true;
    signedIn = false;
    profile = null;
    quizAnswers = null;
    routines = null;
    careList = null;
    sport = null;
    nutrition = null;
  }

  /// Products every search returns; [productError] makes search fail.
  List<ProductResult> products = const [];
  String? productError;
  final productQueries = <String>[];

  @override
  Future<List<ProductResult>> searchProducts(String query) async {
    productQueries.add(query);
    if (productError != null) throw ApiError(productError!);
    return products;
  }

  @override
  Future<void> signOut() async => signedIn = false;

  @override
  Widget buildSignIn(
    BuildContext context, {
    required VoidCallback onSignedIn,
    required ValueChanged<Object> onError,
  }) => ElevatedButton(
    key: const ValueKey('fake-sign-in'),
    onPressed: () {
      signedIn = true;
      onSignedIn();
    },
    child: const Text('fake sign in'),
  );
}
