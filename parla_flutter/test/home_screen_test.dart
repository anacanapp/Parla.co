import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla/app.dart';
import 'package:parla/services/parla_api.dart';
import 'package:parla/state/app_settings.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_api.dart';
import 'support/text_sizes.dart';

/// Opens the app as a signed-in user with a profile, so it lands on M-14.
/// Quiz answers that produce the standard four-step routine.
const _standardAnswers = QuizAnswers(
  chosen: {
    'skin_type': ['normal'],
    'skin_sensitivity': ['rarely'],
    'routine_time': ['standard'],
  },
);

Future<void> _pumpHome(
  WidgetTester tester, {
  String language = 'en',
  DateTime? now,
  QuizAnswers? quizAnswers = _standardAnswers,
}) async {
  tester.view.physicalSize = const Size(390 * 3, 844 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues({'language': language});
  final settings = await AppSettings.load();
  final api = FakeApi()
    ..signedIn = true
    ..profile = ProfileSummary(countryCode: 'AZ', language: language)
    ..quizAnswers = quizAnswers;
  await tester.pumpWidget(
    ParlaApp(
      api: api,
      settings: settings,
      clock: () => now ?? DateTime(2026, 11, 12, 8, 30),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Scrolls back to the meter at the top of the home screen.
Future<void> _toTop(WidgetTester tester) async {
  await tester.drag(find.byType(Scrollable).first, const Offset(0, 5000));
  await tester.pumpAndSettle();
}

Future<void> _scrollThrough(WidgetTester tester) async {
  final list = find.byType(Scrollable).first;
  for (var i = 0; i < 6; i++) {
    await tester.drag(list, const Offset(0, -500));
    await tester.pumpAndSettle();
  }
}

void main() {
  const steps = [
    'Gentle cleanser',
    'Vitamin C serum',
    'Moisturiser',
    'Sunscreen',
  ];

  Finder summary(int done) =>
      find.bySemanticsLabel('Morning routine: $done of 4 steps done');

  Future<void> tick(WidgetTester tester, String step) =>
      _tap(tester, find.bySemanticsLabel('$step: mark as done'));

  testWidgets('morning opens with the summary card and every step open', (
    tester,
  ) async {
    await _pumpHome(tester);
    expect(find.text('Good morning!'), findsOneWidget);
    expect(find.text('MORNING ROUTINE'), findsOneWidget);
    expect(find.text("Let's begin"), findsOneWidget);
    expect(find.text('About 4 min left'), findsOneWidget);
    expect(summary(0), findsOneWidget);
    for (final step in steps) {
      expect(find.bySemanticsLabel('$step: mark as done'), findsOneWidget);
    }
  });

  testWidgets('ticking a step moves the meter and the status on', (
    tester,
  ) async {
    await _pumpHome(tester);
    await tick(tester, 'Gentle cleanser');
    await _toTop(tester);

    expect(summary(1), findsOneWidget);
    expect(find.text('3 steps to go'), findsOneWidget);
    expect(find.text('About 3 min left'), findsOneWidget);

    await tick(tester, 'Vitamin C serum');
    await tick(tester, 'Moisturiser');
    await _toTop(tester);
    expect(find.text('1 step to go'), findsOneWidget);
  });

  testWidgets('finishing every step shows the success card; restart '
      'clears it', (tester) async {
    await _pumpHome(tester);
    for (final step in steps) {
      await tick(tester, step);
    }
    await _toTop(tester);
    expect(summary(4), findsOneWidget);
    expect(find.text('All done'), findsOneWidget);
    expect(find.text('You glowed again today.'), findsOneWidget);

    await _tap(tester, find.text('Start again'));
    await _toTop(tester);
    expect(summary(0), findsOneWidget);
  });

  testWidgets('a step can be unticked', (tester) async {
    await _pumpHome(tester);
    await tick(tester, 'Sunscreen');
    await _toTop(tester);
    expect(summary(1), findsOneWidget);

    await _tap(tester, find.bySemanticsLabel('Sunscreen: done, tap to undo'));
    await _toTop(tester);
    expect(summary(0), findsOneWidget);
  });

  testWidgets('switching to evening shows the evening routine', (
    tester,
  ) async {
    await _pumpHome(tester);
    await _tap(tester, find.text('Evening'));
    expect(find.text('EVENING ROUTINE'), findsOneWidget);
    expect(find.text('Remove make-up'), findsOneWidget);
  });

  testWidgets('in the evening the evening routine opens first', (
    tester,
  ) async {
    await _pumpHome(tester, now: DateTime(2026, 11, 12, 20));
    expect(find.text('Good evening!'), findsOneWidget);
    expect(find.text('EVENING ROUTINE'), findsOneWidget);
  });

  testWidgets('without a quiz the default routine shows with a quiz '
      'prompt', (tester) async {
    await _pumpHome(tester, quizAnswers: null);
    expect(find.text("Let's personalise your routine"), findsOneWidget);
    expect(find.bySemanticsLabel('Gentle cleanser: mark as done'), findsOne);
    expect(
      find.bySemanticsLabel('Vitamin C serum: mark as done'),
      findsNothing,
    );
    await _tap(tester, find.text('Start the quiz'));
    expect(find.text("Let's get to know you."), findsOneWidget);
  });

  testWidgets('with a quiz there is no prompt', (tester) async {
    await _pumpHome(tester);
    expect(find.text("Let's personalise your routine"), findsNothing);
  });

  testWidgets('water goes up and down within 0 to 8', (tester) async {
    await _pumpHome(tester);
    final add = find.bySemanticsLabel('Add a glass');
    final remove = find.bySemanticsLabel('Remove a glass');

    await _tap(tester, remove);
    expect(find.text('0 of 8 glasses'), findsOneWidget);

    for (var i = 0; i < 10; i++) {
      await _tap(tester, add);
    }
    expect(find.text('8 of 8 glasses'), findsOneWidget);

    await _tap(tester, remove);
    expect(find.text('7 of 8 glasses'), findsOneWidget);
  });

  for (final language in ['az', 'ru', 'en']) {
    testWidgets('$language: every text is at least 18 px and nothing '
        'overflows on a 390 px phone', (tester) async {
      await _pumpHome(tester, language: language);

      final sizes = <double>[...paintedFontSizes(tester)];
      await _scrollThrough(tester);
      sizes.addAll(paintedFontSizes(tester));

      expect(sizes, isNotEmpty);
      expect(sizes.where((s) => s < 18), isEmpty);
      expect(tester.takeException(), isNull);
    });
  }
}
