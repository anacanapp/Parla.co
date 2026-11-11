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
  testWidgets('morning opens with the first step as the next step', (
    tester,
  ) async {
    await _pumpHome(tester);
    expect(find.text('Good morning!'), findsOneWidget);
    expect(find.text('0/4'), findsOneWidget);
    expect(find.text('NEXT STEP'), findsOneWidget);
    expect(find.text('Gentle cleanser'), findsNWidgets(2)); // card + list
  });

  testWidgets('sample content never shows the dermatologist badge', (
    tester,
  ) async {
    await _pumpHome(tester);
    expect(find.text('Approved by a dermatologist'), findsNothing);
  });

  testWidgets('"Done" completes the step and moves the meter on', (
    tester,
  ) async {
    await _pumpHome(tester);
    await _tap(tester, find.widgetWithText(FilledButton, 'Done'));
    await _toTop(tester);

    expect(find.text('1/4'), findsOneWidget);
    expect(
      find.text('1 of 4 steps done · about 3 min left'),
      findsOneWidget,
    );
    expect(find.text('Vitamin C serum'), findsNWidgets(2));
  });

  testWidgets('finishing every step shows the success card; restart '
      'clears it', (tester) async {
    await _pumpHome(tester);
    for (var i = 0; i < 4; i++) {
      await _tap(tester, find.widgetWithText(FilledButton, 'Done'));
    }
    await _toTop(tester);
    expect(find.text('4/4'), findsOneWidget);
    expect(find.text('You glowed again today.'), findsOneWidget);
    expect(find.text('Morning routine is done'), findsOneWidget);

    await _tap(tester, find.text('Start again'));
    await _toTop(tester);
    expect(find.text('0/4'), findsOneWidget);
  });

  testWidgets('a step can be ticked and unticked from the list', (
    tester,
  ) async {
    await _pumpHome(tester);
    final sunscreen = find.bySemanticsLabel('Sunscreen: mark as done');
    await _tap(tester, sunscreen);
    await _toTop(tester);
    expect(find.text('1/4'), findsOneWidget);

    await _tap(tester, find.bySemanticsLabel('Sunscreen: done, tap to undo'));
    await _toTop(tester);
    expect(find.text('0/4'), findsOneWidget);
  });

  testWidgets('switching to evening shows the evening routine', (
    tester,
  ) async {
    await _pumpHome(tester);
    await _tap(tester, find.text('Evening'));
    expect(find.text('Remove make-up'), findsNWidgets(2));
    expect(find.text('Evening routine'), findsOneWidget);
  });

  testWidgets('in the evening the evening routine opens first', (
    tester,
  ) async {
    await _pumpHome(tester, now: DateTime(2026, 11, 12, 20));
    expect(find.text('Good evening!'), findsOneWidget);
    expect(find.text('Remove make-up'), findsNWidgets(2));
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
