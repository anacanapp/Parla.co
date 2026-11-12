import 'dart:io';

import 'package:parla_shared/parla_shared.dart';
import 'package:parla_shared/src/cosing_import.dart';
import 'package:test/test.dart';

/// A tiny dataset for tests only. The references and conditions are
/// placeholders, not regulatory data.
final _testData = IngredientDataset(
  source: 'test',
  exportedOn: '2026-01-01',
  entries: const [
    IngredientEntry(
      inci: 'TEST RESTRICTED',
      rules: [
        IngredientRule(
          annex: EuAnnex.iii,
          reference: 'T1',
          conditions: 'Maximum concentration: placeholder',
        ),
      ],
    ),
    IngredientEntry(
      inci: 'TEST PRESERVATIVE',
      rules: [IngredientRule(annex: EuAnnex.v, reference: 'T2')],
    ),
  ],
);

void main() {
  group('splitting', () {
    test('commas outside brackets, label and full stop removed', () {
      expect(
        splitIngredients(
          'Ingredients: Aqua (Water), Glycerin, Parfum (Fragrance, '
          'Mixture), CI 77891.',
        ),
        ['Aqua (Water)', 'Glycerin', 'Parfum (Fragrance, Mixture)', 'CI 77891'],
      );
    });

    test('Russian and Azerbaijani labels and semicolons', () {
      expect(splitIngredients('Состав: Aqua; Glycerin'), ['Aqua', 'Glycerin']);
      expect(splitIngredients('Tərkib: Aqua, , Glycerin'), [
        'Aqua',
        'Glycerin',
      ]);
    });
  });

  test('names are compared without case, spacing or footnote marks', () {
    expect(normaliseInci('  test   restricted* '), 'TEST RESTRICTED');
    expect(_testData.lookup('Test Restricted'), isNotNull);
  });

  test('alternative names are tried one by one', () {
    final matches = analyseIngredients(
      'Aqua/Test Preservative, Water (Test Restricted), Glycerin',
      _testData,
    );
    expect(matches.map((m) => m.entry?.inci), [
      'TEST PRESERVATIVE',
      'TEST RESTRICTED',
      null,
    ]);
    expect(matches.first.name, 'Aqua/Test Preservative');
  });

  test('the shipped dataset is empty until an official export is '
      'imported', () {
    // When data is imported this test changes with it, in the same review.
    expect(euIngredientDataset.isEmpty, cosingExportedOn == null);
  });

  group('CosIng import', () {
    final fixture = File('test/fixtures/cosing_sample.csv').readAsStringSync();

    test('reads quoted fields, title lines and several names per row', () {
      final importer = CosingImporter();
      expect(importer.addCsv(fixture, 'III'), 2);
      expect(importer.length, 3);
      final dart = importer.toDart(exportedOn: '2026-01-01');
      expect(dart, contains("const cosingExportedOn = '2026-01-01';"));
      expect(dart, contains("inci: 'Example Alpha'"));
      expect(dart, contains("inci: 'Example Beta'"));
      expect(dart, contains('annex: EuAnnex.iii'));
      expect(dart, contains("reference: 'X1'"));
      expect(
        dart,
        contains(
          'Maximum concentration in ready for use preparation: 1 %, "quoted"',
        ),
      );
      expect(dart, contains(r"it\'s"));
    });

    test('an unknown format fails loudly', () {
      expect(
        () => CosingImporter().addCsv('a,b\n1,2\n', 'III'),
        throwsFormatException,
      );
      expect(
        () => CosingImporter().addCsv(fixture, 'IX'),
        throwsFormatException,
      );
    });

    test('semicolon separated files work too', () {
      final importer = CosingImporter();
      importer.addCsv(
        'Reference Number;INCI Name;Other\nY1;Example Gamma;-\n',
        'V',
      );
      expect(
        importer.toDart(exportedOn: '2026-01-01'),
        isNot(contains('Other')),
      );
      expect(importer.length, 1);
    });
  });
}
