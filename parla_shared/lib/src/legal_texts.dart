/// The privacy policy and the terms of use are Markdown files
/// (`parla_flutter/assets/legal/<doc>.<language>.md`) that name the
/// company's details as `{{legalName}}`, `{{taxId}}`, `{{address}}`,
/// `{{email}}`, `{{dpo}}` and `{{effectiveDate}}`
/// (`assets/legal/company.json`). The app and the website fill and check
/// them the same way.
abstract final class LegalTexts {
  /// The documents.
  static const docs = ['privacy', 'terms'];

  /// The company's details every document needs.
  static const required = ['email', 'effectiveDate'];

  static final _token = RegExp(r'\{\{(\w+)\}\}');

  /// Whether [markdown] may be shown: no draft banner, no lawyer marker
  /// (⚖️) and no unfilled detail.
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

  /// The company's details from `company.json`'s decoded [json], or `null`
  /// when a [required] one is missing.
  static Map<String, String>? company(Object? json) {
    if (json is! Map) return null;
    final company = {
      for (final e in json.entries)
        if (e.key is String && e.value is String)
          e.key as String: (e.value as String).trim(),
    };
    if (required.any((k) => (company[k] ?? '').isEmpty)) return null;
    return company;
  }
}
