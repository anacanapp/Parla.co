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

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Check a product'**
  String get scanTitle;

  /// No description provided for @scanBody.
  ///
  /// In en, this message translates to:
  /// **'Scan the barcode and see the ingredients in plain words'**
  String get scanBody;

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

  /// No description provided for @navScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get navScan;

  /// No description provided for @navHabits.
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get navHabits;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

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
  /// **'Goals'**
  String get resultGoals;

  /// No description provided for @resultSeeRoutine.
  ///
  /// In en, this message translates to:
  /// **'Show my routine'**
  String get resultSeeRoutine;

  /// No description provided for @resultExclusionPregnancy.
  ///
  /// In en, this message translates to:
  /// **'We left out retinol: we don\'t suggest it during pregnancy or breastfeeding, or when this question isn\'t answered.'**
  String get resultExclusionPregnancy;

  /// No description provided for @resultExclusionMedication.
  ///
  /// In en, this message translates to:
  /// **'We left out retinol: the medication question is unanswered or you use a prescription skin medicine. Talk to your doctor.'**
  String get resultExclusionMedication;

  /// No description provided for @resultExclusionSensitive.
  ///
  /// In en, this message translates to:
  /// **'For sensitive skin we chose soothing steps instead of active ingredients.'**
  String get resultExclusionSensitive;

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

  /// No description provided for @resultExclusionRetinoidBoth.
  ///
  /// In en, this message translates to:
  /// **'We left out retinol: we don\'t suggest it without answers about pregnancy and medicines.'**
  String get resultExclusionRetinoidBoth;

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
  /// **'Your health answers will be deleted right away, and your routine will be built more cautiously. You can give the consent again later.'**
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
  /// **'A file with everything Parla stores about you. It is created now and is not kept on our servers.'**
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
  /// **'Deleted right away: your profile, quiz answers, health answers and their encryption key, and your sign-in account.'**
  String get deleteWhatGoes;

  /// No description provided for @deleteWhatStays.
  ///
  /// In en, this message translates to:
  /// **'Kept as proof, without your name or email: your consent history (3 years) and security log entries (1 year).'**
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

  /// No description provided for @legalConsentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Consent texts'**
  String get legalConsentsTitle;
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
