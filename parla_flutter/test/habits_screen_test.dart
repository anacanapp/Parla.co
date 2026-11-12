import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla/app.dart';
import 'package:parla/habits/habit_log.dart';
import 'package:parla/habits/habit_store.dart';
import 'package:parla/home/widgets/parla_nav_bar.dart';
import 'package:parla/services/parla_api.dart';
import 'package:parla/state/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_api.dart';
import 'support/text_sizes.dart';

final _today = DateTime(2026, 11, 12, 9);

/// A store with three logged days in the last week.
MemoryHabitStore _seeded() {
  final log = HabitLog();
  log.day(_today)
    ..water = 6
    ..sleepHours = 7.5
    ..morningDone.add('cleanser');
  log.day(DateTime(2026, 11, 11))
    ..water = 4
    ..sleepHours = 6.5
    ..moveMinutes = 30
    ..eveningDone.add('makeup-off');
  log.day(DateTime(2026, 11, 8)).moveMinutes = 45;
  return MemoryHabitStore()..data['user-1'] = jsonEncode(log.toJson());
}

Future<void> _pumpHabits(
  WidgetTester tester, {
  String language = 'en',
  MemoryHabitStore? store,
}) async {
  tester.view.physicalSize = const Size(390 * 3, 844 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues({'language': language});
  final settings = await AppSettings.load();
  final api = FakeApi()
    ..signedIn = true
    ..profile = ProfileSummary(countryCode: 'AZ', language: language);
  await tester.pumpWidget(
    ParlaApp(
      api: api,
      settings: settings,
      clock: () => _today,
      habitStore: store ?? _seeded(),
    ),
  );
  await tester.pumpAndSettle();
  await _navTo(tester, 2);
}

/// Taps tab [index] of the bottom navigation.
Future<void> _navTo(WidgetTester tester, int index) async {
  await tester.tap(
    find
        .descendant(
          of: find.byType(ParlaNavBar),
          matching: find.byType(InkWell),
        )
        .at(index),
  );
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

String? _label(WidgetTester tester, String key) {
  final finder = find.byKey(ValueKey(key));
  final semantics = tester.getSemantics(
    find.descendant(of: finder, matching: find.byType(Semantics)).first,
  );
  return semantics.label;
}

void main() {
  testWidgets('weekday labels are short and distinct in every language', (
    tester,
  ) async {
    for (final language in ['az', 'ru', 'en']) {
      await _pumpHabits(tester, language: language);
      final card = find.byKey(const ValueKey('week-care'));
      await tester.scrollUntilVisible(
        card,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      final labels = [
        for (final t in tester.widgetList<Text>(
          find.descendant(of: card, matching: find.byType(Text)),
        ))
          t.data!,
      ].skip(2).toList();
      expect(labels, hasLength(7), reason: language);
      expect(labels.toSet(), hasLength(7), reason: '$language: $labels');
      expect(labels.every((l) => l.length <= 2), isTrue, reason: '$labels');
      debugPrint('$language weekdays: $labels');
    }
  });

  testWidgets('the week shows plain counts and averages', (tester) async {
    await _pumpHabits(tester);
    expect(find.text('Habits'), findsWidgets);
    expect(find.text('Last 7 days'), findsOneWidget);

    final handle = tester.ensureSemantics();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('week-move')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
      _label(tester, 'week-care'),
      'Days you made time for your routine. 2 of 7 days',
    );
    expect(
      _label(tester, 'week-water'),
      'Water. On average 5 glasses a day',
    );
    expect(
      _label(tester, 'week-sleep'),
      'Sleep. On average 7 h, 2 nights logged',
    );
    expect(
      _label(tester, 'week-move'),
      'Movement. 75 min in total, on 2 days',
    );
    handle.dispose();
  });

  testWidgets('an empty week says nothing is logged yet', (tester) async {
    await _pumpHabits(tester, store: MemoryHabitStore());
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('week-move')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Nothing logged yet'), findsWidgets);
    expect(find.text('0 of 7 days'), findsOneWidget);
  });

  testWidgets('water added on the habits tab shows on the home tab', (
    tester,
  ) async {
    await _pumpHabits(tester);
    expect(find.text('6 of 8 glasses'), findsOneWidget);
    await _tap(tester, find.bySemanticsLabel('Add a glass'));
    expect(find.text('7 of 8 glasses'), findsOneWidget);

    await _navTo(tester, 0);
    await tester.scrollUntilVisible(
      find.text('7 of 8 glasses'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('7 of 8 glasses'), findsOneWidget);
  });

  testWidgets('the screen says the entries stay on the phone', (tester) async {
    await _pumpHabits(tester);
    await tester.scrollUntilVisible(
      find.textContaining('kept only on this phone'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('kept only on this phone'), findsOneWidget);
  });

  for (final language in ['az', 'ru', 'en']) {
    testWidgets('$language: habits screen and log sheet keep text at 18 px '
        'or more without overflow', (tester) async {
      await _pumpHabits(tester, language: language);
      final sizes = <double>[];
      final list = find.byType(Scrollable).first;
      for (var i = 0; i < 6; i++) {
        sizes.addAll(paintedFontSizes(tester));
        expect(tester.takeException(), isNull);
        await tester.drag(list, const Offset(0, -400));
        await tester.pumpAndSettle();
      }
      await tester.drag(list, const Offset(0, 5000));
      await tester.pumpAndSettle();

      // Open the sleep sheet through its action button.
      final sleep = find.byKey(const ValueKey('habits-sleep'));
      await _tap(
        tester,
        find.descendant(of: sleep, matching: find.byType(TextButton)),
      );
      sizes.addAll(paintedFontSizes(tester));
      expect(tester.takeException(), isNull);

      expect(sizes, isNotEmpty);
      expect(sizes.where((s) => s < 18), isEmpty);
    });
  }
}
