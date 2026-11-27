/// Translations of Parla's own texts (quiz, routine steps and rules,
/// exercises, product preferences, ingredient notes, tips) into the
/// interface languages that are not [supportedLanguages] (owner,
/// 2026-11-27). They are keyed by the Azerbaijani text, the main one:
/// `parla_shared/i18n/<language>.json`, built into
/// `texts/i18n/texts_<language>.dart` by `tools/l10n/build_text_tables.py`.
/// DRAFT TRANSLATIONS made with Claude, not yet checked by native
/// speakers or the experts who check the source texts.
library;

import '../markets.dart';
import 'i18n/texts_ka.dart';
import 'i18n/texts_kk.dart';
import 'i18n/texts_ky.dart';
import 'i18n/texts_tk.dart';
import 'i18n/texts_tr.dart';
import 'i18n/texts_uz.dart';

/// Interface languages whose texts come from the tables below.
const translatedLanguages = ['tr', 'kk', 'uz', 'tk', 'ky', 'ka'];

const _tables = <String, Map<String, String>>{
  'tr': textsTr,
  'kk': textsKk,
  'uz': textsUz,
  'tk': textsTk,
  'ky': textsKy,
  'ka': textsKa,
};

/// The Azerbaijani texts asked for so far (for the extraction tool).
final Set<String> requestedTexts = {};

/// [az] in [language], or `null` when there is no translation.
String? translationOf(String az, String language) {
  requestedTexts.add(az);
  return _tables[language]?[az];
}

/// [byLanguage] (az, ru, en) with every translation of its Azerbaijani
/// text added, so a lookup by any interface language finds its text.
Map<String, String> withTranslations(Map<String, String> byLanguage) {
  final az = byLanguage['az'];
  if (az == null) return byLanguage;
  requestedTexts.add(az);
  return {
    ...byLanguage,
    for (final language in translatedLanguages)
      language: ?_tables[language]?[az],
  };
}

/// The text for [language] from `[az, ru, en]` (or a shorter list, which
/// holds Azerbaijani first): the language itself, its translation, else
/// the closest of az/ru/en (`contentLanguageFor`).
String pickTriple(List<String> texts, String language) {
  if (texts.isEmpty) return '';
  final i = supportedLanguages.indexOf(language);
  if (i >= 0) return i < texts.length ? texts[i] : texts.first;
  final t = translationOf(texts.first, language);
  if (t != null) return t;
  final j = supportedLanguages.indexOf(contentLanguageFor(language));
  return j >= 0 && j < texts.length ? texts[j] : texts.first;
}
