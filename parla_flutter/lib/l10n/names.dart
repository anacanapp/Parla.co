import 'app_localizations.dart';

/// The name of a market's country in the app's language.
String countryName(AppLocalizations l10n, String code) => switch (code) {
  'AZ' => l10n.countryName_AZ,
  'TR' => l10n.countryName_TR,
  'KZ' => l10n.countryName_KZ,
  'UZ' => l10n.countryName_UZ,
  _ => code,
};

/// The name of an interface language in that language itself (the same
/// in every interface language, so each person finds their own).
String languageName(AppLocalizations l10n, String code) => switch (code) {
  'az' => l10n.languageName_az,
  'ru' => l10n.languageName_ru,
  'en' => l10n.languageName_en,
  'tr' => 'Türkçe',
  'kk' => 'Қазақша',
  'uz' => 'Oʻzbekcha',
  'tk' => 'Türkmençe',
  'ky' => 'Кыргызча',
  'ka' => 'ქართული',
  _ => code,
};
