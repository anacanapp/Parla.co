/// Countries and languages Parla supports.
///
/// A country is only `open` after its legal review is done and its data
/// region exists (PRD roadmap, gate C). Until then the app lists it as
/// "coming soon" and the server refuses sign-ups from it.
library;

/// A country the app knows about.
class Market {
  const Market(this.countryCode, {required this.open});

  /// ISO 3166-1 alpha-2 code.
  final String countryCode;

  /// Whether people from this country can create an account today.
  final bool open;
}

/// Markets in launch order. Only Azerbaijan is open in the MVP.
const List<Market> markets = [
  Market('AZ', open: true),
  Market('TR', open: false),
  Market('KZ', open: false),
  Market('UZ', open: false),
];

/// Whether accounts can be created for [countryCode].
bool isMarketOpen(String countryCode) =>
    markets.any((m) => m.countryCode == countryCode && m.open);

/// Languages of the texts Parla stands behind in writing: consent texts,
/// legal documents, quiz questions, content and notifications. The server
/// accepts and stores only these.
const List<String> supportedLanguages = ['az', 'ru', 'en'];

/// Interface languages in the owner's order (2026-11-27): Azerbaijani (the
/// main one), Turkish, Russian, English, Kazakh, Uzbek (Latin), Turkmen,
/// Kyrgyz and Georgian.
const List<String> interfaceLanguages = [
  'az',
  'tr',
  'ru',
  'en',
  'kk',
  'uz',
  'tk',
  'ky',
  'ka',
];

/// Interface languages people can choose today. A new one is added here
/// after a native speaker has checked its translation; until then it is
/// shown only in test builds.
const List<String> openInterfaceLanguages = ['az', 'ru', 'en'];

/// The [supportedLanguages] text shown to someone using [language]: the
/// interface language itself where Parla has its texts, else the closest
/// one they are likely to read (Turkish → Azerbaijani; Kazakh, Uzbek,
/// Turkmen and Kyrgyz → Russian; Georgian → English).
String contentLanguageFor(String language) => switch (language) {
  _ when supportedLanguages.contains(language) => language,
  'tr' => 'az',
  'kk' || 'uz' || 'tk' || 'ky' => 'ru',
  'ka' => 'en',
  _ => defaultLanguage,
};

/// Language used when the device language is not supported.
const String defaultLanguage = 'az';
