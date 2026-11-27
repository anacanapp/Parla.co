import 'dart:convert';
import 'dart:io';

import 'package:parla_shared/parla_shared.dart';
import 'package:test/test.dart';

/// Every content text the app shows (tools/l10n/text_sources.json, made by
/// parla_flutter/test/tool/extract_texts_test.dart) has a translation in
/// every translated language, so no text falls back silently.
void main() {
  final sources =
      (jsonDecode(File('../tools/l10n/text_sources.json').readAsStringSync())
              as List)
          .cast<String>();

  for (final language in translatedLanguages) {
    test('$language translates every content text', () {
      final missing = [
        for (final az in sources)
          if (translationOf(az, language) == null) az,
      ];
      expect(missing, isEmpty);
    });
  }
}
