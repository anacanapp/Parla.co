import 'package:flutter/widgets.dart';
import 'package:parla_shared/parla_shared.dart';

/// A rule violation reported by the server, identified by a stable [code]
/// such as `age.minor`. Screens translate it with `errorMessage`.
class ApiError implements Exception {
  const ApiError(this.code);

  final String code;

  @override
  String toString() => 'ApiError($code)';
}

/// The part of a profile the app needs.
class ProfileSummary {
  const ProfileSummary({required this.countryCode, required this.language});

  final String countryCode;
  final String language;
}

/// Everything the screens need from the backend.
///
/// Screens depend on this interface, not on the generated Serverpod client,
/// so widget tests can run without a server.
abstract interface class ParlaApi {
  bool get isSignedIn;

  /// The signed-in user's profile, or `null` before onboarding is finished.
  Future<ProfileSummary?> myProfile();

  /// Creates the profile. Throws [ApiError] when a rule is broken.
  Future<void> createProfile({
    required int birthYear,
    bool? birthdayPassedThisYear,
    required String countryCode,
    required String language,
  });

  /// Records a consent decision about the text version the user saw.
  Future<void> decideConsent({
    required ConsentKind kind,
    required bool granted,
    required String textVersion,
    required String language,
  });

  /// Whether the health consent is currently granted.
  Future<bool> hasHealthConsent();

  /// Saves quiz answers. Only questions with `stored: true` are sent; health
  /// answers only when the health consent is granted.
  Future<void> saveQuizAnswers(QuizAnswers answers);

  /// The saved quiz answers, or `null` when the quiz was never taken.
  Future<QuizAnswers?> myQuizAnswers();

  /// The current decision for every consent (M-28).
  Future<Map<ConsentKind, bool>> consentStates();

  /// Everything stored about the user, as JSON (M-31).
  Future<String> exportMyData();

  /// Deletes the account and signs out on this device (M-32).
  Future<void> deleteAccount();

  /// Signs out on this device.
  Future<void> signOut();

  /// The sign-in UI (screens M-05 and M-06).
  Widget buildSignIn(
    BuildContext context, {
    required VoidCallback onSignedIn,
    required ValueChanged<Object> onError,
  });
}
