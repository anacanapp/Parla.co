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
  String get homeTitle => 'Today';

  @override
  String get homePlaceholder =>
      'Your routine will appear here after the skin test. The test arrives in the next version.';

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
}
