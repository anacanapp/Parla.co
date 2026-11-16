import 'dart:convert';

import 'package:parla_shared/parla_shared.dart';
import 'package:test/test.dart';

PreferenceResult _one(String text, String id) =>
    checkPreferences(text, [id]).single;

void main() {
  test('fragrance in any spelling conflicts with fragrance free', () {
    final r = _one(
      'Aqua, Glycerin, Parfum (Fragrance), Linalool',
      'fragrance_free',
    );
    expect(r.outcome, PreferenceOutcome.conflicts);
    // Labelled fragrance allergens count too (from the content sheet).
    expect(r.found, ['Parfum (Fragrance)', 'Linalool']);
    expect(
      _one('Aqua, Glycerin', 'fragrance_free').outcome,
      PreferenceOutcome.fits,
    );
  });

  test('fatty alcohols do not count against alcohol free', () {
    expect(
      _one('Aqua, Cetearyl Alcohol, Cetyl Alcohol', 'alcohol_free').outcome,
      PreferenceOutcome.fits,
    );
    expect(_one('Aqua, Alcohol Denat., Glycerin', 'alcohol_free').found, [
      'Alcohol Denat',
    ]);
  });

  test('sulfates, silicones and parabens are found', () {
    expect(
      _one('Aqua, Sodium Laureth Sulfate', 'sulfate_free').outcome,
      PreferenceOutcome.conflicts,
    );
    expect(
      _one(
        'Cyclopentasiloxane, Dimethicone, Amodimethicone',
        'silicone_free',
      ).found,
      hasLength(3),
    );
    expect(
      _one('Aqua, Methylparaben, Propylparaben', 'paraben_free').found,
      hasLength(2),
    );
    expect(
      _one('Aqua, Phenoxyethanol', 'paraben_free').outcome,
      PreferenceOutcome.fits,
    );
  });

  test('vegan finds known animal-derived names and is cautious', () {
    final r = _one('Aqua, Cera Alba, Lanolin, CI 75470', 'vegan');
    expect(r.found, ['Cera Alba', 'Lanolin', 'CI 75470']);
    expect(r.preference.cautious, isTrue);
    expect(_one('Aqua, Glycerin', 'vegan').outcome, PreferenceOutcome.fits);
  });

  test('the options from the content sheet find their ingredients', () {
    expect(
      _one(
        'Aqua, Lavandula Angustifolia Oil, Helianthus Annuus Seed Oil',
        'essential_oil_free',
      ).found,
      ['Lavandula Angustifolia Oil'],
    );
    expect(_one('Aqua, Retinol', 'retinoid_free').found, ['Retinol']);
    expect(
      _one('Aqua, Bakuchiol', 'retinoid_free').outcome,
      PreferenceOutcome.fits,
    );
    expect(
      _one('Aqua, Methylisothiazolinone', 'preservative_alert').outcome,
      PreferenceOutcome.conflicts,
    );
    expect(_one('Aqua, Lanolin', 'lanolin_free').found, ['Lanolin']);
    expect(
      _one('Aqua, Trimethylsiloxysilicate', 'silicone_free').outcome,
      PreferenceOutcome.conflicts,
    );
    expect(
      _one('Aqua, Sodium Cocoyl Isethionate', 'sulfate_free').outcome,
      PreferenceOutcome.fits,
    );
    expect(
      [for (final p in productPreferences) p.id],
      [
        'fragrance_free',
        'essential_oil_free',
        'alcohol_free',
        'vegan',
        'silicone_free',
        'sulfate_free',
        'retinoid_free',
        'preservative_alert',
        'lanolin_free',
        'paraben_free',
      ],
    );
  });

  test('no ingredient list gives unknown; unknown ids are ignored', () {
    final r = checkPreferences(null, ['vegan', 'nope', 'fragrance_free']);
    expect(r.map((e) => e.preference.id), ['fragrance_free', 'vegan']);
    expect(r.every((e) => e.outcome == PreferenceOutcome.unknown), isTrue);
  });

  test('every preference id fits the stored format', () {
    final ids = [for (final p in productPreferences) p.id];
    expect(ids.toSet(), hasLength(ids.length));
    expect(
      CareListRules.isValid(jsonEncode({'format': 1, 'preferences': ids})),
      isTrue,
    );
  });

  group('care list rules', () {
    Map<String, Object?> list() => {
      'format': 1,
      'preferences': ['vegan'],
      'recent': [
        {
          'code': '123',
          'source': 'openbeautyfacts',
          'name': 'Cream',
          'at': '2026-11-15',
        },
      ],
      'shopping': [
        {
          'id': 'a1',
          'title': 'SPF 30',
          'area': 'face',
          'origin': 'routine',
          'bought': false,
        },
      ],
    };

    bool ok(Object json) => CareListRules.isValid(jsonEncode(json));

    test('a normal list is valid', () => expect(ok(list()), isTrue));

    test('unknown fields, areas and sources are refused', () {
      expect(ok({...list(), 'phone': '1'}), isFalse);
      expect(
        ok({
          ...list(),
          'shopping': [
            {'id': 'a1', 'title': 'x', 'area': 'nails'},
          ],
        }),
        isFalse,
      );
      expect(
        ok({
          ...list(),
          'recent': [
            {'code': '1', 'source': 'web', 'name': 'x', 'at': '2026-11-15'},
          ],
        }),
        isFalse,
      );
    });

    test('limits are enforced', () {
      expect(
        ok({
          ...list(),
          'shopping': [
            for (var i = 0; i < 101; i++) {'id': 'a$i', 'title': 'x'},
          ],
        }),
        isFalse,
      );
      expect(
        ok({
          ...list(),
          'shopping': [
            {'id': 'a1', 'title': 'x' * 61},
          ],
        }),
        isFalse,
      );
    });
  });
}
