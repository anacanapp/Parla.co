/// Reads CosIng annex exports. Used by `tool/import_cosing.dart`; kept in
/// `lib` so it is covered by tests.
library;

import 'ingredients.dart';

/// Parses CSV text (RFC 4180: quoted fields, doubled quotes, newlines in
/// quotes). Accepts comma or semicolon separators, detected from the header.
List<List<String>> parseCsv(String text) {
  final src = text.startsWith('﻿') ? text.substring(1) : text;
  final firstLine = src.split('\n').first;
  final sep =
      ';'.allMatches(firstLine).length > ','.allMatches(firstLine).length
      ? ';'
      : ',';
  final rows = <List<String>>[];
  var row = <String>[];
  final field = StringBuffer();
  var quoted = false;
  for (var i = 0; i < src.length; i++) {
    final ch = src[i];
    if (quoted) {
      if (ch == '"') {
        if (i + 1 < src.length && src[i + 1] == '"') {
          field.write('"');
          i++;
        } else {
          quoted = false;
        }
      } else {
        field.write(ch);
      }
    } else if (ch == '"') {
      quoted = true;
    } else if (ch == sep) {
      row.add(field.toString());
      field.clear();
    } else if (ch == '\n' || ch == '\r') {
      if (ch == '\r' && i + 1 < src.length && src[i + 1] == '\n') i++;
      row.add(field.toString());
      field.clear();
      if (row.any((f) => f.trim().isNotEmpty)) rows.add(row);
      row = <String>[];
    } else {
      field.write(ch);
    }
  }
  row.add(field.toString());
  if (row.any((f) => f.trim().isNotEmpty)) rows.add(row);
  return rows;
}

/// Collects annex rows and writes the Dart dataset.
class CosingImporter {
  final _rules = <String, List<IngredientRule>>{};
  final _names = <String, String>{};

  int get length => _rules.length;

  /// Adds one annex export. Returns the number of rows read. Throws a
  /// [FormatException] naming the headers when the columns are not found,
  /// so a changed export format fails loudly instead of importing nothing.
  int addCsv(String csv, String annexName) {
    final annex = EuAnnex.fromRoman(annexName);
    if (annex == null) {
      throw FormatException('Unknown annex "$annexName" (use II to VI).');
    }
    final rows = parseCsv(csv);
    if (rows.isEmpty) throw const FormatException('The file is empty.');
    // CosIng exports may start with title lines; the header is the first
    // row with a reference column.
    final headerIndex = rows.indexWhere((r) => r.any((h) => _isReference(h)));
    if (headerIndex < 0) {
      throw FormatException(
        'No reference number column. First row: ${rows.first.join(' | ')}',
      );
    }
    final header = [for (final h in rows[headerIndex]) h.trim()];
    final refCol = header.indexWhere(_isReference);
    final nameCols = _nameColumns(header);
    if (nameCols.inci.isEmpty && nameCols.chemical.isEmpty) {
      throw FormatException('No name column. Headers: ${header.join(' | ')}');
    }
    final conditionCols = [
      for (var i = 0; i < header.length; i++)
        if (_isCondition(header[i])) i,
    ];

    var count = 0;
    for (final row in rows.skip(headerIndex + 1)) {
      String cell(int i) => i < row.length ? row[i].trim() : '';
      final reference = cell(refCol);
      if (reference.isEmpty) continue;
      Set<String> namesIn(List<int> cols) => {
        for (final c in cols)
          for (final n in cell(c).split(RegExp(r'\s*[;\n]\s*|\s+/\s+')))
            if (n.trim().isNotEmpty) n.trim(),
      };
      // INCI names when the row has them, otherwise the chemical names.
      var names = namesIn(nameCols.inci);
      if (names.isEmpty) names = namesIn(nameCols.chemical);
      if (names.isEmpty) continue;
      final conditions = [
        for (final c in conditionCols)
          if (cell(c).isNotEmpty && cell(c) != '-')
            '${header[c]}: ${cell(c).replaceAll(RegExp(r'\s+'), ' ')}',
      ].join(' · ');
      final rule = IngredientRule(
        annex: annex,
        reference: reference,
        conditions: conditions.isEmpty ? null : conditions,
      );
      for (final name in names) {
        final key = normaliseInci(name);
        _names.putIfAbsent(key, () => name);
        _rules.putIfAbsent(key, () => []).add(rule);
      }
      count++;
    }
    return count;
  }

  static bool _isReference(String h) =>
      RegExp(r'reference|ref\.?\s*(n|#)', caseSensitive: false).hasMatch(h);

  static bool _isCondition(String h) => RegExp(
    r'maximum|concentration|product type|body part|other|condition|warning',
    caseSensitive: false,
  ).hasMatch(h);

  /// INCI name columns, and chemical name columns used for rows without an
  /// INCI name (Annex II lists many substances without one).
  static ({List<int> inci, List<int> chemical}) _nameColumns(
    List<String> header,
  ) {
    final inci = [
      for (var i = 0; i < header.length; i++)
        if (RegExp(r'inci', caseSensitive: false).hasMatch(header[i])) i,
    ];
    final chemical = [
      for (var i = 0; i < header.length; i++)
        if (RegExp(
          r'chemical name|name of common ingredient|substance',
          caseSensitive: false,
        ).hasMatch(header[i]))
          i,
    ];
    return (inci: inci, chemical: chemical);
  }

  /// The Dart source of `lib/src/cosing_data.dart`.
  String toDart({required String exportedOn}) {
    final keys = _rules.keys.toList()..sort();
    final b = StringBuffer()
      ..writeln('// GENERATED by tool/import_cosing.dart from the official')
      ..writeln('// CosIng annex export of $exportedOn. Do not edit by hand:')
      ..writeln('// import a new export instead (docs/INGREDIENTS.md).')
      ..writeln()
      ..writeln("import 'ingredients.dart';")
      ..writeln()
      ..writeln("const cosingExportedOn = '$exportedOn';")
      ..writeln()
      ..writeln('const cosingEntries = <IngredientEntry>[');
    for (final key in keys) {
      b.writeln('  IngredientEntry(');
      b.writeln('    inci: ${_lit(_names[key]!)},');
      b.writeln('    rules: [');
      for (final r in _rules[key]!) {
        b.write('      IngredientRule(annex: EuAnnex.${r.annex.name}, ');
        b.write('reference: ${_lit(r.reference)}');
        if (r.conditions != null) {
          b.write(', conditions: ${_lit(r.conditions!)}');
        }
        b.writeln('),');
      }
      b.writeln('    ],');
      b.writeln('  ),');
    }
    b.writeln('];');
    return b.toString();
  }

  static String _lit(String s) =>
      "'${s.replaceAll(r'\', r'\\').replaceAll("'", r"\'").replaceAll(r'$', r'\$').replaceAll('\n', ' ')}'";
}
