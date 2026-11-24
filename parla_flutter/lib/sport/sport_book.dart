import 'package:parla_shared/parla_shared.dart';

import '../discover/content_library.dart';
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

  /// Fitness answers ("answers" in the stored document, as before
  /// sections existed).
  SportAnswers? _answers;

  /// Answers of the other planned sections (pilates, wall pilates).
  final Map<String, SportAnswers> _sections = {};

  /// Finished workout ids per day ("2026-11-15").
  final Map<String, Set<String>> _log = {};
  bool _sound = true;

  @override
  int get format => SportRules.format;

  @override
  Future<String?> fetchRemote(ParlaApi api) => api.mySport();

  @override
  Future<void> sendRemote(ParlaApi api, String json) => api.saveSport(json);

  /// The fitness answers; also the latest safety answers for the fixed
  /// sessions when only fitness was answered.
  SportAnswers? get answers => _answers ?? _sections.values.firstOrNull;

  /// The answers of [section] (see [SportOptions.sections]), or `null`
  /// before its questions.
  SportAnswers? answersOf(String section) =>
      section == 'fitness' ? _answers : _sections[section];

  /// The fitness plan, or `null` before its questions.
  SportPlan? get plan => planOf('fitness');

  /// The weekly plan of [section], or `null` before its questions.
  SportPlan? planOf(String section) {
    final a = answersOf(section);
    return a == null
        ? null
        : planSport(
            a,
            section: section,
            exclude: ContentLibrary.hiddenIds('exercise'),
          );
  }

  /// Every workout of every planned section.
  Iterable<Workout> get allWorkouts => [
    for (final s in SportOptions.sections) ...?planOf(s)?.workouts,
  ];

  /// Timer signals on (music plays from the user's own app); off means
  /// vibration only.
  bool get sound => _sound;

  /// Saves the answers of [section]. Pregnancy, injuries and a doctor's
  /// limit belong to the person, so the other sections take them too.
  Future<void> setAnswers(SportAnswers answers, {String section = 'fitness'}) {
    final own = answers.forSection(section);
    if (section == 'fitness') {
      _answers = own;
    } else {
      _sections[section] = own;
    }
    if (section != 'fitness' && _answers != null) {
      _answers = _answers!.withSafetyOf(own);
    }
    for (final key in [..._sections.keys]) {
      if (key != section) _sections[key] = _sections[key]!.withSafetyOf(own);
    }
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

  /// The first fitness workout not finished this week, or `null`.
  Workout? get next => nextOf('fitness');

  /// The first workout of [section] not finished this week, or `null`.
  Workout? nextOf(String section) {
    final done = doneThisWeek;
    for (final w in planOf(section)?.workouts ?? const <Workout>[]) {
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
    if (_sections.isNotEmpty)
      'sections': {
        for (final s in SportOptions.sections)
          if (_sections[s] != null) s: _sections[s]!.toJson(),
      },
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
      final all = SportAnswers.fromJson(answers.cast<String, Object?>());
      _answers = all.forSection('fitness');
      // Before sections, one plan rotated through every chosen type: a
      // pilates or wall pilates choice now starts that section's plan.
      final sections = (json['sections'] as Map?)?.cast<String, Object?>();
      if (sections == null) {
        for (final s in SportOptions.sections.skip(1)) {
          if (all.types.contains(s)) _sections[s] = all.forSection(s);
        }
        if (!all.types.any(SportOptions.typesOf('fitness').contains) &&
            _sections.isNotEmpty) {
          _answers = null;
        }
      }
    }
    final sections = (json['sections'] as Map?)?.cast<String, Object?>();
    for (final e in (sections ?? const <String, Object?>{}).entries) {
      if (e.value is Map && SportOptions.sections.contains(e.key)) {
        _sections[e.key] = SportAnswers.fromJson(
          (e.value! as Map).cast<String, Object?>(),
        ).forSection(e.key);
      }
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
    _sections.clear();
    _log.clear();
    _sound = true;
  }

  @override
  bool get hasContent =>
      _answers != null || _sections.isNotEmpty || _log.isNotEmpty;

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
