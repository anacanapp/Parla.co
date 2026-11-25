import 'dart:convert';

import 'package:flutter/services.dart';

/// The privacy policy and the terms of use, shipped as Markdown in
/// `assets/legal/<doc>.<language>.md`.
///
/// The company's details live in one file, `assets/legal/company.json`,
/// and the texts name them as `{{legalName}}`, `{{taxId}}`, `{{address}}`,
/// `{{email}}`, `{{dpo}}` and `{{effectiveDate}}`. A line whose detail is
/// still empty is left out, so the details can be added later without
/// touching the texts. The contact email and the effective date are
/// required: without them no document is shown.
///
/// The lawyer's open questions are kept apart, in
/// `docs/legal/lawyer-questions.md`; a text with a draft banner, a lawyer
/// marker (⚖️) or an unfilled detail is never shown.
enum LegalDoc {
  privacy,
  terms;

  /// The company's details every document needs.
  static const required = ['email', 'effectiveDate'];

  static final _token = RegExp(r'\{\{(\w+)\}\}');

  /// Whether [markdown] may be shown to users.
  static bool isReady(String markdown) =>
      markdown.trim().isNotEmpty &&
      !markdown.contains('QARALAMA') &&
      !markdown.contains('DRAFT') &&
      !markdown.contains('⚖️') &&
      !markdown.contains('{{');

  /// Fills the company's details into [markdown]: a line naming a detail
  /// that is empty is dropped, an unknown detail is left as it is (so the
  /// text is not [isReady]).
  static String fill(String markdown, Map<String, String> company) {
    final lines = <String>[];
    for (final line in markdown.split('\n')) {
      final names = _token.allMatches(line).map((m) => m.group(1)!);
      if (names.any((n) => company.containsKey(n) && company[n]!.isEmpty)) {
        continue;
      }
      lines.add(
        line.replaceAllMapped(
          _token,
          (m) => company[m.group(1)!] ?? m.group(0)!,
        ),
      );
    }
    return lines.join('\n');
  }

  /// Reads an asset; replaced in tests.
  static Future<String> Function(String path) read = rootBundle.loadString;

  static Future<Map<String, String>?> _company() async {
    try {
      final json = jsonDecode(await read('assets/legal/company.json'));
      final company = {
        for (final e in (json as Map<String, dynamic>).entries)
          e.key: (e.value as String).trim(),
      };
      if (required.any((k) => (company[k] ?? '').isEmpty)) return null;
      return company;
    } on Object {
      return null;
    }
  }

  /// The document in [language], else in Azerbaijani (the governing text),
  /// or `null` when none is ready.
  Future<String?> load(String language) async {
    final company = await _company();
    if (company == null) return null;
    for (final l in {language, 'az'}) {
      try {
        final text = fill(await read('assets/legal/$name.$l.md'), company);
        if (isReady(text)) return text;
      } on Object {
        // No file in this language.
      }
    }
    return null;
  }

  /// The document a link in a legal text points to (`privacy.az.md`,
  /// `terms.en.md`), or `null` for any other link.
  static LegalDoc? fromLink(String href) {
    final match = RegExp(r'^(privacy|terms)\.\w+\.md$').firstMatch(href);
    return match == null ? null : LegalDoc.values.byName(match.group(1)!);
  }
}
