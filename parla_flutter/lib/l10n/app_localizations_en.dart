// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Parla';

  @override
  String get languageTitle => 'Choose your language';

  @override
  String get languageName_az => 'Azərbaycanca';

  @override
  String get languageName_ru => 'Русский';

  @override
  String get languageName_en => 'English';

  @override
  String get continueButton => 'Continue';

  @override
  String get welcomeTitle => 'Your personal care guide';

  @override
  String get welcomeBody1 =>
      'Routines for your skin, hair and body, checked by experts.';

  @override
  String get welcomeBody2 =>
      'Scan a product and see what each ingredient does, with official sources.';

  @override
  String get welcomeBody3 =>
      'Sleep, water and movement: small habits tracked in one place.';

  @override
  String get welcomeStart => 'Get started';

  @override
  String get welcomeBrowse => 'Browse without an account';

  @override
  String get welcomeSignIn => 'I already have an account';

  @override
  String get ageTitle => 'What year were you born?';

  @override
  String get ageWhy =>
      'Parla is for people aged 18 and over. We only store the year, never the full date.';

  @override
  String get ageYearLabel => 'Birth year';

  @override
  String get ageInvalid => 'Enter a year between 1900 and this year.';

  @override
  String get ageBirthdayQuestion =>
      'Have you already had your birthday this year?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get underageTitle => 'Parla is for adults';

  @override
  String get underageBody =>
      'Parla is only available to people aged 18 and over. Nothing you entered has been stored.';

  @override
  String get close => 'Close';

  @override
  String get signInTitle => 'Sign in or create an account';

  @override
  String get signInBody =>
      'We will email you a one-time code. No password needed.';

  @override
  String get signInFailed => 'Sign-in failed. Please try again.';

  @override
  String get countryTitle => 'Where do you live?';

  @override
  String get countryWhy =>
      'Your data is stored in your country\'s region. Parla opens in Azerbaijan first.';

  @override
  String get countryComingSoon => 'Coming soon';

  @override
  String get countryName_AZ => 'Azerbaijan';

  @override
  String get countryName_TR => 'Türkiye';

  @override
  String get countryName_KZ => 'Kazakhstan';

  @override
  String get countryName_UZ => 'Uzbekistan';

  @override
  String get consentTitle => 'Your choices';

  @override
  String get consentIntro =>
      'Each consent is separate and off by default. The app works without them, and you can change them any time in Settings → Privacy.';

  @override
  String get consentHealthTitle => 'Health-related answers';

  @override
  String get consentHealthHint =>
      'Needed only for the optional questions about skin conditions, allergies, pregnancy and medicines.';

  @override
  String get consentAnalyticsTitle => 'Usage statistics';

  @override
  String get consentMarketingTitle => 'News and tips by email';

  @override
  String consentVersion(String version) {
    return 'Text version: $version';
  }

  @override
  String get guestTitle => 'Product search';

  @override
  String get guestPlaceholder =>
      'Product search and scanning arrive in the next version.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get error_age_minor =>
      'Parla is only available to people aged 18 and over.';

  @override
  String get error_age_needs_confirmation =>
      'Please answer the birthday question.';

  @override
  String get error_age_invalid => 'Enter a valid birth year.';

  @override
  String get error_country_closed => 'Parla is not open in this country yet.';

  @override
  String get error_language_unsupported =>
      'This language is not supported yet.';

  @override
  String get error_profile_exists => 'Your profile already exists.';

  @override
  String get error_consent_outdated_version =>
      'The consent text has changed. Please review it again.';

  @override
  String get homeGreetingMorning => 'Good morning!';

  @override
  String get homeGreetingAfternoon => 'Good afternoon!';

  @override
  String get homeGreetingEvening => 'Good evening!';

  @override
  String get homeTagline => 'A little more you, every day.';

  @override
  String get homeProfileButton => 'Profile and privacy';

  @override
  String get routineSwitchLabel => 'Choose routine';

  @override
  String get routineMorning => 'Morning';

  @override
  String get routineEvening => 'Evening';

  @override
  String get routineMorningTitle => 'Morning routine';

  @override
  String get routineEveningTitle => 'Evening routine';

  @override
  String get stepStatusDone => 'Done';

  @override
  String stepMarkDone(String step) {
    return '$step: mark as done';
  }

  @override
  String stepMarkUndone(String step) {
    return '$step: done, tap to undo';
  }

  @override
  String routineDoneHeader(String routine) {
    return '$routine is ready';
  }

  @override
  String get routineDoneTitle => 'You glowed again today.';

  @override
  String get routineDoneBody =>
      'Every step is done. See you at the next routine.';

  @override
  String get routineRestart => 'Start again';

  @override
  String get habitsTitle => 'Today\'s habits';

  @override
  String get habitWater => 'Water';

  @override
  String habitWaterCount(int count, int goal) {
    return '$count of $goal glasses';
  }

  @override
  String get habitWaterAdd => 'Add a glass';

  @override
  String get habitWaterRemove => 'Remove a glass';

  @override
  String get habitSleep => 'Sleep';

  @override
  String get habitMove => 'Movement';

  @override
  String get habitNoEntry => 'Nothing logged yet';

  @override
  String get habitLog => 'Log';

  @override
  String get scanTitle => 'Check a product';

  @override
  String get scanBody =>
      'Scan the barcode and see the ingredients in plain words';

  @override
  String get navMenuLabel => 'Main menu';

  @override
  String get navToday => 'Today';

  @override
  String get navScan => 'Scan';

  @override
  String get navHabits => 'Habits';

  @override
  String get navProfile => 'Profile';

  @override
  String get comingSoon => 'This part arrives in the next version.';

  @override
  String get routineMorningEyebrow => 'MORNING ROUTINE';

  @override
  String get routineEveningEyebrow => 'EVENING ROUTINE';

  @override
  String get routineStatusStart => 'Let\'s begin';

  @override
  String routineStatusLeft(int left) {
    String _temp0 = intl.Intl.pluralLogic(
      left,
      locale: localeName,
      other: '$left steps to go',
      one: '1 step to go',
    );
    return '$_temp0';
  }

  @override
  String get routineStatusDone => 'All done';

  @override
  String routineMinutesLeft(int minutes) {
    return 'About $minutes min left';
  }

  @override
  String routineProgressLabel(String routine, int done, int total) {
    return '$routine: $done of $total steps done';
  }
}
