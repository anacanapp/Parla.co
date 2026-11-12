import '../home/routine.dart';

/// What the user logged on one calendar day.
///
/// Sleep is the night before the day it is logged on. Values are only what
/// the user typed in; nothing is derived or judged.
class DayEntry {
  DayEntry({
    this.water = 0,
    this.sleepHours,
    this.moveMinutes,
    Set<String>? morningDone,
    Set<String>? eveningDone,
  }) : morningDone = morningDone ?? <String>{},
       eveningDone = eveningDone ?? <String>{};

  factory DayEntry.fromJson(Map<String, Object?> json) => DayEntry(
    water: (json['water'] as num?)?.toInt() ?? 0,
    sleepHours: (json['sleepHours'] as num?)?.toDouble(),
    moveMinutes: (json['moveMinutes'] as num?)?.toInt(),
    morningDone: {...?(json['morningDone'] as List?)?.cast<String>()},
    eveningDone: {...?(json['eveningDone'] as List?)?.cast<String>()},
  );

  int water;
  double? sleepHours;
  int? moveMinutes;
  final Set<String> morningDone;
  final Set<String> eveningDone;

  Set<String> done(RoutineKind kind) =>
      kind == RoutineKind.morning ? morningDone : eveningDone;

  /// At least one routine step was ticked.
  bool get hadCare => morningDone.isNotEmpty || eveningDone.isNotEmpty;

  bool get isEmpty =>
      water == 0 && sleepHours == null && moveMinutes == null && !hadCare;

  Map<String, Object?> toJson() => {
    if (water > 0) 'water': water,
    if (sleepHours != null) 'sleepHours': sleepHours,
    if (moveMinutes != null) 'moveMinutes': moveMinutes,
    if (morningDone.isNotEmpty) 'morningDone': morningDone.toList()..sort(),
    if (eveningDone.isNotEmpty) 'eveningDone': eveningDone.toList()..sort(),
  };
}

/// The habit history of one account on this device.
///
/// Kept on the device only and pruned to [keepDays] (privacy by design:
/// the server never sees habit data, and the device keeps no more than the
/// weekly view and a short history need).
class HabitLog {
  HabitLog([Map<String, DayEntry>? days]) : days = days ?? {};

  /// Parses stored data. Unknown or broken data gives an empty log rather
  /// than an error: losing a habit history is better than a crashing app.
  factory HabitLog.decode(Map<String, Object?>? json) {
    if (json == null || json['format'] != format) return HabitLog();
    final raw = json['days'];
    if (raw is! Map) return HabitLog();
    final days = <String, DayEntry>{};
    for (final entry in raw.entries) {
      final key = entry.key;
      final value = entry.value;
      if (key is String && _dayKey.hasMatch(key) && value is Map) {
        days[key] = DayEntry.fromJson(value.cast<String, Object?>());
      }
    }
    return HabitLog(days);
  }

  static const format = 'parla-habits-v1';
  static const keepDays = 90;
  static final _dayKey = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  final Map<String, DayEntry> days;

  static String keyOf(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  /// The entry for [date], created when missing.
  DayEntry day(DateTime date) => days.putIfAbsent(keyOf(date), DayEntry.new);

  /// The entry for [date] without creating it.
  DayEntry? peek(DateTime date) => days[keyOf(date)];

  /// Drops empty days and days older than [keepDays] before [today].
  void prune(DateTime today) {
    final oldest = keyOf(
      DateTime(today.year, today.month, today.day - (keepDays - 1)),
    );
    days.removeWhere(
      (key, entry) => entry.isEmpty || key.compareTo(oldest) < 0,
    );
  }

  Map<String, Object?> toJson() {
    final keys = days.keys.toList()..sort();
    return {
      'format': format,
      'days': {for (final k in keys) k: days[k]!.toJson()},
    };
  }
}

/// The seven days ending today, oldest first.
List<DateTime> lastSevenDays(DateTime today) => [
  for (var i = 6; i >= 0; i--) DateTime(today.year, today.month, today.day - i),
];

/// Weekly summary for the habits tab. Plain counts and averages only.
class WeekSummary {
  WeekSummary(HabitLog log, DateTime today)
    : dates = lastSevenDays(today),
      entries = [for (final d in lastSevenDays(today)) log.peek(d)];

  final List<DateTime> dates;
  final List<DayEntry?> entries;

  int get careDays => entries.where((e) => e?.hadCare ?? false).length;

  List<int> get water => [for (final e in entries) e?.water ?? 0];

  /// Average glasses on days with any water logged, or `null`.
  double? get waterAverage => _average(water.where((w) => w > 0));

  List<double?> get sleep => [for (final e in entries) e?.sleepHours];
  int get sleepNights => sleep.whereType<double>().length;
  double? get sleepAverage => _average(sleep.whereType<double>());

  List<int?> get move => [for (final e in entries) e?.moveMinutes];
  int get moveDays => move.whereType<int>().where((m) => m > 0).length;
  int get moveTotal => move.whereType<int>().fold(0, (a, b) => a + b);

  static double? _average(Iterable<num> values) {
    if (values.isEmpty) return null;
    return values.fold<num>(0, (a, b) => a + b) / values.length;
  }
}
