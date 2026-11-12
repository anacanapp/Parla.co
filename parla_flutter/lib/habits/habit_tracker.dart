import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../home/routine.dart';
import 'habit_log.dart';
import 'habit_store.dart';

/// Today's habits and the recent history of the signed-in account.
///
/// Shared by the home screen and the habits tab. Every change is written to
/// the device store straight away; nothing is sent to the server.
class HabitTracker extends ChangeNotifier {
  HabitTracker({required this._store, required this._clock});

  static const waterGoal = 8;
  static const maxSleepHours = 14.0;
  static const maxMoveMinutes = 240;

  final HabitStore _store;
  final DateTime Function() _clock;

  HabitLog _log = HabitLog();
  String? _accountId;
  bool _loaded = false;

  /// Whether the stored history has been read.
  bool get loaded => _loaded;

  HabitLog get log => _log;

  DateTime get _today => _clock();

  DayEntry? get _todayEntry => _log.peek(_today);

  /// Loads the history of [accountId]; `null` (no account) keeps an
  /// in-memory log only. Loading the same account again is a no-op.
  Future<void> attach(String? accountId) async {
    if (_loaded && accountId == _accountId) return;
    _accountId = accountId;
    _log = HabitLog();
    _loaded = accountId == null;
    if (accountId != null) {
      HabitLog loaded;
      try {
        final raw = await _store.read(accountId);
        loaded = HabitLog.decode(
          raw == null ? null : jsonDecode(raw) as Map<String, Object?>,
        );
      } on Object {
        loaded = HabitLog(); // Unreadable data is treated as no history.
      }
      if (_accountId != accountId) return; // Switched while reading.
      // Keep anything logged while the history was loading.
      final pending = _log.days;
      for (final e in pending.entries) {
        loaded.days.putIfAbsent(e.key, () => e.value);
      }
      _log = loaded..prune(_today);
      _loaded = true;
      if (pending.isNotEmpty) await _save();
    }
    notifyListeners();
  }

  /// Forgets the in-memory log (sign-out). Stored data stays on the device.
  void detach() {
    _accountId = null;
    _log = HabitLog();
    _loaded = false;
    notifyListeners();
  }

  /// Deletes this account's habit history from the device.
  Future<void> erase() async {
    final id = _accountId;
    _log = HabitLog();
    notifyListeners();
    if (id != null) await _store.delete(id);
  }

  // Today's values.

  int get water => _todayEntry?.water ?? 0;
  double? get sleepHours => _todayEntry?.sleepHours;
  int? get moveMinutes => _todayEntry?.moveMinutes;

  bool isDone(RoutineKind kind, String stepId) =>
      _todayEntry?.done(kind).contains(stepId) ?? false;

  void toggleStep(RoutineKind kind, String stepId) => _change((day) {
    final done = day.done(kind);
    if (!done.remove(stepId)) done.add(stepId);
  });

  void restart(RoutineKind kind) => _change((day) => day.done(kind).clear());

  void addWater() {
    if (water >= waterGoal) return;
    _change((day) => day.water++);
  }

  void removeWater() {
    if (water == 0) return;
    _change((day) => day.water--);
  }

  /// Sets last night's sleep, or clears it with `null`.
  void setSleep(double? hours) => _change(
    (day) => day.sleepHours = hours?.clamp(0, maxSleepHours).toDouble(),
  );

  /// Sets today's movement, or clears it with `null`.
  void setMove(int? minutes) =>
      _change((day) => day.moveMinutes = minutes?.clamp(0, maxMoveMinutes));

  /// The device history as a JSON-ready map, for the data export.
  Map<String, Object?> exportJson() => _log.toJson();

  void _change(void Function(DayEntry day) update) {
    final today = _today;
    update(_log.day(today));
    _log.prune(today);
    notifyListeners();
    _save();
  }

  Future<void> _save() async {
    final id = _accountId;
    if (id == null || !_loaded) return;
    try {
      await _store.write(id, jsonEncode(_log.toJson()));
    } on Object catch (error) {
      // Keep working in memory; the next change tries again.
      debugPrint('Habit log not saved: ${error.runtimeType}');
    }
  }
}
