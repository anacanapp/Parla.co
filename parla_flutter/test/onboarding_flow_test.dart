import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla/app.dart';
import 'package:parla/services/parla_api.dart';
import 'package:parla/state/app_settings.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_api.dart';

final _today = DateTime(2026, 11, 11);

Future<FakeApi> _pumpApp(
  WidgetTester tester, {
  Map<String, Object> prefs = const {},
  FakeApi? api,
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final settings = await AppSettings.load();
  final fake = api ?? FakeApi();
  await tester.pumpWidget(
    ParlaApp(api: fake, settings: settings, clock: () => _today),
  );
  await tester.pumpAndSettle();
  return fake;
}

Future<void> _tapText(WidgetTester tester, String text) async {
  await tester.ensureVisible(find.text(text));
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}

Future<void> _enterYear(WidgetTester tester, String year) async {
  await tester.enterText(find.byKey(const ValueKey('birth-year')), year);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('first launch asks for the language and remembers it', (
    tester,
  ) async {
    await _pumpApp(tester);
    expect(find.text('Choose your language'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('language-az')));
    await tester.pumpAndSettle();
    await _tapText(tester, 'Continue');

    expect(find.text('Fərdi qulluq bələdçiniz'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('language'), 'az');
  });

  testWidgets('a minor is sent to M-04 and nothing reaches the server', (
    tester,
  ) async {
    final api = await _pumpApp(tester, prefs: {'language': 'en'});
    await _tapText(tester, 'Get started');

    await _enterYear(tester, '2012');
    await _tapText(tester, 'Continue');

    expect(find.text('Parla is for adults'), findsOneWidget);
    expect(api.createdProfiles, isEmpty);
    expect(api.consentCalls, isEmpty);
  });

  testWidgets('turning 18 this year asks about the birthday', (tester) async {
    await _pumpApp(tester, prefs: {'language': 'en'});
    await _tapText(tester, 'Get started');

    await _enterYear(tester, '2008');
    expect(
      find.text('Have you already had your birthday this year?'),
      findsOneWidget,
    );
    final continueButton = find.widgetWithText(FilledButton, 'Continue');
    expect(tester.widget<FilledButton>(continueButton).onPressed, isNull);

    await _tapText(tester, 'No');
    await _tapText(tester, 'Continue');
    expect(find.text('Parla is for adults'), findsOneWidget);
  });

  testWidgets('an invalid year shows an error and blocks continuing', (
    tester,
  ) async {
    await _pumpApp(tester, prefs: {'language': 'en'});
    await _tapText(tester, 'Get started');

    await _enterYear(tester, '1850');
    expect(
      find.text('Enter a year between 1900 and this year.'),
      findsOneWidget,
    );
    final continueButton = find.widgetWithText(FilledButton, 'Continue');
    expect(tester.widget<FilledButton>(continueButton).onPressed, isNull);
  });

  testWidgets('closed countries cannot be chosen', (tester) async {
    await _pumpApp(tester, prefs: {'language': 'en'});
    await _tapText(tester, 'Get started');
    await _enterYear(tester, '1995');
    await _tapText(tester, 'Continue');
    await tester.tap(find.byKey(const ValueKey('fake-sign-in')));
    await tester.pumpAndSettle();

    final turkey = tester.widget<RadioListTile<String>>(
      find.byKey(const ValueKey('country-TR')),
    );
    expect(turkey.enabled, isFalse);
    expect(find.text('Coming soon'), findsNWidgets(3));
  });

  testWidgets('full onboarding: consents are off by default and only the '
      'granted one is sent with its text version', (tester) async {
    final api = await _pumpApp(tester, prefs: {'language': 'ru'});
    await _tapText(tester, 'Начать');
    await _enterYear(tester, '1995');
    await _tapText(tester, 'Продолжить');

    await tester.tap(find.byKey(const ValueKey('fake-sign-in')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('country-AZ')));
    await tester.pumpAndSettle();
    await _tapText(tester, 'Продолжить');

    final switches = tester
        .widgetList<SwitchListTile>(find.byType(SwitchListTile))
        .toList();
    expect(switches, hasLength(3));
    expect(switches.every((s) => !s.value), isTrue);

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('consent-analytics')),
        matching: find.byType(SwitchListTile),
      ),
    );
    await tester.pumpAndSettle();
    await _tapText(tester, 'Продолжить');

    expect(api.createdProfiles.single, {
      'birthYear': 1995,
      'birthdayPassedThisYear': null,
      'countryCode': 'AZ',
      'language': 'ru',
    });
    expect(api.consentCalls, [
      (
        ConsentKind.analytics,
        true,
        currentConsentText(ConsentKind.analytics).version,
        'ru',
      ),
    ]);
    expect(find.text('Давайте познакомимся.'), findsOneWidget);
  });

  testWidgets('a signed-in user with a profile opens on the home screen', (
    tester,
  ) async {
    final api = FakeApi()
      ..signedIn = true
      ..profile = const ProfileSummary(countryCode: 'AZ', language: 'az');
    await _pumpApp(tester, prefs: {'language': 'az'}, api: api);
    expect(find.text('Bu gün'), findsOneWidget);
  });

  testWidgets('"I already have an account" without a profile still runs the '
      'age gate', (tester) async {
    await _pumpApp(tester, prefs: {'language': 'en'});
    await _tapText(tester, 'I already have an account');
    await tester.tap(find.byKey(const ValueKey('fake-sign-in')));
    await tester.pumpAndSettle();
    expect(find.text('What year were you born?'), findsOneWidget);
  });
}
