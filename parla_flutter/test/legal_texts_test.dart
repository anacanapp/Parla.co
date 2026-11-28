import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:parla_shared/parla_shared.dart';

/// The privacy policy and the terms exist in every interface language
/// (owner, 2026-11-27) and are ready to show once filled; the translations
/// quote the same consent texts the app shows.
void main() {
  final company = LegalTexts.company(
    jsonDecode(File('assets/legal/company.json').readAsStringSync()),
  )!;

  for (final language in interfaceLanguages) {
    test('$language has a ready privacy policy and terms', () {
      for (final doc in LegalTexts.docs) {
        final file = File('assets/legal/$doc.$language.md');
        expect(file.existsSync(), isTrue, reason: file.path);
        final text = LegalTexts.fill(file.readAsStringSync(), company);
        expect(LegalTexts.isReady(text), isTrue, reason: file.path);
      }
      final privacy = File(
        'assets/legal/privacy.$language.md',
      ).readAsStringSync().replaceAll(RegExp(r'\s+'), ' ');
      for (final kind in ConsentKind.values) {
        final version = currentConsentText(kind).version;
        expect(privacy, contains('`$version`'), reason: '$language $kind');
      }
    });
  }
}
