import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla/app.dart';
import 'package:parla/consent/consent_refresh.dart';
import 'package:parla/services/parla_api.dart';
import 'package:parla/state/app_settings.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_api.dart';
import 'support/fake_reminders.dart';

Future<FakeApi> _open(
  WidgetTester tester, {
  required bool consent,
  String? version,
}) async {
  tester.view.physicalSize = const Size(390 * 3, 844 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  SharedPreferences.setMockInitialValues({'language': 'en'});
  final settings = await AppSettings.load();
  final api = FakeApi()
    ..signedIn = true
    ..profile = const ProfileSummary(countryCode: 'AZ', language: 'en')
    ..healthConsent = consent
    ..healthVersion = version;
  await tester.pumpWidget(
    ParlaApp(
      api: api,
      settings: settings,
      reminderScheduler: FakeReminderScheduler(),
    ),
  );
  await tester.pumpAndSettle();
  return api;
}

void main() {
  test('only an older granted version is outdated', () {
    final current = currentConsentText(ConsentKind.health).version;
    expect(healthConsentOutdated(null), isFalse);
    expect(healthConsentOutdated(current), isFalse);
    expect(healthConsentOutdated('health-2026-11-draft2'), isTrue);
  });

  testWidgets('an older consent is asked to be renewed; agreeing records '
      'the current version', (tester) async {
    final api = await _open(
      tester,
      consent: true,
      version: 'health-2026-11-draft2',
    );
    expect(find.byKey(const ValueKey('consent-refresh-card')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('consent-refresh-open')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('consent-refresh-text')), findsOneWidget);
    await tester.tap(find.text('I agree'));
    await tester.pumpAndSettle();
    final (kind, granted, version, _) = api.consentCalls.last;
    expect(kind, ConsentKind.health);
    expect(granted, isTrue);
    expect(version, currentConsentText(ConsentKind.health).version);
    expect(find.byKey(const ValueKey('consent-refresh-card')), findsNothing);
  });

  testWidgets('"Not now" changes nothing', (tester) async {
    final api = await _open(
      tester,
      consent: true,
      version: 'health-2026-11-draft3',
    );
    await tester.tap(find.byKey(const ValueKey('consent-refresh-open')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('consent-refresh-later')));
    await tester.pumpAndSettle();
    expect(api.consentCalls, isEmpty);
    expect(find.byKey(const ValueKey('consent-refresh-card')), findsOneWidget);
  });

  testWidgets('no card with the current version or without consent', (
    tester,
  ) async {
    await _open(tester, consent: true);
    expect(find.byKey(const ValueKey('consent-refresh-card')), findsNothing);
    await _open(tester, consent: false);
    expect(find.byKey(const ValueKey('consent-refresh-card')), findsNothing);
  });
}
