import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla/app.dart';
import 'package:parla/habits/habit_store.dart';
import 'package:parla/home/widgets/parla_nav_bar.dart';
import 'package:parla/services/parla_api.dart';
import 'package:parla/sport/exercise_text.dart';
import 'package:parla/state/app_settings.dart';
import 'package:parla/ui/brand.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_api.dart';
import 'support/fake_reminders.dart';
import 'support/text_sizes.dart';

class _App {
  _App(this.api, this.store, this.habits);

  final FakeApi api;
  final MemoryHabitStore store;
  final MemoryHabitStore habits;
}

/// Signed-in user on the Fitness tab.
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
  api ??= FakeApi()
    ..signedIn = true
    ..profile = ProfileSummary(countryCode: 'AZ', language: language)
    ..healthConsent = healthConsent;
  store ??= MemoryHabitStore();
  final habits = MemoryHabitStore();
  await tester.pumpWidget(
    ParlaApp(
      key: UniqueKey(),
      api: api,
      reminderScheduler: FakeReminderScheduler(),
      settings: settings,
      clock: () => DateTime(2026, 11, 15, 10),
      habitStore: habits,
      routineStore: MemoryHabitStore(),
      careListStore: MemoryHabitStore(),
      sportStore: store,
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(
    find
        .descendant(
          of: find.byType(ParlaNavBar),
          matching: find.byType(InkWell),
        )
        .at(3),
  );
  await tester.pumpAndSettle();
  // Sport opens from its tile on Discover.
  final tile = find.byKey(const ValueKey('discover-sport'));
  await tester.ensureVisible(tile);
  await tester.pumpAndSettle();
  await tester.tap(tile);
  await tester.pumpAndSettle();
  return _App(api, store, habits);
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

Future<void> _next(WidgetTester tester) => _tap(tester, find.text('Next'));

/// Answers every page: [goals], [areas], [types], then the defaults, with
/// [safety] run on the last page.
Future<void> _answer(
  WidgetTester tester, {
  List<String> goals = const ['tone'],
  List<String> areas = const ['full'],
  List<String> types = const ['fitness'],
  Future<void> Function()? safety,
}) async {
  await _tap(tester, find.byKey(const ValueKey('sport-start')));
  for (final g in goals) {
    await _tap(tester, find.byKey(ValueKey('opt-$g')));
  }
  await _next(tester);
  for (final a in areas) {
    await _tap(tester, find.byKey(ValueKey('opt-$a')));
  }
  await _next(tester);
  for (final t in types) {
    await _tap(tester, find.byKey(ValueKey('opt-$t')));
  }
  await _next(tester);
  await _next(tester); // level
  await _next(tester); // schedule
  if (safety != null) await safety();
  await _tap(tester, find.text('Build my plan'));
}

Map<String, Object?> _local(MemoryHabitStore store) =>
    jsonDecode(store.data['user-1']!) as Map<String, Object?>;

void main() {
  test('every exercise has a name and a how-to in every language', () {
    for (final language in ['az', 'ru', 'en']) {
      for (final e in exerciseCatalogue) {
        final (name, how) = exerciseText(e.id, language);
        expect(name, isNot(e.id), reason: '$language ${e.id}');
        expect(how, isNotEmpty, reason: '$language ${e.id}');
      }
      expect(exerciseTextIds(language).toSet(), {
        for (final e in exerciseCatalogue) e.id,
      });
    }
  });

  test('exercises from the content sheet have their caution', () {
    expect(exerciseCaution('squat', 'az'), contains('Diz'));
    expect(exerciseCaution('jumping_jack', 'en'), isNotEmpty);
    expect(
      exerciseText('mountain_climber', 'ru').$1,
      isNot('mountain_climber'),
    );
  });

  testWidgets('the questions build a weekly plan kept on the phone', (
    tester,
  ) async {
    final app = await _open(tester);
    expect(find.text('A workout plan made for you'), findsOneWidget);
    await _answer(
      tester,
      goals: ['muscle'],
      areas: ['arms', 'glutes'],
      types: ['fitness', 'wall_pilates'],
    );
    expect(find.text('0 of 3 workouts'), findsOneWidget);
    expect(find.byKey(const ValueKey('workout-w1')), findsOneWidget);
    expect(find.text('Workout 2'), findsOneWidget);
    final answers = _local(app.store)['answers']! as Map;
    expect(answers['goals'], ['muscle']);
    expect(answers['types'], ['fitness', 'wall_pilates']);
    expect(app.api.sport, isNull);
  });

  testWidgets('each page needs an answer; at most two goals', (tester) async {
    await _open(tester);
    await _tap(tester, find.byKey(const ValueKey('sport-start')));
    await _next(tester);
    expect(find.text('Pick at least one.'), findsOneWidget);

    for (final g in ['tone', 'muscle', 'posture']) {
      await _tap(tester, find.byKey(ValueKey('opt-$g')));
    }
    CheckboxListTile tile(String id) =>
        tester.widget(find.byKey(ValueKey('opt-$id')));
    expect(tile('tone').value, isFalse);
    expect(tile('muscle').value, isTrue);
    expect(tile('posture').value, isTrue);
    // The areas page says that fat cannot be burned from one spot.
    await _next(tester);
    expect(find.textContaining('Fat cannot be burned from one spot'), findsOne);
  });

  testWidgets("a doctor's limit builds no plan", (tester) async {
    await _open(tester);
    await _answer(
      tester,
      safety: () => _tap(tester, find.byKey(const ValueKey('sport-doctor'))),
    );
    expect(find.byKey(const ValueKey('sport-blocked')), findsOneWidget);
    expect(find.text('Talk to your doctor first'), findsOneWidget);
    expect(find.byKey(const ValueKey('workout-w1')), findsNothing);
  });

  testWidgets('pregnancy gives a gentle plan with a note', (tester) async {
    await _open(tester);
    await _answer(
      tester,
      safety: () =>
          _tap(tester, find.byKey(const ValueKey('pregnancy-pregnant'))),
    );
    expect(find.byKey(const ValueKey('sport-gentle')), findsOneWidget);
  });

  testWidgets('a workout runs through sets, rests and the timer, then is '
      'logged with its minutes', (tester) async {
    final app = await _open(tester);
    await _answer(tester, types: ['wall_pilates']);
    await _tap(tester, find.byKey(const ValueKey('workout-w1')));
    expect(find.textContaining('Play music from your own music app'), findsOne);
    await _tap(tester, find.byKey(const ValueKey('workout-start')));
    expect(find.text('Move 1 of 7'), findsOneWidget);
    expect(find.text('Set 1 of 2'), findsOneWidget);

    var guard = 0;
    while (find.text('Workout done').evaluate().isEmpty && guard++ < 200) {
      final count = tester.widget<Text>(
        find.byKey(const ValueKey('workout-count')),
      );
      if (find.byKey(const ValueKey('set-done')).evaluate().isNotEmpty) {
        await _tap(tester, find.byKey(const ValueKey('set-done')));
      } else if (count.data == '0:40' || guard == 3) {
        // A timer counts down by itself.
        await tester.pump(const Duration(seconds: 5));
        expect(
          tester.widget<Text>(find.byKey(const ValueKey('workout-count'))).data,
          isNot(count.data),
        );
        await _tap(tester, find.byKey(const ValueKey('workout-skip')));
      } else {
        await _tap(tester, find.byKey(const ValueKey('workout-skip')));
      }
    }
    expect(find.text('Workout done'), findsOneWidget);
    expect(_local(app.store)['log'], {
      '2026-11-15': ['w1'],
    });
    expect(app.habits.data['user-1'], contains('moveMinutes'));

    await _tap(tester, find.byKey(const ValueKey('workout-back')));
    expect(find.text('1 of 3 workouts'), findsOneWidget);
  });

  testWidgets('the sound switch is kept', (tester) async {
    final app = await _open(tester);
    await _answer(tester);
    await _tap(tester, find.byKey(const ValueKey('workout-w1')));
    expect(find.byTooltip('Sound signals on'), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('sport-sound')));
    expect(find.byTooltip('Sound off, vibration only'), findsOneWidget);
    expect(_local(app.store)['sound'], isFalse);
  });

  testWidgets('with the health consent the answers are kept on the server', (
    tester,
  ) async {
    final app = await _open(tester, healthConsent: true);
    await _answer(tester);
    final server = jsonDecode(app.api.sport!) as Map;
    expect((server['answers'] as Map)['goals'], ['tone']);
    expect(app.api.sport, isNot(contains('pendingUpload')));
  });

  testWidgets("the server's plan shows on a new phone", (tester) async {
    final api = FakeApi()
      ..signedIn = true
      ..profile = const ProfileSummary(countryCode: 'AZ', language: 'en')
      ..healthConsent = true
      ..sport = jsonEncode({
        'format': 1,
        'answers': const SportAnswers(
          goals: ['tone'],
          areas: {'full'},
          types: ['pilates'],
          level: 'beginner',
          days: 2,
          minutes: 15,
        ).toJson(),
      });
    await _open(tester, api: api);
    expect(find.text('0 of 2 workouts'), findsOneWidget);
  });

  for (final language in ['az', 'ru', 'en']) {
    testWidgets('$language: the Fitness screens hold at 200% text', (
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
      await _tap(tester, find.byKey(const ValueKey('sport-start')));
      check();
      await _tap(tester, find.byKey(const ValueKey('opt-tone')));
      for (var i = 0; i < 5; i++) {
        if (i == 1) await _tap(tester, find.byKey(const ValueKey('opt-full')));
        if (i == 2) {
          await _tap(tester, find.byKey(const ValueKey('opt-fitness')));
        }
        await tester.tap(find.byType(FilledButton).last);
        await tester.pumpAndSettle();
        check();
      }
      await tester.tap(find.byType(FilledButton).last);
      await tester.pumpAndSettle();
      check();
      await _tap(tester, find.byKey(const ValueKey('workout-w1')));
      check();
      await _tap(tester, find.byKey(const ValueKey('workout-start')));
      check();
    });
  }
}
