// Lists every Azerbaijani text of Parla's own content that the other
// interface languages need a translation of (quiz, routine steps and rules,
// exercises, product preferences, ingredient notes, skin tips). Skipped
// normally; run:
// flutter test test/tool/extract_texts_test.dart --dart-define=EXTRACT_TEXTS=<abs path>.json
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:parla/check/ingredient_texts.dart';
import 'package:parla/discover/skin_tips.dart';
import 'package:parla_shared/parla_shared.dart';

const _out = String.fromEnvironment('EXTRACT_TEXTS');

void main() {
  test('extract texts', skip: _out.isEmpty, () {
    final texts = <String>{};
    // az → [ru, en] where known, to help the translators.
    final context = <String, List<String>>{};
    void add(String? s, [String? ru, String? en]) {
      if (s == null || s.trim().isEmpty) return;
      texts.add(s);
      if (ru != null || en != null) context[s] = [ru ?? '', en ?? ''];
    }

    void map(Map<String, String> m) => add(m['az'], m['ru'], m['en']);
    void triple(List<String> t) =>
        add(t.first, t.length > 1 ? t[1] : null, t.length > 2 ? t[2] : null);

    // Maps built with _t (quiz, routine rules) register their az text.
    for (final q in quizQuestions) {
      map(q.text);
      map(q.why);
      for (final o in q.options) {
        map(o.text);
      }
    }
    for (final r in routineRuleList) {
      map(r.note);
    }
    texts.addAll(requestedTexts);
    for (final t in routineStepTexts.values) {
      for (final part in t.take(4)) {
        triple(part);
      }
    }
    for (final t in preferenceTexts.values) {
      for (final part in t) {
        triple(part);
      }
    }
    for (final t in exerciseSheetTexts.values) {
      for (final part in t.take(3)) {
        triple(part);
      }
    }
    exerciseDraftTexts['az']!.forEach((id, t) {
      for (final (i, az) in t.indexed) {
        add(
          az,
          exerciseDraftTexts['ru']?[id]?[i],
          exerciseDraftTexts['en']?[id]?[i],
        );
      }
    });
    for (final t in ingredientTexts.values) {
      triple(t.sublist(0, 3));
      triple(t.sublist(3, 6));
    }
    for (final t in skinTips) {
      triple(t);
    }
    final list = texts.toList()..sort();
    File(_out).writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(list),
    );
    File(_out.replaceAll('.json', '_context.json')).writeAsStringSync(
      const JsonEncoder.withIndent(
        '  ',
      ).convert({for (final az in list) az: context[az] ?? const []}),
    );
  });
}
