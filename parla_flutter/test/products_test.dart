import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla/app.dart';
import 'package:parla/habits/habit_store.dart';
import 'package:parla/home/widgets/parla_nav_bar.dart';
import 'package:parla/services/parla_api.dart';
import 'package:parla/state/app_settings.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_api.dart';
import 'support/fake_reminders.dart';
import 'support/text_sizes.dart';

/// Test data only: placeholder references and conditions, not real CosIng
/// content.
final _dataset = IngredientDataset(
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
      inci: 'TEST PROHIBITED',
      rules: [IngredientRule(annex: EuAnnex.ii, reference: 'T2')],
    ),
  ],
);

const _product = ProductResult(
  source: 'openbeautyfacts',
  code: '1',
  name: 'Gentle Cream',
  brand: 'Brand',
  ingredientsText: 'Aqua, Test Restricted, Glycerin, Test Prohibited',
);

Future<FakeApi> _openSearch(
  WidgetTester tester, {
  String language = 'en',
  IngredientDataset? dataset,
  List<ProductResult> products = const [_product],
}) async {
  tester.view.physicalSize = const Size(390 * 3, 844 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues({'language': language});
  final settings = await AppSettings.load();
  final api = FakeApi()
    ..signedIn = true
    ..profile = ProfileSummary(countryCode: 'AZ', language: language)
    ..products = products;
  await tester.pumpWidget(
    ParlaApp(
      api: api,
      settings: settings,
      clock: () => DateTime(2026, 11, 12, 9),
      habitStore: MemoryHabitStore(),
      reminderScheduler: FakeReminderScheduler(),
      ingredientDataset: dataset ?? _dataset,
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(
    find
        .descendant(
          of: find.byType(ParlaNavBar),
          matching: find.byType(InkWell),
        )
        .at(1),
  );
  await tester.pumpAndSettle();
  return api;
}

Future<void> _search(WidgetTester tester, String query) async {
  await tester.enterText(find.byKey(const ValueKey('product-query')), query);
  await tester.tap(find.byType(FilledButton));
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  final list = find.byType(Scrollable);
  if (finder.evaluate().isEmpty && list.evaluate().isNotEmpty) {
    await tester.scrollUntilVisible(finder, 200, scrollable: list.first);
  }
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
  await tester.tap(finder.first);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the Scan tab opens product search', (tester) async {
    await _openSearch(tester);
    expect(find.text('Check a product'), findsOneWidget);
  });

  testWidgets('a one-letter search asks for more and calls nothing', (
    tester,
  ) async {
    final api = await _openSearch(tester);
    await _search(tester, 'n');
    expect(find.text('Type at least 2 letters.'), findsOneWidget);
    expect(api.productQueries, isEmpty);
  });

  testWidgets('results open the product with neutral EU statuses', (
    tester,
  ) async {
    final api = await _openSearch(tester);
    await _search(tester, 'gentle');
    expect(api.productQueries, ['gentle']);
    expect(find.text('Brand · Open Beauty Facts'), findsOneWidget);

    await _tap(tester, find.text('Gentle Cream'));
    expect(find.text('4 ingredients · 2 have an EU entry'), findsOneWidget);
    expect(find.text('EU: allowed with restrictions'), findsOneWidget);
    expect(find.text('EU: on the list of prohibited substances'), findsOne);
    expect(
      find.text('No separate entry found in the EU annexes'),
      findsNWidgets(2),
    );
    await tester.scrollUntilVisible(
      find.textContaining('not a safety assessment'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('not a safety assessment'), findsOneWidget);
    expect(find.textContaining('Open Beauty Facts, under the ODbL'), findsOne);
  });

  testWidgets('an ingredient sheet shows the annex entry, the official '
      'conditions and the source date', (tester) async {
    await _openSearch(tester);
    await _search(tester, 'gentle');
    await _tap(tester, find.text('Gentle Cream'));
    await _tap(tester, find.text('Test Restricted'));
    expect(find.text('TEST RESTRICTED'), findsOneWidget);
    expect(find.text('Annex III, entry T1'), findsOneWidget);
    expect(find.text('Maximum concentration: placeholder'), findsOneWidget);
    expect(find.text('Source: CosIng, 2026-01-01'), findsOneWidget);
  });

  testWidgets('without imported statuses only the list shows, and says so', (
    tester,
  ) async {
    await _openSearch(
      tester,
      dataset: IngredientDataset(
        source: 'CosIng',
        exportedOn: null,
        entries: const [],
      ),
    );
    await _search(tester, 'gentle');
    await _tap(tester, find.text('Gentle Cream'));
    expect(find.byKey(const ValueKey('statuses-missing')), findsOneWidget);
    expect(find.text('4 ingredients'), findsOneWidget);
    expect(find.textContaining('EU:'), findsNothing);
    expect(
      find.text('No separate entry found in the EU annexes'),
      findsNothing,
    );
  });

  testWidgets('nothing found and a missing ingredient list are explained', (
    tester,
  ) async {
    await _openSearch(tester, products: const []);
    await _search(tester, 'xyz');
    expect(find.text('Nothing found'), findsOneWidget);
  });

  testWidgets('a product without ingredients says to check the package', (
    tester,
  ) async {
    await _openSearch(
      tester,
      products: const [
        ProductResult(source: 'parla', code: 'p1', name: 'Local Soap'),
      ],
    );
    await _search(tester, 'soap');
    expect(find.text('Parla catalogue'), findsOneWidget);
    await _tap(tester, find.text('Local Soap'));
    expect(find.textContaining('Please check the package'), findsOneWidget);
    expect(find.textContaining('ODbL'), findsNothing);
  });

  testWidgets('a source failure shows a clear message', (tester) async {
    final api = await _openSearch(tester);
    api.productError = 'product.source_unavailable';
    await _search(tester, 'gentle');
    expect(find.textContaining('not answering right now'), findsOneWidget);
  });

  test('no app text calls anything harmful or toxic, in any language', () {
    const banned = [
      'zərərli',
      'zəhərli',
      'вредн',
      'токсич',
      'harmful',
      'toxic',
    ];
    for (final lang in ['az', 'ru', 'en']) {
      final arb = File(
        'lib/l10n/app_$lang.arb',
      ).readAsStringSync().toLowerCase();
      for (final word in banned) {
        expect(arb.contains(word), isFalse, reason: '$lang contains "$word"');
      }
    }
  });

  for (final language in ['az', 'ru', 'en']) {
    testWidgets('$language: search, product and ingredient sheet keep text '
        'at 18 px or more without overflow', (tester) async {
      await _openSearch(tester, language: language);
      await _search(tester, 'gentle');
      final sizes = <double>[...paintedFontSizes(tester)];
      expect(tester.takeException(), isNull);

      await _tap(tester, find.text('Gentle Cream'));
      final list = find.byType(Scrollable).first;
      for (var i = 0; i < 4; i++) {
        sizes.addAll(paintedFontSizes(tester));
        expect(tester.takeException(), isNull);
        await tester.drag(list, const Offset(0, -400));
        await tester.pumpAndSettle();
      }
      await tester.drag(list, const Offset(0, 5000));
      await tester.pumpAndSettle();
      await _tap(tester, find.text('Test Restricted'));
      sizes.addAll(paintedFontSizes(tester));
      expect(tester.takeException(), isNull);
      expect(sizes.where((s) => s < 18), isEmpty);
    });
  }
}
