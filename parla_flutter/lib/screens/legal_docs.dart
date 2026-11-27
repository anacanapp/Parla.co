import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:parla_shared/parla_shared.dart';

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
  static const required = LegalTexts.required;

  /// Whether [markdown] may be shown to users.
  static bool isReady(String markdown) => LegalTexts.isReady(markdown);

  /// Fills the company's details into [markdown] ([LegalTexts.fill]).
  static String fill(String markdown, Map<String, String> company) =>
      LegalTexts.fill(markdown, company);

  /// Reads an asset; replaced in tests.
  static Future<String> Function(String path) read = rootBundle.loadString;

  static Future<Map<String, String>?> _company() async {
    try {
      return LegalTexts.company(
        jsonDecode(await read('assets/legal/company.json')),
      );
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
