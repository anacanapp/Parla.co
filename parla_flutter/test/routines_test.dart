import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla/app.dart';
import 'package:parla/habits/habit_store.dart';
import 'package:parla/home/routine.dart';
import 'package:parla/home/widgets/home_cards.dart';
import 'package:parla/home/widgets/parla_nav_bar.dart';
import 'package:parla/routines/routine_builder_screen.dart';
import 'package:parla/services/parla_api.dart';
import 'package:parla/state/app_settings.dart';
import 'package:parla/ui/brand.dart';
import 'package:parla/ui/parla_icons.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_api.dart';
import 'support/fake_reminders.dart';
import 'support/text_sizes.dart';

/// Thursday.
final _thursday = DateTime(2026, 11, 12, 9);

class _App {
  _App(this.api, this.habits, this.routines, this.shared);

  final FakeApi api;
  final MemoryHabitStore habits;
  final MemoryHabitStore routines;
  final List<String> shared;
}

/// Signed-in user on the Routine tab.
Future<_App> _open(
  WidgetTester tester, {
  String language = 'en',
  DateTime? now,
  MemoryHabitStore? habits,
  MemoryHabitStore? routines,
  QuizAnswers? answers,
  bool? healthConsent,
  FakeApi? api,
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
  final habitStore = habits ?? MemoryHabitStore();
  final routineStore = routines ?? MemoryHabitStore();
  api ??= FakeApi()
    ..signedIn = true
    ..profile = ProfileSummary(countryCode: 'AZ', language: language)
    ..healthConsent = healthConsent ?? answers != null
    ..quizAnswers = answers;
  await tester.pumpWidget(
    ParlaApp(
      // A new key per pump, so a second pump starts a fresh app.
      key: UniqueKey(),
      api: api,
      reminderScheduler: FakeReminderScheduler(),
      settings: settings,
      clock: () => now ?? _thursday,
      shareExport: (json) async => shared.add(json),
      habitStore: habitStore,
      routineStore: routineStore,
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
  return _App(api, habitStore, routineStore, shared);
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  final list = find.byType(Scrollable);
  if (finder.evaluate().isEmpty && list.evaluate().isNotEmpty) {
    // Look below first, then above (the lists are lazy).
    try {
      await tester.scrollUntilVisible(finder, 200, scrollable: list.first);
    } on StateError {
      await tester.scrollUntilVisible(finder, -200, scrollable: list.first);
    }
  }
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
  await tester.tap(finder.first);
  await tester.pumpAndSettle();
}

Future<void> _enter(WidgetTester tester, String key, String value) async {
  final field = find.byKey(ValueKey(key));
  // The field may be scrolled out of the (lazy) list above.
  if (field.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      field,
      -200,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await tester.ensureVisible(field);
  await tester.enterText(field, value);
  await tester.pumpAndSettle();
}

/// Makes a routine through the builder, starting on the Routine tab.
Future<void> _makeRoutine(
  WidgetTester tester, {
  required String name,
  required List<String> steps,
  String area = 'hair',
  int? weekday,
}) async {
  await _tap(tester, find.byKey(const ValueKey('routine-own-add')));
  await _enter(tester, 'builder-name', name);
  await _tap(tester, find.byKey(ValueKey('builder-area-$area')));
  if (weekday != null) {
    await _tap(tester, find.byKey(const ValueKey('builder-once-week')));
    await _tap(tester, find.byKey(ValueKey('builder-day-$weekday')));
  }
  for (final step in steps) {
    await _enter(tester, 'builder-new-step', step);
    await _tap(tester, find.byKey(const ValueKey('builder-add-step')));
  }
  await _tap(tester, find.text('Save routine'));
}

Map<String, Object?> _stored(MemoryHabitStore store) =>
    jsonDecode(store.data['user-1']!) as Map<String, Object?>;

/// Every answer combination the area rules react to.
final _answerSets = <QuizAnswers?>[
  null,
  const QuizAnswers(
    chosen: {
      'hair_type': ['curly'],
      'hair_concerns': ['dryness', 'breakage'],
      'sun_exposure': ['outdoors'],
    },
  ),
  const QuizAnswers(
    chosen: {
      'hair_type': ['straight'],
      'hair_concerns': ['oiliness'],
      'sensitivity': ['often'],
      'sun_exposure': ['indoors'],
    },
  ),
];

void main() {
  test('every step the area rules can produce has text in every '
      'language', () {
    for (final answers in _answerSets) {
      for (final area in RoutineArea.values) {
        final plan = planArea(area, answers);
        for (final slot in RoutineSlot.values) {
          final ids = plan.slot(slot);
          for (final language in ['az', 'ru', 'en']) {
            expect(
              routineSteps(ids, language).map((s) => s.id),
              ids,
              reason: '$language $area $slot',
            );
          }
        }
      }
    }
  });

  test('hair and body suggestions exist in every language', () {
    for (final language in ['az', 'ru', 'en']) {
      expect(stepSuggestions(RoutineArea.hair, language), hasLength(11));
      expect(stepSuggestions(RoutineArea.body, language), hasLength(8));
      expect(stepSuggestions(RoutineArea.face, language), isNotEmpty);
    }
  });

  testWidgets('the Routine tab switches between face, hair and body', (
    tester,
  ) async {
    await _open(tester);
    expect(find.byKey(const ValueKey('area-face')), findsOneWidget);

    await _tap(tester, find.byKey(const ValueKey('area-hair')));
    expect(
      find.byKey(const ValueKey('routine-step-hair-detangle')),
      findsOneWidget,
    );
    // No evening hair steps without answers, so no evening chip.
    expect(find.byKey(const ValueKey('slot-evening')), findsNothing);

    await _tap(tester, find.byKey(const ValueKey('area-body')));
    expect(
      find.byKey(const ValueKey('routine-step-body-cleanser')),
      findsOneWidget,
    );
  });

  testWidgets('a weekly step stays ticked for the rest of the week, '
      'then opens again on Monday', (tester) async {
    final habits = MemoryHabitStore();
    await _open(tester, habits: habits);
    await _tap(tester, find.byKey(const ValueKey('area-hair')));
    await _tap(tester, find.byKey(const ValueKey('slot-weekly')));
    expect(find.text('Weekly · 0/2'), findsOneWidget);
    await _tap(
      tester,
      find.descendant(
        of: find.byKey(const ValueKey('routine-step-hair-shampoo')),
        matching: find.byType(InkResponse),
      ),
    );
    expect(find.text('Weekly · 1/2'), findsOneWidget);

    // Saturday of the same week.
    await _open(tester, habits: habits, now: DateTime(2026, 11, 14, 10));
    await _tap(tester, find.byKey(const ValueKey('area-hair')));
    expect(find.text('Weekly · 1/2'), findsOneWidget);

    // Monday of the next week.
    await _open(tester, habits: habits, now: DateTime(2026, 11, 16, 10));
    await _tap(tester, find.byKey(const ValueKey('area-hair')));
    expect(find.text('Weekly · 0/2'), findsOneWidget);
  });

  testWidgets('an own routine is made, kept on the phone and ticked off', (
    tester,
  ) async {
    final app = await _open(tester);
    expect(find.text('Make your own routine and tick it off here.'), findsOne);

    await _makeRoutine(
      tester,
      name: 'Sunday spa',
      steps: ['Oil the ends', 'Silk pillowcase'],
    );
    // Back on the Routine tab, face is shown first.
    await _tap(tester, find.byKey(const ValueKey('area-hair')));
    expect(find.text('Sunday spa'), findsOneWidget);
    expect(find.textContaining('Every day · 2 steps · 0/2'), findsOneWidget);

    final routines = _stored(app.routines)['routines']! as List;
    expect(routines, hasLength(1));
    expect((routines.single as Map)['name'], 'Sunday spa');
    expect((routines.single as Map)['area'], 'hair');
    // Without the health consent nothing reaches the server.
    expect(app.api.routines, isNull);
    expect(app.api.routineSaves, 0);

    await _tap(tester, find.text('Oil the ends'));
    expect(find.textContaining('Every day · 2 steps · 1/2'), findsOneWidget);
    expect(_stored(app.routines)['ticks'], {
      '2026-11-12': [isA<String>()],
    });
    expect(app.habits.data['user-1'] ?? '', isNot(contains('customDone')));
  });

  testWidgets('a once-a-week routine shows its steps only on its day', (
    tester,
  ) async {
    final routines = MemoryHabitStore();
    await _open(tester, routines: routines);
    await _makeRoutine(
      tester,
      name: 'Mask night',
      area: 'face',
      steps: ['Clay mask'],
      weekday: DateTime.sunday,
    );
    expect(find.text('Mask night'), findsOneWidget);
    expect(find.textContaining('Sunday · 1 step'), findsOneWidget);
    expect(find.text('Clay mask'), findsNothing);

    await _open(tester, routines: routines, now: DateTime(2026, 11, 15, 9));
    await tester.scrollUntilVisible(
      find.text('Clay mask'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Clay mask'), findsOneWidget);
  });

  testWidgets('the builder asks for a name and a step', (tester) async {
    final app = await _open(tester);
    await _tap(tester, find.byKey(const ValueKey('routine-own-add')));
    expect(find.text('Make your own routine'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.textContaining('For now your own routines are kept only on'),
      200,
      scrollable: find.byType(Scrollable).first,
    );

    await _tap(tester, find.text('Save routine'));
    expect(find.text('Give the routine a name.'), findsOneWidget);

    await _enter(tester, 'builder-name', 'Quick');
    await _tap(tester, find.text('Save routine'));
    await tester.scrollUntilVisible(
      find.text('Add at least one step.'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Add at least one step.'), findsOneWidget);
    expect(app.routines.data, isEmpty);

    // A ready step from the suggestions.
    await _tap(tester, find.byKey(const ValueKey('builder-area-body')));
    await _tap(tester, find.widgetWithText(ActionChip, 'Body moisturiser'));
    await _tap(tester, find.text('Save routine'));
    expect(app.routines.data, contains('user-1'));
  });

  testWidgets('a routine can be edited, reordered and deleted', (
    tester,
  ) async {
    final app = await _open(tester);
    await _makeRoutine(tester, name: 'Evening', steps: ['One', 'Two']);
    await _tap(tester, find.byKey(const ValueKey('area-hair')));

    await _tap(tester, find.byTooltip('Edit: Evening'));
    expect(find.text('Edit routine'), findsOneWidget);
    await _enter(tester, 'builder-name', 'Evening calm');
    await _tap(tester, find.byTooltip('Move down: One'));
    await _tap(tester, find.text('Save routine'));

    final saved = (_stored(app.routines)['routines']! as List).single as Map;
    expect(saved['name'], 'Evening calm');
    expect(
      [for (final s in saved['steps'] as List) (s as Map)['title']],
      [
        'Two',
        'One',
      ],
    );

    await _tap(tester, find.byKey(const ValueKey('area-hair')));
    await _tap(tester, find.byTooltip('Edit: Evening calm'));
    await _tap(tester, find.byKey(const ValueKey('builder-delete')));
    expect(find.text('Delete this routine?'), findsOneWidget);
    await _tap(tester, find.text('Cancel'));
    expect(_stored(app.routines)['routines'], hasLength(1));

    await _tap(tester, find.byKey(const ValueKey('builder-delete')));
    await _tap(tester, find.byKey(const ValueKey('builder-delete-yes')));
    expect(_stored(app.routines)['routines'], isEmpty);
    await _tap(tester, find.byKey(const ValueKey('area-hair')));
    expect(find.text('Evening calm'), findsNothing);
  });

  testWidgets('own routines go into the data export and are deleted with '
      'the account', (tester) async {
    final routines = MemoryHabitStore()
      ..data['user-1'] = jsonEncode({
        'format': 1,
        'routines': [
          {
            'id': 'r1',
            'name': 'Spa',
            'area': 'body',
            'steps': [
              {'id': 's1', 'title': 'Scrub'},
            ],
          },
        ],
      })
      ..data['other-user'] = '{}';
    final app = await _open(
      tester,
      routines: routines,
      answers: const QuizAnswers(chosen: {}),
    );
    await _tap(tester, find.byKey(const ValueKey('area-body')));
    expect(find.text('Spa'), findsOneWidget);

    // Profile and privacy open from the avatar on the Today screen.
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
      find.byWidgetPredicate(
        (w) => w is RoundIconButton && w.icon == ParlaIconName.profile,
      ),
    );
    await tester.pumpAndSettle();

    await _tap(tester, find.text('Create file'));
    final file = jsonDecode(app.shared.single) as Map<String, Object?>;
    expect((file['deviceRoutines']! as Map)['routines'], hasLength(1));

    await _tap(tester, find.text('Delete account'));
    await tester.enterText(
      find.byKey(const ValueKey('delete-confirm')),
      'delete',
    );
    await tester.pumpAndSettle();
    await _tap(tester, find.widgetWithText(FilledButton, 'Delete my account'));
    expect(app.api.deleted, isTrue);
    expect(routines.data.keys, ['other-user']);
  });

  testWidgets('Today lists hair, body and own routines due today; a '
      'finished weekly slot waits for next week', (tester) async {
    final habits = MemoryHabitStore();
    final routines = MemoryHabitStore()
      ..data['user-1'] = jsonEncode({
        'format': 1,
        'routines': [
          {
            'id': 'r1',
            'name': 'Spa',
            'area': 'body',
            'steps': [
              {'id': 's1', 'title': 'Scrub'},
            ],
          },
          {
            'id': 'r2',
            'name': 'Sunday mask',
            'area': 'face',
            'weekday': DateTime.sunday,
            'steps': [
              {'id': 's2', 'title': 'Clay'},
            ],
          },
        ],
      });
    await _open(tester, habits: habits, routines: routines);
    // Tick both weekly hair steps on the Routine tab.
    await _tap(tester, find.byKey(const ValueKey('area-hair')));
    await _tap(tester, find.byKey(const ValueKey('slot-weekly')));
    for (final id in ['hair-shampoo', 'hair-conditioner']) {
      await _tap(
        tester,
        find.descendant(
          of: find.byKey(ValueKey('routine-step-$id')),
          matching: find.byType(InkResponse),
        ),
      );
    }

    await _tap(tester, find.text('Today').last);
    final list = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('today-own-r1')),
      200,
      scrollable: list,
    );
    expect(find.byKey(const ValueKey('today-hair-morning')), findsOneWidget);
    expect(find.byKey(const ValueKey('today-body-morning')), findsOneWidget);
    // The base body routine has no weekly step.
    expect(find.byKey(const ValueKey('today-body-weekly')), findsNothing);
    expect(find.byKey(const ValueKey('today-hair-weekly')), findsNothing);
    expect(find.byKey(const ValueKey('today-own-r2')), findsNothing);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('today-own-r1')),
        matching: find.text('0/1'),
      ),
      findsOneWidget,
    );

    await _tap(tester, find.byKey(const ValueKey('today-own-r1')));
    expect(find.byKey(const ValueKey('area-face')), findsOneWidget);
  });

  group('with the health consent', () {
    Map<String, Object?> server(FakeApi api) =>
        jsonDecode(api.routines!) as Map<String, Object?>;

    testWidgets('a new routine and its ticks are kept on the server too', (
      tester,
    ) async {
      final app = await _open(tester, healthConsent: true);
      await _makeRoutine(tester, name: 'Spa', steps: ['Mask']);
      expect(
        (server(app.api)['routines']! as List).single,
        containsPair(
          'name',
          'Spa',
        ),
      );
      expect(_stored(app.routines)['pendingUpload'], isFalse);

      await _tap(tester, find.byKey(const ValueKey('area-hair')));
      await _tap(tester, find.text('Mask'));
      expect(server(app.api)['ticks'], {
        '2026-11-12': [isA<String>()],
      });
      // The pending flag is local only and never sent.
      expect(app.api.routines, isNot(contains('pendingUpload')));

      await _tap(tester, find.byTooltip('Edit: Spa'));
      await tester.scrollUntilVisible(
        find.textContaining('kept encrypted on our server'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
    });

    testWidgets("the server's copy is shown on a new phone", (tester) async {
      final api = FakeApi()
        ..signedIn = true
        ..profile = const ProfileSummary(countryCode: 'AZ', language: 'en')
        ..healthConsent = true
        ..routines = jsonEncode({
          'format': 1,
          'routines': [
            {'id': 'r1', 'name': 'From the cloud', 'area': 'face'},
          ],
        });
      final routines = MemoryHabitStore();
      await _open(tester, api: api, routines: routines);
      await tester.scrollUntilVisible(
        find.text('From the cloud'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(_stored(routines)['routines'], hasLength(1));
      expect(api.routineSaves, 0);
    });

    testWidgets('changes made offline are sent on the next start', (
      tester,
    ) async {
      final api = FakeApi()
        ..signedIn = true
        ..profile = const ProfileSummary(countryCode: 'AZ', language: 'en')
        ..healthConsent = true
        ..routineError = Exception('offline');
      final routines = MemoryHabitStore();
      await _open(tester, api: api, routines: routines);
      await _makeRoutine(tester, name: 'Offline', steps: ['One']);
      expect(api.routines, isNull);
      expect(_stored(routines)['pendingUpload'], isTrue);

      api.routineError = null;
      await _open(tester, api: api, routines: routines);
      expect(server(api)['routines'], hasLength(1));
      expect(_stored(routines)['pendingUpload'], isFalse);
    });

    testWidgets('routines and ticks from an earlier version move to the '
        'server', (tester) async {
      final routines = MemoryHabitStore()
        ..data['user-1'] = jsonEncode({
          'format': 1,
          'routines': [
            {
              'id': 'r1',
              'name': 'Old',
              'area': 'body',
              'steps': [
                {'id': 's1', 'title': 'Scrub'},
              ],
            },
          ],
        });
      final habits = MemoryHabitStore()
        ..data['user-1'] = jsonEncode({
          'format': 'parla-habits-v1',
          'days': {
            '2026-11-12': {
              'water': 2,
              'customDone': ['s1'],
            },
          },
        });
      final app = await _open(
        tester,
        healthConsent: true,
        routines: routines,
        habits: habits,
      );
      expect(server(app.api)['routines'], hasLength(1));
      expect(server(app.api)['ticks'], {
        '2026-11-12': ['s1'],
      });
      expect(habits.data['user-1'], isNot(contains('customDone')));
      expect(habits.data['user-1'], contains('"water":2'));
    });
  });

  for (final language in ['az', 'ru', 'en']) {
    testWidgets('$language: the Routine tab and builder hold at 200% text', (
      tester,
    ) async {
      await _open(tester, language: language, textScale: 2);
      expect(tester.takeException(), isNull);
      for (final size in paintedFontSizes(tester)) {
        expect(size, greaterThanOrEqualTo(kMinTextSize));
      }
      await _tap(tester, find.byKey(const ValueKey('area-hair')));
      await _tap(tester, find.byKey(const ValueKey('routine-own-add')));
      await _tap(tester, find.byKey(const ValueKey('builder-once-week')));
      expect(tester.takeException(), isNull);
      for (final size in paintedFontSizes(tester)) {
        expect(size, greaterThanOrEqualTo(kMinTextSize));
      }
    });
  }
}
