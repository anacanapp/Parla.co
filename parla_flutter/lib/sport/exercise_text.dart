/// DRAFT CONTENT, NOT REVIEWED BY A TRAINER OR PHYSIOTHERAPIST.
///
/// Name and short how-to of every exercise in `exerciseCatalogue`
/// (parla_shared), per language: `[name, how]`.
library;

import 'package:parla_shared/parla_shared.dart';

import '../discover/content_library.dart';

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
    return (pickTriple(sheet[0], language), pickTriple(sheet[1], language));
  }
  final az = exerciseDraftTexts['az']![id];
  final entry =
      exerciseDraftTexts[language]?[id] ??
      (az == null
          ? null
          : [
              for (final (i, text) in az.indexed)
                pickTriple([
                  text,
                  exerciseDraftTexts['ru']?[id]?[i] ?? text,
                  exerciseDraftTexts['en']?[id]?[i] ?? text,
                ], language),
            ]);
  return entry == null ? (id, '') : (entry[0], entry[1]);
}

/// When to take care or skip the exercise, or `null`.
String? exerciseCaution(String id, String language) {
  if (ContentLibrary.catalogueData('exercise', id) != null) {
    return ContentLibrary.catalogueText('exercise', id, 'caution', language);
  }
  final sheet = exerciseSheetTexts[id];
  if (sheet == null) return null;
  final text = pickTriple(sheet[2], language);
  return text.isEmpty ? null : text;
}

/// Every exercise id with text in [language] (for tests).
Iterable<String> exerciseTextIds(String language) => {
  ...(exerciseDraftTexts[language] ?? const <String, List<String>>{}).keys,
  ...exerciseSheetTexts.keys,
};
