import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:parla_shared/parla_shared.dart';

/// Every supported language must translate every key of the English file,
/// so no screen falls back to English silently.
void main() {
  Map<String, dynamic> load(String language) =>
      jsonDecode(File('lib/l10n/app_$language.arb').readAsStringSync())
          as Map<String, dynamic>;

  Set<String> keys(Map<String, dynamic> arb) =>
      arb.keys.where((k) => !k.startsWith('@')).toSet();

  final english = keys(load('en'));

  for (final language in supportedLanguages) {
    test('$language has every key', () {
      final translated = keys(load(language));
      expect(english.difference(translated), isEmpty);
      expect(translated.difference(english), isEmpty);
    });
  }
}
