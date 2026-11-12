import 'package:flutter/widgets.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Device-level settings. Only the interface language is stored here: it is
/// not personal data and is needed before sign-in (screen M-01).
class AppSettings extends ChangeNotifier {
  AppSettings._(this._prefs, this._language);

  static const _languageKey = 'language';

  /// Loads saved settings.
  static Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_languageKey);
    return AppSettings._(
      prefs,
      supportedLanguages.contains(saved) ? saved : null,
    );
  }

  final SharedPreferences _prefs;
  String? _language;

  /// The chosen language, or `null` on first launch.
  String? get language => _language;

  Locale? get locale => _language == null ? null : Locale(_language!);

  Future<void> setLanguage(String language) async {
    assert(supportedLanguages.contains(language));
    _language = language;
    notifyListeners();
    await _prefs.setString(_languageKey, language);
  }
}
