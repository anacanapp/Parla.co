import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:parla_shared/parla_shared.dart';

import '../habits/habit_store.dart';

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

  static const maxSteps = 12;
  static const maxNameLength = 40;
  static const maxStepLength = 60;
}

/// The user's own routines, kept on this device only (per account,
/// encrypted, like the habit log). They go into the data export and are
/// deleted with the account; nothing is sent to the server.
class CustomRoutineBook extends ChangeNotifier {
  CustomRoutineBook({required this._store, Random? random})
    : _random = random ?? Random.secure();

  static const format = 1;
  static const maxRoutines = 20;

  final HabitStore _store;
  final Random _random;
  final List<CustomRoutine> _routines = [];
  String? _accountId;

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

  Future<void> attach(String? accountId) async {
    if (accountId == _accountId && accountId != null) return;
    _accountId = accountId;
    _routines.clear();
    if (accountId != null) {
      try {
        final raw = await _store.read(accountId);
        if (raw != null && _accountId == accountId) {
          final json = jsonDecode(raw) as Map<String, Object?>;
          if (json['format'] == format) {
            for (final r in (json['routines'] as List? ?? const [])) {
              _routines.add(
                CustomRoutine.fromJson((r as Map).cast<String, Object?>()),
              );
            }
          }
        }
      } on Object {
        _routines.clear(); // Unreadable data is treated as no routines.
      }
    }
    notifyListeners();
  }

  void detach() {
    _accountId = null;
    _routines.clear();
    notifyListeners();
  }

  Future<void> erase() async {
    final id = _accountId;
    _routines.clear();
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
    notifyListeners();
    await _write();
  }

  Future<void> delete(String id) async {
    _routines.removeWhere((r) => r.id == id);
    notifyListeners();
    await _write();
  }

  Map<String, Object?> exportJson() => {
    'format': format,
    'routines': [for (final r in _routines) r.toJson()],
  };

  Future<void> _write() async {
    final id = _accountId;
    if (id == null) return;
    try {
      await _store.write(id, jsonEncode(exportJson()));
    } on Object catch (error) {
      debugPrint('Routines not saved: ${error.runtimeType}');
    }
  }
}
