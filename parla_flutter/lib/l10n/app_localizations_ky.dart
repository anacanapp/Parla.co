// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kirghiz Kyrgyz (`ky`).
class AppLocalizationsKy extends AppLocalizations {
  AppLocalizationsKy([String locale = 'ky']) : super(locale);

  @override
  String get appTitle => 'Parla';

  @override
  String get languageTitle => 'Тилди тандаңыз';

  @override
  String get languageName_az => 'Azərbaycanca';

  @override
  String get languageName_ru => 'Русский';

  @override
  String get languageName_en => 'English';

  @override
  String get continueButton => 'Улантуу';

  @override
  String get welcomeTitle => 'Жеке кам көрүү гидиңиз';

  @override
  String get welcomeBody1 =>
      'Териңиз, чачыңыз жана денеңиз үчүн эксперттер текшерген тартиптер.';

  @override
  String get welcomeBody2 =>
      'Продуктуну сканерлеп, ар бир компонент эмне кыларын расмий булактар менен көрүңүз.';

  @override
  String get welcomeBody3 =>
      'Уйку, суу жана кыймыл: кичинекей адаттар бир жерде.';

  @override
  String get welcomeStart => 'Баштоо';

  @override
  String get welcomeBrowse => 'Аккаунтсуз кароо';

  @override
  String get welcomeSignIn => 'Менде аккаунт бар';

  @override
  String get ageTitle => 'Кайсы жылы төрөлгөнсүз?';

  @override
  String get ageWhy =>
      'Parla 18 жаштан жогоркуларга арналган. Биз толук күнүн эмес, жылын гана сактайбыз.';

  @override
  String get ageYearLabel => 'Туулган жыл';

  @override
  String get ageInvalid =>
      '1900-жыл менен ушул жылдын ортосундагы жылды киргизиңиз.';

  @override
  String get ageBirthdayQuestion => 'Быйыл туулган күнүңүз өтүп кеттиби?';

  @override
  String get yes => 'Ооба';

  @override
  String get no => 'Жок';

  @override
  String get underageTitle => 'Parla чоңдор үчүн';

  @override
  String get underageBody =>
      'Parla 18 жаштан жогорку адамдар үчүн гана жеткиликтүү. Сиз киргизген эч бир маалымат сакталган жок.';

  @override
  String get close => 'Жабуу';

  @override
  String get signInTitle => 'Кириңиз же аккаунт түзүңүз';

  @override
  String get signInBody =>
      'Электрондук почтаңызга бир жолку код жөнөтөбүз. Сырсөз керек эмес.';

  @override
  String get signInFailed => 'Кирүү ишке ашкан жок. Кайра аракет кылыңыз.';

  @override
  String get signInLegalNote =>
      'Аккаунт түзүү менен Колдонуу шарттарын кабыл аласыз. Маалыматтарыңыз кантип иштетилери Купуялык саясатында сүрөттөлгөн.';

  @override
  String get countryTitle => 'Кайда жашайсыз?';

  @override
  String get countryWhy =>
      'Маалыматтарыңыз өлкөңүздүн регионунда сакталат. Parla адегенде Азербайжанда ачылат.';

  @override
  String get countryComingSoon => 'Жакында';

  @override
  String get countryName_AZ => 'Азербайжан';

  @override
  String get countryName_TR => 'Түркия';

  @override
  String get countryName_KZ => 'Казакстан';

  @override
  String get countryName_UZ => 'Өзбекстан';

  @override
  String get consentTitle => 'Сиздин тандоолоруңуз';

  @override
  String get consentIntro =>
      'Ар бир макулдук өзүнчө жана демейки боюнча өчүрүлгөн. Колдонмо аларсыз да иштейт. Аларды каалаган убакта Жөндөөлөр → Купуялык бөлүмүнөн өзгөртө аласыз.';

  @override
  String get consentHealthTitle => 'Ден соолукка байланыштуу жооптор';

  @override
  String get consentHealthHint =>
      'Тери абалы, аллергия, кош бойлуулук жана дары-дармектер жөнүндөгү ыктыярдуу суроолор үчүн гана керек.';

  @override
  String get consentAnalyticsTitle => 'Колдонуу статистикасы';

  @override
  String get consentMarketingTitle =>
      'Электрондук почта аркылуу жаңылыктар жана кеңештер';

  @override
  String consentVersion(String version) {
    return 'Тексттин версиясы: $version';
  }

  @override
  String get guestTitle => 'Продукт издөө';

  @override
  String get guestPlaceholder =>
      'Продукт издөө жана сканерлөө кийинки версияда кошулат.';

  @override
  String get errorGeneric => 'Ката кетти. Кайра аракет кылыңыз.';

  @override
  String get error_age_minor =>
      'Parla 18 жаштан жогорку адамдар үчүн гана жеткиликтүү.';

  @override
  String get error_age_needs_confirmation =>
      'Туулган күн тууралуу суроого жооп бериңиз.';

  @override
  String get error_age_invalid => 'Туура туулган жылды киргизиңиз.';

  @override
  String get error_country_closed => 'Parla бул өлкөдө азырынча ачыла элек.';

  @override
  String get error_language_unsupported =>
      'Бул тил азырынча колдоого алынбайт.';

  @override
  String get error_profile_exists => 'Профилиңиз мурунтан эле бар.';

  @override
  String get error_consent_outdated_version =>
      'Макулдук тексти өзгөрдү. Сураныч, аны кайра карап чыгыңыз.';

  @override
  String get homeGreetingMorning => 'Кутман таң!';

  @override
  String get homeGreetingAfternoon => 'Кутман күн!';

  @override
  String get homeGreetingEvening => 'Кутман кеч!';

  @override
  String get homeTagline => 'Күн сайын бир аз көбүрөөк өзүң.';

  @override
  String get homeProfileButton => 'Профиль жана купуялык';

  @override
  String get routineSwitchLabel => 'Тартипти тандоо';

  @override
  String get routineMorning => 'Эртең менен';

  @override
  String get routineEvening => 'Кечинде';

  @override
  String get routineMorningTitle => 'Эртеңки тартип';

  @override
  String get routineEveningTitle => 'Кечки тартип';

  @override
  String get stepStatusDone => 'Даяр';

  @override
  String stepMarkDone(String step) {
    return '$step: аткарылды деп белгилөө';
  }

  @override
  String stepMarkUndone(String step) {
    return '$step: аткарылды, кайтаруу';
  }

  @override
  String routineDoneHeader(String routine) {
    return '$routine даяр';
  }

  @override
  String get routineDoneTitle => 'Бүгүн да жаркырадың.';

  @override
  String get routineDoneBody =>
      'Бардык кадамдар аткарылды. Кийинки тартипте көрүшөбүз.';

  @override
  String get routineRestart => 'Кайра баштоо';

  @override
  String get habitsTitle => 'Бүгүнкү адаттар';

  @override
  String get habitWater => 'Суу';

  @override
  String habitWaterCount(int count, int goal) {
    return '$count / $goal стакан';
  }

  @override
  String get habitWaterAdd => 'Бир стакан кошуу';

  @override
  String get habitWaterRemove => 'Бир стакан алып салуу';

  @override
  String get habitSleep => 'Уйку';

  @override
  String get habitMove => 'Кыймыл';

  @override
  String get habitNoEntry => 'Азырынча жазуу жок';

  @override
  String get habitLog => 'Белгилөө';

  @override
  String get navMenuLabel => 'Негизги меню';

  @override
  String get navToday => 'Бүгүн';

  @override
  String get comingSoon => 'Бул бөлүм кийинки версияда кошулат.';

  @override
  String get routineMorningEyebrow => 'ЭРТЕҢКИ ТАРТИП';

  @override
  String get routineEveningEyebrow => 'КЕЧКИ ТАРТИП';

  @override
  String get routineStatusStart => 'Баштайлы';

  @override
  String routineStatusLeft(int left) {
    return '$left кадам калды';
  }

  @override
  String get routineStatusDone => 'Баары даяр';

  @override
  String routineMinutesLeft(int minutes) {
    return 'Болжол менен $minutes мүнөт';
  }

  @override
  String routineProgressLabel(String routine, int done, int total) {
    return '$routine: $done / $total кадам аткарылды';
  }

  @override
  String get quizIntroTitle => 'Келиңиз, таанышалы.';

  @override
  String get quizIntroBody =>
      'Териңиз, чачыңыз жана күнүмдүк ритмиңиз тууралуу бир нече суроо. Болжол менен 3 мүнөт алат.';

  @override
  String get quizStart => 'Баштайлы';

  @override
  String get quizLater => 'Кийинчерээк';

  @override
  String quizProgress(int current, int total) {
    return 'Суроо $current / $total';
  }

  @override
  String get quizMultipleHint => 'Бир нечесин тандай аласыз';

  @override
  String get quizNext => 'Кийинки';

  @override
  String get quizBack => 'Артка';

  @override
  String get quizDecline => 'Жооп бергим келбейт';

  @override
  String get quizFinish => 'Бүтүрүү';

  @override
  String get healthGateTitle => 'Бир нече сезимтал суроо';

  @override
  String get healthGateBody =>
      'Кийинки суроолор тери диагноздору, аллергия, кош бойлуулук жана дары-дармектер жөнүндө. Алар тартипти коопсуз кылууга жардам берет. Жоопторуңуз шифрленет жана сиздин макулдугуңуз менен гана сакталат.';

  @override
  String get healthGateAgree => 'Макулмун, улантуу';

  @override
  String get healthGateSkip => 'Бул бөлүмдү өткөрүп жиберүү';

  @override
  String get healthGateSkipNote =>
      'Өткөрүп жиберсеңиз, тартип этиятыраак түзүлөт.';

  @override
  String get redFlagTitle => 'Муну дарыгерге көрсөтүңүз';

  @override
  String get redFlagBody =>
      'Сиз белгилеген белги дарыгердин текшерүүсүн талап кылышы мүмкүн. Parla диагноз койбойт жана дарыгерди алмаштырбайт. Дерматологго кайрылууну сунуштайбыз.';

  @override
  String get redFlagOk => 'Түшүндүм';

  @override
  String get resultTitle => 'Тартибиңиз даяр';

  @override
  String get resultSkin => 'Тери';

  @override
  String get resultHair => 'Чач';

  @override
  String get resultGoals => 'Тынчсыздануулар';

  @override
  String get resultSeeRoutine => 'Тартибимди көрсөт';

  @override
  String get recheckTitle => 'Жообуң дагы эле ушундайбы?';

  @override
  String recheckSkinBody(String answer, int months) {
    return 'Тестте кош бойлуулук тууралуу жообуң: «$answer». Муну $months ай мурун белгилегенсиң; тартибиң ошого жараша түзүлөт.';
  }

  @override
  String recheckSportBody(String answer, int months) {
    return 'Спорт сурамжылоосундагы жообуң: «$answer». Муну $months ай мурун белгилегенсиң; ошондуктан план жумшак.';
  }

  @override
  String get recheckYes => 'Ооба, ушундай';

  @override
  String get recheckChange => 'Өзгөрдү';

  @override
  String get recheckRemove => 'Жоопту өчүрүү';

  @override
  String get recheckChooseTitle => 'Азыр кандай?';

  @override
  String get recheckSaved => 'Сакталды.';

  @override
  String get recheckPrivacy =>
      'Жооп шифрленип сакталат жана тартибиң менен планың үчүн гана колдонулат. Жоопту өчүрсөң, тартип этият бойдон калат.';

  @override
  String get homeFocusTitle => 'Күндүн фокусу';

  @override
  String get homeFocusSub => 'Тартибиңдин негизинде';

  @override
  String get homeFocusDone =>
      'Бүгүнкү тартип аткарылды. Өзүңө бир аз убакыт бөл.';

  @override
  String get homeFocusOpen => 'Тартипти ачуу';

  @override
  String homeFocusSteps(int done, int total) {
    return '$done / $total кадам';
  }

  @override
  String get homePulse => 'Кыскача';

  @override
  String get homeLater => 'Дагы';

  @override
  String get homeQuizTitle => 'Тартибиңизди жекелештирели';

  @override
  String get homeQuizBody => '3 мүнөттүк тест — жана тартип сизге ыңгайлашат.';

  @override
  String get homeQuizStart => 'Тестти баштоо';

  @override
  String get error_consent_health_required =>
      'Бул жооптор үчүн ден соолук боюнча макулдук керек.';

  @override
  String get privacyTitle => 'Купуялык борбору';

  @override
  String get privacyIntro =>
      'Сенин маалыматың, сенин тандооң. Ар бир укугуң бир басуу аралыгында.';

  @override
  String get profileAccountTitle => 'Аккаунтуң';

  @override
  String get profileAccountNote => 'Атыңды сурабайбыз · электрондук почта гана';

  @override
  String get profileEmailLabel => 'Эл. почта';

  @override
  String get profileAgeLabel => 'Жаш';

  @override
  String get profileCountryLabel => 'Өлкө';

  @override
  String get profileLanguageLabel => 'Тил';

  @override
  String get privacyConsentsTitle => 'Макулдуктар';

  @override
  String get privacyHealthWithdrawTitle =>
      'Ден соолук боюнча макулдукту кайтарып аласызбы?';

  @override
  String get privacyHealthWithdrawBody =>
      'Ден соолук боюнча жоопторуңуз жана өз тартиптериңиздин сервердеги көчүрмөсү дароо өчүрүлөт, тартип этиятыраак түзүлөт. Өз тартиптериңиз бул телефондо калат. Макулдукту кийин кайра бере аласыз.';

  @override
  String get privacyWithdraw => 'Кайтарып алуу жана өчүрүү';

  @override
  String get privacyCancel => 'Жокко чыгаруу';

  @override
  String get privacyExportTitle => 'Маалыматымды жүктөп алуу';

  @override
  String get privacyExportBody =>
      'Parla сиз тууралуу сактаган бардык нерсе, ошондой эле бул телефондогу адат жазуулары, өз тартиптериңиз жана күндөлүгүңүз, бир файлда. Файл азыр түзүлөт жана биздин серверлерде сакталбайт.';

  @override
  String get privacyExportButton => 'Файл түзүү';

  @override
  String get privacyLegalTitle => 'Укуктук документтер';

  @override
  String get privacySignOut => 'Чыгуу';

  @override
  String get privacyDeleteTitle => 'Аккаунтту өчүрүү';

  @override
  String get deleteTitle => 'Аккаунтуңуз өчүрүлсүнбү?';

  @override
  String get deleteWhatGoes =>
      'Дароо өчүрүлөт: профилиңиз, тест жана ден соолук боюнча жоопторуңуз, серверде сакталган өз тартиптериңиз, сатып алуу тизмеңиз, спорт жана табак жазууларыңыз (шифрлөө ачкычы менен кошо), колдоо кызматы менен жазышууларыңыз жана кирүү аккаунтуңуз. Бул телефондогу адат жазуулары, күндөлүк жана сакталган рецепттер да өчүрүлөт.';

  @override
  String get deleteWhatStays =>
      'Электрондук почтаңызсыз жана аккаунтуңузга байланышпаган түрдө сакталат: далил катары макулдуктардын тарыхы (3 жыл) жана коопсуздук жазуулары (1 жыл), ал эми буйрутмаларыңыз (эгер болсо) бухгалтердик эсеп үчүн.';

  @override
  String get deleteExportFirst => 'Адегенде маалыматымды жүктөп алуу';

  @override
  String deleteConfirmLabel(String word) {
    return 'Ырастоо үчүн $word деп жазыңыз';
  }

  @override
  String get deleteConfirmWord => 'ӨЧҮР';

  @override
  String get deleteButton => 'Аккаунтумду өчүрүү';

  @override
  String get deletedTitle => 'Аккаунтуңуз өчүрүлдү';

  @override
  String get deletedBody =>
      'Биз менен болгонуңуз үчүн рахмат. Каалаган убакта кайтып келе аласыз.';

  @override
  String get legalTitle => 'Укуктук документтер';

  @override
  String get legalMedicalTitle => 'Медициналык кеңеш эмес';

  @override
  String get legalMedicalBody =>
      'Parla — кам көрүү гиди. Ал диагноз койбойт, дарылабайт жана дарыгерди алмаштырбайт. Тери оорулары же тынчсыздандырган белгилер болсо, дерматологго кайрылыңыз.';

  @override
  String get legalPolicyTitle => 'Купуялык саясаты жана колдонуу шарттары';

  @override
  String get legalPolicyBody =>
      'Бул документтер юрист менен даярдалууда жана ишке киргизүүдөн мурун ушул жерде пайда болот.';

  @override
  String get legalPrivacyPolicy => 'Купуялык саясаты';

  @override
  String get legalTerms => 'Колдонуу шарттары';

  @override
  String get legalConsentsTitle => 'Макулдук тексттери';

  @override
  String get habitEdit => 'Өзгөртүү';

  @override
  String get habitSleepSheetTitle => 'Өткөн түнү канча уктадыңыз?';

  @override
  String get habitMoveSheetTitle => 'Бүгүн канча кыймылдадыңыз?';

  @override
  String habitSleepHours(String hours) {
    return '$hours саат';
  }

  @override
  String habitMoveMinutes(int minutes) {
    return '$minutes мүн';
  }

  @override
  String get habitLess => 'Азайтуу';

  @override
  String get habitMore => 'Көбөйтүү';

  @override
  String get habitSave => 'Сактоо';

  @override
  String get habitClearEntry => 'Жазууну өчүрүү';

  @override
  String get habitsScreenTitle => 'Тартип';

  @override
  String get habitsScreenIntro => 'Кичинекей кадамдар, өз темпиңиз менен.';

  @override
  String get habitsToday => 'Бүгүн';

  @override
  String get habitsWeekTitle => 'Акыркы 7 күн';

  @override
  String get habitsWeekCare => 'Тартипке убакыт бөлгөн күндөрүңүз';

  @override
  String habitsWeekCareValue(int days) {
    return '7 күндөн $days';
  }

  @override
  String get habitsWeekNone => 'Азырынча жазуу жок';

  @override
  String habitsWeekWaterValue(String glasses) {
    return 'Күнүнө орточо $glasses стакан';
  }

  @override
  String habitsWeekSleepValue(String hours, int nights) {
    return 'Орточо $hours саат, $nights түн белгиленген';
  }

  @override
  String habitsWeekMoveValue(int minutes, int days) {
    return 'Бардыгы $minutes мүн, $days күн';
  }

  @override
  String get habitsPrivacyNote =>
      'Адат жазууларыңыз бул телефондо гана сакталат жана серверге жөнөтүлбөйт. 90 күндөн эски жазуулар автоматтык түрдө өчүрүлөт.';

  @override
  String get privacyHabitsTitle => 'Бул телефондогу адат жазуулары';

  @override
  String get privacyHabitsBody =>
      'Суу, уйку, кыймыл жана тартип жазуулары бул телефондо гана сакталат. Аларды каалаган убакта өчүрө аласыз.';

  @override
  String get privacyHabitsDelete => 'Жазууларды өчүрүү';

  @override
  String get privacyHabitsDeleteTitle => 'Адат жазуулары өчүрүлсүнбү?';

  @override
  String get privacyHabitsDeleteBody =>
      'Бул телефондогу бардык суу, уйку, кыймыл жана тартип жазууларыңыз өчүрүлөт. Муну кайтаруу мүмкүн эмес.';

  @override
  String get privacyHabitsDeleted => 'Адат жазуулары өчүрүлдү.';

  @override
  String get remindersTitle => 'Эскертмелер';

  @override
  String get remindersIntro =>
      'Билдирмелерди телефонуңуз өзү көрсөтөт, серверге эч нерсе жөнөтүлбөйт. Каалаган убакта өчүрө аласыз.';

  @override
  String get remindersOpen => 'Жөндөө';

  @override
  String get remindersSummaryOff => 'Баары өчүк';

  @override
  String remindersSummaryOn(int count) {
    return 'Күйүк: $count';
  }

  @override
  String get reminderMorningTitle => 'Эртеңки тартип';

  @override
  String get reminderEveningTitle => 'Кечки тартип';

  @override
  String get reminderSleepTitle => 'Уйку жазуусу';

  @override
  String get reminderMorningBody => 'Эртеңки тартиптин убагы келди.';

  @override
  String get reminderEveningBody => 'Кечки тартиптин убагы келди.';

  @override
  String get reminderSleepBody => 'Өткөн түндү белгилегиңиз келеби?';

  @override
  String reminderAt(String time) {
    return 'Саат $time';
  }

  @override
  String get reminderChangeTime => 'Убакытты өзгөртүү';

  @override
  String get reminderTimeSheetTitle => 'Качан эскертели?';

  @override
  String get reminderPermissionDenied =>
      'Билдирмелерге уруксат берилген жок. Аны телефондун жөндөөлөрүнөн күйгүзө аласыз.';

  @override
  String get remindersNote =>
      'Тексттер нейтралдуу жана кулпу экранында ден соолук тууралуу маалымат көрсөтпөйт. Билдирме бир нече мүнөт кечигип келиши мүмкүн.';

  @override
  String get productsTitle => 'Продуктуну текшерүү';

  @override
  String get productsIntro =>
      'Продуктунун атын же брендин жазып, курамын караңыз.';

  @override
  String get productsSearchLabel => 'Продукттун аты же бренд';

  @override
  String get productsSearchButton => 'Издөө';

  @override
  String get productsQueryTooShort => 'Кеминде 2 тамга жазыңыз.';

  @override
  String get productsNotFoundTitle => 'Эч нерсе табылган жок';

  @override
  String get productsNotFoundBody =>
      'Башкача жазылышын же бренддин атын текшериңиз. Базада азырынча ар бир продукт жок.';

  @override
  String get productsSourceObf => 'Open Beauty Facts';

  @override
  String get productsSourceParla => 'Parla каталогу';

  @override
  String get error_product_query_invalid => 'Издөө 2–80 белгиден турушу керек.';

  @override
  String get error_product_source_unavailable =>
      'Продукт базасы азыр жооп бербей жатат. Бир аздан кийин кайра аракет кылыңыз.';

  @override
  String get productIngredientsTitle => 'Курамы';

  @override
  String get productNoIngredients =>
      'Бул продукт үчүн курам тизмеси жок. Кутудагы тизмени караңыз.';

  @override
  String productIngredientCount(int count) {
    return '$count компонент';
  }

  @override
  String productListedCount(int count) {
    return '$count компонент үчүн ЕБ жазуусу бар';
  }

  @override
  String get productStatusesMissing =>
      'Компоненттердин статустары азырынча жүктөлө элек. Азыр курам тизмеси гана көрсөтүлүүдө.';

  @override
  String get productDataNotice =>
      'Курам тизмеси коомчулуктун базасынан алынат жана анда каталар болушу мүмкүн. Кутудагы тизме менен салыштырыңыз.';

  @override
  String productLegalNotice(String date) {
    return 'Статустар ЕБнин 1223/2009 Регламентинин тиркемелерине негизделген (CosIng, $date). Аталыштар автоматтык түрдө дал келтирилет. Бул Азербайжандын эрежеси эмес жана продукттун коопсуздугуна берилген баа эмес.';
  }

  @override
  String get productAttribution =>
      'Продукт маалыматтары: Open Beauty Facts, ODbL лицензиясы менен.';

  @override
  String get annexIIShort => 'ЕБ: тыюу салынган заттардын тизмесинде';

  @override
  String get annexIIIShort => 'ЕБ: чектөөлөр менен уруксат берилген';

  @override
  String get annexIVShort => 'ЕБ: уруксат берилген боёгуч';

  @override
  String get annexVShort => 'ЕБ: уруксат берилген консервант';

  @override
  String get annexVIShort => 'ЕБ: уруксат берилген УК-фильтр';

  @override
  String annexEntry(String annex, String reference) {
    return 'Тиркеме $annex, катар № $reference';
  }

  @override
  String get annexConditionsLabel =>
      'Расмий шарттар (CosIng\'деги бойдон, англисче)';

  @override
  String get ingredientNoEntry =>
      'ЕБнин тиркемелеринде өзүнчө жазуу табылган жок';

  @override
  String ingredientSheetSource(String date) {
    return 'Булак: CosIng, $date';
  }

  @override
  String get ingredientDetailsHint => 'Кененирээк';

  @override
  String get navRoutine => 'Тартип';

  @override
  String get navCheck => 'Текшерүү';

  @override
  String get navSport => 'Спорт';

  @override
  String get navDiscover => 'Ачылыштар';

  @override
  String get navProfile => 'Профиль';

  @override
  String get sportTitle => 'Спорт';

  @override
  String get discoverTitle => 'Ачылыштар';

  @override
  String get discoverBlogs => 'Блогдор';

  @override
  String get discoverBlogsHint => 'Кам көрүү, сулуулук, мода';

  @override
  String get discoverExperts => 'Адистер';

  @override
  String get discoverExpertsHint => 'Дерматолог, косметолог';

  @override
  String get discoverNutrition => 'Тамактануу';

  @override
  String get discoverNutritionHint => 'Күнүмдүк табак жана рецепттер';

  @override
  String get discoverShopping => 'Сатып алуу тизмеси';

  @override
  String get discoverShoppingHint => 'Керектүүлөрдү белгилеп ал';

  @override
  String get discoverShop => 'Дүкөн';

  @override
  String get discoverShopHint => 'Тартибиңдеги продуктылар';

  @override
  String get soonBadge => 'Жакында';

  @override
  String get onboardingStepAbout => 'Таанышуу';

  @override
  String get onboardingStepAccount => 'Аккаунт';

  @override
  String get onboardingStepCountry => 'Өлкө';

  @override
  String get onboardingStepPrivacy => 'Купуялык';

  @override
  String get routineAreaFace => 'Бет';

  @override
  String get routineAreaHair => 'Чач';

  @override
  String get routineAreaBody => 'Дене';

  @override
  String get routineSlotMorning => 'Эртең менен';

  @override
  String get routineSlotEvening => 'Кечинде';

  @override
  String get routineSlotWeekly => 'Жумалык';

  @override
  String get routineWeeklyHint =>
      'Жумасына бир жолу. Белгилер дүйшөмбүдө жаңыланат.';

  @override
  String get routineSlotEmpty => 'Бул убакыт үчүн кадам жок.';

  @override
  String get routineOwnButton => 'Өз тартибиң';

  @override
  String get routineOwnSection => 'Өз тартиптериң';

  @override
  String get routineOwnEmpty =>
      'Өз тартибиңди түзүп, бул жерден көзөмөлдөй аласың.';

  @override
  String get routineOwnEveryDay => 'Күн сайын';

  @override
  String routineOwnSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count кадам',
      one: '1 кадам',
    );
    return '$_temp0';
  }

  @override
  String routineOwnEdit(String name) {
    return 'Өзгөртүү: $name';
  }

  @override
  String get routineDayHabits => 'Күн ичинде';

  @override
  String get builderTitleNew => 'Өз тартибиңди түз';

  @override
  String get builderTitleEdit => 'Тартипти өзгөртүү';

  @override
  String get builderName => 'Аталышы';

  @override
  String get builderNameHint => 'Мис. Жекшембилик спа';

  @override
  String get builderArea => 'Бөлүм';

  @override
  String get builderWhen => 'Качан';

  @override
  String get builderEveryDay => 'Күн сайын';

  @override
  String get builderOnceWeek => 'Жумасына бир жолу';

  @override
  String get builderSteps => 'Кадамдар';

  @override
  String get builderStepHint => 'Жаңы кадам';

  @override
  String get builderAddStep => 'Кошуу';

  @override
  String get builderSuggestions => 'Даяр кадамдардан танда';

  @override
  String builderMoveUp(String step) {
    return 'Жогору: $step';
  }

  @override
  String builderMoveDown(String step) {
    return 'Төмөн: $step';
  }

  @override
  String builderRemoveStep(String step) {
    return 'Өчүрүү: $step';
  }

  @override
  String get builderSave => 'Сактоо';

  @override
  String get builderDelete => 'Тартипти өчүрүү';

  @override
  String get builderDeleteConfirm => 'Бул тартип өчүрүлсүнбү?';

  @override
  String get builderDeleteYes => 'Өчүрүү';

  @override
  String get builderCancel => 'Жокко чыгаруу';

  @override
  String get builderNeedName => 'Тартипке ат бер.';

  @override
  String get builderNeedStep => 'Кеминде бир кадам кош.';

  @override
  String builderLimit(int count) {
    return 'Эң көп $count кадам.';
  }

  @override
  String get todayRoutinesTitle => 'Бүгүнкү тартиптер';

  @override
  String get todayRoutinesAll => 'Баары';

  @override
  String get todayRoutinesNone => 'Бүгүн үчүн башка тартип жок.';

  @override
  String get builderPrivacySynced =>
      'Өз тартиптериң серверде шифрленип сакталат, ал эми бул телефондо офлайн үчүн көчүрмөсү калат.';

  @override
  String get builderPrivacyDevice =>
      'Өз тартиптериң азырынча бул телефондо гана сакталат. Жаңыртылган ден соолук макулдугу менен серверде шифрленип сакталат.';

  @override
  String get checkPrefsTitle => 'Сенин тандоолоруң';

  @override
  String get checkPrefsEdit => 'Өзгөртүү';

  @override
  String get checkPrefsEmpty =>
      'Сен үчүн маанилүүсүн танда, курамды тандоолоруң менен салыштырабыз.';

  @override
  String get checkPrefsAdd => 'Тандоо кошуу';

  @override
  String get checkPrefsSheetTitle => 'Сен үчүн эмне маанилүү?';

  @override
  String get checkPrefsSave => 'Сактоо';

  @override
  String get checkBarcodeSoon => 'Штрих-код сканери · жакында';

  @override
  String get checkRecentTitle => 'Акыркы текшерилгендер';

  @override
  String get checkRecentClear => 'Тазалоо';

  @override
  String get resultPrefsTitle => 'Сенин тандоолоруң менен';

  @override
  String resultPrefsSummary(int fits, int count) {
    return 'Тандоолоруңдан $fits / $count туура келет';
  }

  @override
  String get resultPrefFits => 'Туура келет';

  @override
  String resultPrefContains(String names) {
    return 'Курамында бар: $names';
  }

  @override
  String get resultPrefVeganFits =>
      'Белгилүү жаныбар тектүү компонент табылган жок';

  @override
  String get resultPrefUnknown =>
      'Курам тизмеси жок болгондуктан текшерүү мүмкүн эмес';

  @override
  String get resultPrefsNone =>
      'Тандоолоруңду кош, курамды алар менен салыштырабыз.';

  @override
  String get resultPrefsNote =>
      'Parla продуктыларды баалабайт жана упай бербейт. Дал келүү сенин тандоолоруңа жана курам тизмесине гана негизделет.';

  @override
  String get resultAddToList => 'Сатып алуу тизмесине';

  @override
  String get resultInList => 'Тизмеде бар';

  @override
  String get resultAdded => 'Сатып алуу тизмесине кошулду.';

  @override
  String shoppingCount(int bought, int total) {
    return '$bought / $total сатылып алынды';
  }

  @override
  String get shoppingNewHint => 'Жаңы продукт';

  @override
  String get shoppingAdd => 'Кошуу';

  @override
  String get shoppingEmpty =>
      'Тизме бош. Керектүүлөрдү ушул жерге белгилеп ал.';

  @override
  String get shoppingAreaOther => 'Башка';

  @override
  String get shoppingFromCheck => 'Текшерүү бөлүмүнөн';

  @override
  String shoppingRemove(String title) {
    return 'Өчүрүү: $title';
  }

  @override
  String get shoppingRemoveBought => 'Алынгандарды өчүрүү';

  @override
  String shoppingFull(int count) {
    return 'Тизмеде эң көп $count продукт болушу мүмкүн.';
  }

  @override
  String get careListSynced =>
      'Тандоолоруң жана сатып алуу тизмең серверде шифрленип сакталат, ал эми бул телефондо офлайн үчүн көчүрмөсү калат.';

  @override
  String get careListDevice =>
      'Тандоолоруң жана сатып алуу тизмең азырынча бул телефондо гана сакталат. Жаңыртылган ден соолук макулдугу менен серверде шифрленип сакталат.';

  @override
  String get shopTitle => 'Parla Дүкөнү';

  @override
  String get shopBody =>
      'Тартибиңдеги продуктылар бир басуу менен. Сатып алуу тизмеңди түз эле буйрутма кылып, тандоолоруңа туура келген продуктыларды таба аласың.';

  @override
  String get shopSoonCard => 'Parla Дүкөнү';

  @override
  String get shopSoonCardBody => 'Өнөктөштөрдүн продуктыларын кара';

  @override
  String get shopOpenList => 'Сатып алуу тизмемди көрүү';

  @override
  String get shopIntro =>
      'Өнөктөштөрдүн продуктылары. Сатып алуу өнөктөштүн сайтында болот; Parla сен тууралуу эч нерсе бербейт.';

  @override
  String get shopAll => 'Баары';

  @override
  String get shopCategoryFace => 'Бет';

  @override
  String get shopCategoryHair => 'Чач';

  @override
  String get shopCategoryBody => 'Дене';

  @override
  String get shopCategoryMakeup => 'Макияж';

  @override
  String get shopCategoryOther => 'Башка';

  @override
  String shopPrice(String price) {
    return '$price ₼';
  }

  @override
  String get shopVisitPartner => 'Өнөктөштүн сайтына өтүү';

  @override
  String get shopPriceNote =>
      'Баасы жана бар-жогу өнөктөштүн сайтында өзгөрүшү мүмкүн. Сатып алардан мурун курамын текшер; териңде көйгөй болсо, дарыгер менен кеңеш.';

  @override
  String get shopEmpty => 'Азырынча продукт жок. Жакында ушул жерде болот.';

  @override
  String get shopMyOrders => 'Буйрутмаларым';

  @override
  String get shopBuy => 'Сатып алуу';

  @override
  String get shopBuyTitle => 'Буйрутманы ырастоо';

  @override
  String shopBuyBody(String product, String price, String seller) {
    return '$product: $price. $seller Төлөм Epoint барагында жүргүзүлөт; картаңдын маалыматы Parla\'га келбейт.';
  }

  @override
  String get shopSellerParla => 'Сатуучу: Parla.';

  @override
  String shopSellerBrand(String brand) {
    return 'Сатуучу: $brand, төлөмдү Parla кабыл алат.';
  }

  @override
  String get shopBuyGo => 'Төлөмгө өтүү';

  @override
  String get shopBuyError =>
      'Төлөм барагы ачылган жок. Бир аздан кийин кайра аракет кыл.';

  @override
  String get shopTooMany =>
      'Акыркы бир саатта өтө көп буйрутма баштадың. Бир аздан кийин кайра аракет кыл.';

  @override
  String get shopOrdersEmpty => 'Азырынча буйрутмаң жок.';

  @override
  String shopOrderMeta(String number, String date, int quantity) {
    return '$number · $date · $quantity даана';
  }

  @override
  String get shopOrderCreated => 'Төлөм күтүлүүдө';

  @override
  String get shopOrderPaid => 'Төлөндү';

  @override
  String get shopOrderFailed => 'Төлөм ишке ашкан жок';

  @override
  String get shopOrderShipped => 'Жөнөтүлдү';

  @override
  String get shopOrderDelivered => 'Жеткирилди';

  @override
  String get shopOrderCancelled => 'Жокко чыгарылды';

  @override
  String get shopOrderRefunded => 'Акча кайтарылды';

  @override
  String get sportIntroTitle => 'Сага ылайык спорт планы';

  @override
  String get sportIntroBody =>
      'Бир нече суроо: максат, аймактар, жакшы көргөн машыгууларың. Андан кийин жумалык план, сеттер, кайталоолор жана таймер. Музыка өз колдонмоңдон ойнойт.';

  @override
  String get sportStart => 'Баштоо';

  @override
  String get sportNext => 'Улантуу';

  @override
  String get sportNeedOne => 'Кеминде бирөөнү танда.';

  @override
  String get sportQGoals => 'Максатың эмне?';

  @override
  String get sportQGoalsHint => '2ге чейин танда';

  @override
  String get sportGoalTone => 'Тонус жана тыгыздык';

  @override
  String get sportGoalMuscle => 'Булчуң массасын көбөйтүү';

  @override
  String get sportGoalFlexibility => 'Ийкемдүүлүк';

  @override
  String get sportGoalPosture => 'Дене түзүлүшү';

  @override
  String get sportGoalEndurance => 'Чыдамкайлык';

  @override
  String get sportGoalRelax => 'Стресстен эс алуу';

  @override
  String get sportQAreas => 'Кайсы аймактарга көңүл буралы?';

  @override
  String get sportAreasNote =>
      'Бир аймактан гана май күйгүзүү мүмкүн эмес. Бул кыймылдар ошол булчуңдарды бекемдеп, тонус берет.';

  @override
  String get sportAreaArms => 'Колдор';

  @override
  String get sportAreaLegs => 'Буттар';

  @override
  String get sportAreaCore => 'Ич жана кор';

  @override
  String get sportAreaGlutes => 'Жамбаш';

  @override
  String get sportAreaBack => 'Арка';

  @override
  String get sportAreaFull => 'Бүт дене';

  @override
  String get sportQTypes => 'Кандай машыгууларды каалайсың?';

  @override
  String get sportTypeFitness => 'Фитнес';

  @override
  String get sportTypePilates => 'Пилатес';

  @override
  String get sportTypeWallPilates => 'Дубал пилатеси';

  @override
  String get sportTypeStretching => 'Стретчинг';

  @override
  String get sportTypeCardio => 'Жеңил кардио';

  @override
  String get sportTypeFaceYoga => 'Бет йогасы';

  @override
  String get sportTypeYoga => 'Йога';

  @override
  String get sportYogaMorning => 'Эртеңки агым';

  @override
  String get sportYogaEvening => 'Кечки тынчтык';

  @override
  String get sportYogaStretch => 'Созулуу жана бошоңдоо';

  @override
  String sportSessionCardBody(int count, int minutes) {
    return '$count кыймыл · болжол менен $minutes мүн';
  }

  @override
  String get sportYogaSafetyTitle => 'Баштаардан мурун';

  @override
  String get sportYogaSafetyBody =>
      'Акырын кыймылда, демиңди кармаба, оорусаң токто. Кош бойлуу болсоң, кан басымың жогору болсо, белиңде, тизеңде же билегиңде жаракат болсо, адегенде дарыгерге кайрыл. Сурамжылоодо жаракат же кош бойлуулукту белгилесең, сага туура келбеген позалар сеанстан алынып салынат.';

  @override
  String sportFaceYogaCardBody(int minutes) {
    return '12 кыймыл · болжол менен $minutes мүн. Күзгүнүн алдында, каалаган убакта.';
  }

  @override
  String get sportFaceYogaSafetyTitle => 'Баштаардан мурун';

  @override
  String get sportFaceYogaSafetyBody =>
      'Колуңузду жууңуз, териге жеңил гана тийиңиз, терини тартпаңыз. Ооруса же ыңгайсыз болсо, токтотуңуз. Жакында косметикалык процедурадан (ботокс, филлер) өткөн болсоңуз, жаак муунунда же териде көйгөй болсо, адегенде дарыгерге кайрылыңыз.';

  @override
  String get sportQLevel => 'Деңгээлиң кандай?';

  @override
  String get sportLevelBeginner => 'Жаңы баштап жатам';

  @override
  String get sportLevelIntermediate => 'Орто';

  @override
  String get sportLevelAdvanced => 'Тажрыйбалуу';

  @override
  String get sportQSchedule => 'Канча убактың бар?';

  @override
  String get sportDaysLabel => 'Жумасына канча күн';

  @override
  String get sportMinutesLabel => 'Бир машыгуу';

  @override
  String sportDays(int count) {
    return '$count күн';
  }

  @override
  String sportMinutes(int count) {
    return '$count мүн';
  }

  @override
  String get sportDumbbells => 'Үйдө гантелим бар';

  @override
  String get sportQSafety => 'Коопсуздук үчүн';

  @override
  String get sportSafetyIntro =>
      'Бул жооптор сага туура келбеген кыймылдарды пландан алып салуу үчүн гана.';

  @override
  String get sportPregnancyLabel => 'Кош бойлуулук';

  @override
  String get sportPregNo => 'Жок';

  @override
  String get sportPregPregnant => 'Кош бойлуумун';

  @override
  String get sportPregPostpartum => 'Акыркы 6 айда төрөдүм';

  @override
  String get sportInjuriesLabel => 'Оору же жаракат';

  @override
  String get sportInjKnee => 'Тизе';

  @override
  String get sportInjBack => 'Бел';

  @override
  String get sportInjShoulder => 'Ийин';

  @override
  String get sportInjWrist => 'Билек';

  @override
  String get sportDoctorLimit =>
      'Дарыгер спортту чектеген же адегенде суроону айткан';

  @override
  String get sportBuildPlan => 'Планды түзүү';

  @override
  String get sportWeekTitle => 'Бул жума';

  @override
  String sportWeekProgress(int done, int total) {
    return '$done / $total машыгуу';
  }

  @override
  String sportWorkoutTitle(int number) {
    return 'Машыгуу $number';
  }

  @override
  String get sportWorkoutName_w6 => 'Жеңил созулуу';

  @override
  String get sportWorkoutName_w7 => 'Жуманын финалы';

  @override
  String get sportWorkoutName_p6 => 'Жумшак агым';

  @override
  String get sportWorkoutName_p7 => 'Борбор финалы';

  @override
  String get sportWorkoutName_v6 => 'Дубалда эс алуу';

  @override
  String get sportWorkoutName_v7 => 'Дубал финалы';

  @override
  String get sportEveryDay => 'Күн сайын';

  @override
  String get sportWeekdaysLabel => 'Кайсы күндөрү?';

  @override
  String sportWeekdaysHint(int count) {
    return '$count күн танда. Ортодогу күндөр эс алуу үчүн.';
  }

  @override
  String get sportEveryDayNote =>
      'Күн сайын: булчуңдар калыбына келиши үчүн жумасына эки күн жеңил созулуу болот.';

  @override
  String sportWeekday(String day) {
    String _temp0 = intl.Intl.selectLogic(
      day,
      {
        '1': 'Дш',
        '2': 'Шш',
        '3': 'Шр',
        '4': 'Бш',
        '5': 'Жм',
        '6': 'Иш',
        'other': 'Жк',
      },
    );
    return '$_temp0';
  }

  @override
  String sportPickWeekdays(int count) {
    return 'Так $count күн танда.';
  }

  @override
  String get sportMonthTitle => 'Айлык план';

  @override
  String sportMonthProgress(int day, int week) {
    return 'Күн $day / 28 · Жума $week';
  }

  @override
  String get sportLegendDone => 'аткарылды';

  @override
  String get sportLegendWorkout => 'машыгуу';

  @override
  String get sportLegendRest => 'эс алуу';

  @override
  String get sportToday => 'Бүгүн';

  @override
  String get sportRestToday => 'Бүгүн эс алуу күнү';

  @override
  String sportNextOn(String when) {
    return 'Кийинки машыгуу: $when';
  }

  @override
  String sportWeekBadge(int week) {
    return 'Жума $week';
  }

  @override
  String get sportRecoveryWeek => 'Калыбына келүү жумасы';

  @override
  String sportCardMeta(int minutes, int moves) {
    return '$minutes мүн · $moves кыймыл';
  }

  @override
  String get sportMonthDoneTitle => 'Ай аяктады';

  @override
  String sportMonthDoneBody(int done) {
    return '$done машыгуу аткарылды. Кийинки айдан мурун жоопторуңду жана деңгээлиңди текшерели.';
  }

  @override
  String get sportNewMonth => 'Кийинки ай';

  @override
  String sportMonthCalendar(int done, int left) {
    return 'Ай календары: $done машыгуу аткарылды, $left калды';
  }

  @override
  String get sportWorkoutName_w1 => 'Күчтүү старт';

  @override
  String get sportWorkoutName_w2 => 'Бут күнү';

  @override
  String get sportWorkoutName_w3 => 'Бүт дене';

  @override
  String get sportWorkoutName_w4 => 'Энергия толкуну';

  @override
  String get sportWorkoutName_w5 => 'Күч жана тең салмак';

  @override
  String get sportWorkoutName_p1 => 'Борборду ойготуу';

  @override
  String get sportWorkoutName_p2 => 'Жумшак агым';

  @override
  String get sportWorkoutName_p3 => 'Дене түзүлүшү жана дем';

  @override
  String get sportWorkoutName_p4 => 'Узун сызыктар';

  @override
  String get sportWorkoutName_p5 => 'Тынч күч';

  @override
  String get sportWorkoutName_v1 => 'Дубал менен таанышуу';

  @override
  String get sportWorkoutName_v2 => 'Дубал таянычы';

  @override
  String get sportWorkoutName_v3 => 'Дубалда агым';

  @override
  String get sportWorkoutName_v4 => 'Дубал ритми';

  @override
  String get sportWorkoutName_v5 => 'Дубал балансы';

  @override
  String sportWorkoutMeta(String type, int minutes) {
    return '$type · ~$minutes мүн';
  }

  @override
  String get sportDone => 'Аткарылды';

  @override
  String get sportNextLabel => 'Кийинки';

  @override
  String get sportEditAnswers => 'Сурамжылоону жаңыртуу';

  @override
  String get sportBlockedTitle => 'Адегенде дарыгериң менен сүйлөш';

  @override
  String get sportBlockedBody =>
      'Дарыгер спортту чектесе, план түзбөйбүз. Уруксат алганда сурамжылоону жаңырт.';

  @override
  String get sportGentleNote =>
      'Кош бойлуулук жана төрөттөн кийинки мезгил үчүн жеңил план. Баштаардан мурун дарыгериңден сура.';

  @override
  String get sportDraftNote =>
      'Кыймылдар жана сандар азырынча машыктыруучу тарабынан текшериле элек. Оору сезсең, токто.';

  @override
  String get sportAllDone => 'Бул жуманын бардык машыгуулары аткарылды.';

  @override
  String sportSetsReps(int sets, int reps) {
    return '$sets × $reps кайталоо';
  }

  @override
  String sportSetsSeconds(int sets, int seconds) {
    return '$sets × $seconds сек';
  }

  @override
  String sportRestSeconds(int seconds) {
    return 'Эс алуу $seconds сек';
  }

  @override
  String get sportStartWorkout => 'Машыгууну баштоо';

  @override
  String get sportMusicNote =>
      'Видеолордун өз музыкасы бар, аны баскыч менен өчүрө аласың. Parla сигнал да берет.';

  @override
  String get sportVideoSoundOn => 'Видеонун үнү күйүк';

  @override
  String get sportVideoSoundOff => 'Видеонун үнү өчүк';

  @override
  String get sportSoundOn => 'Сигнал үнү күйүк';

  @override
  String get sportSoundOff => 'Сигнал үнү өчүк, титирөө гана';

  @override
  String sportSetOf(int set, int sets) {
    return 'Сет $set / $sets';
  }

  @override
  String sportRepsNow(int reps) {
    return '$reps кайталоо';
  }

  @override
  String get sportPause => 'Тыныгуу';

  @override
  String get sportResume => 'Улантуу';

  @override
  String get sportResting => 'Эс алуу';

  @override
  String sportNextUp(String name) {
    return 'Андан кийин: $name';
  }

  @override
  String sportExerciseOf(int index, int total) {
    return 'Кыймыл $index / $total';
  }

  @override
  String get sportFinishedTitle => 'Машыгуу бүттү';

  @override
  String sportFinishedBody(int minutes) {
    return '$minutes мүнөт кыймыл бүгүнкү жазууга кошулду.';
  }

  @override
  String get sportBackToPlan => 'Планга кайтуу';

  @override
  String get sportQuit => 'Машыгууну токтотуу';

  @override
  String get sportGetReady => 'Даярдан';

  @override
  String get sportPrevious => 'Мурунку кыймыл';

  @override
  String get sportNextMove => 'Кийинки';

  @override
  String get sportStopTitle => 'Машыгууну токтотобузбу?';

  @override
  String get sportStopBody => 'Бул машыгуу аткарылды деп белгиленбейт.';

  @override
  String get sportStopConfirm => 'Токтотуу';

  @override
  String get sportKeepGoing => 'Улантуу';

  @override
  String sportRepPace(int seconds) {
    return 'Ар бир кайталоо болжол менен $seconds сек. Тезирээк бүтүрсөң, «Кийинки» баскычын бас.';
  }

  @override
  String get sportPrivacySynced =>
      'Спорт жоопторуң серверде шифрленип сакталат, ал эми бул телефондо офлайн үчүн көчүрмөсү калат.';

  @override
  String get sportPrivacyDevice =>
      'Спорт жоопторуң азырынча бул телефондо гана сакталат. Жаңыртылган ден соолук макулдугу менен серверде шифрленип сакталат.';

  @override
  String get discoverLatest => 'Жаңы макалалар';

  @override
  String get discoverAll => 'Баары';

  @override
  String get expertSample => 'Үлгү';

  @override
  String get expertSampleNote =>
      'Бул үлгү профиль, байланыш маалыматтары иштебейт.';

  @override
  String get discoverJournal => 'Күндөлүк';

  @override
  String get discoverJournalHint => 'Сен үчүн гана, бул телефондо';

  @override
  String get journalIntro =>
      'Күнүң тууралуу жаз. Жазуулар бул телефондо гана, шифрленип сакталат; Parla командасы аларды көрбөйт. Телефонду алмаштырсаң же колдонмону өчүрсөң, жоголот. Сактап калуу үчүн: Профиль → Маалыматымды жүктөп алуу.';

  @override
  String get journalNew => 'Жаңы жазуу';

  @override
  String get journalEmpty => 'Азырынча жазуу жок.';

  @override
  String get journalHint => 'Бүгүн кандай өттү?';

  @override
  String get journalEntryTitle => 'Жазуу';

  @override
  String get journalSave => 'Сактоо';

  @override
  String get journalDelete => 'Өчүрүү';

  @override
  String get journalDeleteTitle => 'Бул жазуу өчүрүлсүнбү?';

  @override
  String get journalDeleteBody => 'Кайтаруу мүмкүн болбойт.';

  @override
  String get journalFull =>
      'Күндөлүк толду. Жаңы жазуу үчүн эскилеринин бирин өчүр.';

  @override
  String get discoverSportHint => 'Жумалык планың';

  @override
  String discoverArticleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count макала',
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
  String get contentEmpty => 'Азырынча макала жок. Жакында ушул жерде болот.';

  @override
  String get contentOffline =>
      'Интернет жок, акыркы жүктөлгөн көчүрмө көрсөтүлүүдө.';

  @override
  String blogMeta(String category, int minutes) {
    return '$category · $minutes мүн';
  }

  @override
  String blogReviewed(String date) {
    return 'Адис текшерген · $date';
  }

  @override
  String get blogTips => 'Кыска кадамдар';

  @override
  String get catCare => 'Кам көрүү';

  @override
  String get catBeauty => 'Сулуулук';

  @override
  String get catFashion => 'Мода';

  @override
  String get catHair => 'Чач';

  @override
  String get specDermatologist => 'Дерматолог';

  @override
  String get specCosmetologist => 'Косметолог';

  @override
  String get specTrainer => 'Машыктыруучу';

  @override
  String get specDietitian => 'Диетолог';

  @override
  String get specTrichologist => 'Трихолог';

  @override
  String expertYears(int years) {
    return '$years жылдык тажрыйба';
  }

  @override
  String get expertCall => 'Чалуу';

  @override
  String get expertWhatsapp => 'WhatsApp';

  @override
  String get expertInstagram => 'Instagram';

  @override
  String get expertsNote =>
      'Parla адистерди тааныштырат гана, алардын кызматтары үчүн жоопкерчилик тартпайт. Байланыш колдонмодон тышкары, түз эле адис менен түзүлөт; Parla маекти көрбөйт.';

  @override
  String get nutritionHero => 'Сулуулук табактан башталат';

  @override
  String get nutritionPlate => 'Бүгүнкү табак';

  @override
  String nutritionPlateCount(int count, int total) {
    return '$count / $total топ';
  }

  @override
  String get groupVegetables => 'Жашылча';

  @override
  String get groupFruit => 'Мөмө-жемиш';

  @override
  String get groupProtein => 'Белок';

  @override
  String get groupWholeGrain => 'Бүтүн дан';

  @override
  String get groupHealthyFat => 'Пайдалуу май';

  @override
  String get groupDairy => 'Сүт азыгы';

  @override
  String nutritionWater(int count, int goal) {
    return 'Суу: $count / $goal стакан';
  }

  @override
  String get nutritionNoCalories =>
      'Табакта калория санабайбыз. Жөн гана ар түрдүүлүк: күн сайын түстүү табак.';

  @override
  String get nutritionTip => 'Күндүн кеңеши';

  @override
  String get nutritionRecipes => 'Сулуулук рецепттери';

  @override
  String get nutritionDisclaimer =>
      'Бул жалпы маалымат, диета же медициналык сунуш эмес. Атайын тамактануу муктаждыгың болсо, диетолог менен кеңеш.';

  @override
  String get nutritionPrivacySynced =>
      'Табак жазууларың серверде шифрленип сакталат, ал эми бул телефондо офлайн үчүн көчүрмөсү калат.';

  @override
  String get nutritionPrivacyDevice =>
      'Табак жазууларың азырынча бул телефондо гана сакталат. Жаңыртылган ден соолук макулдугу менен серверде шифрленип сакталат.';

  @override
  String get mealBreakfast => 'Эртең мененки тамак';

  @override
  String get mealLunch => 'Түшкү тамак';

  @override
  String get mealDinner => 'Кечки тамак';

  @override
  String get mealSnack => 'Жеңил тамак';

  @override
  String recipeMeta(String meal, int minutes, int servings) {
    return '$meal · $minutes мүн · $servings кишилик';
  }

  @override
  String get recipeIngredients => 'Курамы';

  @override
  String get recipeSteps => 'Даярдалышы';

  @override
  String get recipeAddAll => 'Курамын сатып алуу тизмесине кошуу';

  @override
  String get recipeSave => 'Рецептти сактоо';

  @override
  String get recipeUnsave => 'Сакталгандардан алып салуу';

  @override
  String get nutritionDailyRecipe => 'Бүгүнкү сунуш';

  @override
  String get nutritionPlateIdeas => 'Табагыңды толукта';

  @override
  String get nutritionPlateIdeasNote =>
      'Бүгүн тандай элек топторуң үчүн рецепттер.';

  @override
  String get nutritionSaved => 'Сакталгандар';

  @override
  String recipeKcal(int kcal) {
    return '≈ $kcal ккал · 1 порция (болжолдуу)';
  }

  @override
  String recipeAdded(int count) {
    return '$count продукт сатып алуу тизмесине кошулду.';
  }

  @override
  String get skinCardTitle => 'Тери анализи';

  @override
  String get skinCardBody => 'Суроолорго жооп берип, териңди кайра талдап көр.';

  @override
  String get catBody => 'Дене';

  @override
  String get blogSources => 'Булактар';

  @override
  String get blogRelated => 'Окшош макалалар';

  @override
  String recipeAllergens(String list) {
    return 'Курамында: $list';
  }

  @override
  String get recipeNoAllergens => '14 негизги аллергендин бири да жок.';

  @override
  String get allergenGluten => 'глютен';

  @override
  String get allergenCrustaceans => 'рак сымалдуулар';

  @override
  String get allergenEgg => 'жумуртка';

  @override
  String get allergenFish => 'балык';

  @override
  String get allergenPeanuts => 'жер жаңгагы';

  @override
  String get allergenSoy => 'соя';

  @override
  String get allergenMilk => 'сүт';

  @override
  String get allergenNuts => 'жаңгактар';

  @override
  String get allergenCelery => 'сельдерей';

  @override
  String get allergenMustard => 'горчица';

  @override
  String get allergenSesame => 'кунжут';

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
  String get bannerLeaveTitle => 'Башка сайтка өтүп жатасың';

  @override
  String bannerLeaveBody(String host) {
    return '$host сайты браузерде ачылат. Parla бул сайтка сен тууралуу эч кандай маалымат жөнөтпөйт; сайттын өз купуялык эрежелери бар.';
  }

  @override
  String get bannerLeaveGo => 'Сайтка өтүү';

  @override
  String get bannerLeaveCancel => 'Жокко чыгаруу';

  @override
  String get messagesTitle => 'Билдирүүлөр';

  @override
  String get messagesButton => 'Билдирүүлөр';

  @override
  String get messagesButtonUnread => 'Билдирүүлөр, жаңы жооп бар';

  @override
  String get messagesFromParla => 'Parla\'дан';

  @override
  String get messagesNone => 'Азырынча кулактандыруу жок.';

  @override
  String get supportTitle => 'Колдоо';

  @override
  String get supportIntro =>
      'Сурооңду жаз, Parla командасы жооп берет. Билдирүүлөр шифрленип сакталат жана акыркы билдирүүдөн 12 ай өткөндөн кийин өчүрүлөт. Биз медициналык кеңеш бербейбиз: шашылыш же олуттуу учурда дарыгерге кайрыл.';

  @override
  String get supportHint => 'Билдирүүң';

  @override
  String get supportSend => 'Жөнөтүү';

  @override
  String get supportYou => 'Сен';

  @override
  String get supportTeam => 'Parla командасы';

  @override
  String get supportSent => 'Жөнөтүлдү.';

  @override
  String get pushTitle => 'Билдирмелер';

  @override
  String get pushBody =>
      'Колдоо кызматы жооп бергенде кабар аласың. Маркетинг макулдугун берсең, Parla\'нын жаңылыктары да келет. Каалаган убакта өчүрө аласың.';

  @override
  String get pushDenied =>
      'Билдирмелерге уруксат берилген жок. Телефондун жөндөөлөрүнөн күйгүзө аласың.';

  @override
  String get checkSuggestTitle => 'Тестиңе жараша сунуш';

  @override
  String get checkSuggestBody =>
      'Тесттеги жоопторуңа жараша бул тандоолор сага туура келиши мүмкүн. Кошуу же кошпоо — сенин чечимиң.';

  @override
  String checkSuggestAdd(String name) {
    return '$name кошуу';
  }

  @override
  String get consentRefreshCardTitle => 'Макулдук тексти жаңыртылды';

  @override
  String get consentRefreshCardBody =>
      'Ден соолук маалыматтары боюнча макулдуктун жаңы версиясы бар. Окуп, макул болсоң, тартиптериң, тизмелериң, спорт жана тамактануу жазууларың шифрленген серверде да сакталат. Макул болбосоң, алар бул телефондо гана калат.';

  @override
  String get consentRefreshOpen => 'Окуу';

  @override
  String get consentRefreshTitle => 'Ден соолук маалыматтары боюнча макулдук';

  @override
  String get consentRefreshIntro =>
      'Бул мурда макул болгон тексттин жаңы версиясы. Макул болуу ыктыярдуу; каалаган убакта Купуялык бөлүмүнөн кайтарып ала аласың.';

  @override
  String get consentRefreshAgree => 'Макулмун';

  @override
  String get consentRefreshLater => 'Азыр эмес';

  @override
  String get consentRefreshDone => 'Макулдук жаңыртылды.';

  @override
  String get appearanceTitle => 'Көрүнүш';

  @override
  String get appearanceSystem => 'Система';

  @override
  String get appearanceLight => 'Жарык';

  @override
  String get appearanceDark => 'Караңгы';
}
