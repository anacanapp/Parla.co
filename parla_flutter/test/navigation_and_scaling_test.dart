import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:parla/app.dart';
import 'package:parla/habits/habit_store.dart';
import 'package:parla/home/widgets/parla_nav_bar.dart';
import 'package:parla/routes.dart';
import 'package:parla/services/parla_api.dart';
import 'package:parla/state/app_settings.dart';
import 'package:parla/ui/brand.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_api.dart';
import 'support/fake_reminders.dart';
import 'support/text_sizes.dart';

/// Opens the app on a 390 px phone, signed in or not, with the system text
/// size multiplied by [textScale].
Future<void> _pump(
  WidgetTester tester, {
  required String language,
  bool signedIn = true,
  double textScale = 1,
}) async {
  tester.view.physicalSize = const Size(390 * 3, 844 * 3);
  tester.view.devicePixelRatio = 3;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

  SharedPreferences.setMockInitialValues({'language': language});
  final settings = await AppSettings.load();
  final api = FakeApi()..signedIn = signedIn;
  if (signedIn) {
    api.profile = ProfileSummary(countryCode: 'AZ', language: language);
  }
  await tester.pumpWidget(
    ParlaApp(
      api: api,
      settings: settings,
      clock: () => DateTime(2026, 11, 12, 9),
      habitStore: MemoryHabitStore(),
      reminderScheduler: FakeReminderScheduler(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _go(WidgetTester tester, String route) async {
  GoRouter.of(tester.element(find.byType(Scaffold).first)).go(route);
  await tester.pumpAndSettle();
}

Finder _tab(ParlaTab tab) => find
    .descendant(of: find.byType(ParlaNavBar), matching: find.byType(InkWell))
    .at(tab.index);

void main() {
  testWidgets('the navigation has five tabs in the agreed order', (
    tester,
  ) async {
    await _pump(tester, language: 'az');
    // Every tab is named for screen readers.
    for (final label in ['Bu gün', 'Rutin', 'Yoxla', 'Kəşf et', 'Profil']) {
      expect(
        find.descendant(
          of: find.byType(ParlaNavBar),
          matching: find.bySemanticsLabel(label),
        ),
        findsOneWidget,
        reason: label,
      );
    }
    // Light design: the menu shows icons only; the names live in the
    // semantics (and tooltips).
    expect(
      find.descendant(
        of: find.byType(ParlaNavBar),
        matching: find.text('Bu gün'),
      ),
      findsNothing,
    );
  });

  testWidgets('every tab opens its screen', (tester) async {
    await _pump(tester, language: 'en');
    await tester.tap(_tab(ParlaTab.profile));
    await tester.pumpAndSettle();
    expect(find.text('Privacy centre'), findsOneWidget);

    await tester.tap(_tab(ParlaTab.discover));
    await tester.pumpAndSettle();
    expect(find.text('Blogs'), findsOneWidget);
    expect(find.text('Experts'), findsOneWidget);
    expect(find.text('Shopping list'), findsOneWidget);

    await tester.tap(_tab(ParlaTab.routine));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('area-face')), findsOneWidget);

    await tester.tap(_tab(ParlaTab.check));
    await tester.pumpAndSettle();
    expect(find.text('Check a product'), findsOneWidget);

    await tester.tap(_tab(ParlaTab.today));
    await tester.pumpAndSettle();
    expect(find.byType(ParlaNavBar), findsOneWidget);
  });

  for (final language in supportedLanguages) {
    testWidgets('$language: no text under the minimum size on the tabs and '
        'onboarding', (tester) async {
      await _pump(tester, language: language);
      final sizes = <double>[];
      for (final route in [
        Routes.home,
        Routes.habits,
        Routes.products,
        Routes.sport,
        Routes.discover,
      ]) {
        await _go(tester, route);
        sizes.addAll(paintedFontSizes(tester));
      }
      for (final route in [
        Routes.welcome,
        Routes.age,
        Routes.country,
        Routes.consents,
      ]) {
        await _go(tester, route);
        sizes.addAll(paintedFontSizes(tester));
      }
      expect(sizes, isNotEmpty);
      expect(sizes.where((s) => s < kMinTextSize), isEmpty);
    });

    // People who set a large system text size get it everywhere; nothing
    // may overflow or be cut off at twice the normal size.
    testWidgets('$language: screens hold at 200% system text size', (
      tester,
    ) async {
      await _pump(tester, language: language, textScale: 2);
      for (final route in [
        Routes.home,
        Routes.habits,
        Routes.products,
        Routes.sport,
        Routes.discover,
        Routes.welcome,
        Routes.age,
        Routes.country,
        Routes.consents,
      ]) {
        await _go(tester, route);
        expect(tester.takeException(), isNull, reason: route);
      }
    });
  }
}
