import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla/app.dart';
import 'package:parla/services/parla_api.dart';
import 'package:parla/state/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_api.dart';

/// Opens the app as a signed-in user with a profile, so it lands on M-14.
Future<void> _pumpHome(
  WidgetTester tester, {
  String language = 'en',
  DateTime? now,
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

/// Font sizes of every text span painted on screen right now.
List<double> _paintedFontSizes(WidgetTester tester) {
  final sizes = <double>[];
  for (final paragraph in tester.renderObjectList<RenderParagraph>(
    find.byType(RichText),
  )) {
    void visit(InlineSpan span, double? inherited) {
      final size = span.style?.fontSize ?? inherited;
      if (span is TextSpan && (span.text?.trim().isNotEmpty ?? false)) {
        sizes.add(size ?? 14);
      }
      if (span is TextSpan) {
        for (final child in span.children ?? const <InlineSpan>[]) {
          visit(child, size);
        }
      }
    }

    visit(paragraph.text, null);
  }
  return sizes;
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

      final sizes = <double>[..._paintedFontSizes(tester)];
      await _scrollThrough(tester);
      sizes.addAll(_paintedFontSizes(tester));

      expect(sizes, isNotEmpty);
      expect(sizes.where((s) => s < 18), isEmpty);
      expect(tester.takeException(), isNull);
    });
  }
}
