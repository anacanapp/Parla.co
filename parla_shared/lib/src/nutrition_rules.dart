import 'dart:convert';

import 'content_rules.dart';

/// Rules for the daily plate in the nutrition tool: which food groups the
/// user had each day. No calories, no weights, no amounts. Stored on the
/// server encrypted, only with a covering health consent.
abstract final class NutritionRules {
  static const format = 1;
  static const keepDays = 90;
  static const maxBytes = 16 * 1024;

  static final _date = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  static bool isValid(String encoded) {
    if (utf8.encode(encoded).length > maxBytes) return false;
    final Object? json;
    try {
      json = jsonDecode(encoded);
    } on FormatException {
      return false;
    }
    if (json is! Map<String, Object?>) return false;
    if (!json.keys.every({'format', 'plates'}.contains)) return false;
    if (json['format'] != format) return false;
    final plates = json['plates'] ?? const <String, Object?>{};
    if (plates is! Map<String, Object?> || plates.length > keepDays + 1) {
      return false;
    }
    for (final MapEntry(:key, :value) in plates.entries) {
      if (!_date.hasMatch(key) || DateTime.tryParse(key) == null) return false;
      if (value is! List ||
          !value.every(ContentRules.plateGroups.contains) ||
          value.toSet().length != value.length) {
        return false;
      }
    }
    return true;
  }
}
