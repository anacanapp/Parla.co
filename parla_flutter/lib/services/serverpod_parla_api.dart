import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:parla_client/parla_client.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'parla_api.dart';

/// [ParlaApi] backed by the Parla Serverpod server.
class ServerpodParlaApi implements ParlaApi {
  ServerpodParlaApi(this._client);

  final Client _client;

  @override
  bool get isSignedIn => _client.auth.isAuthenticated;

  @override
  String? get accountId => _client.auth.authInfo?.authUserId.toString();

  @override
  Future<ProfileSummary?> myProfile() => _guard(() async {
    final profile = await _client.profile.me();
    if (profile == null) return null;
    return ProfileSummary(
      countryCode: profile.countryCode,
      language: profile.language,
    );
  });

  @override
  Future<void> createProfile({
    required int birthYear,
    bool? birthdayPassedThisYear,
    required String countryCode,
    required String language,
  }) => _guard(
    () => _client.profile.create(
      birthYear: birthYear,
      birthdayPassedThisYear: birthdayPassedThisYear,
      countryCode: countryCode,
      language: language,
    ),
  );

  @override
  Future<void> decideConsent({
    required ConsentKind kind,
    required bool granted,
    required String textVersion,
    required String language,
  }) => _guard(
    () => _client.consent.decide(
      consentType: ConsentType.values.byName(kind.name),
      granted: granted,
      textVersion: textVersion,
      language: language,
      source: kIsWeb ? 'web' : 'app',
    ),
  );

  @override
  Future<String?> grantedHealthVersion() => _guard(() async {
    final states = await _client.consent.current();
    for (final s in states) {
      if (s.consentType == ConsentType.health && s.granted) {
        return s.textVersion;
      }
    }
    return null;
  });

  @override
  Future<bool> hasHealthConsent() => _guard(() async {
    final states = await _client.consent.current();
    return states.any(
      (s) => s.consentType == ConsentType.health && s.granted,
    );
  });

  @override
  Future<void> saveQuizAnswers(QuizAnswers answers) => _guard(() async {
    final inputs = <QuizAnswerInput>[];
    for (final question in quizQuestions.where((q) => q.stored)) {
      if (answers.answered(question.id)) {
        inputs.add(
          QuizAnswerInput(
            questionId: question.id,
            optionIds: answers.of(question.id),
            declined: false,
          ),
        );
      } else if (answers.declined.contains(question.id)) {
        inputs.add(
          QuizAnswerInput(
            questionId: question.id,
            optionIds: const [],
            declined: true,
          ),
        );
      }
    }
    if (inputs.isNotEmpty) await _client.quiz.saveAnswers(inputs);
  });

  @override
  Future<String?> myRoutines() => _guard(_client.routine.myRoutines);

  @override
  Future<void> saveRoutines(String json) =>
      _guard(() => _client.routine.saveRoutines(json));

  @override
  Future<String?> myCareList() => _guard(_client.careList.myCareList);

  @override
  Future<void> saveCareList(String json) =>
      _guard(() => _client.careList.saveCareList(json));

  @override
  Future<List<PublishedItem>> publishedContent(String kind) => _guard(() async {
    final rows = await _client.content.published(kind);
    return [
      for (final r in rows)
        PublishedItem(
          id: r.id,
          kind: r.kind,
          slug: r.slug,
          category: r.category,
          data: (jsonDecode(r.json) as Map).cast<String, Object?>(),
          publishedAt: r.publishedAt,
          reviewedAt: r.reviewedAt,
          image: switch (r.image) {
            final i? when i.url.startsWith('https://') => ContentImageRef(
              url: i.url,
              width: i.pixelWidth,
              height: i.pixelHeight,
              alt: (jsonDecode(i.altJson) as Map).cast<String, Object?>(),
            ),
            _ => null,
          },
          hidden: r.hidden,
        ),
    ];
  });

  @override
  Future<String?> myNutrition() => _guard(_client.nutrition.myNutrition);

  @override
  Future<void> markActive() => _guard(_client.activity.markActive);

  @override
  Future<List<SupportItem>> supportMessages() => _guard(() async {
    final rows = await _client.support.myMessages();
    return [
      for (final r in rows)
        SupportItem(fromTeam: r.fromStaff, text: r.text, at: r.createdAt),
    ];
  });

  @override
  Future<void> registerPush(String token, String platform) =>
      _guard(() => _client.push.register(token, platform));

  @override
  Future<void> unregisterPush(String token) =>
      _guard(() => _client.push.unregister(token));

  @override
  Future<void> sendSupport(String text) =>
      _guard(() => _client.support.send(text));

  @override
  Future<bool> hasUnreadSupportReply() =>
      _guard(_client.support.hasUnreadReply);

  @override
  Future<void> saveNutrition(String json) =>
      _guard(() => _client.nutrition.saveNutrition(json));

  @override
  Future<String?> mySport() => _guard(_client.sport.mySport);

  @override
  Future<void> saveSport(String json) =>
      _guard(() => _client.sport.saveSport(json));

  @override
  Future<QuizAnswers?> myQuizAnswers() => _guard(() async {
    final saved = await _client.quiz.myAnswers();
    if (saved.isEmpty) return null;
    return QuizAnswers(
      chosen: {
        for (final a in saved)
          if (!a.declined) a.questionId: a.optionIds,
      },
      declined: {
        for (final a in saved)
          if (a.declined) a.questionId,
      },
    );
  });

  @override
  Future<Map<ConsentKind, bool>> consentStates() => _guard(() async {
    final states = await _client.consent.current();
    return {
      for (final s in states)
        ConsentKind.values.byName(s.consentType.name): s.granted,
    };
  });

  @override
  Future<String> exportMyData() => _guard(_client.account.exportMyData);

  @override
  Future<void> deleteAccount() => _guard(() async {
    await _client.account.deleteAccount();
    await _signOutLocally();
  });

  @override
  Future<List<ProductResult>> searchProducts(String query) => _guard(() async {
    final found = await _client.product.search(query);
    return [
      for (final p in found)
        ProductResult(
          source: p.source,
          code: p.code,
          name: p.productName,
          brand: p.brand,
          ingredientsText: p.ingredientsText,
          sourceUrl: p.sourceUrl,
        ),
    ];
  });

  @override
  Future<void> signOut() => _guard(_signOutLocally);

  Future<void> _signOutLocally() async {
    try {
      await _client.auth.signOutDevice();
    } on Object {
      // The server may already have dropped the session (deleted account);
      // the local session is cleared either way.
    }
  }

  @override
  Widget buildSignIn(
    BuildContext context, {
    required VoidCallback onSignedIn,
    required ValueChanged<Object> onError,
  }) => SignInWidget(
    client: _client,
    onAuthenticated: onSignedIn,
    onError: onError,
    // Only email one-time codes are configured on the server for now.
    // Apple and Google need their developer accounts first.
    disableAnonymousSignInWidget: true,
  );

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on ParlaException catch (e) {
      throw ApiError(e.code);
    }
  }
}
