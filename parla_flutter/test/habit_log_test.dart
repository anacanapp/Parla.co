import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla/habits/habit_log.dart';
import 'package:parla/habits/habit_store.dart';
import 'package:parla/habits/habit_tracker.dart';
import 'package:parla/home/routine.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final today = DateTime(2026, 11, 12, 9);

  test('keeps 90 days and drops older and empty days', () {
    final log = HabitLog()
      ..day(today).water = 3
      ..day(DateTime(2026, 8, 15)).water =
          1 // 89 days ago: kept.
      ..day(DateTime(2026, 8, 14)).water =
          1 // 90 days ago: dropped.
      ..day(DateTime(2026, 11, 1)); // Empty: dropped.
    log.prune(today);
    expect(log.days.keys.toSet(), {'2026-11-12', '2026-08-15'});
  });

  test('broken or foreign data gives an empty log', () {
    expect(HabitLog.decode(null).days, isEmpty);
    expect(HabitLog.decode({'format': 'other'}).days, isEmpty);
    expect(
      HabitLog.decode({'format': HabitLog.format, 'days': 3}).days,
      isEmpty,
    );
    final log = HabitLog.decode({
      'format': HabitLog.format,
      'days': {
        'not-a-date': {'water': 1},
        '2026-11-12': {'water': 2},
      },
    });
    expect(log.days.keys, ['2026-11-12']);
  });

  test('round-trips through JSON', () {
    final log = HabitLog();
    log.day(today)
      ..water = 4
      ..sleepHours = 7.5
      ..moveMinutes = 30
      ..morningDone.add('cleanser');
    final again = HabitLog.decode(
      jsonDecode(jsonEncode(log.toJson())) as Map<String, Object?>,
    );
    final day = again.peek(today)!;
    expect(day.water, 4);
    expect(day.sleepHours, 7.5);
    expect(day.moveMinutes, 30);
    expect(day.morningDone, {'cleanser'});
  });

  test('the week summary counts care days and averages logged days only', () {
    final log = HabitLog();
    log.day(today)
      ..water = 6
      ..sleepHours = 8
      ..eveningDone.add('makeup-off');
    log.day(DateTime(2026, 11, 10))
      ..water = 2
      ..sleepHours = 6
      ..moveMinutes = 45;
    log.day(DateTime(2026, 11, 5)).water = 8; // Outside the 7 days.
    final week = WeekSummary(log, today);
    expect(week.dates.first, DateTime(2026, 11, 6));
    expect(week.dates.last, DateTime(2026, 11, 12));
    expect(week.careDays, 1);
    expect(week.waterAverage, 4);
    expect(week.sleepAverage, 7);
    expect(week.sleepNights, 2);
    expect(week.moveDays, 1);
    expect(week.moveTotal, 45);
  });

  test(
    'the tracker saves every change for the attached account only',
    () async {
      final store = MemoryHabitStore();
      final tracker = HabitTracker(store: store, clock: () => today);
      await tracker.attach('a');
      tracker
        ..addWater()
        ..toggleStep(RoutineKind.morning, 'cleanser')
        ..setSleep(20); // Clamped to 14.
      await Future<void>.delayed(Duration.zero);
      expect(tracker.sleepHours, HabitTracker.maxSleepHours);
      expect(store.data['a'], contains('"water":1'));

      await tracker.attach('b');
      expect(tracker.water, 0);
      await tracker.attach('a');
      expect(tracker.water, 1);

      await tracker.erase();
      expect(store.data.containsKey('a'), isFalse);
      expect(tracker.water, 0);
    },
  );

  test('without an account nothing is stored', () async {
    final store = MemoryHabitStore();
    final tracker = HabitTracker(store: store, clock: () => today);
    await tracker.attach(null);
    tracker.addWater();
    await Future<void>.delayed(Duration.zero);
    expect(tracker.water, 1);
    expect(store.data, isEmpty);
  });

  test('unreadable stored data is treated as no history', () async {
    final store = MemoryHabitStore()..data['a'] = 'not json';
    final tracker = HabitTracker(store: store, clock: () => today);
    await tracker.attach('a');
    expect(tracker.loaded, isTrue);
    expect(tracker.water, 0);
  });

  test('a fresh installation forgets habit entries left in the Keychain, '
      'once', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({
      'parla.habits.v1.a': '{}',
      'other.key': 'kept',
    });
    const storage = FlutterSecureStorage();
    await SecureHabitStore.forgetAfterReinstall();
    expect(await storage.readAll(), {'other.key': 'kept'});

    await const SecureHabitStore().write('a', '{"x":1}');
    await SecureHabitStore.forgetAfterReinstall();
    expect(await const SecureHabitStore().read('a'), '{"x":1}');
  });
}
