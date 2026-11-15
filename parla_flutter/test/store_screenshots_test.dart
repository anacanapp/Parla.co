// App Store screenshots, rendered from the real screens with made-up data.
//
// Skipped in normal test runs. Generate (or refresh) them with:
//   flutter test test/store_screenshots_test.dart \
//     --dart-define=STORE_SCREENSHOTS=true
// The PNGs land in ios/fastlane/screenshots/tr/ (the store listing is
// Turkish; the screens are shown in Azerbaijani, the app's main language)
// at 1320x2868, the iPhone 6.9" size App Store Connect asks for.
//
// Everything shown is invented: no real person, answer or product.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:parla/app.dart';
import 'package:parla/habits/habit_log.dart';
import 'package:parla/habits/habit_store.dart';
import 'package:parla/routes.dart';
import 'package:parla/services/parla_api.dart';
import 'package:parla/state/app_settings.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_api.dart';
import 'support/fake_reminders.dart';

const _enabled = bool.fromEnvironment('STORE_SCREENSHOTS');
const _language = 'az';
const _dir = '../ios/fastlane/screenshots/tr';
final _today = DateTime(2026, 11, 12, 9);

const _answers = QuizAnswers(
  chosen: {
    'skin_type': ['combination'],
    'skin_sensitivity': ['rarely'],
    'routine_time': ['standard'],
  },
);

/// Display-only sample ingredient data for the product screenshot.
final _dataset = IngredientDataset(
  source: 'CosIng',
  exportedOn: '2026-11-01',
  entries: const [
    IngredientEntry(
      inci: 'PHENOXYETHANOL',
      rules: [
        IngredientRule(
          annex: EuAnnex.v,
          reference: '29',
          conditions: 'Maximum concentration in ready for use preparation: 1 %',
        ),
      ],
    ),
  ],
);

const _product = ProductResult(
  source: 'openbeautyfacts',
  code: 'sample-1',
  name: 'Nəmləndirici gündüz kremi',
  brand: 'Nümunə',
  ingredientsText:
      'Aqua, Glycerin, Niacinamide, Squalane, Panthenol, Phenoxyethanol',
);

MemoryHabitStore _store() {
  final log = HabitLog();
  final days = {
    0: (6, 7.5, 20),
    1: (8, 7.0, 30),
    2: (5, 6.5, 20),
    3: (7, 8.0, null),
    4: (8, 7.5, 45),
    5: (4, 6.0, null),
    6: (7, 7.0, 25),
  };
  days.forEach((ago, v) {
    final d = log.day(_today.subtract(Duration(days: ago)))
      ..water = v.$1
      ..sleepHours = v.$2
      ..moveMinutes = v.$3;
    if (ago != 0) d.morningDone.add('cleanser');
    if (ago.isOdd) d.eveningDone.add('makeup-off');
  });
  log.day(_today)
    ..morningDone.addAll(['cleanser', 'vitamin-c', 'moisturiser'])
    ..moveMinutes = 20;
  return MemoryHabitStore()..data['user-1'] = jsonEncode(log.toJson());
}

Future<void> _loadIconFont() async {
  // Material icons are not loaded in tests by default (chevrons would show
  // as boxes); take the font from the Flutter SDK running the test.
  final root = Platform.environment['FLUTTER_ROOT'];
  if (root == null) return;
  final file = File(
    '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
  if (!file.existsSync()) return;
  final loader = FontLoader('MaterialIcons')
    ..addFont(Future.value(ByteData.sublistView(file.readAsBytesSync())));
  await loader.load();
}

Future<void> _open(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1320, 2868);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues({'language': _language});
  final settings = await AppSettings.load();
  final api = FakeApi()
    ..signedIn = true
    ..healthConsent = true
    ..profile = const ProfileSummary(countryCode: 'AZ', language: _language)
    ..quizAnswers = _answers
    ..products = const [_product];
  await tester.pumpWidget(
    ParlaApp(
      key: UniqueKey(),
      api: api,
      settings: settings,
      clock: () => _today,
      habitStore: _store(),
      reminderScheduler: FakeReminderScheduler(),
      ingredientDataset: _dataset,
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _go(WidgetTester tester, String route) async {
  GoRouter.of(tester.element(find.byType(Scaffold).first)).go(route);
  await tester.pumpAndSettle();
}

Future<void> _shoot(WidgetTester tester, String name) async {
  await expectLater(
    find.byType(ParlaApp),
    matchesGoldenFile('$_dir/$name.png'),
  );
}

void main() {
  setUpAll(() async {
    autoUpdateGoldenFiles = true;
    await _loadIconFont();
  });

  testWidgets('01 home', skip: !_enabled, (tester) async {
    await _open(tester);
    await _shoot(tester, '01_home');
  });

  testWidgets('02 habits', skip: !_enabled, (tester) async {
    await _open(tester);
    await _go(tester, Routes.habits);
    await _shoot(tester, '02_habits');
  });

  testWidgets('03 product search', skip: !_enabled, (tester) async {
    await _open(tester);
    await _go(tester, Routes.products);
    await tester.enterText(
      find.byKey(const ValueKey('product-query')),
      'krem',
    );
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    await _shoot(tester, '03_products');
  });

  testWidgets('04 product ingredients', skip: !_enabled, (tester) async {
    await _open(tester);
    await _go(tester, Routes.products);
    await tester.enterText(
      find.byKey(const ValueKey('product-query')),
      'krem',
    );
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text(_product.name).first);
    await tester.pumpAndSettle();
    await _shoot(tester, '04_ingredients');
  });

  testWidgets('05 reminders', skip: !_enabled, (tester) async {
    await _open(tester);
    await _go(tester, Routes.reminders);
    await _shoot(tester, '05_reminders');
  });

  testWidgets('06 privacy', skip: !_enabled, (tester) async {
    await _open(tester);
    await _go(tester, Routes.privacy);
    await _shoot(tester, '06_privacy');
  });
}
