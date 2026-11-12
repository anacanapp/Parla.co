/// Answers collected during onboarding (screens M-03 to M-08).
///
/// Held in memory only. Nothing here is written to disk, and it is cleared
/// when a minor is turned away or when onboarding finishes.
class OnboardingState {
  int? birthYear;
  bool? birthdayPassedThisYear;
  String? countryCode;

  bool get hasAge => birthYear != null;

  void clear() {
    birthYear = null;
    birthdayPassedThisYear = null;
    countryCode = null;
  }
}
