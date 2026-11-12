// Converts official CosIng annex exports (CSV) into
// lib/src/cosing_data.dart.
//
// Usage, from parla_shared:
//   dart run tool/import_cosing.dart --date 2026-11-12 \
//     annex_ii.csv:II annex_iii.csv:III annex_iv.csv:IV annex_v.csv:V \
//     annex_vi.csv:VI
//
// Download each annex from CosIng (ec.europa.eu/growth/tools-databases/
// cosing → Annexes → export as CSV). The result is reviewed in a pull
// request like any other content change. Nothing is typed by hand, so the
// statuses are exactly the Commission's.
import 'dart:io';

import 'package:parla_shared/src/cosing_import.dart';

void main(List<String> args) {
  String? date;
  final inputs = <(String, String)>[];
  for (var i = 0; i < args.length; i++) {
    if (args[i] == '--date' && i + 1 < args.length) {
      date = args[++i];
    } else {
      final colon = args[i].lastIndexOf(':');
      if (colon < 1) _usage('Expected file.csv:ANNEX, got "${args[i]}".');
      inputs.add((args[i].substring(0, colon), args[i].substring(colon + 1)));
    }
  }
  if (date == null || !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date)) {
    _usage('Give the export date with --date YYYY-MM-DD.');
  }
  if (inputs.isEmpty) _usage('Give at least one file.csv:ANNEX.');

  final importer = CosingImporter();
  for (final (path, annex) in inputs) {
    final count = importer.addCsv(File(path).readAsStringSync(), annex);
    stdout.writeln('$path: $count rows (Annex $annex)');
  }
  final out = File('lib/src/cosing_data.dart');
  out.writeAsStringSync(importer.toDart(exportedOn: date));
  // Keep the file in the repository's format (CI checks it).
  Process.runSync(Platform.resolvedExecutable, ['format', out.path]);
  stdout.writeln('Wrote ${importer.length} ingredient names to ${out.path}.');
}

Never _usage(String message) {
  stderr.writeln(message);
  stderr.writeln(
    'Usage: dart run tool/import_cosing.dart --date YYYY-MM-DD '
    'file.csv:II [file.csv:III ...]',
  );
  exit(64);
}
