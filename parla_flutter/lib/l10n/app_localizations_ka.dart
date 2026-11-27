// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Georgian (`ka`).
class AppLocalizationsKa extends AppLocalizations {
  AppLocalizationsKa([String locale = 'ka']) : super(locale);

  @override
  String get appTitle => 'Parla';

  @override
  String get languageTitle => 'აირჩიეთ ენა';

  @override
  String get languageName_az => 'Azərbaycanca';

  @override
  String get languageName_ru => 'Русский';

  @override
  String get languageName_en => 'English';

  @override
  String get continueButton => 'გაგრძელება';

  @override
  String get welcomeTitle => 'თქვენი პირადი მოვლის გზამკვლევი';

  @override
  String get welcomeBody1 =>
      'ექსპერტების მიერ შემოწმებული რუტინები თქვენი კანის, თმისა და სხეულისთვის.';

  @override
  String get welcomeBody2 =>
      'დაასკანერეთ პროდუქტი და ნახეთ, რას აკეთებს თითოეული ინგრედიენტი, ოფიციალური წყაროების მიხედვით.';

  @override
  String get welcomeBody3 =>
      'ძილი, წყალი და მოძრაობა: პატარა ჩვევები ერთ ადგილას.';

  @override
  String get welcomeStart => 'დაწყება';

  @override
  String get welcomeBrowse => 'ანგარიშის გარეშე ნახვა';

  @override
  String get welcomeSignIn => 'უკვე მაქვს ანგარიში';

  @override
  String get ageTitle => 'რომელ წელს დაიბადეთ?';

  @override
  String get ageWhy =>
      'Parla განკუთვნილია 18 წლისა და უფროსი ასაკისთვის. ვინახავთ მხოლოდ წელს და არა სრულ თარიღს.';

  @override
  String get ageYearLabel => 'დაბადების წელი';

  @override
  String get ageInvalid => 'შეიყვანეთ წელი 1900-სა და მიმდინარე წელს შორის.';

  @override
  String get ageBirthdayQuestion => 'წელს დაბადების დღე უკვე გქონდათ?';

  @override
  String get yes => 'დიახ';

  @override
  String get no => 'არა';

  @override
  String get underageTitle => 'Parla ზრდასრულებისთვისაა';

  @override
  String get underageBody =>
      'Parla ხელმისაწვდომია მხოლოდ 18 წლისა და უფროსი ასაკის პირებისთვის. თქვენ მიერ შეყვანილი არცერთი მონაცემი არ შენახულა.';

  @override
  String get close => 'დახურვა';

  @override
  String get signInTitle => 'შედით ან შექმენით ანგარიში';

  @override
  String get signInBody =>
      'თქვენს ელფოსტაზე ერთჯერად კოდს გამოგიგზავნით. პაროლი არ არის საჭირო.';

  @override
  String get signInFailed => 'შესვლა ვერ მოხერხდა. სცადეთ ხელახლა.';

  @override
  String get signInLegalNote =>
      'ანგარიშის შექმნით თქვენ ეთანხმებით გამოყენების პირობებს. როგორ მუშავდება თქვენი მონაცემები, აღწერილია კონფიდენციალურობის პოლიტიკაში.';

  @override
  String get countryTitle => 'სად ცხოვრობთ?';

  @override
  String get countryWhy =>
      'თქვენი მონაცემები ინახება თქვენი ქვეყნის რეგიონში. Parla ჯერ აზერბაიჯანში იხსნება.';

  @override
  String get countryComingSoon => 'მალე';

  @override
  String get countryName_AZ => 'აზერბაიჯანი';

  @override
  String get countryName_TR => 'თურქეთი';

  @override
  String get countryName_KZ => 'ყაზახეთი';

  @override
  String get countryName_UZ => 'უზბეკეთი';

  @override
  String get consentTitle => 'თქვენი არჩევანი';

  @override
  String get consentIntro =>
      'თითოეული თანხმობა ცალკეა და ნაგულისხმევად გამორთულია. აპი მათ გარეშეც მუშაობს. მათი შეცვლა ნებისმიერ დროს შეგიძლიათ განყოფილებაში პარამეტრები → კონფიდენციალურობა.';

  @override
  String get consentHealthTitle => 'ჯანმრთელობასთან დაკავშირებული პასუხები';

  @override
  String get consentHealthHint =>
      'საჭიროა მხოლოდ ნებაყოფლობითი კითხვებისთვის კანის მდგომარეობის, ალერგიის, ორსულობისა და მედიკამენტების შესახებ.';

  @override
  String get consentAnalyticsTitle => 'გამოყენების სტატისტიკა';

  @override
  String get consentMarketingTitle => 'სიახლეები და რჩევები ელფოსტით';

  @override
  String consentVersion(String version) {
    return 'ტექსტის ვერსია: $version';
  }

  @override
  String get guestTitle => 'პროდუქტის ძიება';

  @override
  String get guestPlaceholder =>
      'პროდუქტის ძიება და სკანირება შემდეგ ვერსიაში დაემატება.';

  @override
  String get errorGeneric => 'მოხდა შეცდომა. სცადეთ ხელახლა.';

  @override
  String get error_age_minor =>
      'Parla ხელმისაწვდომია მხოლოდ 18 წლისა და უფროსი ასაკის პირებისთვის.';

  @override
  String get error_age_needs_confirmation =>
      'უპასუხეთ კითხვას დაბადების დღის შესახებ.';

  @override
  String get error_age_invalid => 'შეიყვანეთ სწორი დაბადების წელი.';

  @override
  String get error_country_closed => 'Parla ამ ქვეყანაში ჯერ არ გახსნილა.';

  @override
  String get error_language_unsupported => 'ეს ენა ჯერ არ არის მხარდაჭერილი.';

  @override
  String get error_profile_exists => 'თქვენი პროფილი უკვე არსებობს.';

  @override
  String get error_consent_outdated_version =>
      'თანხმობის ტექსტი შეიცვალა. გთხოვთ, ხელახლა გადახედოთ.';

  @override
  String get homeGreetingMorning => 'დილა მშვიდობისა!';

  @override
  String get homeGreetingAfternoon => 'გამარჯობა!';

  @override
  String get homeGreetingEvening => 'საღამო მშვიდობისა!';

  @override
  String get homeTagline => 'ყოველდღე ცოტა მეტად შენ.';

  @override
  String get homeProfileButton => 'პროფილი და კონფიდენციალურობა';

  @override
  String get routineSwitchLabel => 'რუტინის არჩევა';

  @override
  String get routineMorning => 'დილა';

  @override
  String get routineEvening => 'საღამო';

  @override
  String get routineMorningTitle => 'დილის რუტინა';

  @override
  String get routineEveningTitle => 'საღამოს რუტინა';

  @override
  String get stepStatusDone => 'შესრულდა';

  @override
  String stepMarkDone(String step) {
    return '$step: შესრულება';
  }

  @override
  String stepMarkUndone(String step) {
    return '$step: შესრულდა, გაუქმება';
  }

  @override
  String routineDoneHeader(String routine) {
    return '$routine მზადაა';
  }

  @override
  String get routineDoneTitle => 'დღესაც გაბრწყინდი.';

  @override
  String get routineDoneBody =>
      'ყველა ნაბიჯი შესრულდა. შევხვდებით შემდეგ რუტინაზე.';

  @override
  String get routineRestart => 'თავიდან დაწყება';

  @override
  String get habitsTitle => 'დღევანდელი ჩვევები';

  @override
  String get habitWater => 'წყალი';

  @override
  String habitWaterCount(int count, int goal) {
    return '$count / $goal ჭიქა';
  }

  @override
  String get habitWaterAdd => 'ერთი ჭიქის დამატება';

  @override
  String get habitWaterRemove => 'ერთი ჭიქის მოკლება';

  @override
  String get habitSleep => 'ძილი';

  @override
  String get habitMove => 'მოძრაობა';

  @override
  String get habitNoEntry => 'ჩანაწერი ჯერ არ არის';

  @override
  String get habitLog => 'ჩაწერა';

  @override
  String get navMenuLabel => 'მთავარი მენიუ';

  @override
  String get navToday => 'დღეს';

  @override
  String get comingSoon => 'ეს განყოფილება შემდეგ ვერსიაში დაემატება.';

  @override
  String get routineMorningEyebrow => 'დილის რუტინა';

  @override
  String get routineEveningEyebrow => 'საღამოს რუტინა';

  @override
  String get routineStatusStart => 'დავიწყოთ';

  @override
  String routineStatusLeft(int left) {
    return 'დარჩა $left ნაბიჯი';
  }

  @override
  String get routineStatusDone => 'ყველაფერი მზადაა';

  @override
  String routineMinutesLeft(int minutes) {
    return 'დაახლოებით $minutes წუთი';
  }

  @override
  String routineProgressLabel(String routine, int done, int total) {
    return '$routine: შესრულდა $done / $total ნაბიჯი';
  }

  @override
  String get quizIntroTitle => 'მოდი, გავიცნოთ ერთმანეთი.';

  @override
  String get quizIntroBody =>
      'რამდენიმე კითხვა თქვენი კანის, თმისა და ყოველდღიური რიტმის შესახებ. დაახლოებით 3 წუთი სჭირდება.';

  @override
  String get quizStart => 'დავიწყოთ';

  @override
  String get quizLater => 'მოგვიანებით';

  @override
  String quizProgress(int current, int total) {
    return 'კითხვა $current / $total';
  }

  @override
  String get quizMultipleHint => 'შეგიძლიათ რამდენიმე აირჩიოთ';

  @override
  String get quizNext => 'შემდეგი';

  @override
  String get quizBack => 'უკან';

  @override
  String get quizDecline => 'არ მსურს პასუხის გაცემა';

  @override
  String get quizFinish => 'დასრულება';

  @override
  String get healthGateTitle => 'რამდენიმე სენსიტიური კითხვა';

  @override
  String get healthGateBody =>
      'შემდეგი კითხვები ეხება კანის დიაგნოზებს, ალერგიას, ორსულობასა და მედიკამენტებს. ისინი რუტინის უსაფრთხოდ შედგენაში გვეხმარება. თქვენი პასუხები დაშიფრულია და ინახება მხოლოდ თქვენი თანხმობით.';

  @override
  String get healthGateAgree => 'ვეთანხმები, გაგრძელება';

  @override
  String get healthGateSkip => 'ამ ნაწილის გამოტოვება';

  @override
  String get healthGateSkipNote =>
      'თუ გამოტოვებთ, რუტინა უფრო ფრთხილად შედგება.';

  @override
  String get redFlagTitle => 'აჩვენეთ ეს ექიმს';

  @override
  String get redFlagBody =>
      'თქვენ მიერ მონიშნული ნიშანი შეიძლება ექიმის გასინჯვას საჭიროებდეს. Parla არ სვამს დიაგნოზს და არ ცვლის ექიმს. გირჩევთ, მიმართოთ დერმატოლოგს.';

  @override
  String get redFlagOk => 'გასაგებია';

  @override
  String get resultTitle => 'თქვენი რუტინა მზადაა';

  @override
  String get resultSkin => 'კანი';

  @override
  String get resultHair => 'თმა';

  @override
  String get resultGoals => 'საზრუნავი';

  @override
  String get resultSeeRoutine => 'ჩემი რუტინის ნახვა';

  @override
  String get recheckTitle => 'ისევ ასეა?';

  @override
  String recheckSkinBody(String answer, int months) {
    return 'ტესტში ორსულობაზე შენი პასუხი: «$answer». ეს $months თვის წინ მონიშნე; რუტინა ამის მიხედვით დგება.';
  }

  @override
  String recheckSportBody(String answer, int months) {
    return 'სპორტის გამოკითხვაში შენი პასუხი: «$answer». ეს $months თვის წინ მონიშნე; ამიტომ გეგმა მსუბუქია.';
  }

  @override
  String get recheckYes => 'დიახ, ასეა';

  @override
  String get recheckChange => 'შეიცვალა';

  @override
  String get recheckRemove => 'პასუხის წაშლა';

  @override
  String get recheckChooseTitle => 'ახლა როგორაა?';

  @override
  String get recheckSaved => 'შენახულია.';

  @override
  String get recheckPrivacy =>
      'პასუხი დაშიფრულად ინახება და მხოლოდ შენი რუტინისა და გეგმისთვის გამოიყენება. თუ პასუხს წაშლი, რუტინა ფრთხილი დარჩება.';

  @override
  String get homeFocusTitle => 'დღის ფოკუსი';

  @override
  String get homeFocusSub => 'შენი რუტინის მიხედვით';

  @override
  String get homeFocusDone =>
      'დღევანდელი რუტინა შესრულებულია. ცოტა დრო საკუთარ თავს დაუთმე.';

  @override
  String get homeFocusOpen => 'რუტინის გახსნა';

  @override
  String homeFocusSteps(int done, int total) {
    return '$done / $total ნაბიჯი';
  }

  @override
  String get homePulse => 'მოკლედ';

  @override
  String get homeLater => 'მეტი';

  @override
  String get homeQuizTitle => 'მოვარგოთ რუტინა თქვენ';

  @override
  String get homeQuizBody => '3-წუთიანი ტესტი — და რუტინა თქვენზე მოერგება.';

  @override
  String get homeQuizStart => 'ტესტის დაწყება';

  @override
  String get error_consent_health_required =>
      'ამ პასუხებისთვის საჭიროა ჯანმრთელობის მონაცემებზე თანხმობა.';

  @override
  String get privacyTitle => 'კონფიდენციალურობის ცენტრი';

  @override
  String get privacyIntro =>
      'შენი მონაცემები, შენი არჩევანი. ყველა უფლება ერთი შეხებით.';

  @override
  String get profileAccountTitle => 'შენი ანგარიში';

  @override
  String get profileAccountNote => 'სახელს არ ვკითხულობთ · მხოლოდ ელფოსტა';

  @override
  String get profileEmailLabel => 'ელფოსტა';

  @override
  String get profileAgeLabel => 'ასაკი';

  @override
  String get profileCountryLabel => 'ქვეყანა';

  @override
  String get profileLanguageLabel => 'ენა';

  @override
  String get privacyConsentsTitle => 'თანხმობები';

  @override
  String get privacyHealthWithdrawTitle =>
      'იხმობთ ჯანმრთელობის მონაცემებზე თანხმობას?';

  @override
  String get privacyHealthWithdrawBody =>
      'თქვენი ჯანმრთელობის პასუხები და საკუთარი რუტინების ასლი სერვერზე დაუყოვნებლივ წაიშლება, რუტინა კი უფრო ფრთხილად შედგება. საკუთარი რუტინები ამ ტელეფონზე რჩება. თანხმობის ხელახლა მიცემა მოგვიანებით შეგიძლიათ.';

  @override
  String get privacyWithdraw => 'გამოხმობა და წაშლა';

  @override
  String get privacyCancel => 'გაუქმება';

  @override
  String get privacyExportTitle => 'ჩემი მონაცემების ჩამოტვირთვა';

  @override
  String get privacyExportBody =>
      'ყველაფერი, რასაც Parla თქვენ შესახებ ინახავს, ასევე ამ ტელეფონზე არსებული ჩვევების ჩანაწერები, საკუთარი რუტინები და დღიური, ერთ ფაილში. ფაილი ახლა იქმნება და ჩვენს სერვერებზე არ ინახება.';

  @override
  String get privacyExportButton => 'ფაილის შექმნა';

  @override
  String get privacyLegalTitle => 'იურიდიული დოკუმენტები';

  @override
  String get privacySignOut => 'გასვლა';

  @override
  String get privacyDeleteTitle => 'ანგარიშის წაშლა';

  @override
  String get deleteTitle => 'წავშალოთ თქვენი ანგარიში?';

  @override
  String get deleteWhatGoes =>
      'დაუყოვნებლივ იშლება: თქვენი პროფილი, ტესტისა და ჯანმრთელობის პასუხები, სერვერზე შენახული საკუთარი რუტინები, საყიდლების სია, სპორტისა და თეფშის ჩანაწერები (დაშიფვრის გასაღებთან ერთად), მხარდაჭერასთან მიმოწერა და შესვლის ანგარიში. ამ ტელეფონზე არსებული ჩვევების ჩანაწერები, დღიური და შენახული რეცეპტებიც იშლება.';

  @override
  String get deleteWhatStays =>
      'თქვენს ელფოსტასა და ანგარიშთან კავშირის გარეშე რჩება: თანხმობების ისტორია (3 წელი) და უსაფრთხოების ჩანაწერები (1 წელი) მტკიცებულებად, ხოლო თქვენი შეკვეთები (ასეთის არსებობის შემთხვევაში) ბუღალტერიისთვის.';

  @override
  String get deleteExportFirst => 'ჯერ ჩემი მონაცემების ჩამოტვირთვა';

  @override
  String deleteConfirmLabel(String word) {
    return 'დასადასტურებლად ჩაწერეთ $word';
  }

  @override
  String get deleteConfirmWord => 'წაშლა';

  @override
  String get deleteButton => 'ჩემი ანგარიშის წაშლა';

  @override
  String get deletedTitle => 'თქვენი ანგარიში წაიშალა';

  @override
  String get deletedBody =>
      'გმადლობთ, რომ ჩვენთან იყავით. ნებისმიერ დროს შეგიძლიათ დაბრუნდეთ.';

  @override
  String get legalTitle => 'იურიდიული დოკუმენტები';

  @override
  String get legalMedicalTitle => 'ეს არ არის სამედიცინო რჩევა';

  @override
  String get legalMedicalBody =>
      'Parla მოვლის გზამკვლევია. ის არ სვამს დიაგნოზს, არ მკურნალობს და არ ცვლის ექიმს. კანის დაავადებების ან შემაშფოთებელი ნიშნების შემთხვევაში მიმართეთ დერმატოლოგს.';

  @override
  String get legalPolicyTitle =>
      'კონფიდენციალურობის პოლიტიკა და გამოყენების პირობები';

  @override
  String get legalPolicyBody =>
      'ეს დოკუმენტები იურისტთან ერთად მზადდება და აქ გაშვებამდე გამოჩნდება.';

  @override
  String get legalPrivacyPolicy => 'კონფიდენციალურობის პოლიტიკა';

  @override
  String get legalTerms => 'გამოყენების პირობები';

  @override
  String get legalConsentsTitle => 'თანხმობის ტექსტები';

  @override
  String get habitEdit => 'შეცვლა';

  @override
  String get habitSleepSheetTitle => 'რამდენი გეძინათ გუშინ ღამით?';

  @override
  String get habitMoveSheetTitle => 'რამდენი იმოძრავეთ დღეს?';

  @override
  String habitSleepHours(String hours) {
    return '$hours სთ';
  }

  @override
  String habitMoveMinutes(int minutes) {
    return '$minutes წთ';
  }

  @override
  String get habitLess => 'შემცირება';

  @override
  String get habitMore => 'გაზრდა';

  @override
  String get habitSave => 'შენახვა';

  @override
  String get habitClearEntry => 'ჩანაწერის წაშლა';

  @override
  String get habitsScreenTitle => 'რუტინა';

  @override
  String get habitsScreenIntro => 'პატარა ნაბიჯები, თქვენი ტემპით.';

  @override
  String get habitsToday => 'დღეს';

  @override
  String get habitsWeekTitle => 'ბოლო 7 დღე';

  @override
  String get habitsWeekCare => 'დღეები, როცა რუტინას დრო დაუთმეთ';

  @override
  String habitsWeekCareValue(int days) {
    return '$days დღე 7-დან';
  }

  @override
  String get habitsWeekNone => 'ჩანაწერი ჯერ არ არის';

  @override
  String habitsWeekWaterValue(String glasses) {
    return 'დღეში საშუალოდ $glasses ჭიქა';
  }

  @override
  String habitsWeekSleepValue(String hours, int nights) {
    return 'საშუალოდ $hours სთ, ჩაწერილია $nights ღამე';
  }

  @override
  String habitsWeekMoveValue(int minutes, int days) {
    return 'სულ $minutes წთ, $days დღე';
  }

  @override
  String get habitsPrivacyNote =>
      'ჩვევების ჩანაწერები მხოლოდ ამ ტელეფონზე ინახება და სერვერზე არ იგზავნება. 90 დღეზე ძველი ჩანაწერები ავტომატურად იშლება.';

  @override
  String get privacyHabitsTitle => 'ჩვევების ჩანაწერები ამ ტელეფონზე';

  @override
  String get privacyHabitsBody =>
      'წყლის, ძილის, მოძრაობისა და რუტინის ჩანაწერები მხოლოდ ამ ტელეფონზე ინახება. მათი წაშლა ნებისმიერ დროს შეგიძლიათ.';

  @override
  String get privacyHabitsDelete => 'ჩანაწერების წაშლა';

  @override
  String get privacyHabitsDeleteTitle => 'წავშალოთ ჩვევების ჩანაწერები?';

  @override
  String get privacyHabitsDeleteBody =>
      'ამ ტელეფონზე წყლის, ძილის, მოძრაობისა და რუტინის ყველა ჩანაწერი წაიშლება. ამის დაბრუნება შეუძლებელია.';

  @override
  String get privacyHabitsDeleted => 'ჩვევების ჩანაწერები წაიშალა.';

  @override
  String get remindersTitle => 'შეხსენებები';

  @override
  String get remindersIntro =>
      'შეტყობინებებს თავად თქვენი ტელეფონი აჩვენებს, სერვერზე არაფერი იგზავნება. გამორთვა ნებისმიერ დროს შეგიძლიათ.';

  @override
  String get remindersOpen => 'მორგება';

  @override
  String get remindersSummaryOff => 'ყველა გამორთულია';

  @override
  String remindersSummaryOn(int count) {
    return 'აქტიური: $count';
  }

  @override
  String get reminderMorningTitle => 'დილის რუტინა';

  @override
  String get reminderEveningTitle => 'საღამოს რუტინა';

  @override
  String get reminderSleepTitle => 'ძილის ჩანაწერი';

  @override
  String get reminderMorningBody => 'დილის რუტინის დროა.';

  @override
  String get reminderEveningBody => 'საღამოს რუტინის დროა.';

  @override
  String get reminderSleepBody => 'გსურთ გასული ღამის ჩაწერა?';

  @override
  String reminderAt(String time) {
    return '$time-ზე';
  }

  @override
  String get reminderChangeTime => 'დროის შეცვლა';

  @override
  String get reminderTimeSheetTitle => 'როდის შეგახსენოთ?';

  @override
  String get reminderPermissionDenied =>
      'შეტყობინებების ნებართვა არ არის მიცემული. მისი ჩართვა ტელეფონის პარამეტრებში შეგიძლიათ.';

  @override
  String get remindersNote =>
      'ტექსტები ნეიტრალურია და დაბლოკილ ეკრანზე ჯანმრთელობის ინფორმაციას არ აჩვენებს. შეტყობინება შეიძლება რამდენიმე წუთით დაგვიანდეს.';

  @override
  String get productsTitle => 'პროდუქტის შემოწმება';

  @override
  String get productsIntro =>
      'ჩაწერეთ პროდუქტის სახელი ან ბრენდი და ნახეთ შემადგენლობა.';

  @override
  String get productsSearchLabel => 'პროდუქტის სახელი ან ბრენდი';

  @override
  String get productsSearchButton => 'ძიება';

  @override
  String get productsQueryTooShort => 'ჩაწერეთ მინიმუმ 2 ასო.';

  @override
  String get productsNotFoundTitle => 'ვერაფერი მოიძებნა';

  @override
  String get productsNotFoundBody =>
      'სცადეთ სხვა მართლწერით ან ბრენდის სახელით. ბაზაში ჯერ ყველა პროდუქტი არ არის.';

  @override
  String get productsSourceObf => 'Open Beauty Facts';

  @override
  String get productsSourceParla => 'Parla-ს კატალოგი';

  @override
  String get error_product_query_invalid => 'ძიება უნდა იყოს 2–80 სიმბოლო.';

  @override
  String get error_product_source_unavailable =>
      'პროდუქტების ბაზა ახლა არ პასუხობს. ცოტა ხანში სცადეთ ხელახლა.';

  @override
  String get productIngredientsTitle => 'შემადგენლობა';

  @override
  String get productNoIngredients =>
      'ამ პროდუქტის შემადგენლობის სია არ გვაქვს. ნახეთ სია შეფუთვაზე.';

  @override
  String productIngredientCount(int count) {
    return '$count ინგრედიენტი';
  }

  @override
  String productListedCount(int count) {
    return '$count ინგრედიენტს აქვს ჩანაწერი ევროკავშირში';
  }

  @override
  String get productStatusesMissing =>
      'ინგრედიენტების სტატუსები ჯერ არ ჩატვირთულა. ახლა მხოლოდ შემადგენლობის სია ჩანს.';

  @override
  String get productDataNotice =>
      'შემადგენლობის სია საზოგადოების ბაზიდან მოდის და შეიძლება შეცდომებს შეიცავდეს. შეადარეთ შეფუთვაზე არსებულ სიას.';

  @override
  String productLegalNotice(String date) {
    return 'სტატუსები ეფუძნება ევროკავშირის №1223/2009 რეგლამენტის დანართებს (CosIng, $date). სახელები ავტომატურად შედარდება. ეს არ არის აზერბაიჯანის წესი და არ არის შეფასება პროდუქტის უსაფრთხოების შესახებ.';
  }

  @override
  String get productAttribution =>
      'პროდუქტის მონაცემები: Open Beauty Facts, ODbL ლიცენზიით.';

  @override
  String get annexIIShort => 'ევროკავშირი: აკრძალული ნივთიერებების სიაშია';

  @override
  String get annexIIIShort => 'ევროკავშირი: დაშვებულია შეზღუდვებით';

  @override
  String get annexIVShort => 'ევროკავშირი: დაშვებული საღებავი';

  @override
  String get annexVShort => 'ევროკავშირი: დაშვებული კონსერვანტი';

  @override
  String get annexVIShort => 'ევროკავშირი: დაშვებული UV ფილტრი';

  @override
  String annexEntry(String annex, String reference) {
    return 'დანართი $annex, რიგი № $reference';
  }

  @override
  String get annexConditionsLabel =>
      'ოფიციალური პირობები (CosIng-დან უცვლელად, ინგლისურად)';

  @override
  String get ingredientNoEntry =>
      'ევროკავშირის დანართებში ცალკე ჩანაწერი ვერ მოიძებნა';

  @override
  String ingredientSheetSource(String date) {
    return 'წყარო: CosIng, $date';
  }

  @override
  String get ingredientDetailsHint => 'დეტალურად';

  @override
  String get navRoutine => 'რუტინა';

  @override
  String get navCheck => 'შემოწმება';

  @override
  String get navSport => 'სპორტი';

  @override
  String get navDiscover => 'აღმოაჩინე';

  @override
  String get navProfile => 'პროფილი';

  @override
  String get sportTitle => 'სპორტი';

  @override
  String get discoverTitle => 'აღმოაჩინე';

  @override
  String get discoverBlogs => 'ბლოგები';

  @override
  String get discoverBlogsHint => 'მოვლა, სილამაზე, მოდა';

  @override
  String get discoverExperts => 'სპეციალისტები';

  @override
  String get discoverExpertsHint => 'დერმატოლოგი, კოსმეტოლოგი';

  @override
  String get discoverNutrition => 'კვება';

  @override
  String get discoverNutritionHint => 'ყოველდღიური თეფში და რეცეპტები';

  @override
  String get discoverShopping => 'საყიდლების სია';

  @override
  String get discoverShoppingHint => 'ჩაინიშნე, რაც გჭირდება';

  @override
  String get discoverShop => 'მაღაზია';

  @override
  String get discoverShopHint => 'პროდუქტები შენი რუტინიდან';

  @override
  String get soonBadge => 'მალე';

  @override
  String get onboardingStepAbout => 'გაცნობა';

  @override
  String get onboardingStepAccount => 'ანგარიში';

  @override
  String get onboardingStepCountry => 'ქვეყანა';

  @override
  String get onboardingStepPrivacy => 'კონფიდენციალურობა';

  @override
  String get routineAreaFace => 'სახე';

  @override
  String get routineAreaHair => 'თმა';

  @override
  String get routineAreaBody => 'სხეული';

  @override
  String get routineSlotMorning => 'დილა';

  @override
  String get routineSlotEvening => 'საღამო';

  @override
  String get routineSlotWeekly => 'კვირაში ერთხელ';

  @override
  String get routineWeeklyHint =>
      'კვირაში ერთხელ. მონიშვნები ორშაბათს განახლდება.';

  @override
  String get routineSlotEmpty => 'ამ დროისთვის ნაბიჯები არ არის.';

  @override
  String get routineOwnButton => 'შენი რუტინა';

  @override
  String get routineOwnSection => 'შენი რუტინები';

  @override
  String get routineOwnEmpty => 'შექმენი საკუთარი რუტინა და აქ ადევნე თვალი.';

  @override
  String get routineOwnEveryDay => 'ყოველდღე';

  @override
  String routineOwnSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ნაბიჯი',
      one: '1 ნაბიჯი',
    );
    return '$_temp0';
  }

  @override
  String routineOwnEdit(String name) {
    return 'შეცვლა: $name';
  }

  @override
  String get routineDayHabits => 'დღის განმავლობაში';

  @override
  String get builderTitleNew => 'შექმენი შენი რუტინა';

  @override
  String get builderTitleEdit => 'რუტინის შეცვლა';

  @override
  String get builderName => 'სახელი';

  @override
  String get builderNameHint => 'მაგ. კვირის სპა';

  @override
  String get builderArea => 'ზონა';

  @override
  String get builderWhen => 'როდის';

  @override
  String get builderEveryDay => 'ყოველდღე';

  @override
  String get builderOnceWeek => 'კვირაში ერთხელ';

  @override
  String get builderSteps => 'ნაბიჯები';

  @override
  String get builderStepHint => 'ახალი ნაბიჯი';

  @override
  String get builderAddStep => 'დამატება';

  @override
  String get builderSuggestions => 'აირჩიე მზა ნაბიჯებიდან';

  @override
  String builderMoveUp(String step) {
    return 'ზემოთ: $step';
  }

  @override
  String builderMoveDown(String step) {
    return 'ქვემოთ: $step';
  }

  @override
  String builderRemoveStep(String step) {
    return 'წაშლა: $step';
  }

  @override
  String get builderSave => 'შენახვა';

  @override
  String get builderDelete => 'რუტინის წაშლა';

  @override
  String get builderDeleteConfirm => 'წავშალოთ ეს რუტინა?';

  @override
  String get builderDeleteYes => 'წაშლა';

  @override
  String get builderCancel => 'გაუქმება';

  @override
  String get builderNeedName => 'დაარქვი რუტინას სახელი.';

  @override
  String get builderNeedStep => 'დაამატე მინიმუმ ერთი ნაბიჯი.';

  @override
  String builderLimit(int count) {
    return 'მაქსიმუმ $count ნაბიჯი.';
  }

  @override
  String get todayRoutinesTitle => 'დღევანდელი რუტინები';

  @override
  String get todayRoutinesAll => 'ყველა';

  @override
  String get todayRoutinesNone => 'დღეისთვის სხვა რუტინა არ არის.';

  @override
  String get builderPrivacySynced =>
      'შენი რუტინები სერვერზე დაშიფრულად ინახება, ამ ტელეფონზე კი ასლი რჩება ოფლაინ გამოსაყენებლად.';

  @override
  String get builderPrivacyDevice =>
      'შენი რუტინები ჯერჯერობით მხოლოდ ამ ტელეფონზე ინახება. ჯანმრთელობის მონაცემებზე განახლებული თანხმობით ისინი სერვერზე დაშიფრულად შეინახება.';

  @override
  String get checkPrefsTitle => 'შენი არჩევანი';

  @override
  String get checkPrefsEdit => 'შეცვლა';

  @override
  String get checkPrefsEmpty =>
      'აირჩიე, რა არის შენთვის მნიშვნელოვანი, და შემადგენლობას შენს არჩევანს შევადარებთ.';

  @override
  String get checkPrefsAdd => 'არჩევანის დამატება';

  @override
  String get checkPrefsSheetTitle => 'რა არის შენთვის მნიშვნელოვანი?';

  @override
  String get checkPrefsSave => 'შენახვა';

  @override
  String get checkBarcodeSoon => 'შტრიხკოდის სკანერი · მალე';

  @override
  String get checkRecentTitle => 'ბოლოს შემოწმებული';

  @override
  String get checkRecentClear => 'გასუფთავება';

  @override
  String get resultPrefsTitle => 'შენი არჩევანის მიხედვით';

  @override
  String resultPrefsSummary(int fits, int count) {
    return 'შენი არჩევანიდან $fits / $count შეესაბამება';
  }

  @override
  String get resultPrefFits => 'შეესაბამება';

  @override
  String resultPrefContains(String names) {
    return 'შემადგენლობაშია: $names';
  }

  @override
  String get resultPrefVeganFits =>
      'ცნობილი ცხოველური წარმოშობის ინგრედიენტი ვერ მოიძებნა';

  @override
  String get resultPrefUnknown =>
      'შემადგენლობის სია არ არის, ამიტომ შემოწმება შეუძლებელია';

  @override
  String get resultPrefsNone =>
      'დაამატე შენი არჩევანი, რომ შემადგენლობა მას შევადაროთ.';

  @override
  String get resultPrefsNote =>
      'Parla პროდუქტებს არ აფასებს და ქულებს არ აძლევს. შესაბამისობა ეფუძნება მხოლოდ შენს არჩევანს და შემადგენლობის სიას.';

  @override
  String get resultAddToList => 'საყიდლების სიაში';

  @override
  String get resultInList => 'სიაშია';

  @override
  String get resultAdded => 'დაემატა საყიდლების სიას.';

  @override
  String shoppingCount(int bought, int total) {
    return 'ნაყიდია $bought / $total';
  }

  @override
  String get shoppingNewHint => 'ახალი პროდუქტი';

  @override
  String get shoppingAdd => 'დამატება';

  @override
  String get shoppingEmpty => 'სია ცარიელია. აქ ჩაინიშნე, რაც გჭირდება.';

  @override
  String get shoppingAreaOther => 'სხვა';

  @override
  String get shoppingFromCheck => 'შემოწმების განყოფილებიდან';

  @override
  String shoppingRemove(String title) {
    return 'წაშლა: $title';
  }

  @override
  String get shoppingRemoveBought => 'ნაყიდის წაშლა';

  @override
  String shoppingFull(int count) {
    return 'სიაში მაქსიმუმ $count პროდუქტი შეიძლება იყოს.';
  }

  @override
  String get careListSynced =>
      'შენი არჩევანი და საყიდლების სია სერვერზე დაშიფრულად ინახება, ამ ტელეფონზე კი ასლი რჩება ოფლაინ გამოსაყენებლად.';

  @override
  String get careListDevice =>
      'შენი არჩევანი და საყიდლების სია ჯერჯერობით მხოლოდ ამ ტელეფონზე ინახება. ჯანმრთელობის მონაცემებზე განახლებული თანხმობით ისინი სერვერზე დაშიფრულად შეინახება.';

  @override
  String get shopTitle => 'Parla მაღაზია';

  @override
  String get shopBody =>
      'შენი რუტინის პროდუქტები ერთი შეხებით. შეძლებ საყიდლების სიის პირდაპირ შეკვეთას და შენს არჩევანზე მორგებული პროდუქტების პოვნას.';

  @override
  String get shopSoonCard => 'Parla მაღაზია';

  @override
  String get shopSoonCardBody => 'ნახე პარტნიორების პროდუქტები';

  @override
  String get shopOpenList => 'ჩემი საყიდლების სია';

  @override
  String get shopIntro =>
      'პარტნიორების პროდუქტები. ყიდვა პარტნიორის საიტზე ხდება; Parla შენ შესახებ არაფერს გადასცემს.';

  @override
  String get shopAll => 'ყველა';

  @override
  String get shopCategoryFace => 'სახე';

  @override
  String get shopCategoryHair => 'თმა';

  @override
  String get shopCategoryBody => 'სხეული';

  @override
  String get shopCategoryMakeup => 'მაკიაჟი';

  @override
  String get shopCategoryOther => 'სხვა';

  @override
  String shopPrice(String price) {
    return '$price ₼';
  }

  @override
  String get shopVisitPartner => 'პარტნიორის საიტზე გადასვლა';

  @override
  String get shopPriceNote =>
      'ფასი და ხელმისაწვდომობა პარტნიორის საიტზე შეიძლება შეიცვალოს. ყიდვამდე შეამოწმე შემადგენლობა; თუ კანის პრობლემა გაქვს, ექიმს გაესაუბრე.';

  @override
  String get shopEmpty => 'პროდუქტები ჯერ არ არის. მალე აქ გამოჩნდება.';

  @override
  String get shopMyOrders => 'ჩემი შეკვეთები';

  @override
  String get shopBuy => 'ყიდვა';

  @override
  String get shopBuyTitle => 'შეკვეთის დადასტურება';

  @override
  String shopBuyBody(String product, String price, String seller) {
    return '$product: $price. $seller გადახდა Epoint-ის გვერდზე ხდება; შენი ბარათის მონაცემები Parla-მდე არ აღწევს.';
  }

  @override
  String get shopSellerParla => 'გამყიდველი: Parla.';

  @override
  String shopSellerBrand(String brand) {
    return 'გამყიდველი: $brand, გადახდას Parla იღებს.';
  }

  @override
  String get shopBuyGo => 'გადახდაზე გადასვლა';

  @override
  String get shopBuyError =>
      'გადახდის გვერდი ვერ გაიხსნა. ცოტა ხანში სცადე ხელახლა.';

  @override
  String get shopTooMany =>
      'ბოლო ერთ საათში ბევრი შეკვეთა დაიწყე. ცოტა ხანში სცადე ხელახლა.';

  @override
  String get shopOrdersEmpty => 'შეკვეთები ჯერ არ გაქვს.';

  @override
  String shopOrderMeta(String number, String date, int quantity) {
    return '$number · $date · $quantity ც.';
  }

  @override
  String get shopOrderCreated => 'გადახდას ელოდება';

  @override
  String get shopOrderPaid => 'გადახდილია';

  @override
  String get shopOrderFailed => 'გადახდა ვერ მოხერხდა';

  @override
  String get shopOrderShipped => 'გაგზავნილია';

  @override
  String get shopOrderDelivered => 'მიტანილია';

  @override
  String get shopOrderCancelled => 'გაუქმებულია';

  @override
  String get shopOrderRefunded => 'თანხა დაბრუნებულია';

  @override
  String get sportIntroTitle => 'შენზე მორგებული სპორტის გეგმა';

  @override
  String get sportIntroBody =>
      'რამდენიმე კითხვა: მიზანი, ზონები, საყვარელი ვარჯიშები. შემდეგ კვირის გეგმა, სეტები და გამეორებები, ტაიმერი. მუსიკა შენი აპიდან ჟღერს.';

  @override
  String get sportStart => 'დაწყება';

  @override
  String get sportNext => 'შემდეგი';

  @override
  String get sportNeedOne => 'აირჩიე მინიმუმ ერთი.';

  @override
  String get sportQGoals => 'რა არის შენი მიზანი?';

  @override
  String get sportQGoalsHint => 'აირჩიე 2-მდე';

  @override
  String get sportGoalTone => 'ტონუსი და სიმკვრივე';

  @override
  String get sportGoalMuscle => 'კუნთის მასის მომატება';

  @override
  String get sportGoalFlexibility => 'მოქნილობა';

  @override
  String get sportGoalPosture => 'სწორი დგომა';

  @override
  String get sportGoalEndurance => 'გამძლეობა';

  @override
  String get sportGoalRelax => 'სტრესისგან განტვირთვა';

  @override
  String get sportQAreas => 'რომელ ზონებზე გავამახვილოთ ყურადღება?';

  @override
  String get sportAreasNote =>
      'ცხიმის ერთი ზონიდან დაწვა შეუძლებელია. ეს მოძრაობები ამ კუნთებს აძლიერებს და ტონუსს აძლევს.';

  @override
  String get sportAreaArms => 'ხელები';

  @override
  String get sportAreaLegs => 'ფეხები';

  @override
  String get sportAreaCore => 'მუცელი და კორი';

  @override
  String get sportAreaGlutes => 'დუნდულები';

  @override
  String get sportAreaBack => 'ზურგი';

  @override
  String get sportAreaFull => 'მთელი სხეული';

  @override
  String get sportQTypes => 'როგორი ვარჯიში გინდა?';

  @override
  String get sportTypeFitness => 'ფიტნესი';

  @override
  String get sportTypePilates => 'პილატესი';

  @override
  String get sportTypeWallPilates => 'კედლის პილატესი';

  @override
  String get sportTypeStretching => 'სტრეჩინგი';

  @override
  String get sportTypeCardio => 'მსუბუქი კარდიო';

  @override
  String get sportTypeFaceYoga => 'სახის იოგა';

  @override
  String get sportTypeYoga => 'იოგა';

  @override
  String get sportYogaMorning => 'დილის ნაკადი';

  @override
  String get sportYogaEvening => 'საღამოს სიმშვიდე';

  @override
  String get sportYogaStretch => 'გაჭიმვა და მოდუნება';

  @override
  String sportSessionCardBody(int count, int minutes) {
    return '$count მოძრაობა · დაახლ. $minutes წთ';
  }

  @override
  String get sportYogaSafetyTitle => 'დაწყებამდე';

  @override
  String get sportYogaSafetyBody =>
      'იმოძრავე ნელა, სუნთქვა არ შეიკავო, ტკივილის შემთხვევაში შეჩერდი. ორსულობის, მაღალი არტერიული წნევის, წელის, მუხლის ან მაჯის ტრავმის დროს ჯერ ექიმს მიმართე. თუ გამოკითხვაში ტრავმა ან ორსულობა მონიშნე, შენთვის შეუფერებელი პოზები სეანსიდან ამოღებულია.';

  @override
  String sportFaceYogaCardBody(int minutes) {
    return '12 მოძრაობა · დაახლ. $minutes წთ. სარკის წინ, ნებისმიერ დროს.';
  }

  @override
  String get sportFaceYogaSafetyTitle => 'დაწყებამდე';

  @override
  String get sportFaceYogaSafetyBody =>
      'დაიბანეთ ხელები, კანს მხოლოდ მსუბუქად შეეხეთ, ნუ გაჭიმავთ. ტკივილის ან დისკომფორტის შემთხვევაში შეწყვიტეთ. თუ ახლახან კოსმეტიკური პროცედურა (ბოტოქსი, ფილერი) გაიკეთეთ, ან ყბის სახსრის ან კანის პრობლემა გაქვთ, ჯერ ექიმს მიმართეთ.';

  @override
  String get sportQLevel => 'როგორია შენი დონე?';

  @override
  String get sportLevelBeginner => 'ახლა ვიწყებ';

  @override
  String get sportLevelIntermediate => 'საშუალო';

  @override
  String get sportLevelAdvanced => 'გამოცდილი';

  @override
  String get sportQSchedule => 'რამდენი დრო გაქვს?';

  @override
  String get sportDaysLabel => 'კვირაში რამდენი დღე';

  @override
  String get sportMinutesLabel => 'ერთი ვარჯიში';

  @override
  String sportDays(int count) {
    return '$count დღე';
  }

  @override
  String sportMinutes(int count) {
    return '$count წთ';
  }

  @override
  String get sportDumbbells => 'სახლში ჰანტელები მაქვს';

  @override
  String get sportQSafety => 'უსაფრთხოებისთვის';

  @override
  String get sportSafetyIntro =>
      'ეს პასუხები მხოლოდ იმისთვისაა, რომ შენთვის შეუფერებელი მოძრაობები გეგმიდან ამოვიღოთ.';

  @override
  String get sportPregnancyLabel => 'ორსულობა';

  @override
  String get sportPregNo => 'არა';

  @override
  String get sportPregPregnant => 'ორსულად ვარ';

  @override
  String get sportPregPostpartum => 'ბოლო 6 თვეში ვიმშობიარე';

  @override
  String get sportInjuriesLabel => 'ტკივილი ან ტრავმა';

  @override
  String get sportInjKnee => 'მუხლი';

  @override
  String get sportInjBack => 'წელი';

  @override
  String get sportInjShoulder => 'მხარი';

  @override
  String get sportInjWrist => 'მაჯა';

  @override
  String get sportDoctorLimit =>
      'ექიმმა სპორტი შემიზღუდა ან ჯერ მასთან კონსულტაცია მირჩია';

  @override
  String get sportBuildPlan => 'გეგმის შედგენა';

  @override
  String get sportWeekTitle => 'ეს კვირა';

  @override
  String sportWeekProgress(int done, int total) {
    return '$done / $total ვარჯიში';
  }

  @override
  String sportWorkoutTitle(int number) {
    return 'ვარჯიში $number';
  }

  @override
  String get sportWorkoutName_w6 => 'მსუბუქი გაჭიმვა';

  @override
  String get sportWorkoutName_w7 => 'კვირის ფინალი';

  @override
  String get sportWorkoutName_p6 => 'რბილი ნაკადი';

  @override
  String get sportWorkoutName_p7 => 'ცენტრის ფინალი';

  @override
  String get sportWorkoutName_v6 => 'მოდუნება კედელთან';

  @override
  String get sportWorkoutName_v7 => 'კედლის ფინალი';

  @override
  String get sportEveryDay => 'ყოველდღე';

  @override
  String get sportWeekdaysLabel => 'რომელ დღეებში?';

  @override
  String sportWeekdaysHint(int count) {
    return 'აირჩიე $count დღე. შუალედური დღეები დასვენებისთვისაა.';
  }

  @override
  String get sportEveryDayNote =>
      'ყოველდღე: კვირაში ორ დღეს მსუბუქი გაჭიმვაა, რომ კუნთები აღდგეს.';

  @override
  String sportWeekday(String day) {
    String _temp0 = intl.Intl.selectLogic(
      day,
      {
        '1': 'ორშ',
        '2': 'სამ',
        '3': 'ოთხ',
        '4': 'ხუთ',
        '5': 'პარ',
        '6': 'შაბ',
        'other': 'კვ',
      },
    );
    return '$_temp0';
  }

  @override
  String sportPickWeekdays(int count) {
    return 'აირჩიე ზუსტად $count დღე.';
  }

  @override
  String get sportMonthTitle => 'თვის გეგმა';

  @override
  String sportMonthProgress(int day, int week) {
    return 'დღე $day / 28 · კვირა $week';
  }

  @override
  String get sportLegendDone => 'შესრულდა';

  @override
  String get sportLegendWorkout => 'ვარჯიში';

  @override
  String get sportLegendRest => 'დასვენება';

  @override
  String get sportToday => 'დღეს';

  @override
  String get sportRestToday => 'დღეს დასვენების დღეა';

  @override
  String sportNextOn(String when) {
    return 'შემდეგი ვარჯიში: $when';
  }

  @override
  String sportWeekBadge(int week) {
    return 'კვირა $week';
  }

  @override
  String get sportRecoveryWeek => 'აღდგენის კვირა';

  @override
  String sportCardMeta(int minutes, int moves) {
    return '$minutes წთ · $moves მოძრაობა';
  }

  @override
  String get sportMonthDoneTitle => 'თვე დასრულდა';

  @override
  String sportMonthDoneBody(int done) {
    return 'შესრულდა $done ვარჯიში. შემდეგ თვემდე გადავხედოთ შენს პასუხებსა და დონეს.';
  }

  @override
  String get sportNewMonth => 'შემდეგი თვე';

  @override
  String sportMonthCalendar(int done, int left) {
    return 'თვის კალენდარი: შესრულდა $done ვარჯიში, დარჩა $left';
  }

  @override
  String get sportWorkoutName_w1 => 'ძლიერი სტარტი';

  @override
  String get sportWorkoutName_w2 => 'ფეხების დღე';

  @override
  String get sportWorkoutName_w3 => 'მთელი სხეული';

  @override
  String get sportWorkoutName_w4 => 'ენერგიის ტალღა';

  @override
  String get sportWorkoutName_w5 => 'ძალა და ბალანსი';

  @override
  String get sportWorkoutName_p1 => 'ცენტრის გაღვიძება';

  @override
  String get sportWorkoutName_p2 => 'რბილი ნაკადი';

  @override
  String get sportWorkoutName_p3 => 'დგომა და სუნთქვა';

  @override
  String get sportWorkoutName_p4 => 'გრძელი ხაზები';

  @override
  String get sportWorkoutName_p5 => 'მშვიდი ძალა';

  @override
  String get sportWorkoutName_v1 => 'კედლის გაცნობა';

  @override
  String get sportWorkoutName_v2 => 'კედლის საყრდენი';

  @override
  String get sportWorkoutName_v3 => 'ნაკადი კედელთან';

  @override
  String get sportWorkoutName_v4 => 'კედლის რიტმი';

  @override
  String get sportWorkoutName_v5 => 'კედლის ბალანსი';

  @override
  String sportWorkoutMeta(String type, int minutes) {
    return '$type · ~$minutes წთ';
  }

  @override
  String get sportDone => 'შესრულდა';

  @override
  String get sportNextLabel => 'შემდეგი';

  @override
  String get sportEditAnswers => 'გამოკითხვის განახლება';

  @override
  String get sportBlockedTitle => 'ჯერ ექიმს გაესაუბრე';

  @override
  String get sportBlockedBody =>
      'თუ ექიმმა სპორტი შეგიზღუდა, გეგმას არ ვადგენთ. ნებართვის მიღების შემდეგ განაახლე გამოკითხვა.';

  @override
  String get sportGentleNote =>
      'მსუბუქი გეგმა ორსულობისა და მშობიარობის შემდგომი პერიოდისთვის. დაწყებამდე ჰკითხე ექიმს.';

  @override
  String get sportDraftNote =>
      'მოძრაობები და რაოდენობები ჯერ მწვრთნელს არ შეუმოწმებია. თუ ტკივილს იგრძნობ, შეჩერდი.';

  @override
  String get sportAllDone => 'ამ კვირის ყველა ვარჯიში შესრულდა.';

  @override
  String sportSetsReps(int sets, int reps) {
    return '$sets × $reps გამეორება';
  }

  @override
  String sportSetsSeconds(int sets, int seconds) {
    return '$sets × $seconds წმ';
  }

  @override
  String sportRestSeconds(int seconds) {
    return 'დასვენება $seconds წმ';
  }

  @override
  String get sportStartWorkout => 'ვარჯიშის დაწყება';

  @override
  String get sportMusicNote =>
      'ვიდეოებს თავისი მუსიკა აქვს, ღილაკით შეგიძლია გამორთო. Parla სიგნალსაც იძლევა.';

  @override
  String get sportVideoSoundOn => 'ვიდეოს ხმა ჩართულია';

  @override
  String get sportVideoSoundOff => 'ვიდეოს ხმა გამორთულია';

  @override
  String get sportSoundOn => 'სიგნალის ხმა ჩართულია';

  @override
  String get sportSoundOff => 'სიგნალის ხმა გამორთულია, მხოლოდ ვიბრაცია';

  @override
  String sportSetOf(int set, int sets) {
    return 'სეტი $set / $sets';
  }

  @override
  String sportRepsNow(int reps) {
    return '$reps გამეორება';
  }

  @override
  String get sportPause => 'პაუზა';

  @override
  String get sportResume => 'გაგრძელება';

  @override
  String get sportResting => 'დასვენება';

  @override
  String sportNextUp(String name) {
    return 'შემდეგი: $name';
  }

  @override
  String sportExerciseOf(int index, int total) {
    return 'მოძრაობა $index / $total';
  }

  @override
  String get sportFinishedTitle => 'ვარჯიში დასრულდა';

  @override
  String sportFinishedBody(int minutes) {
    return '$minutes წუთი მოძრაობა დაემატა დღევანდელ ჩანაწერს.';
  }

  @override
  String get sportBackToPlan => 'გეგმაზე დაბრუნება';

  @override
  String get sportQuit => 'ვარჯიშის შეწყვეტა';

  @override
  String get sportGetReady => 'მოემზადე';

  @override
  String get sportPrevious => 'წინა მოძრაობა';

  @override
  String get sportNextMove => 'შემდეგი';

  @override
  String get sportStopTitle => 'შევწყვიტოთ ვარჯიში?';

  @override
  String get sportStopBody => 'ეს ვარჯიში შესრულებულად არ ჩაითვლება.';

  @override
  String get sportStopConfirm => 'შეწყვეტა';

  @override
  String get sportKeepGoing => 'გაგრძელება';

  @override
  String sportRepPace(int seconds) {
    return 'თითო გამეორება დაახლოებით $seconds წმ. თუ ადრე დაასრულებ, დააჭირე „შემდეგი“-ს.';
  }

  @override
  String get sportPrivacySynced =>
      'შენი სპორტის პასუხები სერვერზე დაშიფრულად ინახება, ამ ტელეფონზე კი ასლი რჩება ოფლაინ გამოსაყენებლად.';

  @override
  String get sportPrivacyDevice =>
      'შენი სპორტის პასუხები ჯერჯერობით მხოლოდ ამ ტელეფონზე ინახება. ჯანმრთელობის მონაცემებზე განახლებული თანხმობით ისინი სერვერზე დაშიფრულად შეინახება.';

  @override
  String get discoverLatest => 'ახალი სტატიები';

  @override
  String get discoverAll => 'ყველა';

  @override
  String get expertSample => 'ნიმუში';

  @override
  String get expertSampleNote =>
      'ეს ნიმუშის პროფილია, საკონტაქტო მონაცემები არ მუშაობს.';

  @override
  String get discoverJournal => 'დღიური';

  @override
  String get discoverJournalHint => 'მხოლოდ შენთვის, ამ ტელეფონზე';

  @override
  String get journalIntro =>
      'დაწერე შენი დღის შესახებ. ჩანაწერები მხოლოდ ამ ტელეფონზე, დაშიფრულად ინახება; Parla-ს გუნდი მათ ვერ ხედავს. ტელეფონის გამოცვლისას ან აპის წაშლისას ისინი იკარგება. შესანახად: პროფილი → ჩემი მონაცემების ჩამოტვირთვა.';

  @override
  String get journalNew => 'ახალი ჩანაწერი';

  @override
  String get journalEmpty => 'ჩანაწერები ჯერ არ არის.';

  @override
  String get journalHint => 'როგორ ჩაიარა დღემ?';

  @override
  String get journalEntryTitle => 'ჩანაწერი';

  @override
  String get journalSave => 'შენახვა';

  @override
  String get journalDelete => 'წაშლა';

  @override
  String get journalDeleteTitle => 'წავშალოთ ეს ჩანაწერი?';

  @override
  String get journalDeleteBody => 'მისი დაბრუნება შეუძლებელი იქნება.';

  @override
  String get journalFull =>
      'დღიური სავსეა. ახალი ჩანაწერისთვის წაშალე ერთ-ერთი ძველი.';

  @override
  String get discoverSportHint => 'შენი კვირის გეგმა';

  @override
  String discoverArticleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count სტატია',
    );
    return '$_temp0';
  }

  @override
  String discoverRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count რეცეპტი',
    );
    return '$_temp0';
  }

  @override
  String get contentEmpty => 'სტატიები ჯერ არ არის. მალე აქ გამოჩნდება.';

  @override
  String get contentOffline =>
      'ინტერნეტი არ არის, ნაჩვენებია ბოლოს ჩატვირთული ვერსია.';

  @override
  String blogMeta(String category, int minutes) {
    return '$category · $minutes წთ';
  }

  @override
  String blogReviewed(String date) {
    return 'შეამოწმა სპეციალისტმა · $date';
  }

  @override
  String get blogTips => 'მოკლე ნაბიჯები';

  @override
  String get catCare => 'მოვლა';

  @override
  String get catBeauty => 'სილამაზე';

  @override
  String get catFashion => 'მოდა';

  @override
  String get catHair => 'თმა';

  @override
  String get specDermatologist => 'დერმატოლოგი';

  @override
  String get specCosmetologist => 'კოსმეტოლოგი';

  @override
  String get specTrainer => 'მწვრთნელი';

  @override
  String get specDietitian => 'დიეტოლოგი';

  @override
  String get specTrichologist => 'ტრიქოლოგი';

  @override
  String expertYears(int years) {
    return '$years წლის გამოცდილება';
  }

  @override
  String get expertCall => 'დარეკვა';

  @override
  String get expertWhatsapp => 'WhatsApp';

  @override
  String get expertInstagram => 'Instagram';

  @override
  String get expertsNote =>
      'Parla მხოლოდ გაცნობს სპეციალისტებს და მათ მომსახურებაზე პასუხს არ აგებს. კონტაქტი აპის გარეთ, პირდაპირ სპეციალისტთან მყარდება; Parla საუბარს ვერ ხედავს.';

  @override
  String get nutritionHero => 'სილამაზე თეფშიდან იწყება';

  @override
  String get nutritionPlate => 'დღევანდელი თეფში';

  @override
  String nutritionPlateCount(int count, int total) {
    return '$count / $total ჯგუფი';
  }

  @override
  String get groupVegetables => 'ბოსტნეული';

  @override
  String get groupFruit => 'ხილი';

  @override
  String get groupProtein => 'ცილა';

  @override
  String get groupWholeGrain => 'მთლიანი მარცვალი';

  @override
  String get groupHealthyFat => 'ჯანსაღი ცხიმი';

  @override
  String get groupDairy => 'რძის ნაწარმი';

  @override
  String nutritionWater(int count, int goal) {
    return 'წყალი: $count / $goal ჭიქა';
  }

  @override
  String get nutritionNoCalories =>
      'თეფშზე კალორიებს არ ვითვლით. უბრალოდ მრავალფეროვნება: ყოველდღე ფერადი თეფში.';

  @override
  String get nutritionTip => 'დღის რჩევა';

  @override
  String get nutritionRecipes => 'სილამაზის რეცეპტები';

  @override
  String get nutritionDisclaimer =>
      'ეს ზოგადი ინფორმაციაა და არა დიეტური ან სამედიცინო რეკომენდაცია. თუ კვების განსაკუთრებული საჭიროება გაქვს, დიეტოლოგს გაესაუბრე.';

  @override
  String get nutritionPrivacySynced =>
      'შენი თეფშის ჩანაწერები სერვერზე დაშიფრულად ინახება, ამ ტელეფონზე კი ასლი რჩება ოფლაინ გამოსაყენებლად.';

  @override
  String get nutritionPrivacyDevice =>
      'შენი თეფშის ჩანაწერები ჯერჯერობით მხოლოდ ამ ტელეფონზე ინახება. ჯანმრთელობის მონაცემებზე განახლებული თანხმობით ისინი სერვერზე დაშიფრულად შეინახება.';

  @override
  String get mealBreakfast => 'საუზმე';

  @override
  String get mealLunch => 'სადილი';

  @override
  String get mealDinner => 'ვახშამი';

  @override
  String get mealSnack => 'წასახემსებელი';

  @override
  String recipeMeta(String meal, int minutes, int servings) {
    return '$meal · $minutes წთ · $servings პორცია';
  }

  @override
  String get recipeIngredients => 'ინგრედიენტები';

  @override
  String get recipeSteps => 'მომზადება';

  @override
  String get recipeAddAll => 'ინგრედიენტების დამატება საყიდლების სიაში';

  @override
  String get recipeSave => 'რეცეპტის შენახვა';

  @override
  String get recipeUnsave => 'შენახულებიდან ამოღება';

  @override
  String get nutritionDailyRecipe => 'დღის რეკომენდაცია';

  @override
  String get nutritionPlateIdeas => 'შეავსე შენი თეფში';

  @override
  String get nutritionPlateIdeasNote =>
      'რეცეპტები ჯგუფებისთვის, რომლებიც დღეს ჯერ არ აგირჩევია.';

  @override
  String get nutritionSaved => 'შენახული';

  @override
  String recipeKcal(int kcal) {
    return '≈ $kcal კკალ · 1 პორცია (დაახლოებით)';
  }

  @override
  String recipeAdded(int count) {
    return 'საყიდლების სიაში დაემატა $count პროდუქტი.';
  }

  @override
  String get skinCardTitle => 'კანის ანალიზი';

  @override
  String get skinCardBody =>
      'უპასუხე კითხვებს და ხელახლა გააანალიზე შენი კანი.';

  @override
  String get catBody => 'სხეული';

  @override
  String get blogSources => 'წყაროები';

  @override
  String get blogRelated => 'მსგავსი სტატიები';

  @override
  String recipeAllergens(String list) {
    return 'შეიცავს: $list';
  }

  @override
  String get recipeNoAllergens => '14 ძირითადი ალერგენიდან არცერთს არ შეიცავს.';

  @override
  String get allergenGluten => 'გლუტენი';

  @override
  String get allergenCrustaceans => 'კიბოსნაირები';

  @override
  String get allergenEgg => 'კვერცხი';

  @override
  String get allergenFish => 'თევზი';

  @override
  String get allergenPeanuts => 'მიწის თხილი';

  @override
  String get allergenSoy => 'სოიო';

  @override
  String get allergenMilk => 'რძე';

  @override
  String get allergenNuts => 'კაკალი და თხილი';

  @override
  String get allergenCelery => 'ნიახური';

  @override
  String get allergenMustard => 'მდოგვი';

  @override
  String get allergenSesame => 'სეზამი';

  @override
  String get allergenSulphites => 'სულფიტები';

  @override
  String get allergenLupin => 'ლუპინი';

  @override
  String get allergenMolluscs => 'მოლუსკები';

  @override
  String bannerAd(String brand) {
    return 'რეკლამა · $brand';
  }

  @override
  String get bannerLeaveTitle => 'სხვა საიტზე გადადიხარ';

  @override
  String bannerLeaveBody(String host) {
    return 'საიტი $host ბრაუზერში გაიხსნება. Parla ამ საიტს შენ შესახებ არანაირ მონაცემს არ უგზავნის; საიტს საკუთარი კონფიდენციალურობის წესები აქვს.';
  }

  @override
  String get bannerLeaveGo => 'საიტზე გადასვლა';

  @override
  String get bannerLeaveCancel => 'გაუქმება';

  @override
  String get messagesTitle => 'შეტყობინებები';

  @override
  String get messagesButton => 'შეტყობინებები';

  @override
  String get messagesButtonUnread => 'შეტყობინებები, არის ახალი პასუხი';

  @override
  String get messagesFromParla => 'Parla-სგან';

  @override
  String get messagesNone => 'განცხადებები ჯერ არ არის.';

  @override
  String get supportTitle => 'მხარდაჭერა';

  @override
  String get supportIntro =>
      'დაწერე შენი კითხვა და Parla-ს გუნდი გიპასუხებს. შეტყობინებები დაშიფრულად ინახება და ბოლო შეტყობინებიდან 12 თვის შემდეგ იშლება. სამედიცინო რჩევებს არ ვიძლევით: სასწრაფო ან სერიოზული შემთხვევისას მიმართე ექიმს.';

  @override
  String get supportHint => 'შენი შეტყობინება';

  @override
  String get supportSend => 'გაგზავნა';

  @override
  String get supportYou => 'შენ';

  @override
  String get supportTeam => 'Parla-ს გუნდი';

  @override
  String get supportSent => 'გაიგზავნა.';

  @override
  String get pushTitle => 'შეტყობინებები';

  @override
  String get pushBody =>
      'გაიგებ, როცა მხარდაჭერა გიპასუხებს. თუ მარკეტინგზე თანხმობას მისცემ, Parla-ს სიახლეებიც მოგივა. გამორთვა ნებისმიერ დროს შეგიძლია.';

  @override
  String get pushDenied =>
      'შეტყობინებების ნებართვა არ მიცემულა. ჩართვა ტელეფონის პარამეტრებიდან შეგიძლია.';

  @override
  String get checkSuggestTitle => 'შემოთავაზება შენი ტესტის მიხედვით';

  @override
  String get checkSuggestBody =>
      'შენი ტესტის პასუხების მიხედვით ეს არჩევანი შეიძლება შენთვის შესაფერისი იყოს. დაამატებ თუ არა, შენი გადასაწყვეტია.';

  @override
  String checkSuggestAdd(String name) {
    return '$name: დამატება';
  }

  @override
  String get consentRefreshCardTitle => 'თანხმობის ტექსტი განახლდა';

  @override
  String get consentRefreshCardBody =>
      'ჯანმრთელობის მონაცემებზე თანხმობის ახალი ვერსია გამოვიდა. თუ წაიკითხავ და დაეთანხმები, შენი რუტინები, სიები, სპორტისა და კვების ჩანაწერები დაშიფრულ სერვერზეც შეინახება. თუ არ დაეთანხმები, ისინი მხოლოდ ამ ტელეფონზე დარჩება.';

  @override
  String get consentRefreshOpen => 'წაკითხვა';

  @override
  String get consentRefreshTitle => 'თანხმობა ჯანმრთელობის მონაცემებზე';

  @override
  String get consentRefreshIntro =>
      'ეს იმ ტექსტის ახალი ვერსიაა, რომელსაც ადრე დაეთანხმე. თანხმობა ნებაყოფლობითია; მისი გამოხმობა ნებისმიერ დროს შეგიძლია კონფიდენციალურობის განყოფილებაში.';

  @override
  String get consentRefreshAgree => 'ვეთანხმები';

  @override
  String get consentRefreshLater => 'ახლა არა';

  @override
  String get consentRefreshDone => 'თანხმობა განახლდა.';

  @override
  String get appearanceTitle => 'იერსახე';

  @override
  String get appearanceSystem => 'სისტემური';

  @override
  String get appearanceLight => 'ღია';

  @override
  String get appearanceDark => 'მუქი';
}
