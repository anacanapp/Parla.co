import 'package:flutter/widgets.dart';

/// Flutter's own texts (buttons of dialogs, the date picker, text field
/// menus) for an interface language Flutter does not ship: Turkmen takes
/// the Turkish ones, the closest language Flutter has. Every other
/// language goes to [inner] unchanged.
class SystemTextsDelegate<T> extends LocalizationsDelegate<T> {
  const SystemTextsDelegate(this.inner);

  final LocalizationsDelegate<T> inner;

  /// Languages without Flutter texts, and the language used instead.
  static const substitutes = {'tk': 'tr'};

  Locale _resolve(Locale locale) {
    final instead = substitutes[locale.languageCode];
    return instead == null ? locale : Locale(instead);
  }

  @override
  bool isSupported(Locale locale) => inner.isSupported(_resolve(locale));

  @override
  Future<T> load(Locale locale) => inner.load(_resolve(locale));

  @override
  bool shouldReload(SystemTextsDelegate<T> old) => false;

  @override
  Type get type => T;
}
