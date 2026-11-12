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
  String get homeTitle => 'Сегодня';

  @override
  String get homePlaceholder =>
      'Ваш уход появится здесь после теста кожи. Тест появится в следующей версии.';

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
}
