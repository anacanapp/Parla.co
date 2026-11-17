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
  String get navMenuLabel => 'Main menu';

  @override
  String get navToday => 'Today';

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
  String get resultGoals => 'Concerns';

  @override
  String get resultSeeRoutine => 'Show my routine';

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
      'Your health answers and the server copy of your own routines will be deleted right away, and your routine will be built more cautiously. Your own routines stay on this phone. You can give the consent again later.';

  @override
  String get privacyWithdraw => 'Withdraw and delete';

  @override
  String get privacyCancel => 'Cancel';

  @override
  String get privacyExportTitle => 'Download my data';

  @override
  String get privacyExportBody =>
      'A file with everything Parla stores about you, plus the habit entries and your own routines on this phone. It is created now and is not kept on our servers.';

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
      'Deleted right away: your profile, quiz answers, health answers, your own routines and their encryption key, and your sign-in account. Your habit entries and the copy of your own routines on this phone are deleted too.';

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
  String get habitsScreenTitle => 'Routine';

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

  @override
  String get productsTitle => 'Check a product';

  @override
  String get productsIntro =>
      'Type a product name or brand and look at its ingredients.';

  @override
  String get productsSearchLabel => 'Product name or brand';

  @override
  String get productsSearchButton => 'Search';

  @override
  String get productsQueryTooShort => 'Type at least 2 letters.';

  @override
  String get productsNotFoundTitle => 'Nothing found';

  @override
  String get productsNotFoundBody =>
      'Try another spelling or the brand name. Not every product is in the database yet.';

  @override
  String get productsSourceObf => 'Open Beauty Facts';

  @override
  String get productsSourceParla => 'Parla catalogue';

  @override
  String get error_product_query_invalid =>
      'A search needs 2 to 80 characters.';

  @override
  String get error_product_source_unavailable =>
      'The product database is not answering right now. Please try again a little later.';

  @override
  String get productIngredientsTitle => 'Ingredients';

  @override
  String get productNoIngredients =>
      'There is no ingredient list for this product. Please check the package.';

  @override
  String productIngredientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ingredients',
      one: '1 ingredient',
    );
    return '$_temp0';
  }

  @override
  String productListedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count have an EU entry',
      one: '1 has an EU entry',
    );
    return '$_temp0';
  }

  @override
  String get productStatusesMissing =>
      'Ingredient statuses are not loaded yet. For now only the ingredient list is shown.';

  @override
  String get productDataNotice =>
      'The ingredient list comes from a community database and may contain mistakes. Compare it with the package.';

  @override
  String productLegalNotice(String date) {
    return 'Statuses are based on the annexes of EU Regulation 1223/2009 (CosIng, $date). Names are matched automatically. This is not an Azerbaijani rule and not a safety assessment of the product.';
  }

  @override
  String get productAttribution =>
      'Product data: Open Beauty Facts, under the ODbL licence.';

  @override
  String get annexIIShort => 'EU: on the list of prohibited substances';

  @override
  String get annexIIIShort => 'EU: allowed with restrictions';

  @override
  String get annexIVShort => 'EU: allowed colorant';

  @override
  String get annexVShort => 'EU: allowed preservative';

  @override
  String get annexVIShort => 'EU: allowed UV filter';

  @override
  String annexEntry(String annex, String reference) {
    return 'Annex $annex, entry $reference';
  }

  @override
  String get annexConditionsLabel =>
      'Official conditions (as in CosIng, in English)';

  @override
  String get ingredientNoEntry => 'No separate entry found in the EU annexes';

  @override
  String ingredientSheetSource(String date) {
    return 'Source: CosIng, $date';
  }

  @override
  String get ingredientDetailsHint => 'Details';

  @override
  String get navRoutine => 'Routine';

  @override
  String get navCheck => 'Check';

  @override
  String get navSport => 'Fitness';

  @override
  String get navDiscover => 'Discover';

  @override
  String get sportTitle => 'Fitness';

  @override
  String get discoverTitle => 'Discover';

  @override
  String get discoverBlogs => 'Blogs';

  @override
  String get discoverBlogsHint => 'Care, beauty, fashion';

  @override
  String get discoverExperts => 'Experts';

  @override
  String get discoverExpertsHint => 'Dermatologists, cosmetologists';

  @override
  String get discoverNutrition => 'Nutrition';

  @override
  String get discoverNutritionHint => 'Daily plate and recipes';

  @override
  String get discoverShopping => 'Shopping list';

  @override
  String get discoverShoppingHint => 'Note what you need';

  @override
  String get discoverShop => 'Shop';

  @override
  String get discoverShopHint => 'Products from your routine';

  @override
  String get soonBadge => 'Soon';

  @override
  String get onboardingStepAbout => 'About you';

  @override
  String get onboardingStepAccount => 'Account';

  @override
  String get onboardingStepCountry => 'Country';

  @override
  String get onboardingStepPrivacy => 'Privacy';

  @override
  String get routineAreaFace => 'Face';

  @override
  String get routineAreaHair => 'Hair';

  @override
  String get routineAreaBody => 'Body';

  @override
  String get routineSlotMorning => 'Morning';

  @override
  String get routineSlotEvening => 'Evening';

  @override
  String get routineSlotWeekly => 'Weekly';

  @override
  String get routineWeeklyHint => 'Once a week. Ticks reset on Monday.';

  @override
  String get routineSlotEmpty => 'No steps for this time.';

  @override
  String get routineOwnButton => 'Your own';

  @override
  String get routineOwnSection => 'Your routines';

  @override
  String get routineOwnEmpty => 'Make your own routine and tick it off here.';

  @override
  String get routineOwnEveryDay => 'Every day';

  @override
  String routineOwnSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count steps',
      one: '1 step',
    );
    return '$_temp0';
  }

  @override
  String routineOwnEdit(String name) {
    return 'Edit: $name';
  }

  @override
  String get routineDayHabits => 'During the day';

  @override
  String get builderTitleNew => 'Make your own routine';

  @override
  String get builderTitleEdit => 'Edit routine';

  @override
  String get builderName => 'Name';

  @override
  String get builderNameHint => 'E.g. Sunday spa';

  @override
  String get builderArea => 'Area';

  @override
  String get builderWhen => 'When';

  @override
  String get builderEveryDay => 'Every day';

  @override
  String get builderOnceWeek => 'Once a week';

  @override
  String get builderSteps => 'Steps';

  @override
  String get builderStepHint => 'New step';

  @override
  String get builderAddStep => 'Add';

  @override
  String get builderSuggestions => 'Pick a ready step';

  @override
  String builderMoveUp(String step) {
    return 'Move up: $step';
  }

  @override
  String builderMoveDown(String step) {
    return 'Move down: $step';
  }

  @override
  String builderRemoveStep(String step) {
    return 'Remove: $step';
  }

  @override
  String get builderSave => 'Save routine';

  @override
  String get builderDelete => 'Delete routine';

  @override
  String get builderDeleteConfirm => 'Delete this routine?';

  @override
  String get builderDeleteYes => 'Delete';

  @override
  String get builderCancel => 'Cancel';

  @override
  String get builderNeedName => 'Give the routine a name.';

  @override
  String get builderNeedStep => 'Add at least one step.';

  @override
  String builderLimit(int count) {
    return 'At most $count steps.';
  }

  @override
  String get todayRoutinesTitle => 'Today\'s routines';

  @override
  String get todayRoutinesAll => 'All';

  @override
  String get todayRoutinesNone => 'No other routines for today.';

  @override
  String get builderPrivacySynced =>
      'Your own routines are kept encrypted on our server, with a copy on this phone for offline use.';

  @override
  String get builderPrivacyDevice =>
      'For now your own routines are kept only on this phone. With the updated health consent they will be kept encrypted on our server.';

  @override
  String get checkPrefsTitle => 'Your preferences';

  @override
  String get checkPrefsEdit => 'Change';

  @override
  String get checkPrefsEmpty =>
      'Pick what matters to you and we compare the ingredients with your picks.';

  @override
  String get checkPrefsAdd => 'Add preferences';

  @override
  String get checkPrefsSheetTitle => 'What matters to you?';

  @override
  String get checkPrefsSave => 'Save';

  @override
  String get checkBarcodeSoon => 'Barcode scanner · soon';

  @override
  String get checkRecentTitle => 'Recently checked';

  @override
  String get checkRecentClear => 'Clear';

  @override
  String get resultPrefsTitle => 'With your preferences';

  @override
  String resultPrefsSummary(int fits, int count) {
    return '$fits of $count of your picks fit';
  }

  @override
  String get resultPrefFits => 'Fits';

  @override
  String resultPrefContains(String names) {
    return 'Contains: $names';
  }

  @override
  String get resultPrefVeganFits => 'No known animal-derived ingredient found';

  @override
  String get resultPrefUnknown => 'Cannot check: no ingredient list';

  @override
  String get resultPrefsNone =>
      'Add your preferences and we compare the ingredients with them.';

  @override
  String get resultPrefsNote =>
      'Parla does not rate products or give scores. The match is based only on your picks and the ingredient list.';

  @override
  String get resultAddToList => 'Add to shopping list';

  @override
  String get resultInList => 'On your list';

  @override
  String get resultAdded => 'Added to your shopping list.';

  @override
  String shoppingCount(int bought, int total) {
    return '$bought of $total bought';
  }

  @override
  String get shoppingNewHint => 'New item';

  @override
  String get shoppingAdd => 'Add';

  @override
  String get shoppingEmpty => 'The list is empty. Note what you need here.';

  @override
  String get shoppingAreaOther => 'Other';

  @override
  String get shoppingFromCheck => 'From Check';

  @override
  String shoppingRemove(String title) {
    return 'Remove: $title';
  }

  @override
  String get shoppingRemoveBought => 'Remove bought';

  @override
  String shoppingFull(int count) {
    return 'The list can hold at most $count items.';
  }

  @override
  String get careListSynced =>
      'Your preferences and shopping list are kept encrypted on our server, with a copy on this phone for offline use.';

  @override
  String get careListDevice =>
      'For now your preferences and shopping list are kept only on this phone. With the updated health consent they will be kept encrypted on our server.';

  @override
  String get shopTitle => 'Parla Shop';

  @override
  String get shopBody =>
      'The products in your routine, in one tap. You will be able to order your shopping list directly and find products that fit your picks.';

  @override
  String get shopSoonCard => 'Parla Shop is coming';

  @override
  String get shopSoonCardBody => 'You will be able to order your list directly';

  @override
  String get shopOpenList => 'See my shopping list';

  @override
  String get sportIntroTitle => 'A workout plan made for you';

  @override
  String get sportIntroBody =>
      'A few questions: goal, areas, the workouts you like. Then a weekly plan with sets, reps and a timer. Music plays from your own app.';

  @override
  String get sportStart => 'Start';

  @override
  String get sportNext => 'Next';

  @override
  String get sportNeedOne => 'Pick at least one.';

  @override
  String get sportQGoals => 'What is your goal?';

  @override
  String get sportQGoalsHint => 'Pick up to two';

  @override
  String get sportGoalTone => 'Tone and firmness';

  @override
  String get sportGoalMuscle => 'Build muscle';

  @override
  String get sportGoalFlexibility => 'Flexibility';

  @override
  String get sportGoalPosture => 'Posture';

  @override
  String get sportGoalEndurance => 'Endurance';

  @override
  String get sportGoalRelax => 'Unwind';

  @override
  String get sportQAreas => 'Which areas should we focus on?';

  @override
  String get sportAreasNote =>
      'Fat cannot be burned from one spot. These moves strengthen and tone those muscles.';

  @override
  String get sportAreaArms => 'Arms';

  @override
  String get sportAreaLegs => 'Legs';

  @override
  String get sportAreaCore => 'Abs and core';

  @override
  String get sportAreaGlutes => 'Glutes';

  @override
  String get sportAreaBack => 'Back';

  @override
  String get sportAreaFull => 'Full body';

  @override
  String get sportQTypes => 'Which workouts do you want?';

  @override
  String get sportTypeFitness => 'Fitness';

  @override
  String get sportTypePilates => 'Pilates';

  @override
  String get sportTypeWallPilates => 'Wall pilates';

  @override
  String get sportTypeStretching => 'Stretching';

  @override
  String get sportTypeCardio => 'Low-impact cardio';

  @override
  String get sportQLevel => 'What is your level?';

  @override
  String get sportLevelBeginner => 'Just starting';

  @override
  String get sportLevelIntermediate => 'Intermediate';

  @override
  String get sportLevelAdvanced => 'Experienced';

  @override
  String get sportQSchedule => 'How much time do you have?';

  @override
  String get sportDaysLabel => 'Days a week';

  @override
  String get sportMinutesLabel => 'One workout';

  @override
  String sportDays(int count) {
    return '$count days';
  }

  @override
  String sportMinutes(int count) {
    return '$count min';
  }

  @override
  String get sportDumbbells => 'I have dumbbells at home';

  @override
  String get sportQSafety => 'For your safety';

  @override
  String get sportSafetyIntro =>
      'These answers only remove moves that do not suit you from the plan.';

  @override
  String get sportPregnancyLabel => 'Pregnancy';

  @override
  String get sportPregNo => 'No';

  @override
  String get sportPregPregnant => 'I am pregnant';

  @override
  String get sportPregPostpartum => 'Gave birth in the last 6 months';

  @override
  String get sportInjuriesLabel => 'Pain or injury';

  @override
  String get sportInjKnee => 'Knee';

  @override
  String get sportInjBack => 'Lower back';

  @override
  String get sportInjShoulder => 'Shoulder';

  @override
  String get sportInjWrist => 'Wrist';

  @override
  String get sportDoctorLimit =>
      'A doctor limited exercise or asked me to check first';

  @override
  String get sportBuildPlan => 'Build my plan';

  @override
  String get sportWeekTitle => 'This week';

  @override
  String sportWeekProgress(int done, int total) {
    return '$done of $total workouts';
  }

  @override
  String sportWorkoutTitle(int number) {
    return 'Workout $number';
  }

  @override
  String sportWorkoutMeta(String type, int minutes) {
    return '$type · ~$minutes min';
  }

  @override
  String get sportDone => 'Done';

  @override
  String get sportNextLabel => 'Next up';

  @override
  String get sportEditAnswers => 'Update answers';

  @override
  String get sportBlockedTitle => 'Talk to your doctor first';

  @override
  String get sportBlockedBody =>
      'If a doctor limited exercise, we do not build a plan. Update your answers once you have the go-ahead.';

  @override
  String get sportGentleNote =>
      'A gentle plan for pregnancy and after birth. Check with your doctor before you start.';

  @override
  String get sportDraftNote =>
      'The moves and numbers have not been reviewed by a trainer yet. Stop if anything hurts.';

  @override
  String get sportAllDone => 'All of this week\'s workouts are done.';

  @override
  String sportSetsReps(int sets, int reps) {
    return '$sets × $reps reps';
  }

  @override
  String sportSetsSeconds(int sets, int seconds) {
    return '$sets × $seconds s';
  }

  @override
  String sportRestSeconds(int seconds) {
    return 'Rest $seconds s';
  }

  @override
  String get sportStartWorkout => 'Start workout';

  @override
  String get sportMusicNote =>
      'Play music from your own music app. Parla only gives short signals.';

  @override
  String get sportSoundOn => 'Sound signals on';

  @override
  String get sportSoundOff => 'Sound off, vibration only';

  @override
  String sportSetOf(int set, int sets) {
    return 'Set $set of $sets';
  }

  @override
  String sportRepsNow(int reps) {
    return '$reps reps';
  }

  @override
  String get sportSetDone => 'Set done';

  @override
  String get sportPause => 'Pause';

  @override
  String get sportResume => 'Resume';

  @override
  String get sportSkip => 'Skip';

  @override
  String get sportResting => 'Rest';

  @override
  String sportNextUp(String name) {
    return 'Next: $name';
  }

  @override
  String sportExerciseOf(int index, int total) {
    return 'Move $index of $total';
  }

  @override
  String get sportFinishedTitle => 'Workout done';

  @override
  String sportFinishedBody(int minutes) {
    return '$minutes minutes of movement were added to today\'s entries.';
  }

  @override
  String get sportBackToPlan => 'Back to the plan';

  @override
  String get sportQuit => 'Stop workout';

  @override
  String get sportPrivacySynced =>
      'Your fitness answers are kept encrypted on our server, with a copy on this phone for offline use.';

  @override
  String get sportPrivacyDevice =>
      'For now your fitness answers are kept only on this phone. With the updated health consent they will be kept encrypted on our server.';

  @override
  String get discoverLatest => 'New articles';

  @override
  String get discoverAll => 'All';

  @override
  String get contentEmpty => 'Nothing here yet. Coming soon.';

  @override
  String get contentOffline => 'No connection, showing the last loaded copy.';

  @override
  String blogMeta(String category, int minutes) {
    return '$category · $minutes min';
  }

  @override
  String blogReviewed(String date) {
    return 'Reviewed by an expert · $date';
  }

  @override
  String get blogTips => 'Quick steps';

  @override
  String get catCare => 'Care';

  @override
  String get catBeauty => 'Beauty';

  @override
  String get catFashion => 'Fashion';

  @override
  String get catHair => 'Hair';

  @override
  String get specDermatologist => 'Dermatologist';

  @override
  String get specCosmetologist => 'Cosmetologist';

  @override
  String get specTrainer => 'Trainer';

  @override
  String get specDietitian => 'Dietitian';

  @override
  String get specTrichologist => 'Trichologist';

  @override
  String expertYears(int years) {
    return '$years years of experience';
  }

  @override
  String get expertCall => 'Call';

  @override
  String get expertWhatsapp => 'WhatsApp';

  @override
  String get expertInstagram => 'Instagram';

  @override
  String get expertsNote =>
      'Parla only introduces experts and is not responsible for their services. You contact them directly, outside the app; Parla does not see the conversation.';

  @override
  String get nutritionHero => 'Beauty starts on your plate';

  @override
  String get nutritionPlate => 'Today\'s plate';

  @override
  String nutritionPlateCount(int count, int total) {
    return '$count of $total groups';
  }

  @override
  String get groupVegetables => 'Vegetables';

  @override
  String get groupFruit => 'Fruit';

  @override
  String get groupProtein => 'Protein';

  @override
  String get groupWholeGrain => 'Whole grain';

  @override
  String get groupHealthyFat => 'Healthy fat';

  @override
  String get groupDairy => 'Dairy';

  @override
  String nutritionWater(int count, int goal) {
    return 'Water: $count of $goal glasses';
  }

  @override
  String get nutritionNoCalories =>
      'We do not count calories. Just variety: a colourful plate every day.';

  @override
  String get nutritionTip => 'Today\'s tip for your skin';

  @override
  String get nutritionRecipes => 'Beauty recipes';

  @override
  String get nutritionDisclaimer =>
      'This is general information, not a diet or medical advice. If you have special dietary needs, talk to a dietitian.';

  @override
  String get nutritionPrivacySynced =>
      'Your plate entries are kept encrypted on our server, with a copy on this phone for offline use.';

  @override
  String get nutritionPrivacyDevice =>
      'For now your plate entries are kept only on this phone. With the updated health consent they will be kept encrypted on our server.';

  @override
  String get mealBreakfast => 'Breakfast';

  @override
  String get mealLunch => 'Lunch';

  @override
  String get mealDinner => 'Dinner';

  @override
  String get mealSnack => 'Snack';

  @override
  String recipeMeta(String meal, int minutes, int servings) {
    return '$meal · $minutes min · serves $servings';
  }

  @override
  String get recipeIngredients => 'Ingredients';

  @override
  String get recipeSteps => 'Method';

  @override
  String get recipeAddAll => 'Add the ingredients to my shopping list';

  @override
  String recipeAdded(int count) {
    return '$count items added to your shopping list.';
  }

  @override
  String get skinCardTitle => 'Skin analysis';

  @override
  String get skinCardBody => 'Analyse your skin again by answering questions.';

  @override
  String get catBody => 'Body';

  @override
  String get blogSources => 'Sources';

  @override
  String recipeAllergens(String list) {
    return 'Contains: $list';
  }

  @override
  String get recipeNoAllergens => 'None of the 14 main allergens.';

  @override
  String get allergenGluten => 'gluten';

  @override
  String get allergenCrustaceans => 'crustaceans';

  @override
  String get allergenEgg => 'egg';

  @override
  String get allergenFish => 'fish';

  @override
  String get allergenPeanuts => 'peanuts';

  @override
  String get allergenSoy => 'soy';

  @override
  String get allergenMilk => 'milk';

  @override
  String get allergenNuts => 'tree nuts';

  @override
  String get allergenCelery => 'celery';

  @override
  String get allergenMustard => 'mustard';

  @override
  String get allergenSesame => 'sesame';

  @override
  String get allergenSulphites => 'sulphites';

  @override
  String get allergenLupin => 'lupin';

  @override
  String get allergenMolluscs => 'molluscs';

  @override
  String bannerAd(String brand) {
    return 'Ad · $brand';
  }

  @override
  String get messagesTitle => 'Messages';

  @override
  String get messagesButton => 'Messages';

  @override
  String get messagesButtonUnread => 'Messages, new reply';

  @override
  String get messagesFromParla => 'From Parla';

  @override
  String get messagesNone => 'No announcements yet.';

  @override
  String get supportTitle => 'Support';

  @override
  String get supportIntro =>
      'Write your question and the Parla team will reply. Messages are stored encrypted and deleted 12 months after the last one. We don\'t give medical advice: in urgent or serious cases, see a doctor.';

  @override
  String get supportHint => 'Your message';

  @override
  String get supportSend => 'Send';

  @override
  String get supportYou => 'You';

  @override
  String get supportTeam => 'Parla team';

  @override
  String get supportSent => 'Sent.';
}
