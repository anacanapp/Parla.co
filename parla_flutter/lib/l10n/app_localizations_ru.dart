// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Parla';

  @override
  String get languageTitle => 'Выберите язык';

  @override
  String get languageName_az => 'Azərbaycanca';

  @override
  String get languageName_ru => 'Русский';

  @override
  String get languageName_en => 'English';

  @override
  String get continueButton => 'Продолжить';

  @override
  String get welcomeTitle => 'Ваш персональный гид по уходу';

  @override
  String get welcomeBody1 =>
      'Уход за кожей, волосами и телом, проверенный экспертами.';

  @override
  String get welcomeBody2 =>
      'Отсканируйте продукт и узнайте, что делает каждый ингредиент, с официальными источниками.';

  @override
  String get welcomeBody3 =>
      'Сон, вода и движение: небольшие привычки в одном месте.';

  @override
  String get welcomeStart => 'Начать';

  @override
  String get welcomeBrowse => 'Смотреть без аккаунта';

  @override
  String get welcomeSignIn => 'У меня уже есть аккаунт';

  @override
  String get ageTitle => 'В каком году вы родились?';

  @override
  String get ageWhy =>
      'Parla предназначена для людей от 18 лет. Мы храним только год, а не полную дату.';

  @override
  String get ageYearLabel => 'Год рождения';

  @override
  String get ageInvalid => 'Введите год от 1900 до текущего.';

  @override
  String get ageBirthdayQuestion => 'У вас уже был день рождения в этом году?';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get underageTitle => 'Parla для взрослых';

  @override
  String get underageBody =>
      'Parla доступна только людям от 18 лет. Введённые вами данные не сохранены.';

  @override
  String get close => 'Закрыть';

  @override
  String get signInTitle => 'Войдите или создайте аккаунт';

  @override
  String get signInBody =>
      'Мы отправим одноразовый код на вашу почту. Пароль не нужен.';

  @override
  String get signInFailed => 'Не удалось войти. Попробуйте ещё раз.';

  @override
  String get countryTitle => 'Где вы живёте?';

  @override
  String get countryWhy =>
      'Ваши данные хранятся в регионе вашей страны. Сначала Parla открывается в Азербайджане.';

  @override
  String get countryComingSoon => 'Скоро';

  @override
  String get countryName_AZ => 'Азербайджан';

  @override
  String get countryName_TR => 'Турция';

  @override
  String get countryName_KZ => 'Казахстан';

  @override
  String get countryName_UZ => 'Узбекистан';

  @override
  String get consentTitle => 'Ваш выбор';

  @override
  String get consentIntro =>
      'Каждое согласие отдельное и по умолчанию выключено. Приложение работает и без них, а изменить их можно в любой момент в разделе Настройки → Конфиденциальность.';

  @override
  String get consentHealthTitle => 'Ответы, связанные со здоровьем';

  @override
  String get consentHealthHint =>
      'Нужно только для необязательных вопросов о состоянии кожи, аллергиях, беременности и лекарствах.';

  @override
  String get consentAnalyticsTitle => 'Статистика использования';

  @override
  String get consentMarketingTitle => 'Новости и советы по почте';

  @override
  String consentVersion(String version) {
    return 'Версия текста: $version';
  }

  @override
  String get guestTitle => 'Поиск продуктов';

  @override
  String get guestPlaceholder =>
      'Поиск и сканирование продуктов появятся в следующей версии.';

  @override
  String get errorGeneric => 'Что-то пошло не так. Попробуйте ещё раз.';

  @override
  String get error_age_minor => 'Parla доступна только людям от 18 лет.';

  @override
  String get error_age_needs_confirmation =>
      'Ответьте, пожалуйста, на вопрос о дне рождения.';

  @override
  String get error_age_invalid => 'Введите корректный год рождения.';

  @override
  String get error_country_closed => 'Parla пока не работает в этой стране.';

  @override
  String get error_language_unsupported => 'Этот язык пока не поддерживается.';

  @override
  String get error_profile_exists => 'Ваш профиль уже существует.';

  @override
  String get error_consent_outdated_version =>
      'Текст согласия изменился. Пожалуйста, просмотрите его ещё раз.';

  @override
  String get homeGreetingMorning => 'Доброе утро!';

  @override
  String get homeGreetingAfternoon => 'Добрый день!';

  @override
  String get homeGreetingEvening => 'Добрый вечер!';

  @override
  String get homeTagline => 'С каждым днём — немного больше себя.';

  @override
  String get homeProfileButton => 'Профиль и конфиденциальность';

  @override
  String get routineSwitchLabel => 'Выбор ухода';

  @override
  String get routineMorning => 'Утро';

  @override
  String get routineEvening => 'Вечер';

  @override
  String get routineMorningTitle => 'Утренний уход';

  @override
  String get routineEveningTitle => 'Вечерний уход';

  @override
  String get stepStatusDone => 'Готово';

  @override
  String stepMarkDone(String step) {
    return '$step: отметить';
  }

  @override
  String stepMarkUndone(String step) {
    return '$step: выполнено, отменить';
  }

  @override
  String routineDoneHeader(String routine) {
    return '$routine: готово';
  }

  @override
  String get routineDoneTitle => 'Сегодня ты снова сияешь.';

  @override
  String get routineDoneBody => 'Все шаги выполнены. До следующего ухода.';

  @override
  String get routineRestart => 'Начать заново';

  @override
  String get habitsTitle => 'Привычки на сегодня';

  @override
  String get habitWater => 'Вода';

  @override
  String habitWaterCount(int count, int goal) {
    return '$count из $goal стаканов';
  }

  @override
  String get habitWaterAdd => 'Добавить стакан';

  @override
  String get habitWaterRemove => 'Убрать стакан';

  @override
  String get habitSleep => 'Сон';

  @override
  String get habitMove => 'Движение';

  @override
  String get habitNoEntry => 'Пока нет записей';

  @override
  String get habitLog => 'Записать';

  @override
  String get scanTitle => 'Проверить продукт';

  @override
  String get scanBody =>
      'Отсканируй штрихкод и посмотри состав простыми словами';

  @override
  String get navMenuLabel => 'Главное меню';

  @override
  String get navToday => 'Сегодня';

  @override
  String get navScan => 'Скан';

  @override
  String get navHabits => 'Привычки';

  @override
  String get navProfile => 'Профиль';

  @override
  String get comingSoon => 'Этот раздел появится в следующей версии.';

  @override
  String get routineMorningEyebrow => 'УТРЕННИЙ УХОД';

  @override
  String get routineEveningEyebrow => 'ВЕЧЕРНИЙ УХОД';

  @override
  String get routineStatusStart => 'Начнём';

  @override
  String routineStatusLeft(int left) {
    String _temp0 = intl.Intl.pluralLogic(
      left,
      locale: localeName,
      other: 'Осталось $left шагов',
      few: 'Осталось $left шага',
      one: 'Остался 1 шаг',
    );
    return '$_temp0';
  }

  @override
  String get routineStatusDone => 'Всё готово';

  @override
  String routineMinutesLeft(int minutes) {
    return 'Примерно $minutes мин';
  }

  @override
  String routineProgressLabel(String routine, int done, int total) {
    return '$routine: выполнено $done из $total';
  }

  @override
  String get quizIntroTitle => 'Давайте познакомимся.';

  @override
  String get quizIntroBody =>
      'Несколько вопросов о коже, волосах и вашем ритме дня. Это займёт около 3 минут.';

  @override
  String get quizStart => 'Начнём';

  @override
  String get quizLater => 'Позже';

  @override
  String quizProgress(int current, int total) {
    return 'Вопрос $current из $total';
  }

  @override
  String get quizMultipleHint => 'Можно выбрать несколько';

  @override
  String get quizNext => 'Далее';

  @override
  String get quizBack => 'Назад';

  @override
  String get quizDecline => 'Предпочитаю не отвечать';

  @override
  String get quizFinish => 'Готово';

  @override
  String get healthGateTitle => 'Несколько деликатных вопросов';

  @override
  String get healthGateBody =>
      'Следующие вопросы — о диагнозах кожи, аллергиях, беременности и лекарствах. Они помогают сделать уход безопасным. Ответы шифруются и хранятся только с вашего согласия.';

  @override
  String get healthGateAgree => 'Даю согласие, продолжить';

  @override
  String get healthGateSkip => 'Пропустить раздел';

  @override
  String get healthGateSkipNote =>
      'Если пропустить, уход будет подобран осторожнее.';

  @override
  String get redFlagTitle => 'Покажите это врачу';

  @override
  String get redFlagBody =>
      'Отмеченный признак может требовать осмотра врача. Parla не ставит диагнозы и не заменяет врача. Рекомендуем обратиться к дерматологу.';

  @override
  String get redFlagOk => 'Понятно';

  @override
  String get resultTitle => 'Ваш уход готов';

  @override
  String get resultSkin => 'Кожа';

  @override
  String get resultHair => 'Волосы';

  @override
  String get resultGoals => 'Цели';

  @override
  String get resultSeeRoutine => 'Показать мой уход';

  @override
  String get resultExclusionPregnancy =>
      'Мы не добавили ретинол: не рекомендуем его при беременности, кормлении грудью или если на этот вопрос нет ответа.';

  @override
  String get resultExclusionMedication =>
      'Мы не добавили ретинол: вопрос о лекарствах без ответа или вы используете препарат для кожи по рецепту. Посоветуйтесь с врачом.';

  @override
  String get resultExclusionSensitive =>
      'Для чувствительной кожи мы выбрали успокаивающие шаги вместо активных средств.';

  @override
  String get homeQuizTitle => 'Давайте настроим уход под вас';

  @override
  String get homeQuizBody => 'Тест на 3 минуты — и уход подстроится под вас.';

  @override
  String get homeQuizStart => 'Начать тест';

  @override
  String get error_consent_health_required =>
      'Для этих ответов нужно согласие на данные о здоровье.';

  @override
  String get resultExclusionRetinoidBoth =>
      'Мы не добавили ретинол: без ответов о беременности и лекарствах мы его не рекомендуем.';

  @override
  String get privacyTitle => 'Центр конфиденциальности';

  @override
  String get privacyIntro =>
      'Ваши данные — ваш выбор. Каждое право — в одно касание.';

  @override
  String get privacyConsentsTitle => 'Согласия';

  @override
  String get privacyHealthWithdrawTitle =>
      'Отозвать согласие на данные о здоровье?';

  @override
  String get privacyHealthWithdrawBody =>
      'Ваши ответы о здоровье будут сразу удалены, а уход будет подобран осторожнее. Согласие можно дать снова позже.';

  @override
  String get privacyWithdraw => 'Отозвать и удалить';

  @override
  String get privacyCancel => 'Отмена';

  @override
  String get privacyExportTitle => 'Скачать мои данные';

  @override
  String get privacyExportBody =>
      'Файл со всем, что Parla хранит о вас. Он создаётся сейчас и не сохраняется на наших серверах.';

  @override
  String get privacyExportButton => 'Создать файл';

  @override
  String get privacyLegalTitle => 'Юридические документы';

  @override
  String get privacySignOut => 'Выйти';

  @override
  String get privacyDeleteTitle => 'Удалить аккаунт';

  @override
  String get deleteTitle => 'Удалить аккаунт?';

  @override
  String get deleteWhatGoes =>
      'Сразу удаляются: профиль, ответы теста, ответы о здоровье и их ключ шифрования, аккаунт для входа.';

  @override
  String get deleteWhatStays =>
      'Остаются как доказательство, без имени и почты: история согласий (3 года) и записи безопасности (1 год).';

  @override
  String get deleteExportFirst => 'Сначала скачать мои данные';

  @override
  String deleteConfirmLabel(String word) {
    return 'Введите $word для подтверждения';
  }

  @override
  String get deleteConfirmWord => 'УДАЛИТЬ';

  @override
  String get deleteButton => 'Удалить мой аккаунт';

  @override
  String get deletedTitle => 'Аккаунт удалён';

  @override
  String get deletedBody =>
      'Спасибо, что были с нами. Вы всегда можете вернуться.';

  @override
  String get legalTitle => 'Юридические документы';

  @override
  String get legalMedicalTitle => 'Не медицинский совет';

  @override
  String get legalMedicalBody =>
      'Parla — гид по уходу. Она не ставит диагнозы, не лечит и не заменяет врача. При заболеваниях кожи или тревожных признаках обратитесь к дерматологу.';

  @override
  String get legalPolicyTitle => 'Политика конфиденциальности и условия';

  @override
  String get legalPolicyBody =>
      'Эти документы готовятся с юристом и появятся здесь до запуска.';

  @override
  String get legalConsentsTitle => 'Тексты согласий';
}
