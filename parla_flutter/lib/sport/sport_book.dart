import 'package:parla_shared/parla_shared.dart';

import '../habits/habit_log.dart';
import '../services/parla_api.dart';
import '../sync/synced_document.dart';

/// The sport answers, the finished workouts and the sound setting. Kept
/// like own routines: on the server (encrypted) with a covering health
/// consent, otherwise on this phone; see [SyncedDocument].
class SportBook extends SyncedDocument {
  SportBook({required super.store, super.api, DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  SportAnswers? _answers;

  /// Finished workout ids per day ("2026-11-15").
  final Map<String, Set<String>> _log = {};
  bool _sound = true;

  @override
  int get format => SportRules.format;

  @override
  Future<String?> fetchRemote(ParlaApi api) => api.mySport();

  @override
  Future<void> sendRemote(ParlaApi api, String json) => api.saveSport(json);

  SportAnswers? get answers => _answers;

  /// The plan for the current answers, or `null` before the questions.
  SportPlan? get plan => _answers == null ? null : planSport(_answers!);

  /// Timer signals on (music plays from the user's own app); off means
  /// vibration only.
  bool get sound => _sound;

  Future<void> setAnswers(SportAnswers answers) {
    _answers = answers;
    return changed();
  }

  Future<void> setSound(bool on) {
    _sound = on;
    return changed();
  }

  /// Workout ids finished this week (Monday to Sunday).
  Set<String> get doneThisWeek {
    final today = _clock();
    final start = weekStart(today);
    final done = <String>{};
    for (var d = start; !d.isAfter(today); d = d.add(const Duration(days: 1))) {
      done.addAll(_log[HabitLog.keyOf(d)] ?? const {});
    }
    return done;
  }

  bool get doneToday => (_log[HabitLog.keyOf(_clock())] ?? const {}).isNotEmpty;

  /// The first workout of the plan not finished this week, or `null`.
  Workout? get next {
    final done = doneThisWeek;
    for (final w in plan?.workouts ?? const <Workout>[]) {
      if (!done.contains(w.id)) return w;
    }
    return null;
  }

  Future<void> markDone(String workoutId) {
    _log.putIfAbsent(HabitLog.keyOf(_clock()), () => <String>{}).add(workoutId);
    _prune();
    return changed();
  }

  @override
  Map<String, Object?> exportJson() => {
    'format': format,
    if (_answers != null) 'answers': _answers!.toJson(),
    'log': {
      for (final e in _log.entries)
        if (e.value.isNotEmpty) e.key: e.value.toList()..sort(),
    },
    'sound': _sound,
  };

  @override
  void load(Map<String, Object?> json) {
    clearContent();
    final answers = json['answers'];
    if (answers is Map) {
      _answers = SportAnswers.fromJson(answers.cast<String, Object?>());
    }
    final log = (json['log'] as Map?)?.cast<String, Object?>() ?? {};
    for (final e in log.entries) {
      _log[e.key] = {...(e.value! as List).cast<String>()};
    }
    _sound = json['sound'] as bool? ?? true;
  }

  @override
  void clearContent() {
    _answers = null;
    _log.clear();
    _sound = true;
  }

  @override
  bool get hasContent => _answers != null || _log.isNotEmpty;

  void _prune() {
    final today = _clock();
    final oldest = DateTime(
      today.year,
      today.month,
      today.day - SportRules.keepLogDays,
    );
    _log.removeWhere((day, _) => DateTime.parse(day).isBefore(oldest));
  }
}
