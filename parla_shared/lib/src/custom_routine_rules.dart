import 'dart:convert';

/// Rules for the routines a user makes herself ("Öz rutinin") and their
/// daily ticks. Used by the app before sending and by the server before
/// storing, so both refuse the same data.
///
/// The names and steps are free text and may hold health details, so the
/// server stores them encrypted and only with the health consent.
abstract final class CustomRoutineRules {
  /// Version of the stored JSON.
  static const format = 1;

  static const maxRoutines = 20;
  static const maxSteps = 12;
  static const maxNameLength = 40;
  static const maxStepLength = 60;
  static const maxNoteLength = 120;
  static const maxIdLength = 16;

  /// Ticks older than this many days are dropped (same as the habit log).
  static const keepTickDays = 90;

  /// Upper bound of the encoded JSON in bytes.
  static const maxBytes = 64 * 1024;

  static const _areas = {'face', 'hair', 'body'};
  static final _id = RegExp(r'^[a-z0-9]{1,16}$');
  static final _date = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  /// Whether [encoded] is a routine book that may be stored: the right
  /// format, within every limit, and nothing but the known fields.
  static bool isValid(String encoded) {
    if (utf8.encode(encoded).length > maxBytes) return false;
    final Object? json;
    try {
      json = jsonDecode(encoded);
    } on FormatException {
      return false;
    }
    if (json is! Map<String, Object?>) return false;
    if (!_onlyKeys(json, const {'format', 'routines', 'ticks'})) return false;
    if (json['format'] != format) return false;

    final routines = json['routines'] ?? const <Object?>[];
    if (routines is! List || routines.length > maxRoutines) return false;
    final stepIds = <String>{};
    final routineIds = <String>{};
    for (final r in routines) {
      if (r is! Map<String, Object?>) return false;
      if (!_onlyKeys(r, const {'id', 'name', 'area', 'weekday', 'steps'})) {
        return false;
      }
      final id = r['id'];
      if (id is! String || !_id.hasMatch(id) || !routineIds.add(id)) {
        return false;
      }
      if (!_text(r['name'], maxNameLength, required: true)) return false;
      if (!_areas.contains(r['area'])) return false;
      final weekday = r['weekday'];
      if (weekday != null && (weekday is! int || weekday < 1 || weekday > 7)) {
        return false;
      }
      final steps = r['steps'] ?? const <Object?>[];
      if (steps is! List || steps.length > maxSteps) return false;
      for (final s in steps) {
        if (s is! Map<String, Object?>) return false;
        if (!_onlyKeys(s, const {'id', 'title', 'note'})) return false;
        final sid = s['id'];
        if (sid is! String || !_id.hasMatch(sid) || !stepIds.add(sid)) {
          return false;
        }
        if (!_text(s['title'], maxStepLength, required: true)) return false;
        if (!_text(s['note'], maxNoteLength)) return false;
      }
    }

    final ticks = json['ticks'] ?? const <String, Object?>{};
    if (ticks is! Map<String, Object?>) return false;
    if (ticks.length > keepTickDays + 1) return false;
    for (final MapEntry(:key, :value) in ticks.entries) {
      if (!_date.hasMatch(key) || DateTime.tryParse(key) == null) return false;
      if (value is! List || value.length > maxRoutines * maxSteps) {
        return false;
      }
      for (final id in value) {
        if (id is! String || !_id.hasMatch(id)) return false;
      }
    }
    return true;
  }

  /// [encoded] without ticks older than [keepTickDays] before [today].
  /// Expects valid input (see [isValid]).
  static String pruneTicks(String encoded, DateTime today) {
    final json = jsonDecode(encoded) as Map<String, Object?>;
    final ticks = json['ticks'] as Map<String, Object?>?;
    if (ticks == null) return encoded;
    final oldest = DateTime.utc(
      today.year,
      today.month,
      today.day,
    ).subtract(const Duration(days: keepTickDays));
    ticks.removeWhere(
      (date, _) => DateTime.parse('${date}T00:00:00Z').isBefore(oldest),
    );
    return jsonEncode(json);
  }

  static bool _onlyKeys(Map<String, Object?> map, Set<String> allowed) =>
      map.keys.every(allowed.contains);

  static bool _text(Object? value, int max, {bool required = false}) {
    if (value == null) return !required;
    if (value is! String) return false;
    final length = value.runes.length;
    return length <= max && (!required || value.trim().isNotEmpty);
  }
}
