import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla/app.dart';
import 'package:parla/habits/habit_store.dart';
import 'package:parla/home/widgets/parla_nav_bar.dart';
import 'package:parla/reminders/reminder_scheduler.dart';
import 'package:parla/reminders/reminder_settings.dart';
import 'package:parla/services/parla_api.dart';
import 'package:parla/state/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'support/fake_api.dart';
import 'support/fake_reminders.dart';
import 'support/text_sizes.dart';

class _App {
  _App(this.api, this.scheduler, this.settings);

  final FakeApi api;
  final FakeReminderScheduler scheduler;
  final AppSettings settings;
}

/// Starts the app signed in and opens the reminders screen. Preferences are
/// reset only when [fresh] is true, so a second call is an app restart.
Future<_App> _open(
  WidgetTester tester, {
  String language = 'en',
  bool fresh = true,
  String userId = 'user-1',
  FakeReminderScheduler? scheduler,
  bool openScreen = true,
}) async {
  tester.view.physicalSize = const Size(390 * 3, 844 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  if (fresh) SharedPreferences.setMockInitialValues({'language': language});
  final settings = await AppSettings.load();
  final api = FakeApi()
    ..signedIn = true
    ..userId = userId
    ..profile = ProfileSummary(countryCode: 'AZ', language: language);
  final fake = scheduler ?? FakeReminderScheduler();
  await tester.pumpWidget(
    ParlaApp(
      key: UniqueKey(),
      api: api,
      settings: settings,
      clock: () => DateTime(2026, 11, 12, 8, 30),
      habitStore: MemoryHabitStore(),
      reminderScheduler: fake,
    ),
  );
  await tester.pumpAndSettle();
  if (openScreen) {
    await _tap(
      tester,
      find
          .descendant(
            of: find.byType(ParlaNavBar),
            matching: find.byType(InkWell),
          )
          .at(2),
    );
    await _tap(
      tester,
      find.descendant(
        of: find.byKey(const ValueKey('habits-reminders')),
        matching: find.byType(TextButton),
      ),
    );
  }
  return _App(api, fake, settings);
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

Finder _switch(ReminderKind kind) => find.descendant(
  of: find.byKey(ValueKey('reminder-${kind.name}')),
  matching: find.byType(Switch),
);

bool _isOn(WidgetTester tester, ReminderKind kind) =>
    tester.widget<Switch>(_switch(kind)).value;

void main() {
  setUpAll(tz_data.initializeTimeZones);

  test('the next reminder time is later today or tomorrow', () {
    final baku = tz.getLocation('Asia/Baku');
    final now = tz.TZDateTime(baku, 2026, 11, 12, 8, 30);
    expect(
      nextInstance(now, 21, 30),
      tz.TZDateTime(baku, 2026, 11, 12, 21, 30),
    );
    expect(nextInstance(now, 8, 0), tz.TZDateTime(baku, 2026, 11, 13, 8));
    expect(nextInstance(now, 8, 30), tz.TZDateTime(baku, 2026, 11, 13, 8, 30));
  });

  test('stored settings are read defensively', () {
    final s = ReminderSettings.decode({
      'morningRoutine': {'enabled': true, 'minutes': 450},
      'eveningRoutine': {'enabled': true, 'minutes': 9999},
      'sleepLog': 'nonsense',
    });
    expect(s[ReminderKind.morningRoutine].enabled, isTrue);
    expect(s[ReminderKind.morningRoutine].minutes, 450);
    expect(s[ReminderKind.eveningRoutine].enabled, isFalse);
    expect(s[ReminderKind.eveningRoutine].minutes, 21 * 60 + 30);
    expect(s[ReminderKind.sleepLog].enabled, isFalse);
  });

  testWidgets('every reminder starts off and nothing is scheduled', (
    tester,
  ) async {
    final app = await _open(tester);
    expect(find.text('Reminders'), findsOneWidget);
    for (final kind in ReminderKind.values) {
      expect(_isOn(tester, kind), isFalse);
    }
    expect(find.text('At 8:00 AM'), findsOneWidget);
    expect(find.text('At 9:30 PM'), findsOneWidget);
    expect(app.scheduler.scheduled, isEmpty);
    expect(app.scheduler.permissionRequests, 0);
  });

  testWidgets('turning a reminder on asks for permission and schedules a '
      'neutral text', (tester) async {
    final app = await _open(tester);
    await _tap(tester, _switch(ReminderKind.eveningRoutine));
    expect(app.scheduler.permissionRequests, 1);
    expect(_isOn(tester, ReminderKind.eveningRoutine), isTrue);
    expect(app.scheduler.scheduled, {
      ReminderKind.eveningRoutine: (21, 30, 'Time for your evening routine.'),
    });

    await _tap(tester, find.byType(BackButton));
    expect(find.text('1 on'), findsOneWidget);
  });

  testWidgets('a refused permission keeps the reminder off', (tester) async {
    final app = await _open(
      tester,
      scheduler: FakeReminderScheduler(permission: false),
    );
    await _tap(tester, _switch(ReminderKind.morningRoutine));
    expect(_isOn(tester, ReminderKind.morningRoutine), isFalse);
    expect(app.scheduler.scheduled, isEmpty);
    expect(find.textContaining('Notifications are not allowed'), findsOne);
  });

  testWidgets('the time changes in 15-minute steps and reschedules', (
    tester,
  ) async {
    final app = await _open(tester);
    await _tap(tester, _switch(ReminderKind.sleepLog));
    await _tap(tester, find.bySemanticsLabel('Change time: Sleep entry'));
    expect(find.text('When should we remind you?'), findsOneWidget);
    await _tap(tester, find.bySemanticsLabel('More'));
    await _tap(tester, find.text('Save'));
    expect(find.text('At 9:15 AM'), findsOneWidget);
    expect(app.scheduler.scheduled[ReminderKind.sleepLog]?.$2, 15);
  });

  testWidgets('settings come back after a restart with the same account '
      'only', (tester) async {
    await _open(tester);
    await _tap(tester, _switch(ReminderKind.morningRoutine));

    final again = await _open(tester, fresh: false, openScreen: false);
    expect(again.scheduler.scheduled.keys, [ReminderKind.morningRoutine]);

    final other = await _open(
      tester,
      fresh: false,
      userId: 'user-2',
      openScreen: false,
    );
    expect(other.scheduler.scheduled, isEmpty);
  });

  testWidgets('reminder texts follow the interface language', (tester) async {
    final app = await _open(tester);
    await _tap(tester, _switch(ReminderKind.morningRoutine));
    await app.settings.setLanguage('az');
    await tester.pumpAndSettle();
    expect(
      app.scheduler.scheduled[ReminderKind.morningRoutine]?.$3,
      'Səhər rutini vaxtıdır.',
    );
  });

  testWidgets('signing out cancels reminders but keeps the settings', (
    tester,
  ) async {
    final app = await _open(tester);
    await _tap(tester, _switch(ReminderKind.morningRoutine));
    await _tap(tester, find.byType(BackButton));
    await _tap(tester, find.text('Profile').last);
    await _tap(tester, find.text('Sign out'));
    expect(app.scheduler.scheduled, isEmpty);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('reminders.v1.user-1'), contains('"enabled":true'));
  });

  testWidgets('deleting the account cancels reminders and deletes the '
      'settings', (tester) async {
    final app = await _open(tester);
    await _tap(tester, _switch(ReminderKind.morningRoutine));
    await _tap(tester, find.byType(BackButton));
    await _tap(tester, find.text('Profile').last);
    await _tap(tester, find.text('Delete account'));
    await tester.enterText(
      find.byKey(const ValueKey('delete-confirm')),
      'DELETE',
    );
    await tester.pumpAndSettle();
    await _tap(tester, find.widgetWithText(FilledButton, 'Delete my account'));
    expect(app.api.deleted, isTrue);
    expect(app.scheduler.scheduled, isEmpty);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('reminders.v1.user-1'), isNull);
  });

  for (final language in ['az', 'ru', 'en']) {
    testWidgets('$language: reminders screen and time sheet keep text at '
        '18 px or more without overflow', (tester) async {
      await _open(tester, language: language);
      final sizes = <double>[];
      final list = find.byType(Scrollable).first;
      for (var i = 0; i < 4; i++) {
        sizes.addAll(paintedFontSizes(tester));
        expect(tester.takeException(), isNull);
        await tester.drag(list, const Offset(0, -400));
        await tester.pumpAndSettle();
      }
      await tester.drag(list, const Offset(0, 5000));
      await tester.pumpAndSettle();
      final card = find.byKey(const ValueKey('reminder-morningRoutine'));
      await _tap(
        tester,
        find.descendant(of: card, matching: find.byType(TextButton)),
      );
      sizes.addAll(paintedFontSizes(tester));
      expect(tester.takeException(), isNull);
      expect(sizes.where((s) => s < 18), isEmpty);
    });
  }
}
