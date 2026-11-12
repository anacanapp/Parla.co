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
  }

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
