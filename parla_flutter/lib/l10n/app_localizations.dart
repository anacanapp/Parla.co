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

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning!'**
  String get homeGreetingMorning;

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon!'**
  String get homeGreetingAfternoon;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening!'**
  String get homeGreetingEvening;

  /// No description provided for @homeTagline.
  ///
  /// In en, this message translates to:
  /// **'A little more you, every day.'**
  String get homeTagline;

  /// No description provided for @homeProfileButton.
  ///
  /// In en, this message translates to:
  /// **'Profile and privacy'**
  String get homeProfileButton;

  /// No description provided for @routineSwitchLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose routine'**
  String get routineSwitchLabel;

  /// No description provided for @routineMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get routineMorning;

  /// No description provided for @routineEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get routineEvening;

  /// No description provided for @routineMorningTitle.
  ///
  /// In en, this message translates to:
  /// **'Morning routine'**
  String get routineMorningTitle;

  /// No description provided for @routineEveningTitle.
  ///
  /// In en, this message translates to:
  /// **'Evening routine'**
  String get routineEveningTitle;

  /// No description provided for @stepStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get stepStatusDone;

  /// No description provided for @stepMarkDone.
  ///
  /// In en, this message translates to:
  /// **'{step}: mark as done'**
  String stepMarkDone(String step);

  /// No description provided for @stepMarkUndone.
  ///
  /// In en, this message translates to:
  /// **'{step}: done, tap to undo'**
  String stepMarkUndone(String step);

  /// No description provided for @routineDoneHeader.
  ///
  /// In en, this message translates to:
  /// **'{routine} is ready'**
  String routineDoneHeader(String routine);

  /// No description provided for @routineDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'You glowed again today.'**
  String get routineDoneTitle;

  /// No description provided for @routineDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Every step is done. See you at the next routine.'**
  String get routineDoneBody;

  /// No description provided for @routineRestart.
  ///
  /// In en, this message translates to:
  /// **'Start again'**
  String get routineRestart;

  /// No description provided for @habitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s habits'**
  String get habitsTitle;

  /// No description provided for @habitWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get habitWater;

  /// No description provided for @habitWaterCount.
  ///
  /// In en, this message translates to:
  /// **'{count} of {goal} glasses'**
  String habitWaterCount(int count, int goal);

  /// No description provided for @habitWaterAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a glass'**
  String get habitWaterAdd;

  /// No description provided for @habitWaterRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove a glass'**
  String get habitWaterRemove;

  /// No description provided for @habitSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get habitSleep;

  /// No description provided for @habitMove.
  ///
  /// In en, this message translates to:
  /// **'Movement'**
  String get habitMove;

  /// No description provided for @habitNoEntry.
  ///
  /// In en, this message translates to:
  /// **'Nothing logged yet'**
  String get habitNoEntry;

  /// No description provided for @habitLog.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get habitLog;

  /// No description provided for @navMenuLabel.
  ///
  /// In en, this message translates to:
  /// **'Main menu'**
  String get navMenuLabel;

  /// No description provided for @navToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'This part arrives in the next version.'**
  String get comingSoon;

  /// No description provided for @routineMorningEyebrow.
  ///
  /// In en, this message translates to:
  /// **'MORNING ROUTINE'**
  String get routineMorningEyebrow;

  /// No description provided for @routineEveningEyebrow.
  ///
  /// In en, this message translates to:
  /// **'EVENING ROUTINE'**
  String get routineEveningEyebrow;

  /// No description provided for @routineStatusStart.
  ///
  /// In en, this message translates to:
  /// **'Let\'s begin'**
  String get routineStatusStart;

  /// No description provided for @routineStatusLeft.
  ///
  /// In en, this message translates to:
  /// **'{left, plural, =1{1 step to go} other{{left} steps to go}}'**
  String routineStatusLeft(int left);

  /// No description provided for @routineStatusDone.
  ///
  /// In en, this message translates to:
  /// **'All done'**
  String get routineStatusDone;

  /// No description provided for @routineMinutesLeft.
  ///
  /// In en, this message translates to:
  /// **'About {minutes} min left'**
  String routineMinutesLeft(int minutes);

  /// No description provided for @routineProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'{routine}: {done} of {total} steps done'**
  String routineProgressLabel(String routine, int done, int total);

  /// No description provided for @quizIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get to know you.'**
  String get quizIntroTitle;

  /// No description provided for @quizIntroBody.
  ///
  /// In en, this message translates to:
  /// **'A few questions about your skin, hair and daily rhythm. It takes about 3 minutes.'**
  String get quizIntroBody;

  /// No description provided for @quizStart.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start'**
  String get quizStart;

  /// No description provided for @quizLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get quizLater;

  /// No description provided for @quizProgress.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String quizProgress(int current, int total);

  /// No description provided for @quizMultipleHint.
  ///
  /// In en, this message translates to:
  /// **'You can choose several'**
  String get quizMultipleHint;

  /// No description provided for @quizNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get quizNext;

  /// No description provided for @quizBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get quizBack;

  /// No description provided for @quizDecline.
  ///
  /// In en, this message translates to:
  /// **'I\'d rather not answer'**
  String get quizDecline;

  /// No description provided for @quizFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get quizFinish;

  /// No description provided for @healthGateTitle.
  ///
  /// In en, this message translates to:
  /// **'A few sensitive questions'**
  String get healthGateTitle;

  /// No description provided for @healthGateBody.
  ///
  /// In en, this message translates to:
  /// **'The next questions are about skin diagnoses, allergies, pregnancy and medicines. They help keep your routine safe. Your answers are encrypted and stored only with your consent.'**
  String get healthGateBody;

  /// No description provided for @healthGateAgree.
  ///
  /// In en, this message translates to:
  /// **'I agree, continue'**
  String get healthGateAgree;

  /// No description provided for @healthGateSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip this section'**
  String get healthGateSkip;

  /// No description provided for @healthGateSkipNote.
  ///
  /// In en, this message translates to:
  /// **'If you skip, your routine will be built more cautiously.'**
  String get healthGateSkipNote;

  /// No description provided for @redFlagTitle.
  ///
  /// In en, this message translates to:
  /// **'Please show this to a doctor'**
  String get redFlagTitle;

  /// No description provided for @redFlagBody.
  ///
  /// In en, this message translates to:
  /// **'The sign you noted may need a doctor\'s examination. Parla does not diagnose and does not replace a doctor. We recommend seeing a dermatologist.'**
  String get redFlagBody;

  /// No description provided for @redFlagOk.
  ///
  /// In en, this message translates to:
  /// **'I understand'**
  String get redFlagOk;

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'Your routine is ready'**
  String get resultTitle;

  /// No description provided for @resultSkin.
  ///
  /// In en, this message translates to:
  /// **'Skin'**
  String get resultSkin;

  /// No description provided for @resultHair.
  ///
  /// In en, this message translates to:
  /// **'Hair'**
  String get resultHair;

  /// No description provided for @resultGoals.
  ///
  /// In en, this message translates to:
  /// **'Concerns'**
  String get resultGoals;

  /// No description provided for @resultSeeRoutine.
  ///
  /// In en, this message translates to:
  /// **'Show my routine'**
  String get resultSeeRoutine;

  /// No description provided for @homeQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s personalise your routine'**
  String get homeQuizTitle;

  /// No description provided for @homeQuizBody.
  ///
  /// In en, this message translates to:
  /// **'A 3-minute quiz and your routine adapts to you.'**
  String get homeQuizBody;

  /// No description provided for @homeQuizStart.
  ///
  /// In en, this message translates to:
  /// **'Start the quiz'**
  String get homeQuizStart;

  /// No description provided for @error_consent_health_required.
  ///
  /// In en, this message translates to:
  /// **'These answers need the health consent.'**
  String get error_consent_health_required;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy centre'**
  String get privacyTitle;

  /// No description provided for @privacyIntro.
  ///
  /// In en, this message translates to:
  /// **'Your data, your choices. Every right is one tap away.'**
  String get privacyIntro;

  /// No description provided for @profileAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Your account'**
  String get profileAccountTitle;

  /// Profile card under the account title: the app never asks for a name, the account is only an email address.
  ///
  /// In en, this message translates to:
  /// **'We don\'t ask your name · email only'**
  String get profileAccountNote;

  /// No description provided for @profileEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmailLabel;

  /// No description provided for @profileAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get profileAgeLabel;

  /// No description provided for @profileCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get profileCountryLabel;

  /// No description provided for @profileLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguageLabel;

  /// No description provided for @privacyConsentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Consents'**
  String get privacyConsentsTitle;

  /// No description provided for @privacyHealthWithdrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdraw the health consent?'**
  String get privacyHealthWithdrawTitle;

  /// No description provided for @privacyHealthWithdrawBody.
  ///
  /// In en, this message translates to:
  /// **'Your health answers and the server copy of your own routines will be deleted right away, and your routine will be built more cautiously. Your own routines stay on this phone. You can give the consent again later.'**
  String get privacyHealthWithdrawBody;

  /// No description provided for @privacyWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw and delete'**
  String get privacyWithdraw;

  /// No description provided for @privacyCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get privacyCancel;

  /// No description provided for @privacyExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Download my data'**
  String get privacyExportTitle;

  /// No description provided for @privacyExportBody.
  ///
  /// In en, this message translates to:
  /// **'A file with everything Parla stores about you, plus the habit entries, your own routines and your journal on this phone. It is created now and is not kept on our servers.'**
  String get privacyExportBody;

  /// No description provided for @privacyExportButton.
  ///
  /// In en, this message translates to:
  /// **'Create file'**
  String get privacyExportButton;

  /// No description provided for @privacyLegalTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal documents'**
  String get privacyLegalTitle;

  /// No description provided for @privacySignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get privacySignOut;

  /// No description provided for @privacyDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get privacyDeleteTitle;

  /// No description provided for @deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get deleteTitle;

  /// No description provided for @deleteWhatGoes.
  ///
  /// In en, this message translates to:
  /// **'Deleted right away: your profile, quiz and health answers, your own routines kept on the server, your shopping list, your fitness and plate entries (with their encryption key), your support conversations and your sign-in account. Your habit entries, journal and saved recipes on this phone are deleted too.'**
  String get deleteWhatGoes;

  /// No description provided for @deleteWhatStays.
  ///
  /// In en, this message translates to:
  /// **'Kept without your email and unlinked from your account: your consent history (3 years) and security log entries (1 year) as proof, and your orders (if any) for accounting.'**
  String get deleteWhatStays;

  /// No description provided for @deleteExportFirst.
  ///
  /// In en, this message translates to:
  /// **'Download my data first'**
  String get deleteExportFirst;

  /// No description provided for @deleteConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Type {word} to confirm'**
  String deleteConfirmLabel(String word);

  /// No description provided for @deleteConfirmWord.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get deleteConfirmWord;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteButton;

  /// No description provided for @deletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your account is deleted'**
  String get deletedTitle;

  /// No description provided for @deletedBody.
  ///
  /// In en, this message translates to:
  /// **'Thank you for being with us. You are always welcome back.'**
  String get deletedBody;

  /// No description provided for @legalTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal documents'**
  String get legalTitle;

  /// No description provided for @legalMedicalTitle.
  ///
  /// In en, this message translates to:
  /// **'Not medical advice'**
  String get legalMedicalTitle;

  /// No description provided for @legalMedicalBody.
  ///
  /// In en, this message translates to:
  /// **'Parla offers care guidance. It does not diagnose, treat or replace a doctor. For skin conditions or worrying signs, see a dermatologist.'**
  String get legalMedicalBody;

  /// No description provided for @legalPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy and terms'**
  String get legalPolicyTitle;

  /// No description provided for @legalPolicyBody.
  ///
  /// In en, this message translates to:
  /// **'These documents are being prepared with a lawyer and will appear here before launch.'**
  String get legalPolicyBody;

  /// No description provided for @legalPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get legalPrivacyPolicy;

  /// No description provided for @legalTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get legalTerms;

  /// No description provided for @legalConsentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Consent texts'**
  String get legalConsentsTitle;

  /// No description provided for @habitEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get habitEdit;

  /// No description provided for @habitSleepSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'How long did you sleep last night?'**
  String get habitSleepSheetTitle;

  /// No description provided for @habitMoveSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'How long did you move today?'**
  String get habitMoveSheetTitle;

  /// No description provided for @habitSleepHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String habitSleepHours(String hours);

  /// No description provided for @habitMoveMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String habitMoveMinutes(int minutes);

  /// No description provided for @habitLess.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get habitLess;

  /// No description provided for @habitMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get habitMore;

  /// No description provided for @habitSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get habitSave;

  /// No description provided for @habitClearEntry.
  ///
  /// In en, this message translates to:
  /// **'Remove entry'**
  String get habitClearEntry;

  /// No description provided for @habitsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Routine'**
  String get habitsScreenTitle;

  /// No description provided for @habitsScreenIntro.
  ///
  /// In en, this message translates to:
  /// **'Small steps, at your own pace.'**
  String get habitsScreenIntro;

  /// No description provided for @habitsToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get habitsToday;

  /// No description provided for @habitsWeekTitle.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get habitsWeekTitle;

  /// No description provided for @habitsWeekCare.
  ///
  /// In en, this message translates to:
  /// **'Days you made time for your routine'**
  String get habitsWeekCare;

  /// No description provided for @habitsWeekCareValue.
  ///
  /// In en, this message translates to:
  /// **'{days} of 7 days'**
  String habitsWeekCareValue(int days);

  /// No description provided for @habitsWeekNone.
  ///
  /// In en, this message translates to:
  /// **'Nothing logged yet'**
  String get habitsWeekNone;

  /// No description provided for @habitsWeekWaterValue.
  ///
  /// In en, this message translates to:
  /// **'On average {glasses} glasses a day'**
  String habitsWeekWaterValue(String glasses);

  /// No description provided for @habitsWeekSleepValue.
  ///
  /// In en, this message translates to:
  /// **'On average {hours} h, {nights} nights logged'**
  String habitsWeekSleepValue(String hours, int nights);

  /// No description provided for @habitsWeekMoveValue.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min in total, on {days} days'**
  String habitsWeekMoveValue(int minutes, int days);

  /// No description provided for @habitsPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Your habit entries are kept only on this phone and are never sent to our server. Entries older than 90 days are deleted automatically.'**
  String get habitsPrivacyNote;

  /// No description provided for @privacyHabitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Habit entries on this phone'**
  String get privacyHabitsTitle;

  /// No description provided for @privacyHabitsBody.
  ///
  /// In en, this message translates to:
  /// **'Water, sleep, movement and routine entries are kept only on this phone. You can delete them at any time.'**
  String get privacyHabitsBody;

  /// No description provided for @privacyHabitsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete entries'**
  String get privacyHabitsDelete;

  /// No description provided for @privacyHabitsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your habit entries?'**
  String get privacyHabitsDeleteTitle;

  /// No description provided for @privacyHabitsDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'All water, sleep, movement and routine entries on this phone will be deleted. This cannot be undone.'**
  String get privacyHabitsDeleteBody;

  /// No description provided for @privacyHabitsDeleted.
  ///
  /// In en, this message translates to:
  /// **'Habit entries deleted.'**
  String get privacyHabitsDeleted;

  /// No description provided for @remindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersTitle;

  /// No description provided for @remindersIntro.
  ///
  /// In en, this message translates to:
  /// **'Your phone shows the reminders itself; nothing is sent to a server. You can turn them off at any time.'**
  String get remindersIntro;

  /// No description provided for @remindersOpen.
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get remindersOpen;

  /// No description provided for @remindersSummaryOff.
  ///
  /// In en, this message translates to:
  /// **'All off'**
  String get remindersSummaryOff;

  /// No description provided for @remindersSummaryOn.
  ///
  /// In en, this message translates to:
  /// **'{count} on'**
  String remindersSummaryOn(int count);

  /// No description provided for @reminderMorningTitle.
  ///
  /// In en, this message translates to:
  /// **'Morning routine'**
  String get reminderMorningTitle;

  /// No description provided for @reminderEveningTitle.
  ///
  /// In en, this message translates to:
  /// **'Evening routine'**
  String get reminderEveningTitle;

  /// No description provided for @reminderSleepTitle.
  ///
  /// In en, this message translates to:
  /// **'Sleep entry'**
  String get reminderSleepTitle;

  /// No description provided for @reminderMorningBody.
  ///
  /// In en, this message translates to:
  /// **'Time for your morning routine.'**
  String get reminderMorningBody;

  /// No description provided for @reminderEveningBody.
  ///
  /// In en, this message translates to:
  /// **'Time for your evening routine.'**
  String get reminderEveningBody;

  /// No description provided for @reminderSleepBody.
  ///
  /// In en, this message translates to:
  /// **'Would you like to log last night?'**
  String get reminderSleepBody;

  /// No description provided for @reminderAt.
  ///
  /// In en, this message translates to:
  /// **'At {time}'**
  String reminderAt(String time);

  /// No description provided for @reminderChangeTime.
  ///
  /// In en, this message translates to:
  /// **'Change time'**
  String get reminderChangeTime;

  /// No description provided for @reminderTimeSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'When should we remind you?'**
  String get reminderTimeSheetTitle;

  /// No description provided for @reminderPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are not allowed. You can allow them in your phone\'s settings.'**
  String get reminderPermissionDenied;

  /// No description provided for @remindersNote.
  ///
  /// In en, this message translates to:
  /// **'The texts are neutral and show no health information on the lock screen. A reminder may arrive a few minutes late.'**
  String get remindersNote;

  /// No description provided for @productsTitle.
  ///
  /// In en, this message translates to:
  /// **'Check a product'**
  String get productsTitle;

  /// No description provided for @productsIntro.
  ///
  /// In en, this message translates to:
  /// **'Type a product name or brand and look at its ingredients.'**
  String get productsIntro;

  /// No description provided for @productsSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Product name or brand'**
  String get productsSearchLabel;

  /// No description provided for @productsSearchButton.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get productsSearchButton;

  /// No description provided for @productsQueryTooShort.
  ///
  /// In en, this message translates to:
  /// **'Type at least 2 letters.'**
  String get productsQueryTooShort;

  /// No description provided for @productsNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get productsNotFoundTitle;

  /// No description provided for @productsNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'Try another spelling or the brand name. Not every product is in the database yet.'**
  String get productsNotFoundBody;

  /// No description provided for @productsSourceObf.
  ///
  /// In en, this message translates to:
  /// **'Open Beauty Facts'**
  String get productsSourceObf;

  /// No description provided for @productsSourceParla.
  ///
  /// In en, this message translates to:
  /// **'Parla catalogue'**
  String get productsSourceParla;

  /// No description provided for @error_product_query_invalid.
  ///
  /// In en, this message translates to:
  /// **'A search needs 2 to 80 characters.'**
  String get error_product_query_invalid;

  /// No description provided for @error_product_source_unavailable.
  ///
  /// In en, this message translates to:
  /// **'The product database is not answering right now. Please try again a little later.'**
  String get error_product_source_unavailable;

  /// No description provided for @productIngredientsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get productIngredientsTitle;

  /// No description provided for @productNoIngredients.
  ///
  /// In en, this message translates to:
  /// **'There is no ingredient list for this product. Please check the package.'**
  String get productNoIngredients;

  /// No description provided for @productIngredientCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 ingredient} other{{count} ingredients}}'**
  String productIngredientCount(int count);

  /// No description provided for @productListedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 has an EU entry} other{{count} have an EU entry}}'**
  String productListedCount(int count);

  /// No description provided for @productStatusesMissing.
  ///
  /// In en, this message translates to:
  /// **'Ingredient statuses are not loaded yet. For now only the ingredient list is shown.'**
  String get productStatusesMissing;

  /// No description provided for @productDataNotice.
  ///
  /// In en, this message translates to:
  /// **'The ingredient list comes from a community database and may contain mistakes. Compare it with the package.'**
  String get productDataNotice;

  /// No description provided for @productLegalNotice.
  ///
  /// In en, this message translates to:
  /// **'Statuses are based on the annexes of EU Regulation 1223/2009 (CosIng, {date}). Names are matched automatically. This is not an Azerbaijani rule and not a safety assessment of the product.'**
  String productLegalNotice(String date);

  /// No description provided for @productAttribution.
  ///
  /// In en, this message translates to:
  /// **'Product data: Open Beauty Facts, under the ODbL licence.'**
  String get productAttribution;

  /// No description provided for @annexIIShort.
  ///
  /// In en, this message translates to:
  /// **'EU: on the list of prohibited substances'**
  String get annexIIShort;

  /// No description provided for @annexIIIShort.
  ///
  /// In en, this message translates to:
  /// **'EU: allowed with restrictions'**
  String get annexIIIShort;

  /// No description provided for @annexIVShort.
  ///
  /// In en, this message translates to:
  /// **'EU: allowed colorant'**
  String get annexIVShort;

  /// No description provided for @annexVShort.
  ///
  /// In en, this message translates to:
  /// **'EU: allowed preservative'**
  String get annexVShort;

  /// No description provided for @annexVIShort.
  ///
  /// In en, this message translates to:
  /// **'EU: allowed UV filter'**
  String get annexVIShort;

  /// No description provided for @annexEntry.
  ///
  /// In en, this message translates to:
  /// **'Annex {annex}, entry {reference}'**
  String annexEntry(String annex, String reference);

  /// No description provided for @annexConditionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Official conditions (as in CosIng, in English)'**
  String get annexConditionsLabel;

  /// No description provided for @ingredientNoEntry.
  ///
  /// In en, this message translates to:
  /// **'No separate entry found in the EU annexes'**
  String get ingredientNoEntry;

  /// No description provided for @ingredientSheetSource.
  ///
  /// In en, this message translates to:
  /// **'Source: CosIng, {date}'**
  String ingredientSheetSource(String date);

  /// No description provided for @ingredientDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get ingredientDetailsHint;

  /// No description provided for @navRoutine.
  ///
  /// In en, this message translates to:
  /// **'Routine'**
  String get navRoutine;

  /// No description provided for @navCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get navCheck;

  /// No description provided for @navSport.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get navSport;

  /// No description provided for @navDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get navDiscover;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @sportTitle.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get sportTitle;

  /// No description provided for @discoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discoverTitle;

  /// No description provided for @discoverBlogs.
  ///
  /// In en, this message translates to:
  /// **'Blogs'**
  String get discoverBlogs;

  /// No description provided for @discoverBlogsHint.
  ///
  /// In en, this message translates to:
  /// **'Care, beauty, fashion'**
  String get discoverBlogsHint;

  /// No description provided for @discoverExperts.
  ///
  /// In en, this message translates to:
  /// **'Experts'**
  String get discoverExperts;

  /// No description provided for @discoverExpertsHint.
  ///
  /// In en, this message translates to:
  /// **'Dermatologists, cosmetologists'**
  String get discoverExpertsHint;

  /// No description provided for @discoverNutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get discoverNutrition;

  /// No description provided for @discoverNutritionHint.
  ///
  /// In en, this message translates to:
  /// **'Daily plate and recipes'**
  String get discoverNutritionHint;

  /// No description provided for @discoverShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping list'**
  String get discoverShopping;

  /// No description provided for @discoverShoppingHint.
  ///
  /// In en, this message translates to:
  /// **'Note what you need'**
  String get discoverShoppingHint;

  /// No description provided for @discoverShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get discoverShop;

  /// No description provided for @discoverShopHint.
  ///
  /// In en, this message translates to:
  /// **'Products from your routine'**
  String get discoverShopHint;

  /// No description provided for @soonBadge.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get soonBadge;

  /// No description provided for @onboardingStepAbout.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get onboardingStepAbout;

  /// No description provided for @onboardingStepAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get onboardingStepAccount;

  /// No description provided for @onboardingStepCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get onboardingStepCountry;

  /// No description provided for @onboardingStepPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get onboardingStepPrivacy;

  /// No description provided for @routineAreaFace.
  ///
  /// In en, this message translates to:
  /// **'Face'**
  String get routineAreaFace;

  /// No description provided for @routineAreaHair.
  ///
  /// In en, this message translates to:
  /// **'Hair'**
  String get routineAreaHair;

  /// No description provided for @routineAreaBody.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get routineAreaBody;

  /// No description provided for @routineSlotMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get routineSlotMorning;

  /// No description provided for @routineSlotEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get routineSlotEvening;

  /// No description provided for @routineSlotWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get routineSlotWeekly;

  /// No description provided for @routineWeeklyHint.
  ///
  /// In en, this message translates to:
  /// **'Once a week. Ticks reset on Monday.'**
  String get routineWeeklyHint;

  /// No description provided for @routineSlotEmpty.
  ///
  /// In en, this message translates to:
  /// **'No steps for this time.'**
  String get routineSlotEmpty;

  /// No description provided for @routineOwnButton.
  ///
  /// In en, this message translates to:
  /// **'Your own'**
  String get routineOwnButton;

  /// No description provided for @routineOwnSection.
  ///
  /// In en, this message translates to:
  /// **'Your routines'**
  String get routineOwnSection;

  /// No description provided for @routineOwnEmpty.
  ///
  /// In en, this message translates to:
  /// **'Make your own routine and tick it off here.'**
  String get routineOwnEmpty;

  /// No description provided for @routineOwnEveryDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get routineOwnEveryDay;

  /// No description provided for @routineOwnSteps.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 step} other{{count} steps}}'**
  String routineOwnSteps(int count);

  /// No description provided for @routineOwnEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit: {name}'**
  String routineOwnEdit(String name);

  /// No description provided for @routineDayHabits.
  ///
  /// In en, this message translates to:
  /// **'During the day'**
  String get routineDayHabits;

  /// No description provided for @builderTitleNew.
  ///
  /// In en, this message translates to:
  /// **'Make your own routine'**
  String get builderTitleNew;

  /// No description provided for @builderTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit routine'**
  String get builderTitleEdit;

  /// No description provided for @builderName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get builderName;

  /// No description provided for @builderNameHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. Sunday spa'**
  String get builderNameHint;

  /// No description provided for @builderArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get builderArea;

  /// No description provided for @builderWhen.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get builderWhen;

  /// No description provided for @builderEveryDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get builderEveryDay;

  /// No description provided for @builderOnceWeek.
  ///
  /// In en, this message translates to:
  /// **'Once a week'**
  String get builderOnceWeek;

  /// No description provided for @builderSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get builderSteps;

  /// No description provided for @builderStepHint.
  ///
  /// In en, this message translates to:
  /// **'New step'**
  String get builderStepHint;

  /// No description provided for @builderAddStep.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get builderAddStep;

  /// No description provided for @builderSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Pick a ready step'**
  String get builderSuggestions;

  /// No description provided for @builderMoveUp.
  ///
  /// In en, this message translates to:
  /// **'Move up: {step}'**
  String builderMoveUp(String step);

  /// No description provided for @builderMoveDown.
  ///
  /// In en, this message translates to:
  /// **'Move down: {step}'**
  String builderMoveDown(String step);

  /// No description provided for @builderRemoveStep.
  ///
  /// In en, this message translates to:
  /// **'Remove: {step}'**
  String builderRemoveStep(String step);

  /// No description provided for @builderSave.
  ///
  /// In en, this message translates to:
  /// **'Save routine'**
  String get builderSave;

  /// No description provided for @builderDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete routine'**
  String get builderDelete;

  /// No description provided for @builderDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this routine?'**
  String get builderDeleteConfirm;

  /// No description provided for @builderDeleteYes.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get builderDeleteYes;

  /// No description provided for @builderCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get builderCancel;

  /// No description provided for @builderNeedName.
  ///
  /// In en, this message translates to:
  /// **'Give the routine a name.'**
  String get builderNeedName;

  /// No description provided for @builderNeedStep.
  ///
  /// In en, this message translates to:
  /// **'Add at least one step.'**
  String get builderNeedStep;

  /// No description provided for @builderLimit.
  ///
  /// In en, this message translates to:
  /// **'At most {count} steps.'**
  String builderLimit(int count);

  /// No description provided for @todayRoutinesTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s routines'**
  String get todayRoutinesTitle;

  /// No description provided for @todayRoutinesAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get todayRoutinesAll;

  /// No description provided for @todayRoutinesNone.
  ///
  /// In en, this message translates to:
  /// **'No other routines for today.'**
  String get todayRoutinesNone;

  /// No description provided for @builderPrivacySynced.
  ///
  /// In en, this message translates to:
  /// **'Your own routines are kept encrypted on our server, with a copy on this phone for offline use.'**
  String get builderPrivacySynced;

  /// No description provided for @builderPrivacyDevice.
  ///
  /// In en, this message translates to:
  /// **'For now your own routines are kept only on this phone. With the updated health consent they will be kept encrypted on our server.'**
  String get builderPrivacyDevice;

  /// No description provided for @checkPrefsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your preferences'**
  String get checkPrefsTitle;

  /// No description provided for @checkPrefsEdit.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get checkPrefsEdit;

  /// No description provided for @checkPrefsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Pick what matters to you and we compare the ingredients with your picks.'**
  String get checkPrefsEmpty;

  /// No description provided for @checkPrefsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add preferences'**
  String get checkPrefsAdd;

  /// No description provided for @checkPrefsSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'What matters to you?'**
  String get checkPrefsSheetTitle;

  /// No description provided for @checkPrefsSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get checkPrefsSave;

  /// No description provided for @checkBarcodeSoon.
  ///
  /// In en, this message translates to:
  /// **'Barcode scanner · soon'**
  String get checkBarcodeSoon;

  /// No description provided for @checkRecentTitle.
  ///
  /// In en, this message translates to:
  /// **'Recently checked'**
  String get checkRecentTitle;

  /// No description provided for @checkRecentClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get checkRecentClear;

  /// No description provided for @resultPrefsTitle.
  ///
  /// In en, this message translates to:
  /// **'With your preferences'**
  String get resultPrefsTitle;

  /// No description provided for @resultPrefsSummary.
  ///
  /// In en, this message translates to:
  /// **'{fits} of {count} of your picks fit'**
  String resultPrefsSummary(int fits, int count);

  /// No description provided for @resultPrefFits.
  ///
  /// In en, this message translates to:
  /// **'Fits'**
  String get resultPrefFits;

  /// No description provided for @resultPrefContains.
  ///
  /// In en, this message translates to:
  /// **'Contains: {names}'**
  String resultPrefContains(String names);

  /// No description provided for @resultPrefVeganFits.
  ///
  /// In en, this message translates to:
  /// **'No known animal-derived ingredient found'**
  String get resultPrefVeganFits;

  /// No description provided for @resultPrefUnknown.
  ///
  /// In en, this message translates to:
  /// **'Cannot check: no ingredient list'**
  String get resultPrefUnknown;

  /// No description provided for @resultPrefsNone.
  ///
  /// In en, this message translates to:
  /// **'Add your preferences and we compare the ingredients with them.'**
  String get resultPrefsNone;

  /// No description provided for @resultPrefsNote.
  ///
  /// In en, this message translates to:
  /// **'Parla does not rate products or give scores. The match is based only on your picks and the ingredient list.'**
  String get resultPrefsNote;

  /// No description provided for @resultAddToList.
  ///
  /// In en, this message translates to:
  /// **'Add to shopping list'**
  String get resultAddToList;

  /// No description provided for @resultInList.
  ///
  /// In en, this message translates to:
  /// **'On your list'**
  String get resultInList;

  /// No description provided for @resultAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to your shopping list.'**
  String get resultAdded;

  /// No description provided for @shoppingCount.
  ///
  /// In en, this message translates to:
  /// **'{bought} of {total} bought'**
  String shoppingCount(int bought, int total);

  /// No description provided for @shoppingNewHint.
  ///
  /// In en, this message translates to:
  /// **'New item'**
  String get shoppingNewHint;

  /// No description provided for @shoppingAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get shoppingAdd;

  /// No description provided for @shoppingEmpty.
  ///
  /// In en, this message translates to:
  /// **'The list is empty. Note what you need here.'**
  String get shoppingEmpty;

  /// No description provided for @shoppingAreaOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get shoppingAreaOther;

  /// No description provided for @shoppingFromCheck.
  ///
  /// In en, this message translates to:
  /// **'From Check'**
  String get shoppingFromCheck;

  /// No description provided for @shoppingRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove: {title}'**
  String shoppingRemove(String title);

  /// No description provided for @shoppingRemoveBought.
  ///
  /// In en, this message translates to:
  /// **'Remove bought'**
  String get shoppingRemoveBought;

  /// No description provided for @shoppingFull.
  ///
  /// In en, this message translates to:
  /// **'The list can hold at most {count} items.'**
  String shoppingFull(int count);

  /// No description provided for @careListSynced.
  ///
  /// In en, this message translates to:
  /// **'Your preferences and shopping list are kept encrypted on our server, with a copy on this phone for offline use.'**
  String get careListSynced;

  /// No description provided for @careListDevice.
  ///
  /// In en, this message translates to:
  /// **'For now your preferences and shopping list are kept only on this phone. With the updated health consent they will be kept encrypted on our server.'**
  String get careListDevice;

  /// No description provided for @shopTitle.
  ///
  /// In en, this message translates to:
  /// **'Parla Shop'**
  String get shopTitle;

  /// No description provided for @shopBody.
  ///
  /// In en, this message translates to:
  /// **'The products in your routine, in one tap. You will be able to order your shopping list directly and find products that fit your picks.'**
  String get shopBody;

  /// No description provided for @shopSoonCard.
  ///
  /// In en, this message translates to:
  /// **'Parla Shop'**
  String get shopSoonCard;

  /// No description provided for @shopSoonCardBody.
  ///
  /// In en, this message translates to:
  /// **'See products from our partners'**
  String get shopSoonCardBody;

  /// No description provided for @shopOpenList.
  ///
  /// In en, this message translates to:
  /// **'See my shopping list'**
  String get shopOpenList;

  /// No description provided for @shopIntro.
  ///
  /// In en, this message translates to:
  /// **'Products from partners. You buy on the partner\'s site; Parla passes on nothing about you.'**
  String get shopIntro;

  /// No description provided for @shopAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get shopAll;

  /// No description provided for @shopCategoryFace.
  ///
  /// In en, this message translates to:
  /// **'Face'**
  String get shopCategoryFace;

  /// No description provided for @shopCategoryHair.
  ///
  /// In en, this message translates to:
  /// **'Hair'**
  String get shopCategoryHair;

  /// No description provided for @shopCategoryBody.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get shopCategoryBody;

  /// No description provided for @shopCategoryMakeup.
  ///
  /// In en, this message translates to:
  /// **'Make-up'**
  String get shopCategoryMakeup;

  /// No description provided for @shopCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get shopCategoryOther;

  /// No description provided for @shopPrice.
  ///
  /// In en, this message translates to:
  /// **'{price} ₼'**
  String shopPrice(String price);

  /// No description provided for @shopVisitPartner.
  ///
  /// In en, this message translates to:
  /// **'Go to the partner\'s site'**
  String get shopVisitPartner;

  /// No description provided for @shopPriceNote.
  ///
  /// In en, this message translates to:
  /// **'Price and stock may change on the partner\'s site. Check the ingredients before you buy; if you have a skin problem, ask a doctor.'**
  String get shopPriceNote;

  /// No description provided for @shopEmpty.
  ///
  /// In en, this message translates to:
  /// **'No products yet. They will be here soon.'**
  String get shopEmpty;

  /// No description provided for @shopMyOrders.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get shopMyOrders;

  /// No description provided for @shopBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get shopBuy;

  /// No description provided for @shopBuyTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm your order'**
  String get shopBuyTitle;

  /// No description provided for @shopBuyBody.
  ///
  /// In en, this message translates to:
  /// **'{product}: {price}. {seller} You pay on Epoint\'s page; your card details never reach Parla.'**
  String shopBuyBody(String product, String price, String seller);

  /// No description provided for @shopSellerParla.
  ///
  /// In en, this message translates to:
  /// **'Sold by Parla.'**
  String get shopSellerParla;

  /// No description provided for @shopSellerBrand.
  ///
  /// In en, this message translates to:
  /// **'Sold by {brand}; Parla takes the payment.'**
  String shopSellerBrand(String brand);

  /// No description provided for @shopBuyGo.
  ///
  /// In en, this message translates to:
  /// **'Go to payment'**
  String get shopBuyGo;

  /// No description provided for @shopBuyError.
  ///
  /// In en, this message translates to:
  /// **'The payment page did not open. Try again a little later.'**
  String get shopBuyError;

  /// No description provided for @shopTooMany.
  ///
  /// In en, this message translates to:
  /// **'Too many orders started in the last hour. Try again a little later.'**
  String get shopTooMany;

  /// No description provided for @shopOrdersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No orders yet.'**
  String get shopOrdersEmpty;

  /// No description provided for @shopOrderMeta.
  ///
  /// In en, this message translates to:
  /// **'{number} · {date} · {quantity} pcs'**
  String shopOrderMeta(String number, String date, int quantity);

  /// No description provided for @shopOrderCreated.
  ///
  /// In en, this message translates to:
  /// **'Waiting for payment'**
  String get shopOrderCreated;

  /// No description provided for @shopOrderPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get shopOrderPaid;

  /// No description provided for @shopOrderFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get shopOrderFailed;

  /// No description provided for @shopOrderShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get shopOrderShipped;

  /// No description provided for @shopOrderDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get shopOrderDelivered;

  /// No description provided for @shopOrderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get shopOrderCancelled;

  /// No description provided for @shopOrderRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get shopOrderRefunded;

  /// No description provided for @sportIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'A workout plan made for you'**
  String get sportIntroTitle;

  /// No description provided for @sportIntroBody.
  ///
  /// In en, this message translates to:
  /// **'A few questions: goal, areas, the workouts you like. Then a weekly plan with sets, reps and a timer. Music plays from your own app.'**
  String get sportIntroBody;

  /// No description provided for @sportStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get sportStart;

  /// No description provided for @sportNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get sportNext;

  /// No description provided for @sportNeedOne.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one.'**
  String get sportNeedOne;

  /// No description provided for @sportQGoals.
  ///
  /// In en, this message translates to:
  /// **'What is your goal?'**
  String get sportQGoals;

  /// No description provided for @sportQGoalsHint.
  ///
  /// In en, this message translates to:
  /// **'Pick up to two'**
  String get sportQGoalsHint;

  /// No description provided for @sportGoalTone.
  ///
  /// In en, this message translates to:
  /// **'Tone and firmness'**
  String get sportGoalTone;

  /// No description provided for @sportGoalMuscle.
  ///
  /// In en, this message translates to:
  /// **'Build muscle'**
  String get sportGoalMuscle;

  /// No description provided for @sportGoalFlexibility.
  ///
  /// In en, this message translates to:
  /// **'Flexibility'**
  String get sportGoalFlexibility;

  /// No description provided for @sportGoalPosture.
  ///
  /// In en, this message translates to:
  /// **'Posture'**
  String get sportGoalPosture;

  /// No description provided for @sportGoalEndurance.
  ///
  /// In en, this message translates to:
  /// **'Endurance'**
  String get sportGoalEndurance;

  /// No description provided for @sportGoalRelax.
  ///
  /// In en, this message translates to:
  /// **'Unwind'**
  String get sportGoalRelax;

  /// No description provided for @sportQAreas.
  ///
  /// In en, this message translates to:
  /// **'Which areas should we focus on?'**
  String get sportQAreas;

  /// No description provided for @sportAreasNote.
  ///
  /// In en, this message translates to:
  /// **'Fat cannot be burned from one spot. These moves strengthen and tone those muscles.'**
  String get sportAreasNote;

  /// No description provided for @sportAreaArms.
  ///
  /// In en, this message translates to:
  /// **'Arms'**
  String get sportAreaArms;

  /// No description provided for @sportAreaLegs.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get sportAreaLegs;

  /// No description provided for @sportAreaCore.
  ///
  /// In en, this message translates to:
  /// **'Abs and core'**
  String get sportAreaCore;

  /// No description provided for @sportAreaGlutes.
  ///
  /// In en, this message translates to:
  /// **'Glutes'**
  String get sportAreaGlutes;

  /// No description provided for @sportAreaBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get sportAreaBack;

  /// No description provided for @sportAreaFull.
  ///
  /// In en, this message translates to:
  /// **'Full body'**
  String get sportAreaFull;

  /// No description provided for @sportQTypes.
  ///
  /// In en, this message translates to:
  /// **'Which workouts do you want?'**
  String get sportQTypes;

  /// No description provided for @sportTypeFitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get sportTypeFitness;

  /// No description provided for @sportTypePilates.
  ///
  /// In en, this message translates to:
  /// **'Pilates'**
  String get sportTypePilates;

  /// No description provided for @sportTypeWallPilates.
  ///
  /// In en, this message translates to:
  /// **'Wall pilates'**
  String get sportTypeWallPilates;

  /// No description provided for @sportTypeStretching.
  ///
  /// In en, this message translates to:
  /// **'Stretching'**
  String get sportTypeStretching;

  /// No description provided for @sportTypeCardio.
  ///
  /// In en, this message translates to:
  /// **'Low-impact cardio'**
  String get sportTypeCardio;

  /// No description provided for @sportTypeFaceYoga.
  ///
  /// In en, this message translates to:
  /// **'Face yoga'**
  String get sportTypeFaceYoga;

  /// No description provided for @sportTypeYoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get sportTypeYoga;

  /// No description provided for @sportYogaMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning flow'**
  String get sportYogaMorning;

  /// No description provided for @sportYogaEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening calm'**
  String get sportYogaEvening;

  /// No description provided for @sportYogaStretch.
  ///
  /// In en, this message translates to:
  /// **'Stretch & release'**
  String get sportYogaStretch;

  /// No description provided for @sportSessionCardBody.
  ///
  /// In en, this message translates to:
  /// **'{count} moves · about {minutes} min'**
  String sportSessionCardBody(int count, int minutes);

  /// No description provided for @sportYogaSafetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you start'**
  String get sportYogaSafetyTitle;

  /// No description provided for @sportYogaSafetyBody.
  ///
  /// In en, this message translates to:
  /// **'Move slowly, don\'t hold your breath and stop if anything hurts. If you are pregnant, have high blood pressure or a back, knee or wrist injury, talk to a doctor first. If you noted an injury or pregnancy in the questions, poses that don\'t suit you are left out.'**
  String get sportYogaSafetyBody;

  /// No description provided for @sportFaceYogaCardBody.
  ///
  /// In en, this message translates to:
  /// **'12 moves · about {minutes} min. In front of a mirror, any time.'**
  String sportFaceYogaCardBody(int minutes);

  /// No description provided for @sportFaceYogaSafetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you start'**
  String get sportFaceYogaSafetyTitle;

  /// No description provided for @sportFaceYogaSafetyBody.
  ///
  /// In en, this message translates to:
  /// **'Wash your hands, touch your skin lightly and don\'t pull it. Stop if anything hurts or feels uncomfortable. If you recently had a cosmetic procedure (Botox, fillers) or have jaw joint or skin problems, talk to a doctor first.'**
  String get sportFaceYogaSafetyBody;

  /// No description provided for @sportQLevel.
  ///
  /// In en, this message translates to:
  /// **'What is your level?'**
  String get sportQLevel;

  /// No description provided for @sportLevelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Just starting'**
  String get sportLevelBeginner;

  /// No description provided for @sportLevelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get sportLevelIntermediate;

  /// No description provided for @sportLevelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Experienced'**
  String get sportLevelAdvanced;

  /// No description provided for @sportQSchedule.
  ///
  /// In en, this message translates to:
  /// **'How much time do you have?'**
  String get sportQSchedule;

  /// No description provided for @sportDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Days a week'**
  String get sportDaysLabel;

  /// No description provided for @sportMinutesLabel.
  ///
  /// In en, this message translates to:
  /// **'One workout'**
  String get sportMinutesLabel;

  /// No description provided for @sportDays.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String sportDays(int count);

  /// No description provided for @sportMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String sportMinutes(int count);

  /// No description provided for @sportDumbbells.
  ///
  /// In en, this message translates to:
  /// **'I have dumbbells at home'**
  String get sportDumbbells;

  /// No description provided for @sportQSafety.
  ///
  /// In en, this message translates to:
  /// **'For your safety'**
  String get sportQSafety;

  /// No description provided for @sportSafetyIntro.
  ///
  /// In en, this message translates to:
  /// **'These answers only remove moves that do not suit you from the plan.'**
  String get sportSafetyIntro;

  /// No description provided for @sportPregnancyLabel.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy'**
  String get sportPregnancyLabel;

  /// No description provided for @sportPregNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get sportPregNo;

  /// No description provided for @sportPregPregnant.
  ///
  /// In en, this message translates to:
  /// **'I am pregnant'**
  String get sportPregPregnant;

  /// No description provided for @sportPregPostpartum.
  ///
  /// In en, this message translates to:
  /// **'Gave birth in the last 6 months'**
  String get sportPregPostpartum;

  /// No description provided for @sportInjuriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Pain or injury'**
  String get sportInjuriesLabel;

  /// No description provided for @sportInjKnee.
  ///
  /// In en, this message translates to:
  /// **'Knee'**
  String get sportInjKnee;

  /// No description provided for @sportInjBack.
  ///
  /// In en, this message translates to:
  /// **'Lower back'**
  String get sportInjBack;

  /// No description provided for @sportInjShoulder.
  ///
  /// In en, this message translates to:
  /// **'Shoulder'**
  String get sportInjShoulder;

  /// No description provided for @sportInjWrist.
  ///
  /// In en, this message translates to:
  /// **'Wrist'**
  String get sportInjWrist;

  /// No description provided for @sportDoctorLimit.
  ///
  /// In en, this message translates to:
  /// **'A doctor limited exercise or asked me to check first'**
  String get sportDoctorLimit;

  /// No description provided for @sportBuildPlan.
  ///
  /// In en, this message translates to:
  /// **'Build my plan'**
  String get sportBuildPlan;

  /// No description provided for @sportWeekTitle.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get sportWeekTitle;

  /// No description provided for @sportWeekProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} workouts'**
  String sportWeekProgress(int done, int total);

  /// No description provided for @sportWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout {number}'**
  String sportWorkoutTitle(int number);

  /// No description provided for @sportWorkoutName_w1.
  ///
  /// In en, this message translates to:
  /// **'Strong start'**
  String get sportWorkoutName_w1;

  /// No description provided for @sportWorkoutName_w2.
  ///
  /// In en, this message translates to:
  /// **'Leg day'**
  String get sportWorkoutName_w2;

  /// No description provided for @sportWorkoutName_w3.
  ///
  /// In en, this message translates to:
  /// **'Full body'**
  String get sportWorkoutName_w3;

  /// No description provided for @sportWorkoutName_w4.
  ///
  /// In en, this message translates to:
  /// **'Energy wave'**
  String get sportWorkoutName_w4;

  /// No description provided for @sportWorkoutName_w5.
  ///
  /// In en, this message translates to:
  /// **'Strength and balance'**
  String get sportWorkoutName_w5;

  /// No description provided for @sportWorkoutName_p1.
  ///
  /// In en, this message translates to:
  /// **'Core awakening'**
  String get sportWorkoutName_p1;

  /// No description provided for @sportWorkoutName_p2.
  ///
  /// In en, this message translates to:
  /// **'Soft flow'**
  String get sportWorkoutName_p2;

  /// No description provided for @sportWorkoutName_p3.
  ///
  /// In en, this message translates to:
  /// **'Posture and breath'**
  String get sportWorkoutName_p3;

  /// No description provided for @sportWorkoutName_p4.
  ///
  /// In en, this message translates to:
  /// **'Long lines'**
  String get sportWorkoutName_p4;

  /// No description provided for @sportWorkoutName_p5.
  ///
  /// In en, this message translates to:
  /// **'Quiet strength'**
  String get sportWorkoutName_p5;

  /// No description provided for @sportWorkoutName_v1.
  ///
  /// In en, this message translates to:
  /// **'Meet the wall'**
  String get sportWorkoutName_v1;

  /// No description provided for @sportWorkoutName_v2.
  ///
  /// In en, this message translates to:
  /// **'Wall support'**
  String get sportWorkoutName_v2;

  /// No description provided for @sportWorkoutName_v3.
  ///
  /// In en, this message translates to:
  /// **'Wall flow'**
  String get sportWorkoutName_v3;

  /// No description provided for @sportWorkoutName_v4.
  ///
  /// In en, this message translates to:
  /// **'Wall rhythm'**
  String get sportWorkoutName_v4;

  /// No description provided for @sportWorkoutName_v5.
  ///
  /// In en, this message translates to:
  /// **'Wall balance'**
  String get sportWorkoutName_v5;

  /// No description provided for @sportWorkoutMeta.
  ///
  /// In en, this message translates to:
  /// **'{type} · ~{minutes} min'**
  String sportWorkoutMeta(String type, int minutes);

  /// No description provided for @sportDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get sportDone;

  /// No description provided for @sportNextLabel.
  ///
  /// In en, this message translates to:
  /// **'Next up'**
  String get sportNextLabel;

  /// No description provided for @sportEditAnswers.
  ///
  /// In en, this message translates to:
  /// **'Update answers'**
  String get sportEditAnswers;

  /// No description provided for @sportBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Talk to your doctor first'**
  String get sportBlockedTitle;

  /// No description provided for @sportBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'If a doctor limited exercise, we do not build a plan. Update your answers once you have the go-ahead.'**
  String get sportBlockedBody;

  /// No description provided for @sportGentleNote.
  ///
  /// In en, this message translates to:
  /// **'A gentle plan for pregnancy and after birth. Check with your doctor before you start.'**
  String get sportGentleNote;

  /// No description provided for @sportDraftNote.
  ///
  /// In en, this message translates to:
  /// **'The moves and numbers have not been reviewed by a trainer yet. Stop if anything hurts.'**
  String get sportDraftNote;

  /// No description provided for @sportAllDone.
  ///
  /// In en, this message translates to:
  /// **'All of this week\'s workouts are done.'**
  String get sportAllDone;

  /// No description provided for @sportSetsReps.
  ///
  /// In en, this message translates to:
  /// **'{sets} × {reps} reps'**
  String sportSetsReps(int sets, int reps);

  /// No description provided for @sportSetsSeconds.
  ///
  /// In en, this message translates to:
  /// **'{sets} × {seconds} s'**
  String sportSetsSeconds(int sets, int seconds);

  /// No description provided for @sportRestSeconds.
  ///
  /// In en, this message translates to:
  /// **'Rest {seconds} s'**
  String sportRestSeconds(int seconds);

  /// No description provided for @sportStartWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start workout'**
  String get sportStartWorkout;

  /// No description provided for @sportMusicNote.
  ///
  /// In en, this message translates to:
  /// **'The videos have their own music; you can turn it off with the button. Parla also gives short signals.'**
  String get sportMusicNote;

  /// No description provided for @sportVideoSoundOn.
  ///
  /// In en, this message translates to:
  /// **'Video sound on'**
  String get sportVideoSoundOn;

  /// No description provided for @sportVideoSoundOff.
  ///
  /// In en, this message translates to:
  /// **'Video sound off'**
  String get sportVideoSoundOff;

  /// No description provided for @sportSoundOn.
  ///
  /// In en, this message translates to:
  /// **'Sound signals on'**
  String get sportSoundOn;

  /// No description provided for @sportSoundOff.
  ///
  /// In en, this message translates to:
  /// **'Sound off, vibration only'**
  String get sportSoundOff;

  /// No description provided for @sportSetOf.
  ///
  /// In en, this message translates to:
  /// **'Set {set} of {sets}'**
  String sportSetOf(int set, int sets);

  /// No description provided for @sportRepsNow.
  ///
  /// In en, this message translates to:
  /// **'{reps} reps'**
  String sportRepsNow(int reps);

  /// No description provided for @sportPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get sportPause;

  /// No description provided for @sportResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get sportResume;

  /// No description provided for @sportResting.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get sportResting;

  /// No description provided for @sportNextUp.
  ///
  /// In en, this message translates to:
  /// **'Next: {name}'**
  String sportNextUp(String name);

  /// No description provided for @sportExerciseOf.
  ///
  /// In en, this message translates to:
  /// **'Move {index} of {total}'**
  String sportExerciseOf(int index, int total);

  /// No description provided for @sportFinishedTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout done'**
  String get sportFinishedTitle;

  /// No description provided for @sportFinishedBody.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes of movement were added to today\'s entries.'**
  String sportFinishedBody(int minutes);

  /// No description provided for @sportBackToPlan.
  ///
  /// In en, this message translates to:
  /// **'Back to the plan'**
  String get sportBackToPlan;

  /// No description provided for @sportQuit.
  ///
  /// In en, this message translates to:
  /// **'Stop workout'**
  String get sportQuit;

  /// No description provided for @sportGetReady.
  ///
  /// In en, this message translates to:
  /// **'Get ready'**
  String get sportGetReady;

  /// No description provided for @sportPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous move'**
  String get sportPrevious;

  /// No description provided for @sportNextMove.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get sportNextMove;

  /// No description provided for @sportStopTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop the workout?'**
  String get sportStopTitle;

  /// No description provided for @sportStopBody.
  ///
  /// In en, this message translates to:
  /// **'It won\'t be marked as done.'**
  String get sportStopBody;

  /// No description provided for @sportStopConfirm.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get sportStopConfirm;

  /// No description provided for @sportKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get sportKeepGoing;

  /// No description provided for @sportRepPace.
  ///
  /// In en, this message translates to:
  /// **'About {seconds} s per rep. Done sooner? Tap “Next”.'**
  String sportRepPace(int seconds);

  /// No description provided for @sportPrivacySynced.
  ///
  /// In en, this message translates to:
  /// **'Your fitness answers are kept encrypted on our server, with a copy on this phone for offline use.'**
  String get sportPrivacySynced;

  /// No description provided for @sportPrivacyDevice.
  ///
  /// In en, this message translates to:
  /// **'For now your fitness answers are kept only on this phone. With the updated health consent they will be kept encrypted on our server.'**
  String get sportPrivacyDevice;

  /// No description provided for @discoverLatest.
  ///
  /// In en, this message translates to:
  /// **'New articles'**
  String get discoverLatest;

  /// No description provided for @discoverAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get discoverAll;

  /// No description provided for @expertSample.
  ///
  /// In en, this message translates to:
  /// **'Sample'**
  String get expertSample;

  /// No description provided for @expertSampleNote.
  ///
  /// In en, this message translates to:
  /// **'This is a sample profile; the contacts do not work.'**
  String get expertSampleNote;

  /// No description provided for @discoverJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get discoverJournal;

  /// No description provided for @discoverJournalHint.
  ///
  /// In en, this message translates to:
  /// **'Just for you, on this phone'**
  String get discoverJournalHint;

  /// No description provided for @journalIntro.
  ///
  /// In en, this message translates to:
  /// **'Write about your day. Entries are kept only on this phone, encrypted; the Parla team cannot see them. They are lost if you change phones or remove the app. To keep a copy: Profile → Download my data.'**
  String get journalIntro;

  /// No description provided for @journalNew.
  ///
  /// In en, this message translates to:
  /// **'New entry'**
  String get journalNew;

  /// No description provided for @journalEmpty.
  ///
  /// In en, this message translates to:
  /// **'No entries yet.'**
  String get journalEmpty;

  /// No description provided for @journalHint.
  ///
  /// In en, this message translates to:
  /// **'How was your day?'**
  String get journalHint;

  /// No description provided for @journalEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Entry'**
  String get journalEntryTitle;

  /// No description provided for @journalSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get journalSave;

  /// No description provided for @journalDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get journalDelete;

  /// No description provided for @journalDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this entry?'**
  String get journalDeleteTitle;

  /// No description provided for @journalDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get journalDeleteBody;

  /// No description provided for @journalFull.
  ///
  /// In en, this message translates to:
  /// **'The journal is full. Delete an old entry to add a new one.'**
  String get journalFull;

  /// Under the Sport tile on Discover.
  ///
  /// In en, this message translates to:
  /// **'Your weekly plan'**
  String get discoverSportHint;

  /// Published articles, on the Blogs tile.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} article} other{{count} articles}}'**
  String discoverArticleCount(int count);

  /// Published recipes, on the Nutrition tile.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} recipe} other{{count} recipes}}'**
  String discoverRecipeCount(int count);

  /// No description provided for @contentEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet. Coming soon.'**
  String get contentEmpty;

  /// No description provided for @contentOffline.
  ///
  /// In en, this message translates to:
  /// **'No connection, showing the last loaded copy.'**
  String get contentOffline;

  /// No description provided for @blogMeta.
  ///
  /// In en, this message translates to:
  /// **'{category} · {minutes} min'**
  String blogMeta(String category, int minutes);

  /// No description provided for @blogReviewed.
  ///
  /// In en, this message translates to:
  /// **'Reviewed by an expert · {date}'**
  String blogReviewed(String date);

  /// No description provided for @blogTips.
  ///
  /// In en, this message translates to:
  /// **'Quick steps'**
  String get blogTips;

  /// No description provided for @catCare.
  ///
  /// In en, this message translates to:
  /// **'Care'**
  String get catCare;

  /// No description provided for @catBeauty.
  ///
  /// In en, this message translates to:
  /// **'Beauty'**
  String get catBeauty;

  /// No description provided for @catFashion.
  ///
  /// In en, this message translates to:
  /// **'Fashion'**
  String get catFashion;

  /// No description provided for @catHair.
  ///
  /// In en, this message translates to:
  /// **'Hair'**
  String get catHair;

  /// No description provided for @specDermatologist.
  ///
  /// In en, this message translates to:
  /// **'Dermatologist'**
  String get specDermatologist;

  /// No description provided for @specCosmetologist.
  ///
  /// In en, this message translates to:
  /// **'Cosmetologist'**
  String get specCosmetologist;

  /// No description provided for @specTrainer.
  ///
  /// In en, this message translates to:
  /// **'Trainer'**
  String get specTrainer;

  /// No description provided for @specDietitian.
  ///
  /// In en, this message translates to:
  /// **'Dietitian'**
  String get specDietitian;

  /// No description provided for @specTrichologist.
  ///
  /// In en, this message translates to:
  /// **'Trichologist'**
  String get specTrichologist;

  /// No description provided for @expertYears.
  ///
  /// In en, this message translates to:
  /// **'{years} years of experience'**
  String expertYears(int years);

  /// No description provided for @expertCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get expertCall;

  /// No description provided for @expertWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get expertWhatsapp;

  /// No description provided for @expertInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get expertInstagram;

  /// No description provided for @expertsNote.
  ///
  /// In en, this message translates to:
  /// **'Parla only introduces experts and is not responsible for their services. You contact them directly, outside the app; Parla does not see the conversation.'**
  String get expertsNote;

  /// No description provided for @nutritionHero.
  ///
  /// In en, this message translates to:
  /// **'Beauty starts on your plate'**
  String get nutritionHero;

  /// No description provided for @nutritionPlate.
  ///
  /// In en, this message translates to:
  /// **'Today\'s plate'**
  String get nutritionPlate;

  /// No description provided for @nutritionPlateCount.
  ///
  /// In en, this message translates to:
  /// **'{count} of {total} groups'**
  String nutritionPlateCount(int count, int total);

  /// No description provided for @groupVegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get groupVegetables;

  /// No description provided for @groupFruit.
  ///
  /// In en, this message translates to:
  /// **'Fruit'**
  String get groupFruit;

  /// No description provided for @groupProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get groupProtein;

  /// No description provided for @groupWholeGrain.
  ///
  /// In en, this message translates to:
  /// **'Whole grain'**
  String get groupWholeGrain;

  /// No description provided for @groupHealthyFat.
  ///
  /// In en, this message translates to:
  /// **'Healthy fat'**
  String get groupHealthyFat;

  /// No description provided for @groupDairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get groupDairy;

  /// No description provided for @nutritionWater.
  ///
  /// In en, this message translates to:
  /// **'Water: {count} of {goal} glasses'**
  String nutritionWater(int count, int goal);

  /// No description provided for @nutritionNoCalories.
  ///
  /// In en, this message translates to:
  /// **'The plate does not count calories. Just variety: a colourful plate every day.'**
  String get nutritionNoCalories;

  /// No description provided for @nutritionTip.
  ///
  /// In en, this message translates to:
  /// **'Tip of the day'**
  String get nutritionTip;

  /// No description provided for @nutritionRecipes.
  ///
  /// In en, this message translates to:
  /// **'Beauty recipes'**
  String get nutritionRecipes;

  /// No description provided for @nutritionDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This is general information, not a diet or medical advice. If you have special dietary needs, talk to a dietitian.'**
  String get nutritionDisclaimer;

  /// No description provided for @nutritionPrivacySynced.
  ///
  /// In en, this message translates to:
  /// **'Your plate entries are kept encrypted on our server, with a copy on this phone for offline use.'**
  String get nutritionPrivacySynced;

  /// No description provided for @nutritionPrivacyDevice.
  ///
  /// In en, this message translates to:
  /// **'For now your plate entries are kept only on this phone. With the updated health consent they will be kept encrypted on our server.'**
  String get nutritionPrivacyDevice;

  /// No description provided for @mealBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get mealBreakfast;

  /// No description provided for @mealLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get mealLunch;

  /// No description provided for @mealDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get mealDinner;

  /// No description provided for @mealSnack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get mealSnack;

  /// No description provided for @recipeMeta.
  ///
  /// In en, this message translates to:
  /// **'{meal} · {minutes} min · serves {servings}'**
  String recipeMeta(String meal, int minutes, int servings);

  /// No description provided for @recipeIngredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get recipeIngredients;

  /// No description provided for @recipeSteps.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get recipeSteps;

  /// No description provided for @recipeAddAll.
  ///
  /// In en, this message translates to:
  /// **'Add the ingredients to my shopping list'**
  String get recipeAddAll;

  /// No description provided for @recipeSave.
  ///
  /// In en, this message translates to:
  /// **'Save recipe'**
  String get recipeSave;

  /// No description provided for @recipeUnsave.
  ///
  /// In en, this message translates to:
  /// **'Remove from saved'**
  String get recipeUnsave;

  /// No description provided for @nutritionDailyRecipe.
  ///
  /// In en, this message translates to:
  /// **'Today\'s pick'**
  String get nutritionDailyRecipe;

  /// No description provided for @nutritionPlateIdeas.
  ///
  /// In en, this message translates to:
  /// **'Fill your plate'**
  String get nutritionPlateIdeas;

  /// No description provided for @nutritionPlateIdeasNote.
  ///
  /// In en, this message translates to:
  /// **'Recipes for the groups you haven\'t had today.'**
  String get nutritionPlateIdeasNote;

  /// No description provided for @nutritionSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved recipes'**
  String get nutritionSaved;

  /// No description provided for @recipeKcal.
  ///
  /// In en, this message translates to:
  /// **'≈ {kcal} kcal · 1 serving (approximate)'**
  String recipeKcal(int kcal);

  /// No description provided for @recipeAdded.
  ///
  /// In en, this message translates to:
  /// **'{count} items added to your shopping list.'**
  String recipeAdded(int count);

  /// No description provided for @skinCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Skin analysis'**
  String get skinCardTitle;

  /// No description provided for @skinCardBody.
  ///
  /// In en, this message translates to:
  /// **'Analyse your skin again by answering questions.'**
  String get skinCardBody;

  /// No description provided for @catBody.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get catBody;

  /// No description provided for @blogSources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get blogSources;

  /// No description provided for @blogRelated.
  ///
  /// In en, this message translates to:
  /// **'Related articles'**
  String get blogRelated;

  /// No description provided for @recipeAllergens.
  ///
  /// In en, this message translates to:
  /// **'Contains: {list}'**
  String recipeAllergens(String list);

  /// No description provided for @recipeNoAllergens.
  ///
  /// In en, this message translates to:
  /// **'None of the 14 main allergens.'**
  String get recipeNoAllergens;

  /// No description provided for @allergenGluten.
  ///
  /// In en, this message translates to:
  /// **'gluten'**
  String get allergenGluten;

  /// No description provided for @allergenCrustaceans.
  ///
  /// In en, this message translates to:
  /// **'crustaceans'**
  String get allergenCrustaceans;

  /// No description provided for @allergenEgg.
  ///
  /// In en, this message translates to:
  /// **'egg'**
  String get allergenEgg;

  /// No description provided for @allergenFish.
  ///
  /// In en, this message translates to:
  /// **'fish'**
  String get allergenFish;

  /// No description provided for @allergenPeanuts.
  ///
  /// In en, this message translates to:
  /// **'peanuts'**
  String get allergenPeanuts;

  /// No description provided for @allergenSoy.
  ///
  /// In en, this message translates to:
  /// **'soy'**
  String get allergenSoy;

  /// No description provided for @allergenMilk.
  ///
  /// In en, this message translates to:
  /// **'milk'**
  String get allergenMilk;

  /// No description provided for @allergenNuts.
  ///
  /// In en, this message translates to:
  /// **'tree nuts'**
  String get allergenNuts;

  /// No description provided for @allergenCelery.
  ///
  /// In en, this message translates to:
  /// **'celery'**
  String get allergenCelery;

  /// No description provided for @allergenMustard.
  ///
  /// In en, this message translates to:
  /// **'mustard'**
  String get allergenMustard;

  /// No description provided for @allergenSesame.
  ///
  /// In en, this message translates to:
  /// **'sesame'**
  String get allergenSesame;

  /// No description provided for @allergenSulphites.
  ///
  /// In en, this message translates to:
  /// **'sulphites'**
  String get allergenSulphites;

  /// No description provided for @allergenLupin.
  ///
  /// In en, this message translates to:
  /// **'lupin'**
  String get allergenLupin;

  /// No description provided for @allergenMolluscs.
  ///
  /// In en, this message translates to:
  /// **'molluscs'**
  String get allergenMolluscs;

  /// No description provided for @bannerAd.
  ///
  /// In en, this message translates to:
  /// **'Ad · {brand}'**
  String bannerAd(String brand);

  /// No description provided for @bannerLeaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Leaving Parla'**
  String get bannerLeaveTitle;

  /// No description provided for @bannerLeaveBody.
  ///
  /// In en, this message translates to:
  /// **'{host} will open in your browser. Parla sends this site nothing about you; the site has its own privacy rules.'**
  String bannerLeaveBody(String host);

  /// No description provided for @bannerLeaveGo.
  ///
  /// In en, this message translates to:
  /// **'Open site'**
  String get bannerLeaveGo;

  /// No description provided for @bannerLeaveCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get bannerLeaveCancel;

  /// No description provided for @messagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesTitle;

  /// No description provided for @messagesButton.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesButton;

  /// No description provided for @messagesButtonUnread.
  ///
  /// In en, this message translates to:
  /// **'Messages, new reply'**
  String get messagesButtonUnread;

  /// No description provided for @messagesFromParla.
  ///
  /// In en, this message translates to:
  /// **'From Parla'**
  String get messagesFromParla;

  /// No description provided for @messagesNone.
  ///
  /// In en, this message translates to:
  /// **'No announcements yet.'**
  String get messagesNone;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportTitle;

  /// No description provided for @supportIntro.
  ///
  /// In en, this message translates to:
  /// **'Write your question and the Parla team will reply. Messages are stored encrypted and deleted 12 months after the last one. We don\'t give medical advice: in urgent or serious cases, see a doctor.'**
  String get supportIntro;

  /// No description provided for @supportHint.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get supportHint;

  /// No description provided for @supportSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get supportSend;

  /// No description provided for @supportYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get supportYou;

  /// No description provided for @supportTeam.
  ///
  /// In en, this message translates to:
  /// **'Parla team'**
  String get supportTeam;

  /// No description provided for @supportSent.
  ///
  /// In en, this message translates to:
  /// **'Sent.'**
  String get supportSent;

  /// No description provided for @pushTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get pushTitle;

  /// No description provided for @pushBody.
  ///
  /// In en, this message translates to:
  /// **'Get told when support replies. With the marketing consent you\'ll also get Parla news. You can turn this off any time.'**
  String get pushBody;

  /// No description provided for @pushDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are not allowed. You can turn them on in your phone settings.'**
  String get pushDenied;

  /// No description provided for @checkSuggestTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggested from your quiz'**
  String get checkSuggestTitle;

  /// No description provided for @checkSuggestBody.
  ///
  /// In en, this message translates to:
  /// **'Based on your quiz answers, these filters may suit you. Adding them is up to you.'**
  String get checkSuggestBody;

  /// No description provided for @checkSuggestAdd.
  ///
  /// In en, this message translates to:
  /// **'Add {name}'**
  String checkSuggestAdd(String name);

  /// No description provided for @consentRefreshCardTitle.
  ///
  /// In en, this message translates to:
  /// **'The consent text was updated'**
  String get consentRefreshCardTitle;

  /// No description provided for @consentRefreshCardBody.
  ///
  /// In en, this message translates to:
  /// **'There is a new version of the health data consent. If you read and agree, your routines, lists, sport and nutrition entries are also kept encrypted on the server. If not, they stay on this phone only.'**
  String get consentRefreshCardBody;

  /// No description provided for @consentRefreshOpen.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get consentRefreshOpen;

  /// No description provided for @consentRefreshTitle.
  ///
  /// In en, this message translates to:
  /// **'Health data consent'**
  String get consentRefreshTitle;

  /// No description provided for @consentRefreshIntro.
  ///
  /// In en, this message translates to:
  /// **'This is a new version of the text you agreed to. Agreeing is voluntary; you can withdraw at any time under Privacy.'**
  String get consentRefreshIntro;

  /// No description provided for @consentRefreshAgree.
  ///
  /// In en, this message translates to:
  /// **'I agree'**
  String get consentRefreshAgree;

  /// No description provided for @consentRefreshLater.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get consentRefreshLater;

  /// No description provided for @consentRefreshDone.
  ///
  /// In en, this message translates to:
  /// **'Consent updated.'**
  String get consentRefreshDone;
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
