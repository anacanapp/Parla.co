import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:parla_shared/parla_shared.dart';

import '../habits/habit_log.dart';
import '../habits/habit_store.dart';
import '../services/parla_api.dart';

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
/// keeps an encrypted copy for offline use; changes made offline are sent
/// on the next start. Without the consent they stay on this phone only.
/// The names and steps are free text that may hold health details, which
/// is why the server needs the health consent (checked there too).
class CustomRoutineBook extends ChangeNotifier {
  CustomRoutineBook({
    required this._store,
    this._api,
    DateTime Function()? clock,
    Random? random,
  }) : _clock = clock ?? DateTime.now,
       _random = random ?? Random.secure();

  static const format = CustomRoutineRules.format;
  static const maxRoutines = CustomRoutineRules.maxRoutines;

  final HabitStore _store;
  final ParlaApi? _api;
  final DateTime Function() _clock;
  final Random _random;
  final List<CustomRoutine> _routines = [];

  /// Ticked step ids per day ("2026-11-12").
  final Map<String, Set<String>> _ticks = {};
  String? _accountId;

  /// Local changes the server has not got yet.
  bool _pending = false;

  /// Whether the server keeps the routines (health consent granted).
  bool _synced = false;
  bool _pushing = false;
  bool _pushAgain = false;

  List<CustomRoutine> get routines => List.unmodifiable(_routines);

  /// Whether the routines are kept on the server for this account.
  bool get isSynced => _synced;

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
      _ticks[_key(_clock())]?.contains(stepId) ?? false;

  void toggleTick(String stepId) {
    final day = _ticks.putIfAbsent(_key(_clock()), () => <String>{});
    if (!day.remove(stepId)) day.add(stepId);
    _changed();
  }

  /// Days with at least one tick (for the week view).
  Set<String> get tickedDays => {
    for (final e in _ticks.entries)
      if (e.value.isNotEmpty) e.key,
  };

  Future<void> attach(String? accountId) async {
    if (accountId == _accountId && accountId != null) return;
    _accountId = accountId;
    _clear();
    if (accountId != null) {
      try {
        final raw = await _store.read(accountId);
        if (raw != null && _accountId == accountId) {
          final json = jsonDecode(raw) as Map<String, Object?>;
          if (json['format'] == format) {
            _load(json);
            _pending = json['pendingUpload'] == true;
          }
        }
      } on Object {
        _clear(); // Unreadable data is treated as no routines.
      }
    }
    notifyListeners();
    if (accountId != null) await _sync(accountId);
  }

  /// Moves own-routine ticks kept in the habit log by an earlier version
  /// into this book, which sends them on.
  Future<void> adoptTicks(Map<String, Set<String>> ticks) async {
    if (ticks.isEmpty || _accountId == null) return;
    for (final e in ticks.entries) {
      _ticks.putIfAbsent(e.key, () => <String>{}).addAll(e.value);
    }
    await _changed();
  }

  void detach() {
    _accountId = null;
    _clear();
    notifyListeners();
  }

  /// Deletes the routines on this phone. The server deletes its copy with
  /// the account or the health consent.
  Future<void> erase() async {
    final id = _accountId;
    _clear();
    notifyListeners();
    if (id != null) await _store.delete(id);
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

  /// The routines and ticks in the stored format (also the data export).
  Map<String, Object?> exportJson() => {
    'format': format,
    'routines': [for (final r in _routines) r.toJson()],
    'ticks': {
      for (final e in _ticks.entries)
        if (e.value.isNotEmpty) e.key: e.value.toList()..sort(),
    },
  };

  void _clear() {
    _routines.clear();
    _ticks.clear();
    _pending = false;
    _synced = false;
  }

  void _load(Map<String, Object?> json) {
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

  bool get _hasContent => _routines.isNotEmpty || tickedDays.isNotEmpty;

  /// Server first when the consent is granted: local changes not sent yet
  /// (or a first upload) go up, otherwise the server's copy comes down.
  Future<void> _sync(String accountId) async {
    final api = _api;
    if (api == null) return;
    try {
      if (!await api.hasHealthConsent()) return;
      final remote = await api.myRoutines();
      if (_accountId != accountId) return;
      _synced = true;
      if (_pending || (remote == null && _hasContent)) {
        await _push();
      } else if (remote != null) {
        final json = jsonDecode(remote) as Map<String, Object?>;
        if (json['format'] != format) return;
        _load(json);
        notifyListeners();
        await _writeLocal();
      }
    } on Object catch (error) {
      // Offline or the server refused: the local copy keeps working and
      // is sent on the next start.
      debugPrint('Routines not synced: ${error.runtimeType}');
    }
  }

  Future<void> _changed() async {
    _prune();
    _pending = true;
    notifyListeners();
    await _writeLocal();
    await _push();
  }

  /// Sends the current state; one request at a time, the last state wins.
  Future<void> _push() async {
    final api = _api;
    final id = _accountId;
    if (api == null || id == null || !_synced) return;
    if (_pushing) {
      _pushAgain = true;
      return;
    }
    _pushing = true;
    try {
      do {
        _pushAgain = false;
        await api.saveRoutines(jsonEncode(exportJson()));
      } while (_pushAgain && _accountId == id);
      if (_accountId == id) {
        _pending = false;
        await _writeLocal();
      }
    } on Object catch (error) {
      debugPrint('Routines not sent: ${error.runtimeType}');
    } finally {
      _pushing = false;
    }
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

  Future<void> _writeLocal() async {
    final id = _accountId;
    if (id == null) return;
    try {
      await _store.write(
        id,
        jsonEncode({...exportJson(), 'pendingUpload': _pending}),
      );
    } on Object catch (error) {
      debugPrint('Routines not saved: ${error.runtimeType}');
    }
  }

  static String _key(DateTime day) => HabitLog.keyOf(day);
}
