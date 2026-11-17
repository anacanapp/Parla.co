/// DRAFT CONTENT, NOT REVIEWED BY A TRAINER OR PHYSIOTHERAPIST.
///
/// Name and short how-to of every exercise in `exerciseCatalogue`
/// (parla_shared), per language: `[name, how]`.
library;

import 'package:parla_shared/parla_shared.dart';

import '../discover/content_library.dart';

int _index(String language) => switch (language) {
  'ru' => 1,
  'en' => 2,
  _ => 0,
};

/// Name and how-to of [id] in [language] (Azerbaijani as fallback). Texts
/// from the content sheet win over the first draft.
(String, String) exerciseText(String id, String language) {
  final name = ContentLibrary.catalogueText('exercise', id, 'name', language);
  if (name != null) {
    return (
      name,
      ContentLibrary.catalogueText('exercise', id, 'how', language) ?? '',
    );
  }
  final sheet = exerciseSheetTexts[id];
  if (sheet != null) {
    final i = _index(language);
    return (sheet[0][i], sheet[1][i]);
  }
  final texts = exerciseDraftTexts[language] ?? exerciseDraftTexts['az']!;
  final entry = texts[id] ?? exerciseDraftTexts['az']![id];
  return entry == null ? (id, '') : (entry[0], entry[1]);
}

/// When to take care or skip the exercise, or `null`.
String? exerciseCaution(String id, String language) {
  if (ContentLibrary.catalogueData('exercise', id) != null) {
    return ContentLibrary.catalogueText('exercise', id, 'caution', language);
  }
  final sheet = exerciseSheetTexts[id];
  if (sheet == null) return null;
  final text = sheet[2][_index(language)];
  return text.isEmpty ? null : text;
}

/// Every exercise id with text in [language] (for tests).
Iterable<String> exerciseTextIds(String language) => {
  ...(exerciseDraftTexts[language] ?? const <String, List<String>>{}).keys,
  ...exerciseSheetTexts.keys,
};
