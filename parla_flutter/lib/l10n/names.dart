import 'app_localizations.dart';

/// The name of a market's country in the app's language.
String countryName(AppLocalizations l10n, String code) => switch (code) {
  'AZ' => l10n.countryName_AZ,
  'TR' => l10n.countryName_TR,
  'KZ' => l10n.countryName_KZ,
  'UZ' => l10n.countryName_UZ,
  _ => code,
};

/// The name of a supported interface language.
String languageName(AppLocalizations l10n, String code) => switch (code) {
  'az' => l10n.languageName_az,
  'ru' => l10n.languageName_ru,
  _ => l10n.languageName_en,
};
