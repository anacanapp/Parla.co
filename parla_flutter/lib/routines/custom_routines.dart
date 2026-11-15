import 'dart:math';

import 'package:parla_shared/parla_shared.dart';

import '../habits/habit_log.dart';
import '../services/parla_api.dart';
import '../sync/synced_document.dart';

/// One step of a routine the user made herself.
class CustomStep {
  CustomStep({required this.id, required this.title, this.note = ''});

  factory CustomStep.fromJson(Map<String, Object?> json) => CustomStep(
    id: json['id']! as String,
    title: json['title']! as String,
    note: json['note'] as String? ?? '',
  );

  final String id;
  String title;
  String note;

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    if (note.isNotEmpty) 'note': note,
  };
}

/// A routine the user made: a name, a care area, when it is done (every
/// day or one weekday) and its steps in order.
class CustomRoutine {
  CustomRoutine({
    required this.id,
    required this.name,
    required this.area,
    this.weekday,
    List<CustomStep>? steps,
  }) : steps = steps ?? [];

  factory CustomRoutine.fromJson(Map<String, Object?> json) => CustomRoutine(
    id: json['id']! as String,
    name: json['name']! as String,
    area: RoutineArea.values.byName(json['area']! as String),
    weekday: (json['weekday'] as num?)?.toInt(),
    steps: [
      for (final s in (json['steps'] as List? ?? const []))
        CustomStep.fromJson((s as Map).cast<String, Object?>()),
    ],
  );

  final String id;
  String name;
  RoutineArea area;

  /// [DateTime.monday] to [DateTime.sunday], or `null` for every day.
  int? weekday;
  final List<CustomStep> steps;

  /// Whether the routine is on the list for [day].
  bool isDueOn(DateTime day) => weekday == null || weekday == day.weekday;

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'area': area.name,
    if (weekday != null) 'weekday': weekday,
    'steps': [for (final s in steps) s.toJson()],
  };

  static const maxSteps = CustomRoutineRules.maxSteps;
  static const maxNameLength = CustomRoutineRules.maxNameLength;
  static const maxStepLength = CustomRoutineRules.maxStepLength;
}

/// The user's own routines and their daily ticks.
///
/// With the health consent the server keeps them (encrypted) and this phone
/// keeps an encrypted copy for offline use; see [SyncedDocument]. Without
/// the consent they stay on this phone only. The names and steps are free
/// text that may hold health details, which is why the server needs the
/// health consent (checked there too).
class CustomRoutineBook extends SyncedDocument {
  CustomRoutineBook({
    required super.store,
    super.api,
    DateTime Function()? clock,
    Random? random,
  }) : _clock = clock ?? DateTime.now,
       _random = random ?? Random.secure();

  static const maxRoutines = CustomRoutineRules.maxRoutines;

  final DateTime Function() _clock;
  final Random _random;
  final List<CustomRoutine> _routines = [];

  /// Ticked step ids per day ("2026-11-12").
  final Map<String, Set<String>> _ticks = {};

  @override
  int get format => CustomRoutineRules.format;

  @override
  Future<String?> fetchRemote(ParlaApi api) => api.myRoutines();

  @override
  Future<void> sendRemote(ParlaApi api, String json) => api.saveRoutines(json);

  List<CustomRoutine> get routines => List.unmodifiable(_routines);

  Iterable<CustomRoutine> forArea(RoutineArea area) =>
      _routines.where((r) => r.area == area);

  CustomRoutine? byId(String id) {
    for (final r in _routines) {
      if (r.id == id) return r;
    }
    return null;
  }

  /// A short random id for a routine or step.
  String newId() => List.generate(
    10,
    (_) => 'abcdefghijklmnopqrstuvwxyz0123456789'[_random.nextInt(36)],
  ).join();

  /// Whether [stepId] is ticked today.
  bool isTicked(String stepId) =>
      _ticks[HabitLog.keyOf(_clock())]?.contains(stepId) ?? false;

  void toggleTick(String stepId) {
    final day = _ticks.putIfAbsent(HabitLog.keyOf(_clock()), () => <String>{});
    if (!day.remove(stepId)) day.add(stepId);
    _changed();
  }

  /// Days with at least one tick (for the week view).
  Set<String> get tickedDays => {
    for (final e in _ticks.entries)
      if (e.value.isNotEmpty) e.key,
  };

  /// Moves own-routine ticks kept in the habit log by an earlier version
  /// into this book, which sends them on.
  Future<void> adoptTicks(Map<String, Set<String>> ticks) async {
    if (ticks.isEmpty || accountId == null) return;
    for (final e in ticks.entries) {
      _ticks.putIfAbsent(e.key, () => <String>{}).addAll(e.value);
    }
    await _changed();
  }

  /// Adds [routine], or replaces the routine with the same id.
  Future<void> save(CustomRoutine routine) async {
    final i = _routines.indexWhere((r) => r.id == routine.id);
    if (i >= 0) {
      _routines[i] = routine;
    } else {
      if (_routines.length >= maxRoutines) return;
      _routines.add(routine);
    }
    await _changed();
  }

  Future<void> delete(String id) async {
    final routine = byId(id);
    _routines.removeWhere((r) => r.id == id);
    if (routine != null) {
      final steps = {for (final s in routine.steps) s.id};
      for (final day in _ticks.values) {
        day.removeAll(steps);
      }
    }
    await _changed();
  }

  @override
  Map<String, Object?> exportJson() => {
    'format': format,
    'routines': [for (final r in _routines) r.toJson()],
    'ticks': {
      for (final e in _ticks.entries)
        if (e.value.isNotEmpty) e.key: e.value.toList()..sort(),
    },
  };

  @override
  void clearContent() {
    _routines.clear();
    _ticks.clear();
  }

  @override
  void load(Map<String, Object?> json) {
    _routines.clear();
    _ticks.clear();
    for (final r in (json['routines'] as List? ?? const [])) {
      _routines.add(CustomRoutine.fromJson((r as Map).cast<String, Object?>()));
    }
    final ticks = (json['ticks'] as Map?)?.cast<String, Object?>() ?? {};
    for (final e in ticks.entries) {
      _ticks[e.key] = {...(e.value! as List).cast<String>()};
    }
  }

  @override
  bool get hasContent => _routines.isNotEmpty || tickedDays.isNotEmpty;

  Future<void> _changed() {
    _prune();
    return changed();
  }

  void _prune() {
    final today = _clock();
    final oldest = DateTime(
      today.year,
      today.month,
      today.day - CustomRoutineRules.keepTickDays,
    );
    _ticks.removeWhere(
      (day, steps) => steps.isEmpty || DateTime.parse(day).isBefore(oldest),
    );
  }
}
