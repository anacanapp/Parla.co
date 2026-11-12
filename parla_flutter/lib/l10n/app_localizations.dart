import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_az.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('az'),
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Parla'**
  String get appTitle;

  /// M-01 heading
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get languageTitle;

  /// No description provided for @languageName_az.
  ///
  /// In en, this message translates to:
  /// **'Azərbaycanca'**
  String get languageName_az;

  /// No description provided for @languageName_ru.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageName_ru;

  /// No description provided for @languageName_en.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName_en;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// M-02 heading
  ///
  /// In en, this message translates to:
  /// **'Your personal care guide'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody1.
  ///
  /// In en, this message translates to:
  /// **'Routines for your skin, hair and body, checked by experts.'**
  String get welcomeBody1;

  /// No description provided for @welcomeBody2.
  ///
  /// In en, this message translates to:
  /// **'Scan a product and see what each ingredient does, with official sources.'**
  String get welcomeBody2;

  /// No description provided for @welcomeBody3.
  ///
  /// In en, this message translates to:
  /// **'Sleep, water and movement: small habits tracked in one place.'**
  String get welcomeBody3;

  /// No description provided for @welcomeStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get welcomeStart;

  /// No description provided for @welcomeBrowse.
  ///
  /// In en, this message translates to:
  /// **'Browse without an account'**
  String get welcomeBrowse;

  /// No description provided for @welcomeSignIn.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get welcomeSignIn;

  /// M-03 heading
  ///
  /// In en, this message translates to:
  /// **'What year were you born?'**
  String get ageTitle;

  /// No description provided for @ageWhy.
  ///
  /// In en, this message translates to:
  /// **'Parla is for people aged 18 and over. We only store the year, never the full date.'**
  String get ageWhy;

  /// No description provided for @ageYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Birth year'**
  String get ageYearLabel;

  /// No description provided for @ageInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a year between 1900 and this year.'**
  String get ageInvalid;

  /// No description provided for @ageBirthdayQuestion.
  ///
  /// In en, this message translates to:
  /// **'Have you already had your birthday this year?'**
  String get ageBirthdayQuestion;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// M-04 heading
  ///
  /// In en, this message translates to:
  /// **'Parla is for adults'**
  String get underageTitle;

  /// No description provided for @underageBody.
  ///
  /// In en, this message translates to:
  /// **'Parla is only available to people aged 18 and over. Nothing you entered has been stored.'**
  String get underageBody;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// M-05 heading
  ///
  /// In en, this message translates to:
  /// **'Sign in or create an account'**
  String get signInTitle;

  /// No description provided for @signInBody.
  ///
  /// In en, this message translates to:
  /// **'We will email you a one-time code. No password needed.'**
  String get signInBody;

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed. Please try again.'**
  String get signInFailed;

  /// M-07 heading
  ///
  /// In en, this message translates to:
  /// **'Where do you live?'**
  String get countryTitle;

  /// No description provided for @countryWhy.
  ///
  /// In en, this message translates to:
  /// **'Your data is stored in your country\'s region. Parla opens in Azerbaijan first.'**
  String get countryWhy;

  /// No description provided for @countryComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get countryComingSoon;

  /// No description provided for @countryName_AZ.
  ///
  /// In en, this message translates to:
  /// **'Azerbaijan'**
  String get countryName_AZ;

  /// No description provided for @countryName_TR.
  ///
  /// In en, this message translates to:
  /// **'Türkiye'**
  String get countryName_TR;

  /// No description provided for @countryName_KZ.
  ///
  /// In en, this message translates to:
  /// **'Kazakhstan'**
  String get countryName_KZ;

  /// No description provided for @countryName_UZ.
  ///
  /// In en, this message translates to:
  /// **'Uzbekistan'**
  String get countryName_UZ;

  /// M-08 heading
  ///
  /// In en, this message translates to:
  /// **'Your choices'**
  String get consentTitle;

  /// No description provided for @consentIntro.
  ///
  /// In en, this message translates to:
  /// **'Each consent is separate and off by default. The app works without them, and you can change them any time in Settings → Privacy.'**
  String get consentIntro;

  /// No description provided for @consentHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Health-related answers'**
  String get consentHealthTitle;

  /// No description provided for @consentHealthHint.
  ///
  /// In en, this message translates to:
  /// **'Needed only for the optional questions about skin conditions, allergies, pregnancy and medicines.'**
  String get consentHealthHint;

  /// No description provided for @consentAnalyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Usage statistics'**
  String get consentAnalyticsTitle;

  /// No description provided for @consentMarketingTitle.
  ///
  /// In en, this message translates to:
  /// **'News and tips by email'**
  String get consentMarketingTitle;

  /// No description provided for @consentVersion.
  ///
  /// In en, this message translates to:
  /// **'Text version: {version}'**
  String consentVersion(String version);

  /// M-14 placeholder
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeTitle;

  /// No description provided for @homePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your routine will appear here after the skin test. The test arrives in the next version.'**
  String get homePlaceholder;

  /// No description provided for @guestTitle.
  ///
  /// In en, this message translates to:
  /// **'Product search'**
  String get guestTitle;

  /// No description provided for @guestPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Product search and scanning arrive in the next version.'**
  String get guestPlaceholder;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @error_age_minor.
  ///
  /// In en, this message translates to:
  /// **'Parla is only available to people aged 18 and over.'**
  String get error_age_minor;

  /// No description provided for @error_age_needs_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Please answer the birthday question.'**
  String get error_age_needs_confirmation;

  /// No description provided for @error_age_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid birth year.'**
  String get error_age_invalid;

  /// No description provided for @error_country_closed.
  ///
  /// In en, this message translates to:
  /// **'Parla is not open in this country yet.'**
  String get error_country_closed;

  /// No description provided for @error_language_unsupported.
  ///
  /// In en, this message translates to:
  /// **'This language is not supported yet.'**
  String get error_language_unsupported;

  /// No description provided for @error_profile_exists.
  ///
  /// In en, this message translates to:
  /// **'Your profile already exists.'**
  String get error_profile_exists;

  /// No description provided for @error_consent_outdated_version.
  ///
  /// In en, this message translates to:
  /// **'The consent text has changed. Please review it again.'**
  String get error_consent_outdated_version;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['az', 'en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'az':
      return AppLocalizationsAz();
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
