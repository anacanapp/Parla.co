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

/// Interface languages in the MVP. tr, kk and uz follow in v2.
const List<String> supportedLanguages = ['az', 'ru', 'en'];

/// Language used when the device language is not supported.
const String defaultLanguage = 'az';
