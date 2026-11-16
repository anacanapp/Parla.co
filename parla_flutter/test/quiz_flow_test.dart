import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla/ui/brand.dart';
import 'package:parla/app.dart';
import 'package:parla/services/parla_api.dart';
import 'package:parla/state/app_settings.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_api.dart';
import 'support/fake_reminders.dart';
import 'support/text_sizes.dart';

/// Signed-in user with a profile and no quiz yet, opened on the quiz.
Future<FakeApi> _openQuiz(
  WidgetTester tester, {
  bool healthConsent = false,
}) async {
  tester.view.physicalSize = const Size(390 * 3, 844 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues({'language': 'en'});
  final settings = await AppSettings.load();
  final api = FakeApi()
    ..signedIn = true
    ..profile = const ProfileSummary(countryCode: 'AZ', language: 'en')
    ..healthConsent = healthConsent;
  await tester.pumpWidget(
    ParlaApp(
      api: api,
      reminderScheduler: FakeReminderScheduler(),
      settings: settings,
      clock: () => DateTime(2026, 11, 12, 8, 30),
    ),
  );
  await tester.pumpAndSettle();
  await _tap(tester, find.text('Start the quiz'));
  await _tap(tester, find.text("Let's start"));
  return api;
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
  await tester.tap(finder.first);
  await tester.pumpAndSettle();
}

/// Picks [options] (English texts) and presses Next/Finish.
Future<void> _answer(WidgetTester tester, List<String> options) async {
  for (final option in options) {
    await _tap(tester, find.text(option));
  }
  final next = find.widgetWithText(FilledButton, 'Next');
  await _tap(
    tester,
    next.evaluate().isNotEmpty
        ? next
        : find.widgetWithText(FilledButton, 'Finish'),
  );
}

/// The questions that are not health questions, in the quiz's order.
Future<void> _answerCore(WidgetTester tester) async {
  await _answer(tester, ['Normal, comfortable']); // skin type
  await _answer(tester, ['Almost never']); // sensitivity
  await _answer(tester, ['Fine lines']); // concerns
  await _answer(tester, ['Less than an hour']); // sun
  await _answer(tester, ['No']); // makeup and SPF
  await _answer(tester, ['Standard: 4–5 steps']); // routine level
  await _answer(tester, ['A few times']); // actives
  await _answer(tester, ['No preference']); // fragrance
  await _answer(tester, ['Normal']); // body skin
  await _answer(tester, ['Nothing']); // body concerns
  await _answer(tester, ['Wavy']); // hair type
  await _answer(tester, ['Normal']); // scalp
  await _answer(tester, ['Nothing']); // hair concerns
  await _answer(tester, ['Rarely or never']); // heat styling
  await _answer(tester, ['Every 2–3 days']); // washing
  await _answer(tester, ['No']); // treated hair
}

void main() {
  testWidgets('skipping the health section sends no health answers and '
      'never sends warning signs', (tester) async {
    final api = await _openQuiz(tester);
    await _answerCore(tester);

    expect(find.text('A few sensitive questions'), findsOneWidget);
    await _tap(tester, find.text('Skip this section'));
    expect(api.consentCalls, isEmpty);

    await _answer(tester, ['None of these']);
    expect(find.text('Your routine is ready'), findsOneWidget);

    final sent = api.savedQuizAnswers.single;
    expect(sent.chosen.keys, isNot(contains('pregnancy')));
    expect(sent.chosen.keys, isNot(contains('warning_signs')));
    expect(sent.of('concerns'), ['fine_lines']);
  });

  testWidgets('agreeing at the gate grants the health consent with the '
      'current text, and health answers are saved', (tester) async {
    final api = await _openQuiz(tester);
    await _answerCore(tester);
    await _tap(tester, find.text('I agree, continue'));

    expect(api.consentCalls.single.$1, ConsentKind.health);
    expect(api.consentCalls.single.$2, isTrue);
    expect(
      api.consentCalls.single.$3,
      currentConsentText(ConsentKind.health).version,
    );

    await _answer(tester, ['No']); // pregnancy
    await _answer(tester, ['No']); // medications
    await _answer(tester, ['Lanolin']); // allergies
    await _answer(tester, ['None of these']); // warning signs

    final sent = api.savedQuizAnswers.single;
    expect(sent.of('pregnancy'), ['no']);
    expect(sent.of('allergies'), ['lanolin']);
    expect(find.text('Your routine is ready'), findsOneWidget);
    // The lanolin rule explains itself (draft texts from the sheet).
    expect(find.textContaining('Lanolin is flagged'), findsOneWidget);

    await _tap(tester, find.text('Show my routine'));
    await _tap(tester, find.text('Evening'));
    // Safe answers and fine lines: the retinoid is in the evening.
    expect(find.text('Retinoid / retinol'), findsOneWidget);
  });

  testWidgets('a health question can be declined', (tester) async {
    final api = await _openQuiz(tester, healthConsent: true);
    await _answerCore(tester);
    // Consent already granted: no gate.
    expect(find.text('A few sensitive questions'), findsNothing);

    await _tap(tester, find.text("I'd rather not answer")); // pregnancy
    await _answer(tester, ['No']); // medications
    await _answer(tester, ['None']); // allergies
    await _answer(tester, ['None of these']); // warning signs

    final sent = api.savedQuizAnswers.single;
    expect(sent.declined, contains('pregnancy'));
    expect(sent.chosen.keys, isNot(contains('pregnancy')));
  });

  testWidgets('a warning sign shows the doctor screen; the answer stays on '
      'the device', (tester) async {
    final api = await _openQuiz(tester);
    await _answerCore(tester);
    await _tap(tester, find.text('Skip this section'));
    await _answer(tester, ['A mole that changes shape or colour']);

    expect(find.text('Please show this to a doctor'), findsOneWidget);
    expect(api.savedQuizAnswers, isEmpty);

    await _tap(tester, find.text('I understand'));
    expect(find.text('Your routine is ready'), findsOneWidget);
    expect(
      api.savedQuizAnswers.single.chosen.keys,
      isNot(contains('warning_signs')),
    );
  });

  testWidgets('"none of these" clears other choices and Next needs an '
      'answer', (tester) async {
    await _openQuiz(tester);
    final next = find.widgetWithText(FilledButton, 'Next');
    expect(tester.widget<FilledButton>(next).onPressed, isNull);

    await _answer(tester, ['Normal, comfortable']);
    await _answer(tester, ['Almost never']);

    await _tap(tester, find.text('Redness'));
    await _tap(tester, find.text('Enlarged pores'));
    await _tap(tester, find.text('Nothing in particular'));
    final selected = tester
        .widgetList<Semantics>(find.byType(Semantics))
        .where((s) => s.properties.selected == true)
        .length;
    expect(selected, 1);
  });

  testWidgets('Later on the intro goes home', (tester) async {
    SharedPreferences.setMockInitialValues({'language': 'en'});
    await _openQuiz(tester);
    await _tap(tester, find.text('Back'));
    await _tap(tester, find.text('Later'));
    expect(find.text("Let's personalise your routine"), findsOneWidget);
  });

  for (final language in ['az', 'ru', 'en']) {
    testWidgets(
      '$language: every quiz screen keeps text at the minimum size or more '
      'without overflow',
      (tester) async {
        tester.view.physicalSize = const Size(390 * 3, 844 * 3);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);
        SharedPreferences.setMockInitialValues({'language': language});
        final settings = await AppSettings.load();
        final api = FakeApi()
          ..signedIn = true
          ..profile = ProfileSummary(countryCode: 'AZ', language: language);
        await tester.pumpWidget(ParlaApp(api: api, settings: settings));
        await tester.pumpAndSettle();
        await _tap(tester, find.byType(FilledButton)); // home: start the quiz
        await _tap(tester, find.byType(FilledButton)); // intro: start

        final sizes = <double>[];
        void collect() {
          sizes.addAll(paintedFontSizes(tester));
          expect(tester.takeException(), isNull);
        }

        // The order the quiz asks: other questions, then health, then
        // warning signs.
        final order = [
          ...quizQuestions.where((q) => !q.sensitive && q.stored),
          ...quizQuestions.where((q) => q.sensitive),
          ...quizQuestions.where((q) => !q.stored),
        ];
        for (final q in order) {
          collect();
          if (q.sensitive && !api.healthConsent) {
            // The consent gate before the first health question.
            await _tap(tester, find.byType(FilledButton));
            collect();
          }
          final option = q.options.first.text[language]!;
          await _tap(tester, find.text(option));
          await _tap(tester, find.byType(FilledButton));
        }
        collect(); // red flag or result
        expect(sizes.where((s) => s < kMinTextSize), isEmpty);
      },
    );
  }
}
