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
