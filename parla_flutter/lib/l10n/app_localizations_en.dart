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

  @override
  String get quizIntroTitle => 'Let\'s get to know you.';

  @override
  String get quizIntroBody =>
      'A few questions about your skin, hair and daily rhythm. It takes about 3 minutes.';

  @override
  String get quizStart => 'Let\'s start';

  @override
  String get quizLater => 'Later';

  @override
  String quizProgress(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get quizMultipleHint => 'You can choose several';

  @override
  String get quizNext => 'Next';

  @override
  String get quizBack => 'Back';

  @override
  String get quizDecline => 'I\'d rather not answer';

  @override
  String get quizFinish => 'Finish';

  @override
  String get healthGateTitle => 'A few sensitive questions';

  @override
  String get healthGateBody =>
      'The next questions are about skin diagnoses, allergies, pregnancy and medicines. They help keep your routine safe. Your answers are encrypted and stored only with your consent.';

  @override
  String get healthGateAgree => 'I agree, continue';

  @override
  String get healthGateSkip => 'Skip this section';

  @override
  String get healthGateSkipNote =>
      'If you skip, your routine will be built more cautiously.';

  @override
  String get redFlagTitle => 'Please show this to a doctor';

  @override
  String get redFlagBody =>
      'The sign you noted may need a doctor\'s examination. Parla does not diagnose and does not replace a doctor. We recommend seeing a dermatologist.';

  @override
  String get redFlagOk => 'I understand';

  @override
  String get resultTitle => 'Your routine is ready';

  @override
  String get resultSkin => 'Skin';

  @override
  String get resultHair => 'Hair';

  @override
  String get resultGoals => 'Goals';

  @override
  String get resultSeeRoutine => 'Show my routine';

  @override
  String get resultExclusionPregnancy =>
      'We left out retinol: we don\'t suggest it during pregnancy or breastfeeding, or when this question isn\'t answered.';

  @override
  String get resultExclusionMedication =>
      'We left out retinol: the medication question is unanswered or you use a prescription skin medicine. Talk to your doctor.';

  @override
  String get resultExclusionSensitive =>
      'For sensitive skin we chose soothing steps instead of active ingredients.';

  @override
  String get homeQuizTitle => 'Let\'s personalise your routine';

  @override
  String get homeQuizBody => 'A 3-minute quiz and your routine adapts to you.';

  @override
  String get homeQuizStart => 'Start the quiz';

  @override
  String get error_consent_health_required =>
      'These answers need the health consent.';

  @override
  String get resultExclusionRetinoidBoth =>
      'We left out retinol: we don\'t suggest it without answers about pregnancy and medicines.';

  @override
  String get privacyTitle => 'Privacy centre';

  @override
  String get privacyIntro =>
      'Your data, your choices. Every right is one tap away.';

  @override
  String get privacyConsentsTitle => 'Consents';

  @override
  String get privacyHealthWithdrawTitle => 'Withdraw the health consent?';

  @override
  String get privacyHealthWithdrawBody =>
      'Your health answers will be deleted right away, and your routine will be built more cautiously. You can give the consent again later.';

  @override
  String get privacyWithdraw => 'Withdraw and delete';

  @override
  String get privacyCancel => 'Cancel';

  @override
  String get privacyExportTitle => 'Download my data';

  @override
  String get privacyExportBody =>
      'A file with everything Parla stores about you, plus the habit entries on this phone. It is created now and is not kept on our servers.';

  @override
  String get privacyExportButton => 'Create file';

  @override
  String get privacyLegalTitle => 'Legal documents';

  @override
  String get privacySignOut => 'Sign out';

  @override
  String get privacyDeleteTitle => 'Delete account';

  @override
  String get deleteTitle => 'Delete your account?';

  @override
  String get deleteWhatGoes =>
      'Deleted right away: your profile, quiz answers, health answers and their encryption key, and your sign-in account. Your habit entries on this phone are deleted too.';

  @override
  String get deleteWhatStays =>
      'Kept as proof, without your name or email: your consent history (3 years) and security log entries (1 year).';

  @override
  String get deleteExportFirst => 'Download my data first';

  @override
  String deleteConfirmLabel(String word) {
    return 'Type $word to confirm';
  }

  @override
  String get deleteConfirmWord => 'DELETE';

  @override
  String get deleteButton => 'Delete my account';

  @override
  String get deletedTitle => 'Your account is deleted';

  @override
  String get deletedBody =>
      'Thank you for being with us. You are always welcome back.';

  @override
  String get legalTitle => 'Legal documents';

  @override
  String get legalMedicalTitle => 'Not medical advice';

  @override
  String get legalMedicalBody =>
      'Parla offers care guidance. It does not diagnose, treat or replace a doctor. For skin conditions or worrying signs, see a dermatologist.';

  @override
  String get legalPolicyTitle => 'Privacy policy and terms';

  @override
  String get legalPolicyBody =>
      'These documents are being prepared with a lawyer and will appear here before launch.';

  @override
  String get legalConsentsTitle => 'Consent texts';

  @override
  String get habitEdit => 'Edit';

  @override
  String get habitSleepSheetTitle => 'How long did you sleep last night?';

  @override
  String get habitMoveSheetTitle => 'How long did you move today?';

  @override
  String habitSleepHours(String hours) {
    return '$hours h';
  }

  @override
  String habitMoveMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get habitLess => 'Less';

  @override
  String get habitMore => 'More';

  @override
  String get habitSave => 'Save';

  @override
  String get habitClearEntry => 'Remove entry';

  @override
  String get habitsScreenTitle => 'Habits';

  @override
  String get habitsScreenIntro => 'Small steps, at your own pace.';

  @override
  String get habitsToday => 'Today';

  @override
  String get habitsWeekTitle => 'Last 7 days';

  @override
  String get habitsWeekCare => 'Days you made time for your routine';

  @override
  String habitsWeekCareValue(int days) {
    return '$days of 7 days';
  }

  @override
  String get habitsWeekNone => 'Nothing logged yet';

  @override
  String habitsWeekWaterValue(String glasses) {
    return 'On average $glasses glasses a day';
  }

  @override
  String habitsWeekSleepValue(String hours, int nights) {
    return 'On average $hours h, $nights nights logged';
  }

  @override
  String habitsWeekMoveValue(int minutes, int days) {
    return '$minutes min in total, on $days days';
  }

  @override
  String get habitsPrivacyNote =>
      'Your habit entries are kept only on this phone and are never sent to our server. Entries older than 90 days are deleted automatically.';

  @override
  String get privacyHabitsTitle => 'Habit entries on this phone';

  @override
  String get privacyHabitsBody =>
      'Water, sleep, movement and routine entries are kept only on this phone. You can delete them at any time.';

  @override
  String get privacyHabitsDelete => 'Delete entries';

  @override
  String get privacyHabitsDeleteTitle => 'Delete your habit entries?';

  @override
  String get privacyHabitsDeleteBody =>
      'All water, sleep, movement and routine entries on this phone will be deleted. This cannot be undone.';

  @override
  String get privacyHabitsDeleted => 'Habit entries deleted.';

  @override
  String get remindersTitle => 'Reminders';

  @override
  String get remindersIntro =>
      'Your phone shows the reminders itself; nothing is sent to a server. You can turn them off at any time.';

  @override
  String get remindersOpen => 'Set up';

  @override
  String get remindersSummaryOff => 'All off';

  @override
  String remindersSummaryOn(int count) {
    return '$count on';
  }

  @override
  String get reminderMorningTitle => 'Morning routine';

  @override
  String get reminderEveningTitle => 'Evening routine';

  @override
  String get reminderSleepTitle => 'Sleep entry';

  @override
  String get reminderMorningBody => 'Time for your morning routine.';

  @override
  String get reminderEveningBody => 'Time for your evening routine.';

  @override
  String get reminderSleepBody => 'Would you like to log last night?';

  @override
  String reminderAt(String time) {
    return 'At $time';
  }

  @override
  String get reminderChangeTime => 'Change time';

  @override
  String get reminderTimeSheetTitle => 'When should we remind you?';

  @override
  String get reminderPermissionDenied =>
      'Notifications are not allowed. You can allow them in your phone\'s settings.';

  @override
  String get remindersNote =>
      'The texts are neutral and show no health information on the lock screen. A reminder may arrive a few minutes late.';
}
