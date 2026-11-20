import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:parla/app.dart';
import 'package:parla/habits/habit_store.dart';
import 'package:parla/home/widgets/parla_nav_bar.dart';
import 'package:parla/services/parla_api.dart';
import 'package:parla/state/app_settings.dart';
import 'package:parla/ui/brand.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_api.dart';
import 'support/fake_reminders.dart';
import 'support/text_sizes.dart';

const _cream = ProductResult(
  source: 'openbeautyfacts',
  code: '4001',
  name: 'Day Cream',
  brand: 'Brand',
  ingredientsText: 'Aqua, Glycerin, Parfum, Cera Alba, Cetyl Alcohol',
);

class _App {
  _App(this.api, this.store, this.shared);

  final FakeApi api;
  final MemoryHabitStore store;
  final List<String> shared;
}

/// Signed-in user on the Check tab.
Future<_App> _open(
  WidgetTester tester, {
  String language = 'en',
  bool healthConsent = false,
  FakeApi? api,
  MemoryHabitStore? store,
  double textScale = 1,
}) async {
  tester.view.physicalSize = const Size(390 * 3, 844 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

  SharedPreferences.setMockInitialValues({'language': language});
  final settings = await AppSettings.load();
  final shared = <String>[];
  api ??= FakeApi()
    ..signedIn = true
    ..profile = ProfileSummary(countryCode: 'AZ', language: language)
    ..healthConsent = healthConsent
    ..products = const [_cream];
  store ??= MemoryHabitStore();
  await tester.pumpWidget(
    ParlaApp(
      key: UniqueKey(),
      api: api,
      reminderScheduler: FakeReminderScheduler(),
      settings: settings,
      clock: () => DateTime(2026, 11, 15, 10),
      shareExport: (json) async => shared.add(json),
      habitStore: MemoryHabitStore(),
      routineStore: MemoryHabitStore(),
      careListStore: store,
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(
    find
        .descendant(
          of: find.byType(ParlaNavBar),
          matching: find.byType(InkWell),
        )
        .at(2),
  );
  await tester.pumpAndSettle();
  return _App(api, store, shared);
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

Future<void> _pick(WidgetTester tester, List<String> ids) async {
  await _tap(tester, find.byKey(const ValueKey('prefs-edit')));
  for (final id in ids) {
    await _tap(tester, find.byKey(ValueKey('pref-$id')));
  }
  await _tap(tester, find.byKey(const ValueKey('prefs-save')));
}

Future<void> _searchAndOpen(WidgetTester tester) async {
  await tester.enterText(find.byKey(const ValueKey('product-query')), 'day');
  await _tap(tester, find.text('Search'));
  await _tap(tester, find.text('Day Cream'));
}

Map<String, Object?> _local(MemoryHabitStore store) =>
    jsonDecode(store.data['user-1']!) as Map<String, Object?>;

void main() {
  testWidgets('quiz answers suggest preferences; the user adds them', (
    tester,
  ) async {
    final api = FakeApi()
      ..signedIn = true
      ..profile = const ProfileSummary(countryCode: 'AZ', language: 'en')
      ..products = const [_cream]
      ..quizAnswers = const QuizAnswers(
        chosen: {
          'sensitivity': ['often'],
        },
        declined: {},
      );
    final app = await _open(tester, api: api);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('check-suggestions')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('up to you'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('suggest-fragrance_free')));
    await tester.pumpAndSettle();
    // Added: shown among the preferences and no longer suggested.
    expect(find.byKey(const ValueKey('check-suggestions')), findsNothing);
    expect(find.text('Fragrance-free'), findsOneWidget);
    expect(app.store.data.values.single, contains('fragrance_free'));
  });

  testWidgets('without a quiz nothing is suggested', (tester) async {
    await _open(tester);
    expect(find.byKey(const ValueKey('check-suggestions')), findsNothing);
  });

  testWidgets('preferences are picked and shown as chips', (tester) async {
    final app = await _open(tester);
    expect(
      find.text(
        'Pick what matters to you and we compare the ingredients with '
        'your picks.',
      ),
      findsOneWidget,
    );
    await _pick(tester, ['fragrance_free', 'vegan']);
    expect(find.text('Fragrance-free'), findsOneWidget);
    expect(find.text('Vegan'), findsOneWidget);
    expect(_local(app.store)['preferences'], ['fragrance_free', 'vegan']);
    // Without the health consent nothing reaches the server.
    expect(app.api.careList, isNull);
  });

  testWidgets('the product shows how it fits the picks, neutrally', (
    tester,
  ) async {
    await _open(tester);
    await _pick(tester, ['fragrance_free', 'alcohol_free', 'vegan']);
    await _searchAndOpen(tester);

    final card = find.byKey(const ValueKey('prefs-result'));
    await tester.ensureVisible(card);
    expect(
      find.descendant(
        of: card,
        matching: find.text('1 of 3 of your picks fit'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: card, matching: find.text('Contains: Parfum')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: card, matching: find.text('Contains: Cera Alba')),
      findsOneWidget,
    );
    // Cetyl alcohol is a fatty alcohol and does not count.
    expect(
      find.descendant(of: card, matching: find.text('Fits')),
      findsOneWidget,
    );
    expect(find.textContaining('does not rate products'), findsOneWidget);
    // Ingredient explanations from the content sheet.
    await tester.scrollUntilVisible(
      find.text('Solvent'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('The base of most products'), findsOneWidget);
    for (final word in ['harmful', 'risk', 'score:', 'bad']) {
      expect(find.textContaining(word), findsNothing, reason: word);
    }
  });

  testWidgets('vegan only says that nothing known was found', (tester) async {
    final api = FakeApi()
      ..signedIn = true
      ..profile = const ProfileSummary(countryCode: 'AZ', language: 'en')
      ..products = const [
        ProductResult(
          source: 'openbeautyfacts',
          code: '5',
          name: 'Day Cream',
          ingredientsText: 'Aqua, Glycerin',
        ),
      ];
    await _open(tester, api: api);
    await _pick(tester, ['vegan']);
    await _searchAndOpen(tester);
    expect(find.text('No known animal-derived ingredient found'), findsOne);
  });

  testWidgets('checked products show under recently checked', (tester) async {
    final app = await _open(tester);
    await _searchAndOpen(tester);
    await _tap(tester, find.byType(BackButton));
    await tester.scrollUntilVisible(
      find.text('Recently checked'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(const ValueKey('recent-4001')), findsOneWidget);
    expect((_local(app.store)['recent']! as List).single, {
      'code': '4001',
      'source': 'openbeautyfacts',
      'name': 'Day Cream',
      'brand': 'Brand',
      'at': '2026-11-15',
    });

    await _tap(tester, find.text('Clear'));
    expect(find.text('Recently checked'), findsNothing);
  });

  testWidgets('a product goes onto the shopping list once', (tester) async {
    final app = await _open(tester);
    await _searchAndOpen(tester);
    await _tap(tester, find.byKey(const ValueKey('add-to-list')));
    expect(find.text('Added to your shopping list.'), findsOneWidget);
    expect(find.text('On your list'), findsOneWidget);
    final item = (_local(app.store)['shopping']! as List).single as Map;
    expect(item['title'], 'Brand · Day Cream');
    expect(item['origin'], 'check');
    expect(item['code'], '4001');
  });

  testWidgets('the shopping list adds, ticks, groups and removes items', (
    tester,
  ) async {
    final app = await _open(tester);
    await _tap(tester, find.byKey(const ValueKey('open-shopping')));
    expect(
      find.text('The list is empty. Note what you need here.'),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey('shopping-new')),
      'SPF 30',
    );
    await _tap(tester, find.byKey(const ValueKey('shopping-add')));
    await tester.enterText(
      find.byKey(const ValueKey('shopping-new')),
      'Heat protect spray',
    );
    await _tap(tester, find.byKey(const ValueKey('shopping-area-hair')));
    await _tap(tester, find.byKey(const ValueKey('shopping-add')));
    expect(find.text('FACE'), findsOneWidget);
    expect(find.text('HAIR'), findsOneWidget);
    expect(find.text('0 of 2 bought'), findsOneWidget);

    await _tap(tester, find.text('SPF 30'));
    expect(find.text('1 of 2 bought'), findsOneWidget);
    await _tap(tester, find.text('Remove bought'));
    expect(find.text('SPF 30'), findsNothing);
    await _tap(tester, find.byTooltip('Remove: Heat protect spray'));
    expect(_local(app.store)['shopping'], isEmpty);
    expect(
      find.textContaining('For now your preferences and shopping list'),
      findsOneWidget,
    );

    await _tap(tester, find.byKey(const ValueKey('shop-soon')));
    expect(find.text('Parla Shop'), findsOneWidget);
    // No sign-up for news on the shop screen.
    expect(find.byType(Switch), findsNothing);
    await _tap(tester, find.text('See my shopping list'));
    expect(find.byKey(const ValueKey('shopping-new')), findsOneWidget);
  });

  testWidgets('Discover opens the shopping list', (tester) async {
    await _open(tester);
    await tester.tap(
      find
          .descendant(
            of: find.byType(ParlaNavBar),
            matching: find.byType(InkWell),
          )
          .at(3),
    );
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Shopping list'));
    expect(find.byKey(const ValueKey('shopping-new')), findsOneWidget);
    // Back returns to Discover, not to Check.
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Shopping list'), findsOneWidget);
    expect(find.text('Check a product'), findsNothing);
  });

  group('with the health consent', () {
    testWidgets('the list is kept on the server too', (tester) async {
      final app = await _open(tester, healthConsent: true);
      await _pick(tester, ['sulfate_free']);
      final server = jsonDecode(app.api.careList!) as Map;
      expect(server['preferences'], ['sulfate_free']);
      expect(app.api.careList, isNot(contains('pendingUpload')));
      expect(_local(app.store)['pendingUpload'], isFalse);
    });

    testWidgets("the server's list shows on a new phone", (tester) async {
      final api = FakeApi()
        ..signedIn = true
        ..profile = const ProfileSummary(countryCode: 'AZ', language: 'en')
        ..healthConsent = true
        ..careList = jsonEncode({
          'format': 1,
          'preferences': ['paraben_free'],
        });
      await _open(tester, api: api);
      expect(find.text('Paraben-free'), findsOneWidget);
    });

    testWidgets('the export and account deletion cover the phone copy', (
      tester,
    ) async {
      final store = MemoryHabitStore()
        ..data['user-1'] = jsonEncode({
          'format': 1,
          'preferences': ['vegan'],
        })
        ..data['other-user'] = '{}';
      final app = await _open(tester, healthConsent: true, store: store);
      await tester.tap(
        find
            .descendant(
              of: find.byType(ParlaNavBar),
              matching: find.byType(InkWell),
            )
            .at(0),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find
            .descendant(
              of: find.byType(ParlaNavBar),
              matching: find.byType(InkWell),
            )
            .at(4),
      );
      await tester.pumpAndSettle();
      await _tap(tester, find.text('Create file'));
      final file = jsonDecode(app.shared.single) as Map<String, Object?>;
      expect((file['deviceCareList']! as Map)['preferences'], ['vegan']);

      await _tap(tester, find.text('Delete account'));
      await tester.enterText(
        find.byKey(const ValueKey('delete-confirm')),
        'delete',
      );
      await tester.pumpAndSettle();
      await _tap(
        tester,
        find.widgetWithText(FilledButton, 'Delete my account'),
      );
      expect(store.data.keys, ['other-user']);
    });
  });

  for (final language in ['az', 'ru', 'en']) {
    testWidgets('$language: Check, product, list and shop hold at 200% text', (
      tester,
    ) async {
      await _open(tester, language: language, textScale: 2);
      void check() {
        expect(tester.takeException(), isNull);
        for (final size in paintedFontSizes(tester)) {
          expect(size, greaterThanOrEqualTo(kMinTextSize));
        }
      }

      check();
      await _pick(tester, ['fragrance_free', 'vegan']);
      check();
      await tester.enterText(
        find.byKey(const ValueKey('product-query')),
        'day',
      );
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      await _tap(tester, find.text('Day Cream'));
      check();
      await _tap(tester, find.byKey(const ValueKey('add-to-list')));
      await _tap(tester, find.byType(BackButton));
      await _tap(tester, find.byKey(const ValueKey('open-shopping')));
      check();
      await _tap(tester, find.byKey(const ValueKey('shop-soon')));
      check();
    });
  }
}
