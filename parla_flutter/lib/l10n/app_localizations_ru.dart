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
  String get navMenuLabel => 'Главное меню';

  @override
  String get navToday => 'Сегодня';

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
  String get resultGoals => 'Что беспокоит';

  @override
  String get resultSeeRoutine => 'Показать мой уход';

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
      'Ваши ответы о здоровье и копия ваших рутин на сервере будут сразу удалены, а уход будет подобран осторожнее. Ваши рутины останутся на этом телефоне. Согласие можно дать снова позже.';

  @override
  String get privacyWithdraw => 'Отозвать и удалить';

  @override
  String get privacyCancel => 'Отмена';

  @override
  String get privacyExportTitle => 'Скачать мои данные';

  @override
  String get privacyExportBody =>
      'Всё, что Parla хранит о вас, а также записи о привычках, ваши собственные рутины и дневник с этого телефона, в одном файле. Файл создаётся сейчас и не хранится на наших серверах.';

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
      'Сразу удаляются: профиль, ответы теста, ответы о здоровье, ваши рутины и их ключ шифрования, аккаунт для входа. Записи о привычках и копия ваших рутин на этом телефоне тоже удаляются.';

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

  @override
  String get habitEdit => 'Изменить';

  @override
  String get habitSleepSheetTitle => 'Сколько вы спали прошлой ночью?';

  @override
  String get habitMoveSheetTitle => 'Сколько вы сегодня двигались?';

  @override
  String habitSleepHours(String hours) {
    return '$hours ч';
  }

  @override
  String habitMoveMinutes(int minutes) {
    return '$minutes мин';
  }

  @override
  String get habitLess => 'Меньше';

  @override
  String get habitMore => 'Больше';

  @override
  String get habitSave => 'Сохранить';

  @override
  String get habitClearEntry => 'Удалить запись';

  @override
  String get habitsScreenTitle => 'Рутина';

  @override
  String get habitsScreenIntro => 'Маленькие шаги в вашем темпе.';

  @override
  String get habitsToday => 'Сегодня';

  @override
  String get habitsWeekTitle => 'Последние 7 дней';

  @override
  String get habitsWeekCare => 'Дни, когда вы уделили время уходу';

  @override
  String habitsWeekCareValue(int days) {
    return '$days из 7 дней';
  }

  @override
  String get habitsWeekNone => 'Пока нет записей';

  @override
  String habitsWeekWaterValue(String glasses) {
    return 'В среднем $glasses стак. в день';
  }

  @override
  String habitsWeekSleepValue(String hours, int nights) {
    return 'В среднем $hours ч, записано ночей: $nights';
  }

  @override
  String habitsWeekMoveValue(int minutes, int days) {
    return 'Всего $minutes мин, дней: $days';
  }

  @override
  String get habitsPrivacyNote =>
      'Записи о привычках хранятся только на этом телефоне и не отправляются на сервер. Записи старше 90 дней удаляются автоматически.';

  @override
  String get privacyHabitsTitle => 'Записи о привычках на этом телефоне';

  @override
  String get privacyHabitsBody =>
      'Записи о воде, сне, движении и уходе хранятся только на этом телефоне. Вы можете удалить их в любой момент.';

  @override
  String get privacyHabitsDelete => 'Удалить записи';

  @override
  String get privacyHabitsDeleteTitle => 'Удалить записи о привычках?';

  @override
  String get privacyHabitsDeleteBody =>
      'Все записи о воде, сне, движении и уходе на этом телефоне будут удалены. Это нельзя отменить.';

  @override
  String get privacyHabitsDeleted => 'Записи о привычках удалены.';

  @override
  String get remindersTitle => 'Напоминания';

  @override
  String get remindersIntro =>
      'Уведомления показывает сам телефон, ничего не отправляется на сервер. Их можно выключить в любой момент.';

  @override
  String get remindersOpen => 'Настроить';

  @override
  String get remindersSummaryOff => 'Все выключены';

  @override
  String remindersSummaryOn(int count) {
    return 'Включено: $count';
  }

  @override
  String get reminderMorningTitle => 'Утренний уход';

  @override
  String get reminderEveningTitle => 'Вечерний уход';

  @override
  String get reminderSleepTitle => 'Запись сна';

  @override
  String get reminderMorningBody => 'Время утреннего ухода.';

  @override
  String get reminderEveningBody => 'Время вечернего ухода.';

  @override
  String get reminderSleepBody => 'Хотите записать прошлую ночь?';

  @override
  String reminderAt(String time) {
    return 'В $time';
  }

  @override
  String get reminderChangeTime => 'Изменить время';

  @override
  String get reminderTimeSheetTitle => 'Когда напомнить?';

  @override
  String get reminderPermissionDenied =>
      'Разрешение на уведомления не дано. Его можно включить в настройках телефона.';

  @override
  String get remindersNote =>
      'Тексты нейтральные и не показывают на экране блокировки данные о здоровье. Уведомление может прийти на несколько минут позже.';

  @override
  String get productsTitle => 'Проверить продукт';

  @override
  String get productsIntro => 'Введите название или бренд и посмотрите состав.';

  @override
  String get productsSearchLabel => 'Название или бренд';

  @override
  String get productsSearchButton => 'Найти';

  @override
  String get productsQueryTooShort => 'Введите хотя бы 2 буквы.';

  @override
  String get productsNotFoundTitle => 'Ничего не найдено';

  @override
  String get productsNotFoundBody =>
      'Попробуйте другое написание или название бренда. В базе пока есть не все продукты.';

  @override
  String get productsSourceObf => 'Open Beauty Facts';

  @override
  String get productsSourceParla => 'Каталог Parla';

  @override
  String get error_product_query_invalid =>
      'Запрос должен быть от 2 до 80 символов.';

  @override
  String get error_product_source_unavailable =>
      'База продуктов сейчас не отвечает. Попробуйте чуть позже.';

  @override
  String get productIngredientsTitle => 'Состав';

  @override
  String get productNoIngredients =>
      'Для этого продукта нет списка ингредиентов. Посмотрите состав на упаковке.';

  @override
  String productIngredientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ингредиента',
      many: '$count ингредиентов',
      few: '$count ингредиента',
      one: '1 ингредиент',
    );
    return '$_temp0';
  }

  @override
  String productListedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Для $count ингредиентов есть записи ЕС',
      one: 'Для 1 ингредиента есть запись ЕС',
    );
    return '$_temp0';
  }

  @override
  String get productStatusesMissing =>
      'Статусы ингредиентов ещё не загружены. Пока показан только список ингредиентов.';

  @override
  String get productDataNotice =>
      'Список ингредиентов взят из открытой базы и может содержать ошибки. Сверьте его с упаковкой.';

  @override
  String productLegalNotice(String date) {
    return 'Статусы основаны на приложениях к Регламенту ЕС 1223/2009 (CosIng, $date). Названия сопоставляются автоматически. Это не правила Азербайджана и не оценка безопасности продукта.';
  }

  @override
  String get productAttribution =>
      'Данные о продукте: Open Beauty Facts, лицензия ODbL.';

  @override
  String get annexIIShort => 'ЕС: в списке запрещённых веществ';

  @override
  String get annexIIIShort => 'ЕС: разрешено с ограничениями';

  @override
  String get annexIVShort => 'ЕС: разрешённый краситель';

  @override
  String get annexVShort => 'ЕС: разрешённый консервант';

  @override
  String get annexVIShort => 'ЕС: разрешённый УФ-фильтр';

  @override
  String annexEntry(String annex, String reference) {
    return 'Приложение $annex, № $reference';
  }

  @override
  String get annexConditionsLabel =>
      'Официальные условия (как в CosIng, на английском)';

  @override
  String get ingredientNoEntry =>
      'В приложениях ЕС отдельной записи не найдено';

  @override
  String ingredientSheetSource(String date) {
    return 'Источник: CosIng, $date';
  }

  @override
  String get ingredientDetailsHint => 'Подробнее';

  @override
  String get navRoutine => 'Рутина';

  @override
  String get navCheck => 'Проверка';

  @override
  String get navSport => 'Спорт';

  @override
  String get navDiscover => 'Обзор';

  @override
  String get navProfile => 'Профиль';

  @override
  String get sportTitle => 'Спорт';

  @override
  String get discoverTitle => 'Обзор';

  @override
  String get discoverBlogs => 'Блоги';

  @override
  String get discoverBlogsHint => 'Уход, красота, мода';

  @override
  String get discoverExperts => 'Специалисты';

  @override
  String get discoverExpertsHint => 'Дерматолог, косметолог';

  @override
  String get discoverNutrition => 'Питание';

  @override
  String get discoverNutritionHint => 'Тарелка дня и рецепты';

  @override
  String get discoverShopping => 'Список покупок';

  @override
  String get discoverShoppingHint => 'Отмечай нужное';

  @override
  String get discoverShop => 'Магазин';

  @override
  String get discoverShopHint => 'Продукты из твоей рутины';

  @override
  String get soonBadge => 'Скоро';

  @override
  String get onboardingStepAbout => 'Знакомство';

  @override
  String get onboardingStepAccount => 'Аккаунт';

  @override
  String get onboardingStepCountry => 'Страна';

  @override
  String get onboardingStepPrivacy => 'Приватность';

  @override
  String get routineAreaFace => 'Лицо';

  @override
  String get routineAreaHair => 'Волосы';

  @override
  String get routineAreaBody => 'Тело';

  @override
  String get routineSlotMorning => 'Утро';

  @override
  String get routineSlotEvening => 'Вечер';

  @override
  String get routineSlotWeekly => 'Раз в неделю';

  @override
  String get routineWeeklyHint =>
      'Раз в неделю. Отметки обновляются в понедельник.';

  @override
  String get routineSlotEmpty => 'На это время шагов нет.';

  @override
  String get routineOwnButton => 'Своя рутина';

  @override
  String get routineOwnSection => 'Твои рутины';

  @override
  String get routineOwnEmpty => 'Создай свою рутину и отмечай её здесь.';

  @override
  String get routineOwnEveryDay => 'Каждый день';

  @override
  String routineOwnSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count шага',
      many: '$count шагов',
      few: '$count шага',
      one: '$count шаг',
    );
    return '$_temp0';
  }

  @override
  String routineOwnEdit(String name) {
    return 'Изменить: $name';
  }

  @override
  String get routineDayHabits => 'В течение дня';

  @override
  String get builderTitleNew => 'Своя рутина';

  @override
  String get builderTitleEdit => 'Изменить рутину';

  @override
  String get builderName => 'Название';

  @override
  String get builderNameHint => 'Например, СПА в воскресенье';

  @override
  String get builderArea => 'Раздел';

  @override
  String get builderWhen => 'Когда';

  @override
  String get builderEveryDay => 'Каждый день';

  @override
  String get builderOnceWeek => 'Раз в неделю';

  @override
  String get builderSteps => 'Шаги';

  @override
  String get builderStepHint => 'Новый шаг';

  @override
  String get builderAddStep => 'Добавить';

  @override
  String get builderSuggestions => 'Готовые шаги';

  @override
  String builderMoveUp(String step) {
    return 'Выше: $step';
  }

  @override
  String builderMoveDown(String step) {
    return 'Ниже: $step';
  }

  @override
  String builderRemoveStep(String step) {
    return 'Удалить: $step';
  }

  @override
  String get builderSave => 'Сохранить';

  @override
  String get builderDelete => 'Удалить рутину';

  @override
  String get builderDeleteConfirm => 'Удалить эту рутину?';

  @override
  String get builderDeleteYes => 'Удалить';

  @override
  String get builderCancel => 'Отмена';

  @override
  String get builderNeedName => 'Дай рутине название.';

  @override
  String get builderNeedStep => 'Добавь хотя бы один шаг.';

  @override
  String builderLimit(int count) {
    return 'Не больше $count шагов.';
  }

  @override
  String get todayRoutinesTitle => 'Рутины на сегодня';

  @override
  String get todayRoutinesAll => 'Все';

  @override
  String get todayRoutinesNone => 'На сегодня других рутин нет.';

  @override
  String get builderPrivacySynced =>
      'Твои рутины хранятся на сервере в зашифрованном виде, а на этом телефоне остаётся копия для работы без сети.';

  @override
  String get builderPrivacyDevice =>
      'Пока твои рутины хранятся только на этом телефоне. С обновлённым согласием на данные о здоровье они будут храниться на сервере в зашифрованном виде.';

  @override
  String get checkPrefsTitle => 'Твои предпочтения';

  @override
  String get checkPrefsEdit => 'Изменить';

  @override
  String get checkPrefsEmpty =>
      'Выбери, что для тебя важно, и мы сравним состав с твоими предпочтениями.';

  @override
  String get checkPrefsAdd => 'Добавить предпочтения';

  @override
  String get checkPrefsSheetTitle => 'Что для тебя важно?';

  @override
  String get checkPrefsSave => 'Сохранить';

  @override
  String get checkBarcodeSoon => 'Сканер штрихкода · скоро';

  @override
  String get checkRecentTitle => 'Недавно проверенные';

  @override
  String get checkRecentClear => 'Очистить';

  @override
  String get resultPrefsTitle => 'По твоим предпочтениям';

  @override
  String resultPrefsSummary(int fits, int count) {
    return 'Подходит $fits из $count предпочтений';
  }

  @override
  String get resultPrefFits => 'Подходит';

  @override
  String resultPrefContains(String names) {
    return 'В составе есть: $names';
  }

  @override
  String get resultPrefVeganFits =>
      'Известных компонентов животного происхождения не найдено';

  @override
  String get resultPrefUnknown => 'Нельзя проверить: нет списка состава';

  @override
  String get resultPrefsNone =>
      'Добавь свои предпочтения, и мы сравним с ними состав.';

  @override
  String get resultPrefsNote =>
      'Parla не оценивает продукты и не ставит баллы. Совпадение основано только на твоих предпочтениях и списке состава.';

  @override
  String get resultAddToList => 'В список покупок';

  @override
  String get resultInList => 'Уже в списке';

  @override
  String get resultAdded => 'Добавлено в список покупок.';

  @override
  String shoppingCount(int bought, int total) {
    return 'Куплено $bought из $total';
  }

  @override
  String get shoppingNewHint => 'Новый продукт';

  @override
  String get shoppingAdd => 'Добавить';

  @override
  String get shoppingEmpty =>
      'Список пуст. Отмечай здесь то, что нужно купить.';

  @override
  String get shoppingAreaOther => 'Другое';

  @override
  String get shoppingFromCheck => 'Из раздела «Проверка»';

  @override
  String shoppingRemove(String title) {
    return 'Удалить: $title';
  }

  @override
  String get shoppingRemoveBought => 'Удалить купленное';

  @override
  String shoppingFull(int count) {
    return 'В списке может быть не больше $count позиций.';
  }

  @override
  String get careListSynced =>
      'Твои предпочтения и список покупок хранятся на сервере в зашифрованном виде, а на этом телефоне остаётся копия для работы без сети.';

  @override
  String get careListDevice =>
      'Пока твои предпочтения и список покупок хранятся только на этом телефоне. С обновлённым согласием на данные о здоровье они будут храниться на сервере в зашифрованном виде.';

  @override
  String get shopTitle => 'Parla Магазин';

  @override
  String get shopBody =>
      'Продукты из твоей рутины в одно касание. Ты сможешь заказать список покупок напрямую и находить продукты по своим предпочтениям.';

  @override
  String get shopSoonCard => 'Parla Магазин скоро';

  @override
  String get shopSoonCardBody => 'Ты сможешь заказать список напрямую';

  @override
  String get shopOpenList => 'Открыть мой список покупок';

  @override
  String get sportIntroTitle => 'План тренировок для тебя';

  @override
  String get sportIntroBody =>
      'Несколько вопросов: цель, зоны, любимые тренировки. Затем план на неделю, подходы и повторы, таймер. Музыка играет из твоего приложения.';

  @override
  String get sportStart => 'Начать';

  @override
  String get sportNext => 'Далее';

  @override
  String get sportNeedOne => 'Выбери хотя бы один вариант.';

  @override
  String get sportQGoals => 'Какая у тебя цель?';

  @override
  String get sportQGoalsHint => 'Выбери до двух';

  @override
  String get sportGoalTone => 'Тонус и упругость';

  @override
  String get sportGoalMuscle => 'Набор мышечной массы';

  @override
  String get sportGoalFlexibility => 'Гибкость';

  @override
  String get sportGoalPosture => 'Осанка';

  @override
  String get sportGoalEndurance => 'Выносливость';

  @override
  String get sportGoalRelax => 'Снять стресс';

  @override
  String get sportQAreas => 'На какие зоны сделать акцент?';

  @override
  String get sportAreasNote =>
      'Сжечь жир в одной зоне невозможно. Эти упражнения укрепляют мышцы и придают им тонус.';

  @override
  String get sportAreaArms => 'Руки';

  @override
  String get sportAreaLegs => 'Ноги';

  @override
  String get sportAreaCore => 'Пресс и кор';

  @override
  String get sportAreaGlutes => 'Ягодицы';

  @override
  String get sportAreaBack => 'Спина';

  @override
  String get sportAreaFull => 'Всё тело';

  @override
  String get sportQTypes => 'Какие тренировки тебе по душе?';

  @override
  String get sportTypeFitness => 'Фитнес';

  @override
  String get sportTypePilates => 'Пилатес';

  @override
  String get sportTypeWallPilates => 'Пилатес у стены';

  @override
  String get sportTypeStretching => 'Растяжка';

  @override
  String get sportTypeCardio => 'Лёгкое кардио';

  @override
  String get sportQLevel => 'Какой у тебя уровень?';

  @override
  String get sportLevelBeginner => 'Только начинаю';

  @override
  String get sportLevelIntermediate => 'Средний';

  @override
  String get sportLevelAdvanced => 'Опытная';

  @override
  String get sportQSchedule => 'Сколько у тебя времени?';

  @override
  String get sportDaysLabel => 'Дней в неделю';

  @override
  String get sportMinutesLabel => 'Одна тренировка';

  @override
  String sportDays(int count) {
    return '$count дн.';
  }

  @override
  String sportMinutes(int count) {
    return '$count мин';
  }

  @override
  String get sportDumbbells => 'У меня есть гантели';

  @override
  String get sportQSafety => 'Для безопасности';

  @override
  String get sportSafetyIntro =>
      'Эти ответы нужны только для того, чтобы убрать из плана неподходящие упражнения.';

  @override
  String get sportPregnancyLabel => 'Беременность';

  @override
  String get sportPregNo => 'Нет';

  @override
  String get sportPregPregnant => 'Я беременна';

  @override
  String get sportPregPostpartum => 'Роды в последние 6 месяцев';

  @override
  String get sportInjuriesLabel => 'Боль или травма';

  @override
  String get sportInjKnee => 'Колено';

  @override
  String get sportInjBack => 'Поясница';

  @override
  String get sportInjShoulder => 'Плечо';

  @override
  String get sportInjWrist => 'Запястье';

  @override
  String get sportDoctorLimit =>
      'Врач ограничил нагрузки или просил сначала посоветоваться';

  @override
  String get sportBuildPlan => 'Составить план';

  @override
  String get sportWeekTitle => 'На этой неделе';

  @override
  String sportWeekProgress(int done, int total) {
    return '$done из $total тренировок';
  }

  @override
  String sportWorkoutTitle(int number) {
    return 'Тренировка $number';
  }

  @override
  String sportWorkoutMeta(String type, int minutes) {
    return '$type · ~$minutes мин';
  }

  @override
  String get sportDone => 'Готово';

  @override
  String get sportNextLabel => 'Следующая';

  @override
  String get sportEditAnswers => 'Изменить ответы';

  @override
  String get sportBlockedTitle => 'Сначала поговори с врачом';

  @override
  String get sportBlockedBody =>
      'Если врач ограничил нагрузки, мы не составляем план. Когда получишь разрешение, обнови ответы.';

  @override
  String get sportGentleNote =>
      'Мягкий план для беременности и периода после родов. Перед началом посоветуйся с врачом.';

  @override
  String get sportDraftNote =>
      'Упражнения и цифры ещё не проверены тренером. Если чувствуешь боль, остановись.';

  @override
  String get sportAllDone => 'Все тренировки этой недели выполнены.';

  @override
  String sportSetsReps(int sets, int reps) {
    return '$sets × $reps повт.';
  }

  @override
  String sportSetsSeconds(int sets, int seconds) {
    return '$sets × $seconds сек';
  }

  @override
  String sportRestSeconds(int seconds) {
    return 'Отдых $seconds сек';
  }

  @override
  String get sportStartWorkout => 'Начать тренировку';

  @override
  String get sportMusicNote =>
      'Включи музыку в своём музыкальном приложении. Parla подаёт только короткие сигналы.';

  @override
  String get sportSoundOn => 'Звуковые сигналы включены';

  @override
  String get sportSoundOff => 'Звук выключен, только вибрация';

  @override
  String sportSetOf(int set, int sets) {
    return 'Подход $set из $sets';
  }

  @override
  String sportRepsNow(int reps) {
    return '$reps повторений';
  }

  @override
  String get sportSetDone => 'Подход выполнен';

  @override
  String get sportPause => 'Пауза';

  @override
  String get sportResume => 'Продолжить';

  @override
  String get sportSkip => 'Пропустить';

  @override
  String get sportResting => 'Отдых';

  @override
  String sportNextUp(String name) {
    return 'Далее: $name';
  }

  @override
  String sportExerciseOf(int index, int total) {
    return 'Упражнение $index из $total';
  }

  @override
  String get sportFinishedTitle => 'Тренировка завершена';

  @override
  String sportFinishedBody(int minutes) {
    return '$minutes минут движения добавлены в записи за сегодня.';
  }

  @override
  String get sportBackToPlan => 'Вернуться к плану';

  @override
  String get sportQuit => 'Остановить тренировку';

  @override
  String get sportPrivacySynced =>
      'Твои ответы о спорте хранятся на сервере в зашифрованном виде, а на этом телефоне остаётся копия для работы без сети.';

  @override
  String get sportPrivacyDevice =>
      'Пока твои ответы о спорте хранятся только на этом телефоне. С обновлённым согласием на данные о здоровье они будут храниться на сервере в зашифрованном виде.';

  @override
  String get discoverLatest => 'Новые статьи';

  @override
  String get discoverAll => 'Все';

  @override
  String get discoverJournal => 'Дневник';

  @override
  String get discoverJournalHint => 'Только для тебя, на этом телефоне';

  @override
  String get journalIntro =>
      'Пиши о своём дне. Записи хранятся только на этом телефоне в зашифрованном виде; команда Parla их не видит. При смене телефона или удалении приложения они пропадут. Чтобы сохранить: Профиль → Скачать мои данные.';

  @override
  String get journalNew => 'Новая запись';

  @override
  String get journalEmpty => 'Пока нет записей.';

  @override
  String get journalHint => 'Как прошёл день?';

  @override
  String get journalEntryTitle => 'Запись';

  @override
  String get journalSave => 'Сохранить';

  @override
  String get journalDelete => 'Удалить';

  @override
  String get journalDeleteTitle => 'Удалить запись?';

  @override
  String get journalDeleteBody => 'Восстановить будет нельзя.';

  @override
  String get journalFull =>
      'Дневник заполнен. Удали старую запись, чтобы добавить новую.';

  @override
  String get discoverSportHint => 'Твой план на неделю';

  @override
  String discoverArticleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count статьи',
      many: '$count статей',
      few: '$count статьи',
      one: '$count статья',
    );
    return '$_temp0';
  }

  @override
  String discoverRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count рецепта',
      many: '$count рецептов',
      few: '$count рецепта',
      one: '$count рецепт',
    );
    return '$_temp0';
  }

  @override
  String get contentEmpty => 'Пока ничего нет. Скоро здесь появится.';

  @override
  String get contentOffline =>
      'Нет интернета, показана последняя загруженная версия.';

  @override
  String blogMeta(String category, int minutes) {
    return '$category · $minutes мин';
  }

  @override
  String blogReviewed(String date) {
    return 'Проверено специалистом · $date';
  }

  @override
  String get blogTips => 'Короткие шаги';

  @override
  String get catCare => 'Уход';

  @override
  String get catBeauty => 'Красота';

  @override
  String get catFashion => 'Мода';

  @override
  String get catHair => 'Волосы';

  @override
  String get specDermatologist => 'Дерматолог';

  @override
  String get specCosmetologist => 'Косметолог';

  @override
  String get specTrainer => 'Тренер';

  @override
  String get specDietitian => 'Диетолог';

  @override
  String get specTrichologist => 'Трихолог';

  @override
  String expertYears(int years) {
    return 'Опыт $years лет';
  }

  @override
  String get expertCall => 'Позвонить';

  @override
  String get expertWhatsapp => 'WhatsApp';

  @override
  String get expertInstagram => 'Instagram';

  @override
  String get expertsNote =>
      'Parla только знакомит со специалистами и не отвечает за их услуги. Связь идёт вне приложения, напрямую со специалистом; Parla не видит переписку.';

  @override
  String get nutritionHero => 'Красота начинается с тарелки';

  @override
  String get nutritionPlate => 'Тарелка дня';

  @override
  String nutritionPlateCount(int count, int total) {
    return '$count из $total групп';
  }

  @override
  String get groupVegetables => 'Овощи';

  @override
  String get groupFruit => 'Фрукты';

  @override
  String get groupProtein => 'Белок';

  @override
  String get groupWholeGrain => 'Цельные злаки';

  @override
  String get groupHealthyFat => 'Полезные жиры';

  @override
  String get groupDairy => 'Молочное';

  @override
  String nutritionWater(int count, int goal) {
    return 'Вода: $count из $goal стаканов';
  }

  @override
  String get nutritionNoCalories =>
      'Мы не считаем калории. Просто разнообразие: каждый день яркая тарелка.';

  @override
  String get nutritionTip => 'Совет дня для кожи';

  @override
  String get nutritionRecipes => 'Бьюти-рецепты';

  @override
  String get nutritionDisclaimer =>
      'Это общая информация, а не диета или медицинская рекомендация. Если у тебя особые потребности в питании, посоветуйся с диетологом.';

  @override
  String get nutritionPrivacySynced =>
      'Твои записи о тарелке хранятся на сервере в зашифрованном виде, а на этом телефоне остаётся копия для работы без сети.';

  @override
  String get nutritionPrivacyDevice =>
      'Пока твои записи о тарелке хранятся только на этом телефоне. С обновлённым согласием на данные о здоровье они будут храниться на сервере в зашифрованном виде.';

  @override
  String get mealBreakfast => 'Завтрак';

  @override
  String get mealLunch => 'Обед';

  @override
  String get mealDinner => 'Ужин';

  @override
  String get mealSnack => 'Перекус';

  @override
  String recipeMeta(String meal, int minutes, int servings) {
    return '$meal · $minutes мин · $servings порц.';
  }

  @override
  String get recipeIngredients => 'Ингредиенты';

  @override
  String get recipeSteps => 'Приготовление';

  @override
  String get recipeAddAll => 'Добавить ингредиенты в список покупок';

  @override
  String recipeAdded(int count) {
    return 'В список покупок добавлено: $count.';
  }

  @override
  String get skinCardTitle => 'Анализ кожи';

  @override
  String get skinCardBody => 'Проанализируй кожу заново, ответив на вопросы.';

  @override
  String get catBody => 'Тело';

  @override
  String get blogSources => 'Источники';

  @override
  String get blogRelated => 'Похожие статьи';

  @override
  String recipeAllergens(String list) {
    return 'Содержит: $list';
  }

  @override
  String get recipeNoAllergens => 'Нет ни одного из 14 основных аллергенов.';

  @override
  String get allergenGluten => 'глютен';

  @override
  String get allergenCrustaceans => 'ракообразные';

  @override
  String get allergenEgg => 'яйца';

  @override
  String get allergenFish => 'рыба';

  @override
  String get allergenPeanuts => 'арахис';

  @override
  String get allergenSoy => 'соя';

  @override
  String get allergenMilk => 'молоко';

  @override
  String get allergenNuts => 'орехи';

  @override
  String get allergenCelery => 'сельдерей';

  @override
  String get allergenMustard => 'горчица';

  @override
  String get allergenSesame => 'кунжут';

  @override
  String get allergenSulphites => 'сульфиты';

  @override
  String get allergenLupin => 'люпин';

  @override
  String get allergenMolluscs => 'моллюски';

  @override
  String bannerAd(String brand) {
    return 'Реклама · $brand';
  }

  @override
  String get messagesTitle => 'Сообщения';

  @override
  String get messagesButton => 'Сообщения';

  @override
  String get messagesButtonUnread => 'Сообщения, есть новый ответ';

  @override
  String get messagesFromParla => 'От Parla';

  @override
  String get messagesNone => 'Пока нет объявлений.';

  @override
  String get supportTitle => 'Поддержка';

  @override
  String get supportIntro =>
      'Напиши вопрос, команда Parla ответит. Сообщения хранятся в зашифрованном виде и удаляются через 12 месяцев после последнего. Мы не даём медицинских советов: в срочных или серьёзных случаях обратись к врачу.';

  @override
  String get supportHint => 'Твоё сообщение';

  @override
  String get supportSend => 'Отправить';

  @override
  String get supportYou => 'Ты';

  @override
  String get supportTeam => 'Команда Parla';

  @override
  String get supportSent => 'Отправлено.';

  @override
  String get pushTitle => 'Уведомления';

  @override
  String get pushBody =>
      'Узнаешь, когда поддержка ответит. С согласием на маркетинг придут и новости Parla. Можно выключить в любой момент.';

  @override
  String get pushDenied =>
      'Уведомления не разрешены. Их можно включить в настройках телефона.';

  @override
  String get checkSuggestTitle => 'По твоему тесту';

  @override
  String get checkSuggestBody =>
      'По ответам теста тебе могут подойти эти фильтры. Добавлять или нет — решаешь ты.';

  @override
  String checkSuggestAdd(String name) {
    return 'Добавить: $name';
  }

  @override
  String get consentRefreshCardTitle => 'Текст согласия обновлён';

  @override
  String get consentRefreshCardBody =>
      'Есть новая версия согласия на данные о здоровье. Если прочитаешь и согласишься, твои рутины, списки, спорт и питание будут храниться и на сервере в зашифрованном виде. Если нет, они остаются только на этом телефоне.';

  @override
  String get consentRefreshOpen => 'Прочитать';

  @override
  String get consentRefreshTitle => 'Согласие на данные о здоровье';

  @override
  String get consentRefreshIntro =>
      'Это новая версия текста, с которым ты соглашалась. Согласие добровольное; его можно отозвать в любой момент в разделе «Приватность».';

  @override
  String get consentRefreshAgree => 'Согласна';

  @override
  String get consentRefreshLater => 'Не сейчас';

  @override
  String get consentRefreshDone => 'Согласие обновлено.';
}
