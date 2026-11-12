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
    if (kind == ConsentKind.health) healthConsent = granted;
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
