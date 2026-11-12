import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla/app.dart';
import 'package:parla/services/parla_api.dart';
import 'package:parla/state/app_settings.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_api.dart';
import 'support/text_sizes.dart';

class _Harness {
  _Harness(this.api, this.shared);

  final FakeApi api;
  final List<String> shared;
}

/// Signed-in user with a quiz and the health consent, opened on the privacy
/// centre through the Profile tab.
Future<_Harness> _openPrivacy(
  WidgetTester tester, {
  String language = 'en',
}) async {
  tester.view.physicalSize = const Size(390 * 3, 844 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues({'language': language});
  final settings = await AppSettings.load();
  final shared = <String>[];
  final api = FakeApi()
    ..signedIn = true
    ..profile = ProfileSummary(countryCode: 'AZ', language: language)
    ..healthConsent = true
    ..quizAnswers = const QuizAnswers(
      chosen: {
        'skin_type': ['dry'],
      },
    );
  await tester.pumpWidget(
    ParlaApp(
      api: api,
      settings: settings,
      shareExport: (json) async => shared.add(json),
    ),
  );
  await tester.pumpAndSettle();
  // The Profile tab is the last item of the bottom navigation.
  final nav = find.byType(InkWell).last;
  await tester.tap(nav);
  await tester.pumpAndSettle();
  return _Harness(api, shared);
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
  await tester.tap(finder.first);
  await tester.pumpAndSettle();
}

SwitchListTile _switch(WidgetTester tester, ConsentKind kind) =>
    tester.widget<SwitchListTile>(
      find.byKey(ValueKey('consent-switch-${kind.name}')),
    );

void main() {
  testWidgets('the Profile tab opens the privacy centre with the current '
      'consents', (tester) async {
    await _openPrivacy(tester);
    expect(find.text('Privacy centre'), findsOneWidget);
    expect(_switch(tester, ConsentKind.health).value, isTrue);
    expect(_switch(tester, ConsentKind.analytics).value, isFalse);
  });

  testWidgets('granting a consent records the current text version', (
    tester,
  ) async {
    final h = await _openPrivacy(tester);
    await _tap(
      tester,
      find.byKey(const ValueKey('consent-switch-analytics')),
    );
    expect(h.api.consentCalls.single.$1, ConsentKind.analytics);
    expect(h.api.consentCalls.single.$2, isTrue);
    expect(
      h.api.consentCalls.single.$3,
      currentConsentText(ConsentKind.analytics).version,
    );
    expect(_switch(tester, ConsentKind.analytics).value, isTrue);
  });

  testWidgets('withdrawing the health consent asks first; cancel keeps it', (
    tester,
  ) async {
    final h = await _openPrivacy(tester);
    await _tap(tester, find.byKey(const ValueKey('consent-switch-health')));
    expect(find.text('Withdraw the health consent?'), findsOneWidget);

    await _tap(tester, find.text('Cancel'));
    expect(h.api.consentCalls, isEmpty);
    expect(_switch(tester, ConsentKind.health).value, isTrue);

    await _tap(tester, find.byKey(const ValueKey('consent-switch-health')));
    await _tap(tester, find.text('Withdraw and delete'));
    expect(h.api.consentCalls.single.$2, isFalse);
    expect(h.api.healthConsent, isFalse);
    expect(_switch(tester, ConsentKind.health).value, isFalse);
  });

  testWidgets('download my data hands the export to the share sheet', (
    tester,
  ) async {
    final h = await _openPrivacy(tester);
    await _tap(tester, find.text('Create file'));
    expect(h.api.exports, 1);
    expect(h.shared.single, contains('parla-export-v1'));
  });

  testWidgets('deleting needs the typed word, then signs out to the '
      'goodbye screen', (tester) async {
    final h = await _openPrivacy(tester);
    await _tap(tester, find.text('Delete account'));
    expect(find.text('Delete your account?'), findsOneWidget);

    final button = find.widgetWithText(FilledButton, 'Delete my account');
    expect(tester.widget<FilledButton>(button).onPressed, isNull);

    await tester.enterText(find.byKey(const ValueKey('delete-confirm')), 'del');
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(button).onPressed, isNull);

    await tester.enterText(
      find.byKey(const ValueKey('delete-confirm')),
      'delete',
    );
    await tester.pumpAndSettle();
    await _tap(tester, button);

    expect(h.api.deleted, isTrue);
    expect(find.text('Your account is deleted'), findsOneWidget);
    await _tap(tester, find.text('Close'));
    expect(find.text('Your personal care guide'), findsOneWidget);
  });

  testWidgets('az: lower-case "sil" confirms deletion', (tester) async {
    final h = await _openPrivacy(tester, language: 'az');
    await _tap(tester, find.text('Hesabı sil'));
    await tester.enterText(find.byKey(const ValueKey('delete-confirm')), 'sil');
    await tester.pumpAndSettle();
    await _tap(tester, find.widgetWithText(FilledButton, 'Hesabımı sil'));
    expect(h.api.deleted, isTrue);
  });

  testWidgets('the delete screen offers the export first', (tester) async {
    final h = await _openPrivacy(tester);
    await _tap(tester, find.text('Delete account'));
    await _tap(tester, find.text('Download my data first'));
    expect(h.shared, hasLength(1));
    expect(h.api.deleted, isFalse);
  });

  testWidgets('sign out goes to the welcome screen', (tester) async {
    final h = await _openPrivacy(tester);
    await _tap(tester, find.text('Sign out'));
    expect(h.api.signedIn, isFalse);
    expect(find.text('Your personal care guide'), findsOneWidget);
  });

  testWidgets('legal documents show the medical disclaimer and consent '
      'texts', (tester) async {
    await _openPrivacy(tester);
    await _tap(tester, find.text('Legal documents'));
    expect(find.text('Not medical advice'), findsOneWidget);
    expect(
      find.textContaining(currentConsentText(ConsentKind.health).version),
      findsOneWidget,
    );
  });

  for (final language in ['az', 'ru', 'en']) {
    testWidgets('$language: privacy screens keep text at 18 px or more '
        'without overflow', (tester) async {
      await _openPrivacy(tester, language: language);
      final sizes = <double>[];
      Future<void> scrollAndCollect() async {
        final list = find.byType(Scrollable);
        for (var i = 0; i < 4; i++) {
          sizes.addAll(paintedFontSizes(tester));
          expect(tester.takeException(), isNull);
          if (list.evaluate().isEmpty) break;
          await tester.drag(list.first, const Offset(0, -400));
          await tester.pumpAndSettle();
        }
      }

      await scrollAndCollect();
      final tiles = find.byType(ListTile);
      // Legal documents, then back, then delete account.
      await _tap(tester, tiles.first);
      await scrollAndCollect();
      await _tap(tester, find.byType(BackButton));
      await _tap(tester, find.byType(ListTile).last);
      await scrollAndCollect();

      expect(sizes, isNotEmpty);
      expect(sizes.where((s) => s < 18), isEmpty);
    });
  }
}
