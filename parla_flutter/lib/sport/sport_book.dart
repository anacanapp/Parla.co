import 'package:parla_shared/parla_shared.dart';

import '../discover/content_library.dart';
import '../habits/habit_log.dart';
import '../services/parla_api.dart';
import '../sync/synced_document.dart';

/// The sport answers, the finished workouts and the sound settings. Kept
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
  bool _videoSound = true;

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

  /// The weekly plan of [section] for the week of [on] (today by default)
  /// in its monthly plan, or `null` before its questions.
  SportPlan? planOf(String section, {DateTime? on}) {
    final a = answersOf(section);
    if (a == null) return null;
    final start = SportMonth.startOf(a);
    final index = start == null
        ? null
        : SportMonth.indexOf(start, on ?? _clock());
    return planSport(
      a,
      section: section,
      exclude: ContentLibrary.hiddenIds('exercise'),
      week: index == null ? 0 : SportMonth.weekOf(index),
    );
  }

  /// The first day of [section]'s monthly plan, or `null` before its
  /// questions.
  DateTime? startOf(String section) {
    final a = answersOf(section);
    return a == null ? null : SportMonth.startOf(a);
  }

  /// Day 0 to 27 of today in [section]'s plan, or `null` outside it.
  int? todayIndexOf(String section) {
    final start = startOf(section);
    return start == null ? null : SportMonth.indexOf(start, _clock());
  }

  /// Today (the book's clock), without the time of day.
  DateTime get today => SportMonth.dayOf(_clock());

  /// Whether [section]'s 28 days are over.
  bool monthOver(String section) {
    final start = startOf(section);
    return start != null &&
        SportMonth.indexOf(start, _clock()) == null &&
        !SportMonth.dayOf(_clock()).isBefore(start);
  }

  /// The workout of [section] planned on [day], or `null` on a rest day or
  /// outside the plan.
  Workout? workoutOn(String section, DateTime day) {
    final a = answersOf(section);
    final start = startOf(section);
    if (a == null || start == null) return null;
    final i = SportMonth.workoutOn(a, start, day);
    final workouts = planOf(section, on: day)?.workouts ?? const <Workout>[];
    return i == null || i >= workouts.length ? null : workouts[i];
  }

  /// Whether the workout [workoutId] planned on [day] is finished: on any
  /// day of the same plan week (seven days from the start), so a workout
  /// done a day early or late still counts once.
  bool doneOn(String workoutId, DateTime day) {
    final start = _startOfWorkout(workoutId);
    final index = start == null ? null : SportMonth.indexOf(start, day);
    if (start == null || index == null) {
      return _log[SportMonth.keyOf(day)]?.contains(workoutId) ?? false;
    }
    final first = SportMonth.weekOf(index) * 7;
    for (var i = first; i < first + 7; i++) {
      final d = DateTime(start.year, start.month, start.day + i);
      if (_log[SportMonth.keyOf(d)]?.contains(workoutId) ?? false) return true;
    }
    return false;
  }

  DateTime? _startOfWorkout(String workoutId) {
    final section = SportOptions.sectionOfWorkout(workoutId);
    return SportOptions.sections.contains(section) ? startOf(section) : null;
  }

  /// The planned days of [section]'s month with their workouts.
  List<(DateTime, Workout)> monthOf(String section) {
    final start = startOf(section);
    if (start == null) return const [];
    return [
      for (var i = 0; i < SportMonth.days; i++)
        if (workoutOn(section, DateTime(start.year, start.month, start.day + i))
            case final w?)
          (DateTime(start.year, start.month, start.day + i), w),
    ];
  }

  /// The next planned day of [section] from today whose workout is not
  /// finished yet, or `null` when none is left this month.
  (DateTime, Workout)? nextDayOf(String section) {
    final today = SportMonth.dayOf(_clock());
    for (final (day, w) in monthOf(section)) {
      if (!day.isBefore(today) && !doneOn(w.id, day)) return (day, w);
    }
    return null;
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
  /// A new answer set keeps the running month's start; a new section, or
  /// one whose month is over, starts a new month today.
  Future<void> setAnswers(SportAnswers answers, {String section = 'fitness'}) {
    final running = todayIndexOf(section) != null;
    final own = answers
        .forSection(section)
        .copyWith(
          start: running
              ? answersOf(section)!.start
              : SportMonth.keyOf(_clock()),
        );
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

  /// The exercise videos' own sound (music); off plays them muted.
  bool get videoSound => _videoSound;

  Future<void> setVideoSound(bool on) {
    _videoSound = on;
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

  /// The next planned workout of [section] not finished yet, or `null`.
  Workout? nextOf(String section) => nextDayOf(section)?.$2;

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
    'videoSound': _videoSound,
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
    _videoSound = json['videoSound'] as bool? ?? true;
    // Answers from before the monthly plan: the month starts this Monday.
    final monday = SportMonth.keyOf(weekStart(_clock()));
    if (_answers != null && _answers!.start == null) {
      _answers = _answers!.copyWith(start: monday);
    }
    for (final s in [..._sections.keys]) {
      if (_sections[s]!.start == null) {
        _sections[s] = _sections[s]!.copyWith(start: monday);
      }
    }
  }

  @override
  void clearContent() {
    _answers = null;
    _sections.clear();
    _log.clear();
    _sound = true;
    _videoSound = true;
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
