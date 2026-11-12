import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

Future<void> _answerCore(WidgetTester tester) async {
  await _answer(tester, ['Comfortable: neither oily nor dry']);
  await _answer(tester, ['Almost never']);
  await _answer(tester, ['A natural glow']);
  await _answer(tester, ['Wavy']);
  await _answer(tester, ['Nothing']);
  await _answer(tester, ['5–10 minutes']);
  await _answer(tester, ['A mix']);
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
    expect(sent.of('skin_goals'), ['glow']);

    // Without the health answers the routine leaves retinol out and says
    // so once.
    expect(find.textContaining('We left out retinol'), findsOneWidget);
    expect(
      find.textContaining('without answers about pregnancy and medicines'),
      findsOneWidget,
    );
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

    await _answer(tester, ['None of these']); // conditions
    await _answer(tester, ['Nickel']); // allergies
    await _answer(tester, ['No']); // pregnancy
    await _answer(tester, ['None of these']); // medication
    await _answer(tester, ['None of these']); // warning signs

    final sent = api.savedQuizAnswers.single;
    expect(sent.of('pregnancy'), ['no']);
    expect(sent.of('allergies'), ['nickel']);
    expect(find.text('Your routine is ready'), findsOneWidget);
    expect(find.textContaining('We left out retinol'), findsNothing);

    await _tap(tester, find.text('Show my routine'));
    await _tap(tester, find.text('Evening'));
    expect(find.text('Retinol (evening)'), findsOneWidget);
  });

  testWidgets('a health question can be declined', (tester) async {
    final api = await _openQuiz(tester, healthConsent: true);
    await _answerCore(tester);
    // Consent already granted: no gate.
    expect(find.text('A few sensitive questions'), findsNothing);

    await _answer(tester, ['None of these']); // conditions
    await _answer(tester, ['None of these']); // allergies
    await _tap(tester, find.text("I'd rather not answer")); // pregnancy
    await _answer(tester, ['None of these']); // medication
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

    await _answer(tester, ['Comfortable: neither oily nor dry']);
    await _answer(tester, ['Almost never']);
    await _answer(tester, ['A natural glow']);
    await _answer(tester, ['Wavy']);

    await _tap(tester, find.text('Dryness'));
    await _tap(tester, find.text('Frizz'));
    await _tap(tester, find.text('Nothing'));
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
    testWidgets('$language: every quiz screen keeps text at 18 px or more '
        'without overflow', (tester) async {
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

      for (final q in quizQuestions) {
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
      expect(sizes.where((s) => s < 18), isEmpty);
    });
  }
}
