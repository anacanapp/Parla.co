import 'package:flutter/widgets.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// How the app looks: like the phone, always light or always dark (night
/// mode, owner 2026-11-26).
enum Appearance { system, light, dark }

/// Device-level settings: the interface language (needed before sign-in,
/// screen M-01) and the appearance. Neither is personal data; both stay on
/// the phone.
class AppSettings extends ChangeNotifier {
  AppSettings._(this._prefs, this._language, this._appearance);

  static const _languageKey = 'language';
  static const _appearanceKey = 'appearance';

  /// Loads saved settings.
  static Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_languageKey);
    final look = prefs.getString(_appearanceKey);
    return AppSettings._(
      prefs,
      interfaceLanguages.contains(saved) ? saved : null,
      Appearance.values.where((a) => a.name == look).firstOrNull ??
          Appearance.system,
    );
  }

  final SharedPreferences _prefs;
  String? _language;
  Appearance _appearance;

  /// Light, dark or like the phone (the default).
  Appearance get appearance => _appearance;

  Future<void> setAppearance(Appearance appearance) async {
    _appearance = appearance;
    notifyListeners();
    await _prefs.setString(_appearanceKey, appearance.name);
  }

  /// The chosen interface language, or `null` on first launch.
  String? get language => _language;

  /// The language texts are shown in (the interface language, Azerbaijani
  /// until one is chosen). Parla's own texts are picked for it with their
  /// translation or the closest language (`ContentRules.pick`,
  /// `pickTriple`).
  String get textLanguage => _language ?? defaultLanguage;

  /// The language of consent texts, legal documents, quiz questions,
  /// content and notifications for this person (see `contentLanguageFor`):
  /// the interface language where Parla has those texts, else the closest.
  /// The server only ever gets this one.
  String get contentLanguage =>
      contentLanguageFor(_language ?? defaultLanguage);

  Locale? get locale => _language == null ? null : Locale(_language!);

  Future<void> setLanguage(String language) async {
    assert(interfaceLanguages.contains(language));
    _language = language;
    notifyListeners();
    await _prefs.setString(_languageKey, language);
  }
}
