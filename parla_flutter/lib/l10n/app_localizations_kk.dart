// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get appTitle => 'Parla';

  @override
  String get languageTitle => 'Тілді таңдаңыз';

  @override
  String get languageName_az => 'Azərbaycanca';

  @override
  String get languageName_ru => 'Русский';

  @override
  String get languageName_en => 'English';

  @override
  String get continueButton => 'Жалғастыру';

  @override
  String get welcomeTitle => 'Жеке күтім нұсқаулығыңыз';

  @override
  String get welcomeBody1 =>
      'Теріңізге, шашыңызға және денеңізге арналған, сарапшылар тексерген күтім.';

  @override
  String get welcomeBody2 =>
      'Өнімді сканерлеп, әр құрамдастың не істейтінін ресми дереккөздерден көріңіз.';

  @override
  String get welcomeBody3 => 'Ұйқы, су және қозғалыс: шағын әдеттер бір жерде.';

  @override
  String get welcomeStart => 'Бастау';

  @override
  String get welcomeBrowse => 'Аккаунтсыз қарау';

  @override
  String get welcomeSignIn => 'Менде аккаунт бар';

  @override
  String get ageTitle => 'Қай жылы тудыңыз?';

  @override
  String get ageWhy =>
      'Parla 18 жас және одан үлкен адамдарға арналған. Біз толық күнді емес, тек жылды сақтаймыз.';

  @override
  String get ageYearLabel => 'Туған жыл';

  @override
  String get ageInvalid =>
      '1900 жыл мен биылғы жыл аралығындағы жылды енгізіңіз.';

  @override
  String get ageBirthdayQuestion => 'Биыл туған күніңіз өтіп кетті ме?';

  @override
  String get yes => 'Иә';

  @override
  String get no => 'Жоқ';

  @override
  String get underageTitle => 'Parla ересектерге арналған';

  @override
  String get underageBody =>
      'Parla тек 18 жас және одан үлкен адамдарға қолжетімді. Сіз енгізген ешбір дерек сақталған жоқ.';

  @override
  String get close => 'Жабу';

  @override
  String get signInTitle => 'Кіріңіз немесе аккаунт ашыңыз';

  @override
  String get signInBody =>
      'Поштаңызға бір реттік код жібереміз. Құпиясөз қажет емес.';

  @override
  String get signInFailed => 'Кіру сәтсіз аяқталды. Қайталап көріңіз.';

  @override
  String get signInLegalNote =>
      'Аккаунт ашу арқылы Пайдалану шарттарын қабылдайсыз. Деректеріңіздің қалай өңделетіні Құпиялық саясатында сипатталған.';

  @override
  String get countryTitle => 'Қай елде тұрасыз?';

  @override
  String get countryWhy =>
      'Деректеріңіз еліңіздің өңірінде сақталады. Parla алдымен Әзербайжанда ашылады.';

  @override
  String get countryComingSoon => 'Жақында';

  @override
  String get countryName_AZ => 'Әзербайжан';

  @override
  String get countryName_TR => 'Түркия';

  @override
  String get countryName_KZ => 'Қазақстан';

  @override
  String get countryName_UZ => 'Өзбекстан';

  @override
  String get consentTitle => 'Таңдауларыңыз';

  @override
  String get consentIntro =>
      'Әр келісім бөлек және әдепкі бойынша өшірулі. Қолданба оларсыз да жұмыс істейді. Оларды кез келген уақытта Баптаулар → Құпиялық бөлімінде өзгерте аласыз.';

  @override
  String get consentHealthTitle => 'Денсаулыққа қатысты жауаптар';

  @override
  String get consentHealthHint =>
      'Тек тері жағдайлары, аллергия, жүктілік және дәрілер туралы ерікті сұрақтар үшін қажет.';

  @override
  String get consentAnalyticsTitle => 'Пайдалану статистикасы';

  @override
  String get consentMarketingTitle => 'Поштаға жаңалықтар мен кеңестер';

  @override
  String consentVersion(String version) {
    return 'Мәтін нұсқасы: $version';
  }

  @override
  String get guestTitle => 'Өнім іздеу';

  @override
  String get guestPlaceholder =>
      'Өнімді іздеу және сканерлеу келесі нұсқада қосылады.';

  @override
  String get errorGeneric => 'Қате орын алды. Қайталап көріңіз.';

  @override
  String get error_age_minor =>
      'Parla тек 18 жас және одан үлкен адамдарға қолжетімді.';

  @override
  String get error_age_needs_confirmation =>
      'Туған күн туралы сұраққа жауап беріңіз.';

  @override
  String get error_age_invalid => 'Дұрыс туған жылды енгізіңіз.';

  @override
  String get error_country_closed => 'Parla бұл елде әлі ашылған жоқ.';

  @override
  String get error_language_unsupported =>
      'Бұл тілге әлі қолдау көрсетілмейді.';

  @override
  String get error_profile_exists => 'Профиліңіз бұрыннан бар.';

  @override
  String get error_consent_outdated_version =>
      'Келісім мәтіні өзгерді. Қайта қарап шығыңызшы.';

  @override
  String get homeGreetingMorning => 'Қайырлы таң!';

  @override
  String get homeGreetingAfternoon => 'Қайырлы күн!';

  @override
  String get homeGreetingEvening => 'Қайырлы кеш!';

  @override
  String get homeTagline => 'Күн сайын өзіңе сәл жақынырақ.';

  @override
  String get homeProfileButton => 'Профиль және құпиялық';

  @override
  String get routineSwitchLabel => 'Күтімді таңдау';

  @override
  String get routineMorning => 'Таң';

  @override
  String get routineEvening => 'Кеш';

  @override
  String get routineMorningTitle => 'Таңғы күтім';

  @override
  String get routineEveningTitle => 'Кешкі күтім';

  @override
  String get stepStatusDone => 'Дайын';

  @override
  String stepMarkDone(String step) {
    return '$step: аяқтау';
  }

  @override
  String stepMarkUndone(String step) {
    return '$step: орындалды, қайтару';
  }

  @override
  String routineDoneHeader(String routine) {
    return '$routine дайын';
  }

  @override
  String get routineDoneTitle => 'Бүгін де жарқырадың.';

  @override
  String get routineDoneBody =>
      'Барлық қадам орындалды. Келесі күтімде кездесеміз.';

  @override
  String get routineRestart => 'Қайта бастау';

  @override
  String get habitsTitle => 'Бүгінгі әдеттер';

  @override
  String get habitWater => 'Су';

  @override
  String habitWaterCount(int count, int goal) {
    return '$count / $goal стақан';
  }

  @override
  String get habitWaterAdd => 'Бір стақан қосу';

  @override
  String get habitWaterRemove => 'Бір стақан азайту';

  @override
  String get habitSleep => 'Ұйқы';

  @override
  String get habitMove => 'Қозғалыс';

  @override
  String get habitNoEntry => 'Әзірге жазба жоқ';

  @override
  String get habitLog => 'Жазу';

  @override
  String get navMenuLabel => 'Негізгі мәзір';

  @override
  String get navToday => 'Бүгін';

  @override
  String get comingSoon => 'Бұл бөлім келесі нұсқада қосылады.';

  @override
  String get routineMorningEyebrow => 'ТАҢҒЫ КҮТІМ';

  @override
  String get routineEveningEyebrow => 'КЕШКІ КҮТІМ';

  @override
  String get routineStatusStart => 'Бастайық';

  @override
  String routineStatusLeft(int left) {
    return '$left қадам қалды';
  }

  @override
  String get routineStatusDone => 'Бәрі дайын';

  @override
  String routineMinutesLeft(int minutes) {
    return 'Шамамен $minutes минут';
  }

  @override
  String routineProgressLabel(String routine, int done, int total) {
    return '$routine: $done / $total қадам орындалды';
  }

  @override
  String get quizIntroTitle => 'Танысайық.';

  @override
  String get quizIntroBody =>
      'Теріңіз, шашыңыз және күнделікті ырғағыңыз туралы бірнеше сұрақ. Шамамен 3 минут алады.';

  @override
  String get quizStart => 'Бастайық';

  @override
  String get quizLater => 'Кейін';

  @override
  String quizProgress(int current, int total) {
    return 'Сұрақ $current / $total';
  }

  @override
  String get quizMultipleHint => 'Бірнешеуін таңдауға болады';

  @override
  String get quizNext => 'Келесі';

  @override
  String get quizBack => 'Артқа';

  @override
  String get quizDecline => 'Жауап бергім келмейді';

  @override
  String get quizFinish => 'Аяқтау';

  @override
  String get healthGateTitle => 'Бірнеше нәзік сұрақ';

  @override
  String get healthGateBody =>
      'Келесі сұрақтар тері диагноздары, аллергия, жүктілік және дәрілер туралы. Олар күтімді қауіпсіз етуге көмектеседі. Жауаптарыңыз шифрланады және тек келісіміңізбен сақталады.';

  @override
  String get healthGateAgree => 'Келісемін, жалғастыру';

  @override
  String get healthGateSkip => 'Бұл бөлімді өткізу';

  @override
  String get healthGateSkipNote =>
      'Өткізіп жіберсеңіз, күтім сақтырақ құрылады.';

  @override
  String get redFlagTitle => 'Мұны дәрігерге көрсетіңіз';

  @override
  String get redFlagBody =>
      'Сіз белгілеген белгі дәрігердің тексеруін қажет етуі мүмкін. Parla диагноз қоймайды және дәрігердің орнын баспайды. Дерматологқа жүгінуге кеңес береміз.';

  @override
  String get redFlagOk => 'Түсіндім';

  @override
  String get resultTitle => 'Күтіміңіз дайын';

  @override
  String get resultSkin => 'Тері';

  @override
  String get resultHair => 'Шаш';

  @override
  String get resultGoals => 'Мазалайтыны';

  @override
  String get resultSeeRoutine => 'Күтімімді көрсету';

  @override
  String get recheckTitle => 'Жауабың әлі сол күйінде ме?';

  @override
  String recheckSkinBody(String answer, int months) {
    return 'Тестте жүктілік туралы жауабың: «$answer». Мұны $months ай бұрын белгілегенсің; күтімің соған қарай құрылады.';
  }

  @override
  String recheckSportBody(String answer, int months) {
    return 'Спорт сауалнамасындағы жауабың: «$answer». Мұны $months ай бұрын белгілегенсің; сондықтан жоспар жеңіл.';
  }

  @override
  String get recheckYes => 'Иә, солай';

  @override
  String get recheckChange => 'Өзгерді';

  @override
  String get recheckRemove => 'Жауапты жою';

  @override
  String get recheckChooseTitle => 'Қазір қалай?';

  @override
  String get recheckSaved => 'Сақталды.';

  @override
  String get recheckPrivacy =>
      'Жауап шифрланып сақталады және тек күтімің мен жоспарың үшін қолданылады. Жауапты жойсаң, күтім сақ күйінде қалады.';

  @override
  String get homeFocusTitle => 'Күннің фокусы';

  @override
  String get homeFocusSub => 'Күтіміңе негізделген';

  @override
  String get homeFocusDone => 'Бүгінгі күтім орындалды. Өзіңе сәл уақыт бөл.';

  @override
  String get homeFocusOpen => 'Күтімді ашу';

  @override
  String homeFocusSteps(int done, int total) {
    return '$done / $total қадам';
  }

  @override
  String get homePulse => 'Қысқа шолу';

  @override
  String get homeLater => 'Жалғасы';

  @override
  String get homeQuizTitle => 'Күтіміңізді жекелендірейік';

  @override
  String get homeQuizBody => '3 минуттық тест — және күтім сізге бейімделеді.';

  @override
  String get homeQuizStart => 'Тестті бастау';

  @override
  String get error_consent_health_required =>
      'Бұл жауаптар үшін денсаулық деректеріне келісім қажет.';

  @override
  String get privacyTitle => 'Құпиялық орталығы';

  @override
  String get privacyIntro =>
      'Деректерің — сенің таңдауың. Әр құқығың бір түрту қашықтықта.';

  @override
  String get profileAccountTitle => 'Аккаунтың';

  @override
  String get profileAccountNote => 'Атыңды сұрамаймыз · тек эл. пошта';

  @override
  String get profileEmailLabel => 'Эл. пошта';

  @override
  String get profileAgeLabel => 'Жас';

  @override
  String get profileCountryLabel => 'Ел';

  @override
  String get profileLanguageLabel => 'Тіл';

  @override
  String get privacyConsentsTitle => 'Келісімдер';

  @override
  String get privacyHealthWithdrawTitle =>
      'Денсаулық деректеріне келісімді кері қайтарасыз ба?';

  @override
  String get privacyHealthWithdrawBody =>
      'Денсаулық туралы жауаптарыңыз және өз рутиналарыңыздың серверлегі көшірмесі бірден жойылады, күтім сақтырақ құрылады. Өз рутиналарыңыз осы телефонда қалады. Келісімді кейін қайта бере аласыз.';

  @override
  String get privacyWithdraw => 'Кері қайтару және жою';

  @override
  String get privacyCancel => 'Бас тарту';

  @override
  String get privacyExportTitle => 'Деректерімді жүктеп алу';

  @override
  String get privacyExportBody =>
      'Parla сіз туралы сақтайтын барлық нәрсе, сонымен қатар осы телефондағы әдет жазбалары, өз рутиналарыңыз бен күнделігіңіз — бір файлда. Файл қазір жасалады және біздің серверлерде сақталмайды.';

  @override
  String get privacyExportButton => 'Файл жасау';

  @override
  String get privacyLegalTitle => 'Құқықтық құжаттар';

  @override
  String get privacySignOut => 'Шығу';

  @override
  String get privacyDeleteTitle => 'Аккаунтты жою';

  @override
  String get deleteTitle => 'Аккаунтыңыз жойылсын ба?';

  @override
  String get deleteWhatGoes =>
      'Бірден жойылады: профиліңіз, тест және денсаулық жауаптарыңыз, серверде сақталған өз рутиналарыңыз, сатып алу тізіміңіз, спорт және тәрелке жазбаларыңыз (шифрлау кілтімен бірге), қолдау қызметімен хат алмасуыңыз және кіру аккаунтыңыз. Осы телефондағы әдет жазбалары, күнделік және сақталған рецепттер де жойылады.';

  @override
  String get deleteWhatStays =>
      'Поштаңызсыз және аккаунтыңызбен байланыссыз сақталады: дәлел ретінде келісімдер тарихы (3 жыл) мен қауіпсіздік жазбалары (1 жыл), ал тапсырыстарыңыз (бар болса) бухгалтерия үшін.';

  @override
  String get deleteExportFirst => 'Алдымен деректерімді жүктеп алу';

  @override
  String deleteConfirmLabel(String word) {
    return 'Растау үшін $word деп жазыңыз';
  }

  @override
  String get deleteConfirmWord => 'ЖОЮ';

  @override
  String get deleteButton => 'Аккаунтымды жою';

  @override
  String get deletedTitle => 'Аккаунтыңыз жойылды';

  @override
  String get deletedBody =>
      'Бізбен бірге болғаныңызға рахмет. Кез келген уақытта орала аласыз.';

  @override
  String get legalTitle => 'Құқықтық құжаттар';

  @override
  String get legalMedicalTitle => 'Медициналық кеңес емес';

  @override
  String get legalMedicalBody =>
      'Parla — күтім нұсқаулығы. Ол диагноз қоймайды, емдемейді және дәрігердің орнын баспайды. Тері аурулары немесе алаңдатарлық белгілер болса, дерматологқа жүгініңіз.';

  @override
  String get legalPolicyTitle => 'Құпиялық саясаты және пайдалану шарттары';

  @override
  String get legalPolicyBody =>
      'Бұл құжаттар заңгермен бірге дайындалып жатыр және іске қосылғанға дейін осында пайда болады.';

  @override
  String get legalPrivacyPolicy => 'Құпиялық саясаты';

  @override
  String get legalTerms => 'Пайдалану шарттары';

  @override
  String get legalConsentsTitle => 'Келісім мәтіндері';

  @override
  String get habitEdit => 'Өзгерту';

  @override
  String get habitSleepSheetTitle => 'Өткен түні қанша ұйықтадыңыз?';

  @override
  String get habitMoveSheetTitle => 'Бүгін қанша қозғалдыңыз?';

  @override
  String habitSleepHours(String hours) {
    return '$hours сағат';
  }

  @override
  String habitMoveMinutes(int minutes) {
    return '$minutes мин';
  }

  @override
  String get habitLess => 'Азайту';

  @override
  String get habitMore => 'Көбейту';

  @override
  String get habitSave => 'Сақтау';

  @override
  String get habitClearEntry => 'Жазбаны жою';

  @override
  String get habitsScreenTitle => 'Рутина';

  @override
  String get habitsScreenIntro => 'Шағын қадамдар, өз қарқыныңызбен.';

  @override
  String get habitsToday => 'Бүгін';

  @override
  String get habitsWeekTitle => 'Соңғы 7 күн';

  @override
  String get habitsWeekCare => 'Күтімге уақыт бөлген күндеріңіз';

  @override
  String habitsWeekCareValue(int days) {
    return '$days / 7 күн';
  }

  @override
  String get habitsWeekNone => 'Әзірге жазба жоқ';

  @override
  String habitsWeekWaterValue(String glasses) {
    return 'Күніне орта есеппен $glasses стақан';
  }

  @override
  String habitsWeekSleepValue(String hours, int nights) {
    return 'Орта есеппен $hours сағат, $nights түн жазылған';
  }

  @override
  String habitsWeekMoveValue(int minutes, int days) {
    return 'Барлығы $minutes мин, $days күн';
  }

  @override
  String get habitsPrivacyNote =>
      'Әдет жазбаларыңыз тек осы телефонда сақталады және серверге жіберілмейді. 90 күннен ескі жазбалар автоматты түрде жойылады.';

  @override
  String get privacyHabitsTitle => 'Осы телефондағы әдет жазбалары';

  @override
  String get privacyHabitsBody =>
      'Су, ұйқы, қозғалыс және күтім жазбалары тек осы телефонда сақталады. Оларды кез келген уақытта жоя аласыз.';

  @override
  String get privacyHabitsDelete => 'Жазбаларды жою';

  @override
  String get privacyHabitsDeleteTitle => 'Әдет жазбалары жойылсын ба?';

  @override
  String get privacyHabitsDeleteBody =>
      'Осы телефондағы барлық су, ұйқы, қозғалыс және күтім жазбаларыңыз жойылады. Мұны қайтару мүмкін емес.';

  @override
  String get privacyHabitsDeleted => 'Әдет жазбалары жойылды.';

  @override
  String get remindersTitle => 'Еске салғыштар';

  @override
  String get remindersIntro =>
      'Хабарландыруларды телефоныңыздың өзі көрсетеді, серверге ештеңе жіберілмейді. Қалаған уақытта өшіре аласыз.';

  @override
  String get remindersOpen => 'Баптау';

  @override
  String get remindersSummaryOff => 'Барлығы өшірулі';

  @override
  String remindersSummaryOn(int count) {
    return 'Қосулы: $count';
  }

  @override
  String get reminderMorningTitle => 'Таңғы күтім';

  @override
  String get reminderEveningTitle => 'Кешкі күтім';

  @override
  String get reminderSleepTitle => 'Ұйқы жазбасы';

  @override
  String get reminderMorningBody => 'Таңғы күтім уақыты келді.';

  @override
  String get reminderEveningBody => 'Кешкі күтім уақыты келді.';

  @override
  String get reminderSleepBody => 'Өткен түнді жазғыңыз келе ме?';

  @override
  String reminderAt(String time) {
    return 'Сағат $time';
  }

  @override
  String get reminderChangeTime => 'Уақытты өзгерту';

  @override
  String get reminderTimeSheetTitle => 'Қашан еске салайық?';

  @override
  String get reminderPermissionDenied =>
      'Хабарландыруға рұқсат берілмеген. Оны телефон баптауларында қоса аласыз.';

  @override
  String get remindersNote =>
      'Мәтіндер бейтарап және құлып экранында денсаулық деректерін көрсетпейді. Хабарландыру бірнеше минут кешігіп келуі мүмкін.';

  @override
  String get productsTitle => 'Өнімді тексеру';

  @override
  String get productsIntro =>
      'Өнімнің атауын немесе брендін жазып, құрамын қараңыз.';

  @override
  String get productsSearchLabel => 'Өнім атауы немесе бренд';

  @override
  String get productsSearchButton => 'Іздеу';

  @override
  String get productsQueryTooShort => 'Кемінде 2 әріп жазыңыз.';

  @override
  String get productsNotFoundTitle => 'Ештеңе табылмады';

  @override
  String get productsNotFoundBody =>
      'Басқаша жазып немесе бренд атауымен көріңіз. Базада әзірге барлық өнім жоқ.';

  @override
  String get productsSourceObf => 'Open Beauty Facts';

  @override
  String get productsSourceParla => 'Parla каталогы';

  @override
  String get error_product_query_invalid =>
      'Іздеу сұрауы 2–80 таңба болуы керек.';

  @override
  String get error_product_source_unavailable =>
      'Өнімдер базасы қазір жауап бермей тұр. Сәлден соң қайталап көріңіз.';

  @override
  String get productIngredientsTitle => 'Құрамы';

  @override
  String get productNoIngredients =>
      'Бұл өнімнің құрам тізімі жоқ. Қораптағы тізімді қараңыз.';

  @override
  String productIngredientCount(int count) {
    return '$count құрамдас';
  }

  @override
  String productListedCount(int count) {
    return '$count құрамдасқа ЕО жазбасы бар';
  }

  @override
  String get productStatusesMissing =>
      'Құрамдас мәртебелері әлі жүктелмеді. Әзірге тек құрам тізімі көрсетіледі.';

  @override
  String get productDataNotice =>
      'Құрам тізімі қауымдастық базасынан алынған, қателер болуы мүмкін. Қораптағы тізіммен салыстырыңыз.';

  @override
  String productLegalNotice(String date) {
    return 'Мәртебелер ЕО-ның 1223/2009 Регламентінің қосымшаларына негізделген (CosIng, $date). Атаулар автоматты түрде сәйкестендіріледі. Бұл Әзербайжан ережесі емес және өнімнің қауіпсіздігіне берілген баға емес.';
  }

  @override
  String get productAttribution =>
      'Өнім деректері: Open Beauty Facts, ODbL лицензиясы бойынша.';

  @override
  String get annexIIShort => 'ЕО: тыйым салынған заттар тізімінде';

  @override
  String get annexIIIShort => 'ЕО: шектеулермен рұқсат етілген';

  @override
  String get annexIVShort => 'ЕО: рұқсат етілген бояғыш';

  @override
  String get annexVShort => 'ЕО: рұқсат етілген консервант';

  @override
  String get annexVIShort => 'ЕО: рұқсат етілген УК-сүзгі';

  @override
  String annexEntry(String annex, String reference) {
    return '$annex қосымша, № $reference';
  }

  @override
  String get annexConditionsLabel =>
      'Ресми шарттар (CosIng-тегідей, ағылшынша)';

  @override
  String get ingredientNoEntry => 'ЕО қосымшаларында жеке жазба табылмады';

  @override
  String ingredientSheetSource(String date) {
    return 'Дереккөз: CosIng, $date';
  }

  @override
  String get ingredientDetailsHint => 'Толығырақ';

  @override
  String get navRoutine => 'Рутина';

  @override
  String get navCheck => 'Тексеру';

  @override
  String get navSport => 'Спорт';

  @override
  String get navDiscover => 'Шолу';

  @override
  String get navProfile => 'Профиль';

  @override
  String get sportTitle => 'Спорт';

  @override
  String get discoverTitle => 'Шолу';

  @override
  String get discoverBlogs => 'Блогтар';

  @override
  String get discoverBlogsHint => 'Күтім, сұлулық, сән';

  @override
  String get discoverExperts => 'Мамандар';

  @override
  String get discoverExpertsHint => 'Дерматолог, косметолог';

  @override
  String get discoverNutrition => 'Тамақтану';

  @override
  String get discoverNutritionHint => 'Күнделікті тәрелке және рецепттер';

  @override
  String get discoverShopping => 'Сатып алу тізімі';

  @override
  String get discoverShoppingHint => 'Қажетін белгіле';

  @override
  String get discoverShop => 'Дүкен';

  @override
  String get discoverShopHint => 'Рутинаңдағы өнімдер';

  @override
  String get soonBadge => 'Жақында';

  @override
  String get onboardingStepAbout => 'Танысу';

  @override
  String get onboardingStepAccount => 'Аккаунт';

  @override
  String get onboardingStepCountry => 'Ел';

  @override
  String get onboardingStepPrivacy => 'Құпиялық';

  @override
  String get routineAreaFace => 'Бет';

  @override
  String get routineAreaHair => 'Шаш';

  @override
  String get routineAreaBody => 'Дене';

  @override
  String get routineSlotMorning => 'Таң';

  @override
  String get routineSlotEvening => 'Кеш';

  @override
  String get routineSlotWeekly => 'Апталық';

  @override
  String get routineWeeklyHint =>
      'Аптасына бір рет. Белгілер дүйсенбіде жаңарады.';

  @override
  String get routineSlotEmpty => 'Бұл уақытқа қадам жоқ.';

  @override
  String get routineOwnButton => 'Өз рутинаң';

  @override
  String get routineOwnSection => 'Өз рутиналарың';

  @override
  String get routineOwnEmpty => 'Өз рутинаңды жасап, осында бақылай аласың.';

  @override
  String get routineOwnEveryDay => 'Күн сайын';

  @override
  String routineOwnSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count қадам',
      one: '1 қадам',
    );
    return '$_temp0';
  }

  @override
  String routineOwnEdit(String name) {
    return 'Өзгерту: $name';
  }

  @override
  String get routineDayHabits => 'Күн бойы';

  @override
  String get builderTitleNew => 'Өз рутинаңды жаса';

  @override
  String get builderTitleEdit => 'Рутинаны өзгерту';

  @override
  String get builderName => 'Атауы';

  @override
  String get builderNameHint => 'Мыс. Жексенбілік спа';

  @override
  String get builderArea => 'Бөлім';

  @override
  String get builderWhen => 'Қашан';

  @override
  String get builderEveryDay => 'Күн сайын';

  @override
  String get builderOnceWeek => 'Аптасына бір рет';

  @override
  String get builderSteps => 'Қадамдар';

  @override
  String get builderStepHint => 'Жаңа қадам';

  @override
  String get builderAddStep => 'Қосу';

  @override
  String get builderSuggestions => 'Дайын қадамдардан таңда';

  @override
  String builderMoveUp(String step) {
    return 'Жоғары: $step';
  }

  @override
  String builderMoveDown(String step) {
    return 'Төмен: $step';
  }

  @override
  String builderRemoveStep(String step) {
    return 'Жою: $step';
  }

  @override
  String get builderSave => 'Сақтау';

  @override
  String get builderDelete => 'Рутинаны жою';

  @override
  String get builderDeleteConfirm => 'Бұл рутина жойылсын ба?';

  @override
  String get builderDeleteYes => 'Жою';

  @override
  String get builderCancel => 'Бас тарту';

  @override
  String get builderNeedName => 'Рутинаға атау бер.';

  @override
  String get builderNeedStep => 'Кемінде бір қадам қос.';

  @override
  String builderLimit(int count) {
    return 'Ең көбі $count қадам.';
  }

  @override
  String get todayRoutinesTitle => 'Бүгінгі рутиналар';

  @override
  String get todayRoutinesAll => 'Барлығы';

  @override
  String get todayRoutinesNone => 'Бүгінге басқа рутина жоқ.';

  @override
  String get builderPrivacySynced =>
      'Өз рутиналарың серверде шифрланып сақталады, ал осы телефонда офлайн үшін көшірмесі қалады.';

  @override
  String get builderPrivacyDevice =>
      'Өз рутиналарың әзірге тек осы телефонда сақталады. Жаңартылған денсаулық деректеріне келісіммен серверде шифрланып сақталатын болады.';

  @override
  String get checkPrefsTitle => 'Сенің таңдауларың';

  @override
  String get checkPrefsEdit => 'Өзгерту';

  @override
  String get checkPrefsEmpty =>
      'Өзің үшін маңыздысын таңда, құрамды таңдауларыңмен салыстырайық.';

  @override
  String get checkPrefsAdd => 'Таңдау қосу';

  @override
  String get checkPrefsSheetTitle => 'Сен үшін не маңызды?';

  @override
  String get checkPrefsSave => 'Сақтау';

  @override
  String get checkBarcodeSoon => 'Штрихкод сканері · жақында';

  @override
  String get checkRecentTitle => 'Соңғы тексерілгендер';

  @override
  String get checkRecentClear => 'Тазалау';

  @override
  String get resultPrefsTitle => 'Сенің таңдауларыңмен';

  @override
  String resultPrefsSummary(int fits, int count) {
    return 'Таңдауларыңның $fits / $count сәйкес';
  }

  @override
  String get resultPrefFits => 'Сәйкес';

  @override
  String resultPrefContains(String names) {
    return 'Құрамында бар: $names';
  }

  @override
  String get resultPrefVeganFits => 'Танылған жануар текті зат табылмады';

  @override
  String get resultPrefUnknown =>
      'Құрам тізімі жоқ болғандықтан, тексеру мүмкін емес';

  @override
  String get resultPrefsNone =>
      'Таңдауларыңды қос, құрамды солармен салыстырайық.';

  @override
  String get resultPrefsNote =>
      'Parla өнімдерді бағаламайды және ұпай бермейді. Сәйкестік тек сенің таңдауларың мен құрам тізіміне негізделген.';

  @override
  String get resultAddToList => 'Сатып алу тізіміне';

  @override
  String get resultInList => 'Тізімде бар';

  @override
  String get resultAdded => 'Сатып алу тізіміне қосылды.';

  @override
  String shoppingCount(int bought, int total) {
    return '$bought / $total алынды';
  }

  @override
  String get shoppingNewHint => 'Жаңа өнім';

  @override
  String get shoppingAdd => 'Қосу';

  @override
  String get shoppingEmpty => 'Тізім бос. Қажеттерді осында белгіле.';

  @override
  String get shoppingAreaOther => 'Басқа';

  @override
  String get shoppingFromCheck => 'Тексеру бөлімінен';

  @override
  String shoppingRemove(String title) {
    return 'Жою: $title';
  }

  @override
  String get shoppingRemoveBought => 'Алынғандарды жою';

  @override
  String shoppingFull(int count) {
    return 'Тізімде ең көбі $count өнім бола алады.';
  }

  @override
  String get careListSynced =>
      'Таңдауларың мен сатып алу тізімің серверде шифрланып сақталады, ал осы телефонда офлайн үшін көшірмесі қалады.';

  @override
  String get careListDevice =>
      'Таңдауларың мен сатып алу тізімің әзірге тек осы телефонда сақталады. Жаңартылған денсаулық деректеріне келісіммен серверде шифрланып сақталатын болады.';

  @override
  String get shopTitle => 'Parla Дүкен';

  @override
  String get shopBody =>
      'Рутинаңдағы өнімдер бір түртумен. Сатып алу тізіміңе тікелей тапсырыс беріп, таңдауларыңа сай өнімдерді таба алатын боласың.';

  @override
  String get shopSoonCard => 'Parla Дүкен';

  @override
  String get shopSoonCardBody => 'Серіктестердің өнімдерін қара';

  @override
  String get shopOpenList => 'Сатып алу тізімімді қарау';

  @override
  String get shopIntro =>
      'Серіктестердің өнімдері. Сатып алу серіктестің сайтында жүреді; Parla сен туралы ештеңе бермейді.';

  @override
  String get shopAll => 'Барлығы';

  @override
  String get shopCategoryFace => 'Бет';

  @override
  String get shopCategoryHair => 'Шаш';

  @override
  String get shopCategoryBody => 'Дене';

  @override
  String get shopCategoryMakeup => 'Макияж';

  @override
  String get shopCategoryOther => 'Басқа';

  @override
  String shopPrice(String price) {
    return '$price ₼';
  }

  @override
  String get shopVisitPartner => 'Серіктестің сайтына өту';

  @override
  String get shopPriceNote =>
      'Баға мен қолда бары серіктестің сайтында өзгеруі мүмкін. Алмас бұрын құрамын тексер; теріде мәселе болса, дәрігермен кеңес.';

  @override
  String get shopEmpty => 'Әзірге өнім жоқ. Жақында осында болады.';

  @override
  String get shopMyOrders => 'Тапсырыстарым';

  @override
  String get shopBuy => 'Сатып алу';

  @override
  String get shopBuyTitle => 'Тапсырысты растау';

  @override
  String shopBuyBody(String product, String price, String seller) {
    return '$product: $price. $seller Төлем Epoint бетінде жасалады; карта деректерің Parla-ға келмейді.';
  }

  @override
  String get shopSellerParla => 'Сатушы: Parla.';

  @override
  String shopSellerBrand(String brand) {
    return 'Сатушы: $brand, төлемді Parla қабылдайды.';
  }

  @override
  String get shopBuyGo => 'Төлемге өту';

  @override
  String get shopBuyError => 'Төлем беті ашылмады. Сәлден соң қайталап көр.';

  @override
  String get shopTooMany =>
      'Соңғы бір сағатта тым көп тапсырыс бастадың. Сәлден соң қайталап көр.';

  @override
  String get shopOrdersEmpty => 'Әзірге тапсырысың жоқ.';

  @override
  String shopOrderMeta(String number, String date, int quantity) {
    return '$number · $date · $quantity дана';
  }

  @override
  String get shopOrderCreated => 'Төлем күтілуде';

  @override
  String get shopOrderPaid => 'Төленді';

  @override
  String get shopOrderFailed => 'Төлем өтпеді';

  @override
  String get shopOrderShipped => 'Жіберілді';

  @override
  String get shopOrderDelivered => 'Жеткізілді';

  @override
  String get shopOrderCancelled => 'Бас тартылды';

  @override
  String get shopOrderRefunded => 'Ақша қайтарылды';

  @override
  String get sportIntroTitle => 'Саған лайық спорт жоспары';

  @override
  String get sportIntroBody =>
      'Бірнеше сұрақ: мақсат, аймақтар, ұнайтын жаттығулар. Содан кейін апталық жоспар, сет пен қайталау саны, таймер. Музыка өз қолданбаңнан ойнайды.';

  @override
  String get sportStart => 'Бастау';

  @override
  String get sportNext => 'Жалғастыру';

  @override
  String get sportNeedOne => 'Кемінде біреуін таңда.';

  @override
  String get sportQGoals => 'Мақсатың қандай?';

  @override
  String get sportQGoalsHint => '2-ге дейін таңда';

  @override
  String get sportGoalTone => 'Тонус пен серпімділік';

  @override
  String get sportGoalMuscle => 'Бұлшықет массасын арттыру';

  @override
  String get sportGoalFlexibility => 'Икемділік';

  @override
  String get sportGoalPosture => 'Дене қалпы';

  @override
  String get sportGoalEndurance => 'Төзімділік';

  @override
  String get sportGoalRelax => 'Стрессті басу';

  @override
  String get sportQAreas => 'Қай аймақтарға назар аударайық?';

  @override
  String get sportAreasNote =>
      'Бір аймақтан ғана май жағу мүмкін емес. Бұл қозғалыстар сол бұлшықеттерді нығайтып, тонус береді.';

  @override
  String get sportAreaArms => 'Қолдар';

  @override
  String get sportAreaLegs => 'Аяқтар';

  @override
  String get sportAreaCore => 'Іш және кор';

  @override
  String get sportAreaGlutes => 'Бөксе';

  @override
  String get sportAreaBack => 'Арқа';

  @override
  String get sportAreaFull => 'Бүкіл дене';

  @override
  String get sportQTypes => 'Қандай жаттығулар ұнайды?';

  @override
  String get sportTypeFitness => 'Фитнес';

  @override
  String get sportTypePilates => 'Пилатес';

  @override
  String get sportTypeWallPilates => 'Қабырға пилатесі';

  @override
  String get sportTypeStretching => 'Созылу';

  @override
  String get sportTypeCardio => 'Жеңіл кардио';

  @override
  String get sportTypeFaceYoga => 'Бет йогасы';

  @override
  String get sportTypeYoga => 'Йога';

  @override
  String get sportYogaMorning => 'Таңғы ағын';

  @override
  String get sportYogaEvening => 'Кешкі тыныштық';

  @override
  String get sportYogaStretch => 'Созылу және босаңсу';

  @override
  String sportSessionCardBody(int count, int minutes) {
    return '$count қозғалыс · шамамен $minutes мин';
  }

  @override
  String get sportYogaSafetyTitle => 'Бастамас бұрын';

  @override
  String get sportYogaSafetyBody =>
      'Баяу қозғал, тынысыңды ұстама, ауырсыну болса, тоқта. Жүктілікте, жоғары қан қысымында, бел, тізе немесе білек жарақатында алдымен дәрігерге жүгін. Сауалнамада жарақат немесе жүктілікті белгілесең, саған сай емес қалыптар сеанстан алынып тасталады.';

  @override
  String sportFaceYogaCardBody(int minutes) {
    return '12 қозғалыс · шамамен $minutes мин. Айна алдында, кез келген уақытта.';
  }

  @override
  String get sportFaceYogaSafetyTitle => 'Бастамас бұрын';

  @override
  String get sportFaceYogaSafetyBody =>
      'Қолыңызды жуыңыз, теріге тек жеңіл тиіңіз, теріні созбаңыз. Ауырсыну немесе жайсыздық болса, тоқтатыңыз. Жақында косметикалық процедурадан (ботокс, филлер) өтсеңіз, жақ буынында немесе теріде мәселе болса, алдымен дәрігерге жүгініңіз.';

  @override
  String get sportQLevel => 'Деңгейің қандай?';

  @override
  String get sportLevelBeginner => 'Енді бастап жүрмін';

  @override
  String get sportLevelIntermediate => 'Орташа';

  @override
  String get sportLevelAdvanced => 'Тәжірибелі';

  @override
  String get sportQSchedule => 'Қанша уақытың бар?';

  @override
  String get sportDaysLabel => 'Аптасына неше күн';

  @override
  String get sportMinutesLabel => 'Бір жаттығу';

  @override
  String sportDays(int count) {
    return '$count күн';
  }

  @override
  String sportMinutes(int count) {
    return '$count мин';
  }

  @override
  String get sportDumbbells => 'Үйде гантелім бар';

  @override
  String get sportQSafety => 'Қауіпсіздік үшін';

  @override
  String get sportSafetyIntro =>
      'Бұл жауаптар тек саған сай емес қозғалыстарды жоспардан алып тастау үшін керек.';

  @override
  String get sportPregnancyLabel => 'Жүктілік';

  @override
  String get sportPregNo => 'Жоқ';

  @override
  String get sportPregPregnant => 'Жүктімін';

  @override
  String get sportPregPostpartum => 'Соңғы 6 айда босандым';

  @override
  String get sportInjuriesLabel => 'Ауырсыну немесе жарақат';

  @override
  String get sportInjKnee => 'Тізе';

  @override
  String get sportInjBack => 'Бел';

  @override
  String get sportInjShoulder => 'Иық';

  @override
  String get sportInjWrist => 'Білек';

  @override
  String get sportDoctorLimit =>
      'Дәрігер спортты шектеген немесе алдымен ақылдасуды айтқан';

  @override
  String get sportBuildPlan => 'Жоспар құру';

  @override
  String get sportWeekTitle => 'Осы апта';

  @override
  String sportWeekProgress(int done, int total) {
    return '$done / $total жаттығу';
  }

  @override
  String sportWorkoutTitle(int number) {
    return 'Жаттығу $number';
  }

  @override
  String get sportWorkoutName_w6 => 'Жеңіл созылу';

  @override
  String get sportWorkoutName_w7 => 'Апта финалы';

  @override
  String get sportWorkoutName_p6 => 'Жұмсақ ағын';

  @override
  String get sportWorkoutName_p7 => 'Орталық финалы';

  @override
  String get sportWorkoutName_v6 => 'Қабырғамен босаңсу';

  @override
  String get sportWorkoutName_v7 => 'Қабырға финалы';

  @override
  String get sportEveryDay => 'Күн сайын';

  @override
  String get sportWeekdaysLabel => 'Қай күндері?';

  @override
  String sportWeekdaysHint(int count) {
    return '$count күн таңда. Арасындағы күндер — демалыс.';
  }

  @override
  String get sportEveryDayNote =>
      'Күн сайын: бұлшықеттер қалпына келуі үшін аптасына екі күн жеңіл созылу болады.';

  @override
  String sportWeekday(String day) {
    String _temp0 = intl.Intl.selectLogic(
      day,
      {
        '1': 'Дс',
        '2': 'Сс',
        '3': 'Ср',
        '4': 'Бс',
        '5': 'Жм',
        '6': 'Сб',
        'other': 'Жс',
      },
    );
    return '$_temp0';
  }

  @override
  String sportPickWeekdays(int count) {
    return 'Дәл $count күн таңда.';
  }

  @override
  String get sportMonthTitle => 'Айлық жоспар';

  @override
  String sportMonthProgress(int day, int week) {
    return 'Күн $day / 28 · Апта $week';
  }

  @override
  String get sportLegendDone => 'орындалды';

  @override
  String get sportLegendWorkout => 'жаттығу';

  @override
  String get sportLegendRest => 'демалыс';

  @override
  String get sportToday => 'Бүгін';

  @override
  String get sportRestToday => 'Бүгін — демалыс күні';

  @override
  String sportNextOn(String when) {
    return 'Келесі жаттығу: $when';
  }

  @override
  String sportWeekBadge(int week) {
    return 'Апта $week';
  }

  @override
  String get sportRecoveryWeek => 'Қалпына келу аптасы';

  @override
  String sportCardMeta(int minutes, int moves) {
    return '$minutes мин · $moves қозғалыс';
  }

  @override
  String get sportMonthDoneTitle => 'Ай аяқталды';

  @override
  String sportMonthDoneBody(int done) {
    return '$done жаттығу орындалды. Келесі айдың алдында жауаптарың мен деңгейіңді тексерейік.';
  }

  @override
  String get sportNewMonth => 'Келесі ай';

  @override
  String sportMonthCalendar(int done, int left) {
    return 'Ай күнтізбесі: $done жаттығу орындалды, $left қалды';
  }

  @override
  String get sportWorkoutName_w1 => 'Күшті бастау';

  @override
  String get sportWorkoutName_w2 => 'Аяқ күні';

  @override
  String get sportWorkoutName_w3 => 'Бүкіл дене';

  @override
  String get sportWorkoutName_w4 => 'Энергия толқыны';

  @override
  String get sportWorkoutName_w5 => 'Күш пен тепе-теңдік';

  @override
  String get sportWorkoutName_p1 => 'Орталықты ояту';

  @override
  String get sportWorkoutName_p2 => 'Жұмсақ ағын';

  @override
  String get sportWorkoutName_p3 => 'Дене қалпы мен тыныс';

  @override
  String get sportWorkoutName_p4 => 'Ұзын сызықтар';

  @override
  String get sportWorkoutName_p5 => 'Байсалды күш';

  @override
  String get sportWorkoutName_v1 => 'Қабырғамен танысу';

  @override
  String get sportWorkoutName_v2 => 'Қабырға тірегі';

  @override
  String get sportWorkoutName_v3 => 'Қабырғадағы ағын';

  @override
  String get sportWorkoutName_v4 => 'Қабырға ырғағы';

  @override
  String get sportWorkoutName_v5 => 'Қабырға балансы';

  @override
  String sportWorkoutMeta(String type, int minutes) {
    return '$type · ~$minutes мин';
  }

  @override
  String get sportDone => 'Орындалды';

  @override
  String get sportNextLabel => 'Келесі';

  @override
  String get sportEditAnswers => 'Сауалнаманы жаңарту';

  @override
  String get sportBlockedTitle => 'Алдымен дәрігеріңмен сөйлес';

  @override
  String get sportBlockedBody =>
      'Дәрігер спортты шектеген болса, жоспар құрмаймыз. Рұқсат алғанда сауалнаманы жаңарт.';

  @override
  String get sportGentleNote =>
      'Жүктілік және босанғаннан кейінгі кезеңге арналған жеңіл жоспар. Бастамас бұрын дәрігеріңнен сұра.';

  @override
  String get sportDraftNote =>
      'Қозғалыстар мен сандарды жаттықтырушы әлі тексерген жоқ. Ауырсыну сезсең, тоқта.';

  @override
  String get sportAllDone => 'Осы аптаның барлық жаттығуы орындалды.';

  @override
  String sportSetsReps(int sets, int reps) {
    return '$sets × $reps қайталау';
  }

  @override
  String sportSetsSeconds(int sets, int seconds) {
    return '$sets × $seconds сек';
  }

  @override
  String sportRestSeconds(int seconds) {
    return 'Демалыс $seconds сек';
  }

  @override
  String get sportStartWorkout => 'Жаттығуды бастау';

  @override
  String get sportMusicNote =>
      'Бейнелердің өз музыкасы бар, оны түймемен өшіре аласың. Parla дыбыс белгісін де береді.';

  @override
  String get sportVideoSoundOn => 'Бейне дыбысы қосулы';

  @override
  String get sportVideoSoundOff => 'Бейне дыбысы өшірулі';

  @override
  String get sportSoundOn => 'Сигнал дыбысы қосулы';

  @override
  String get sportSoundOff => 'Сигнал дыбысы өшірулі, тек діріл';

  @override
  String sportSetOf(int set, int sets) {
    return 'Сет $set / $sets';
  }

  @override
  String sportRepsNow(int reps) {
    return '$reps қайталау';
  }

  @override
  String get sportPause => 'Үзіліс';

  @override
  String get sportResume => 'Жалғастыру';

  @override
  String get sportResting => 'Демалыс';

  @override
  String sportNextUp(String name) {
    return 'Кейін: $name';
  }

  @override
  String sportExerciseOf(int index, int total) {
    return 'Қозғалыс $index / $total';
  }

  @override
  String get sportFinishedTitle => 'Жаттығу аяқталды';

  @override
  String sportFinishedBody(int minutes) {
    return '$minutes минут қозғалыс бүгінгі жазбаға қосылды.';
  }

  @override
  String get sportBackToPlan => 'Жоспарға оралу';

  @override
  String get sportQuit => 'Жаттығуды тоқтату';

  @override
  String get sportGetReady => 'Дайындал';

  @override
  String get sportPrevious => 'Алдыңғы қозғалыс';

  @override
  String get sportNextMove => 'Келесі';

  @override
  String get sportStopTitle => 'Жаттығуды тоқтатамыз ба?';

  @override
  String get sportStopBody => 'Бұл жаттығу орындалды деп белгіленбейді.';

  @override
  String get sportStopConfirm => 'Тоқтату';

  @override
  String get sportKeepGoing => 'Жалғастыру';

  @override
  String sportRepPace(int seconds) {
    return 'Әр қайталау шамамен $seconds сек. Ертерек бітірсең, “Келесі” түймесін бас.';
  }

  @override
  String get sportPrivacySynced =>
      'Спорт жауаптарың серверде шифрланып сақталады, ал осы телефонда офлайн үшін көшірмесі қалады.';

  @override
  String get sportPrivacyDevice =>
      'Спорт жауаптарың әзірге тек осы телефонда сақталады. Жаңартылған денсаулық деректеріне келісіммен серверде шифрланып сақталатын болады.';

  @override
  String get discoverLatest => 'Жаңа мақалалар';

  @override
  String get discoverAll => 'Барлығы';

  @override
  String get expertSample => 'Үлгі';

  @override
  String get expertSampleNote =>
      'Бұл үлгі профиль, байланыс деректері жұмыс істемейді.';

  @override
  String get discoverJournal => 'Күнделік';

  @override
  String get discoverJournalHint => 'Тек сен үшін, осы телефонда';

  @override
  String get journalIntro =>
      'Күнің туралы жаз. Жазбалар тек осы телефонда шифрланып сақталады; Parla командасы оларды көрмейді. Телефонды ауыстырғанда немесе қолданбаны жойғанда олар жоғалады. Сақтау үшін: Профиль → Деректерімді жүктеп алу.';

  @override
  String get journalNew => 'Жаңа жазба';

  @override
  String get journalEmpty => 'Әзірге жазба жоқ.';

  @override
  String get journalHint => 'Бүгін қалай өтті?';

  @override
  String get journalEntryTitle => 'Жазба';

  @override
  String get journalSave => 'Сақтау';

  @override
  String get journalDelete => 'Жою';

  @override
  String get journalDeleteTitle => 'Бұл жазба жойылсын ба?';

  @override
  String get journalDeleteBody => 'Қайтару мүмкін болмайды.';

  @override
  String get journalFull =>
      'Күнделік толды. Жаңа жазба үшін ескілерінің бірін жой.';

  @override
  String get discoverSportHint => 'Апталық жоспарың';

  @override
  String discoverArticleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count мақала',
    );
    return '$_temp0';
  }

  @override
  String discoverRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count рецепт',
    );
    return '$_temp0';
  }

  @override
  String get contentEmpty => 'Әзірге мақала жоқ. Жақында осында болады.';

  @override
  String get contentOffline =>
      'Интернет жоқ, соңғы жүктелген көшірме көрсетілуде.';

  @override
  String blogMeta(String category, int minutes) {
    return '$category · $minutes мин';
  }

  @override
  String blogReviewed(String date) {
    return 'Маман тексерген · $date';
  }

  @override
  String get blogTips => 'Қысқа қадамдар';

  @override
  String get catCare => 'Күтім';

  @override
  String get catBeauty => 'Сұлулық';

  @override
  String get catFashion => 'Сән';

  @override
  String get catHair => 'Шаш';

  @override
  String get specDermatologist => 'Дерматолог';

  @override
  String get specCosmetologist => 'Косметолог';

  @override
  String get specTrainer => 'Жаттықтырушы';

  @override
  String get specDietitian => 'Диетолог';

  @override
  String get specTrichologist => 'Трихолог';

  @override
  String expertYears(int years) {
    return '$years жыл тәжірибе';
  }

  @override
  String get expertCall => 'Қоңырау шалу';

  @override
  String get expertWhatsapp => 'WhatsApp';

  @override
  String get expertInstagram => 'Instagram';

  @override
  String get expertsNote =>
      'Parla мамандармен тек таныстырады, олардың қызметтеріне жауап бермейді. Байланыс қолданбадан тыс, маманмен тікелей орнатылады; Parla хат алмасуды көрмейді.';

  @override
  String get nutritionHero => 'Сұлулық тәрелкеден басталады';

  @override
  String get nutritionPlate => 'Бүгінгі тәрелке';

  @override
  String nutritionPlateCount(int count, int total) {
    return '$count / $total топ';
  }

  @override
  String get groupVegetables => 'Көкөніс';

  @override
  String get groupFruit => 'Жеміс';

  @override
  String get groupProtein => 'Ақуыз';

  @override
  String get groupWholeGrain => 'Тұтас дән';

  @override
  String get groupHealthyFat => 'Пайдалы май';

  @override
  String get groupDairy => 'Сүт өнімі';

  @override
  String nutritionWater(int count, int goal) {
    return 'Су: $count / $goal стақан';
  }

  @override
  String get nutritionNoCalories =>
      'Тәрелкеде калория санамаймыз. Тек алуан түрлілік: күн сайын түрлі түсті тәрелке.';

  @override
  String get nutritionTip => 'Күннің кеңесі';

  @override
  String get nutritionRecipes => 'Сұлулық рецепттері';

  @override
  String get nutritionDisclaimer =>
      'Бұл жалпы ақпарат, диета немесе медициналық ұсыныс емес. Тамақтануға ерекше қажеттілігің болса, диетологпен кеңес.';

  @override
  String get nutritionPrivacySynced =>
      'Тәрелке жазбаларың серверде шифрланып сақталады, ал осы телефонда офлайн үшін көшірмесі қалады.';

  @override
  String get nutritionPrivacyDevice =>
      'Тәрелке жазбаларың әзірге тек осы телефонда сақталады. Жаңартылған денсаулық деректеріне келісіммен серверде шифрланып сақталатын болады.';

  @override
  String get mealBreakfast => 'Таңғы ас';

  @override
  String get mealLunch => 'Түскі ас';

  @override
  String get mealDinner => 'Кешкі ас';

  @override
  String get mealSnack => 'Жеңіл тамақ';

  @override
  String recipeMeta(String meal, int minutes, int servings) {
    return '$meal · $minutes мин · $servings адам';
  }

  @override
  String get recipeIngredients => 'Құрамы';

  @override
  String get recipeSteps => 'Дайындалуы';

  @override
  String get recipeAddAll => 'Құрамын сатып алу тізіміне қосу';

  @override
  String get recipeSave => 'Рецептті сақтау';

  @override
  String get recipeUnsave => 'Сақталғандардан алып тастау';

  @override
  String get nutritionDailyRecipe => 'Бүгінгі ұсыныс';

  @override
  String get nutritionPlateIdeas => 'Тәрелкеңді толықтыр';

  @override
  String get nutritionPlateIdeasNote =>
      'Бүгін әлі таңдамаған топтарыңа арналған рецепттер.';

  @override
  String get nutritionSaved => 'Сақтағандарың';

  @override
  String recipeKcal(int kcal) {
    return '≈ $kcal ккал · 1 порция (шамамен)';
  }

  @override
  String recipeAdded(int count) {
    return '$count өнім сатып алу тізіміне қосылды.';
  }

  @override
  String get skinCardTitle => 'Тері талдауы';

  @override
  String get skinCardBody => 'Сұрақтарға жауап беріп, теріңді қайта талда.';

  @override
  String get catBody => 'Дене';

  @override
  String get blogSources => 'Дереккөздер';

  @override
  String get blogRelated => 'Ұқсас мақалалар';

  @override
  String recipeAllergens(String list) {
    return 'Құрамында: $list';
  }

  @override
  String get recipeNoAllergens => '14 негізгі аллергеннің ешқайсысы жоқ.';

  @override
  String get allergenGluten => 'глютен';

  @override
  String get allergenCrustaceans => 'шаянтәрізділер';

  @override
  String get allergenEgg => 'жұмыртқа';

  @override
  String get allergenFish => 'балық';

  @override
  String get allergenPeanuts => 'жержаңғақ';

  @override
  String get allergenSoy => 'соя';

  @override
  String get allergenMilk => 'сүт';

  @override
  String get allergenNuts => 'жаңғақтар';

  @override
  String get allergenCelery => 'балдыркөк';

  @override
  String get allergenMustard => 'қыша';

  @override
  String get allergenSesame => 'күнжіт';

  @override
  String get allergenSulphites => 'сульфиттер';

  @override
  String get allergenLupin => 'люпин';

  @override
  String get allergenMolluscs => 'моллюскалар';

  @override
  String bannerAd(String brand) {
    return 'Жарнама · $brand';
  }

  @override
  String get bannerLeaveTitle => 'Басқа сайтқа өтесің';

  @override
  String bannerLeaveBody(String host) {
    return '$host сайты браузерде ашылады. Parla бұл сайтқа сен туралы ешқандай дерек жібермейді; сайттың өз құпиялық ережелері бар.';
  }

  @override
  String get bannerLeaveGo => 'Сайтқа өту';

  @override
  String get bannerLeaveCancel => 'Бас тарту';

  @override
  String get messagesTitle => 'Хабарламалар';

  @override
  String get messagesButton => 'Хабарламалар';

  @override
  String get messagesButtonUnread => 'Хабарламалар, жаңа жауап бар';

  @override
  String get messagesFromParla => 'Parla-дан';

  @override
  String get messagesNone => 'Әзірге хабарландыру жоқ.';

  @override
  String get supportTitle => 'Қолдау';

  @override
  String get supportIntro =>
      'Сұрағыңды жаз, Parla командасы жауап береді. Хабарламалар шифрланып сақталады және соңғы хабарламадан 12 ай өткен соң жойылады. Біз медициналық кеңес бермейміз: шұғыл немесе күрделі жағдайда дәрігерге жүгін.';

  @override
  String get supportHint => 'Хабарламаң';

  @override
  String get supportSend => 'Жіберу';

  @override
  String get supportYou => 'Сен';

  @override
  String get supportTeam => 'Parla командасы';

  @override
  String get supportSent => 'Жіберілді.';

  @override
  String get pushTitle => 'Хабарландырулар';

  @override
  String get pushBody =>
      'Қолдау қызметі жауап бергенде хабар аласың. Маркетингке келісім берсең, Parla жаңалықтары да келеді. Кез келген уақытта өшіре аласың.';

  @override
  String get pushDenied =>
      'Хабарландыруларға рұқсат берілмеді. Телефон баптауларынан қоса аласың.';

  @override
  String get checkSuggestTitle => 'Тестіңе қарай ұсыныс';

  @override
  String get checkSuggestBody =>
      'Тест жауаптарыңа қарағанда, бұл таңдаулар саған сай болуы мүмкін. Қосу-қоспау — өз шешімің.';

  @override
  String checkSuggestAdd(String name) {
    return '$name қосу';
  }

  @override
  String get consentRefreshCardTitle => 'Келісім мәтіні жаңартылды';

  @override
  String get consentRefreshCardBody =>
      'Денсаулық деректеріне келісімнің жаңа нұсқасы бар. Оқып, келіссең, рутиналарың, тізімдерің, спорт және тамақтану жазбаларың шифрланған серверге де сақталады. Келіспесең, олар тек осы телефонда қалады.';

  @override
  String get consentRefreshOpen => 'Оқу';

  @override
  String get consentRefreshTitle => 'Денсаулық деректеріне келісім';

  @override
  String get consentRefreshIntro =>
      'Бұл бұрын келіскен мәтініңнің жаңа нұсқасы. Келісу ерікті; оны кез келген уақытта Құпиялық бөлімінде кері қайтара аласың.';

  @override
  String get consentRefreshAgree => 'Келісемін';

  @override
  String get consentRefreshLater => 'Қазір емес';

  @override
  String get consentRefreshDone => 'Келісім жаңартылды.';

  @override
  String get appearanceTitle => 'Көрініс';

  @override
  String get appearanceSystem => 'Жүйелік';

  @override
  String get appearanceLight => 'Ашық';

  @override
  String get appearanceDark => 'Қараңғы';
}
