import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla/app.dart';
import 'package:parla/home/widgets/parla_nav_bar.dart';
import 'package:parla/services/parla_api.dart';
import 'package:parla/state/app_settings.dart';
import 'package:parla/ui/brand.dart';
import 'package:parla/ui/warm.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_api.dart';
import 'support/fake_reminders.dart';

/// Signed-in user on the Profile tab.
Future<AppSettings> _openProfile(
  WidgetTester tester, {
  Map<String, Object> prefs = const {},
}) async {
  tester.view.physicalSize = const Size(390 * 3, 844 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  addTearDown(() => Tone.dark = false);

  SharedPreferences.setMockInitialValues({'language': 'en', ...prefs});
  final settings = await AppSettings.load();
  final api = FakeApi()
    ..signedIn = true
    ..profile = const ProfileSummary(
      countryCode: 'AZ',
      language: 'en',
      birthYear: 1995,
      email: 'member@example.com',
    );
  await tester.pumpWidget(
    ParlaApp(
      api: api,
      reminderScheduler: FakeReminderScheduler(),
      settings: settings,
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(
    find
        .descendant(
          of: find.byType(ParlaNavBar),
          matching: find.byType(InkWell),
        )
        .at(4),
  );
  await tester.pumpAndSettle();
  return settings;
}

/// The colour the "Appearance" heading is painted in.
Color? _headingColor(WidgetTester tester) =>
    tester.widget<Text>(find.text('Appearance')).style?.color;

Future<void> _choose(WidgetTester tester, String name) async {
  final target = find.byKey(ValueKey('appearance-$name'));
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Profile switches between light and dark at once, keeps the '
      'screen and remembers the choice on the phone', (tester) async {
    final settings = await _openProfile(tester);
    expect(settings.appearance, Appearance.system);
    expect(Tone.dark, isFalse);
    expect(_headingColor(tester), const Color(0xFF16130F));

    await _choose(tester, 'dark');
    expect(Tone.dark, isTrue);
    expect(settings.appearance, Appearance.dark);
    // Still on Profile, and already redrawn in the night ink.
    expect(find.text('Appearance'), findsOneWidget);
    expect(_headingColor(tester), Warm.ink);
    expect(Warm.ink, const Color(0xFFF5F1EC));
    expect(
      Theme.of(tester.element(find.text('Appearance'))).brightness,
      Brightness.dark,
    );
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('appearance'), 'dark');

    await _choose(tester, 'light');
    expect(Tone.dark, isFalse);
    expect(_headingColor(tester), const Color(0xFF16130F));
    expect(prefs.getString('appearance'), 'light');
  });

  testWidgets('"System" follows the phone', (tester) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await _openProfile(tester);
    expect(Tone.dark, isTrue);

    await _choose(tester, 'light');
    expect(Tone.dark, isFalse);
  });

  testWidgets('a saved choice is used from the first frame', (tester) async {
    await _openProfile(tester, prefs: {'appearance': 'dark'});
    expect(Tone.dark, isTrue);
  });

  test('the yellow tokens are the same day and night', () {
    addTearDown(() => Tone.dark = false);
    for (final dark in [false, true]) {
      Tone.dark = dark;
      expect(Warm.banana, const Color(0xFFFFCE00));
      expect(ParlaColors.sun, const Color(0xFFFFCE00));
      expect(Warm.dayInk, const Color(0xFF16130F));
    }
  });
}
