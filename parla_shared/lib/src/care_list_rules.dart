import 'dart:convert';

/// Rules for the "Yoxla" data a user keeps: her product preferences, the
/// products she checked last and her shopping list. Used by the app before
/// sending and by the server before storing.
///
/// The shopping list is free text that may hold health details, so the
/// server stores all of it encrypted and only with a health consent whose
/// text covers it (`healthVersionsCoveringCareList`).
abstract final class CareListRules {
  static const format = 1;

  static const maxPreferences = 20;
  static const maxRecent = 20;
  static const maxShopping = 100;
  static const maxTitleLength = 60;
  static const maxProductNameLength = 120;
  static const maxBrandLength = 80;
  static const maxCodeLength = 64;

  /// Upper bound of the encoded JSON in bytes.
  static const maxBytes = 64 * 1024;

  static const areas = {'face', 'hair', 'body', 'other'};
  static const origins = {'own', 'routine', 'check', 'recipe'};
  static const sources = {'parla', 'openbeautyfacts'};

  static final _id = RegExp(r'^[a-z0-9]{1,16}$');
  static final _preference = RegExp(r'^[a-z_]{1,32}$');
  static final _date = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  /// Whether [encoded] may be stored: the right format, within every
  /// limit, and nothing but the known fields.
  static bool isValid(String encoded) {
    if (utf8.encode(encoded).length > maxBytes) return false;
    final Object? json;
    try {
      json = jsonDecode(encoded);
    } on FormatException {
      return false;
    }
    if (json is! Map<String, Object?>) return false;
    if (!_only(json, const {'format', 'preferences', 'recent', 'shopping'})) {
      return false;
    }
    if (json['format'] != format) return false;

    final preferences = json['preferences'] ?? const <Object?>[];
    if (preferences is! List || preferences.length > maxPreferences) {
      return false;
    }
    if (!preferences.every((p) => p is String && _preference.hasMatch(p))) {
      return false;
    }

    final recent = json['recent'] ?? const <Object?>[];
    if (recent is! List || recent.length > maxRecent) return false;
    for (final r in recent) {
      if (r is! Map<String, Object?>) return false;
      if (!_only(r, const {'code', 'source', 'name', 'brand', 'at'})) {
        return false;
      }
      if (!_text(r['code'], maxCodeLength, required: true)) return false;
      if (!sources.contains(r['source'])) return false;
      if (!_text(r['name'], maxProductNameLength, required: true)) {
        return false;
      }
      if (!_text(r['brand'], maxBrandLength)) return false;
      final at = r['at'];
      if (at is! String ||
          !_date.hasMatch(at) ||
          DateTime.tryParse(at) == null) {
        return false;
      }
    }

    final shopping = json['shopping'] ?? const <Object?>[];
    if (shopping is! List || shopping.length > maxShopping) return false;
    final ids = <String>{};
    for (final item in shopping) {
      if (item is! Map<String, Object?>) return false;
      if (!_only(item, const {
        'id',
        'title',
        'area',
        'origin',
        'code',
        'source',
        'bought',
      })) {
        return false;
      }
      final id = item['id'];
      if (id is! String || !_id.hasMatch(id) || !ids.add(id)) return false;
      if (!_text(item['title'], maxTitleLength, required: true)) return false;
      if (!areas.contains(item['area'] ?? 'other')) return false;
      if (!origins.contains(item['origin'] ?? 'own')) return false;
      if (!_text(item['code'], maxCodeLength)) return false;
      final source = item['source'];
      if (source != null && !sources.contains(source)) return false;
      final bought = item['bought'];
      if (bought != null && bought is! bool) return false;
    }
    return true;
  }

  static bool _only(Map<String, Object?> map, Set<String> allowed) =>
      map.keys.every(allowed.contains);

  static bool _text(Object? value, int max, {bool required = false}) {
    if (value == null) return !required;
    if (value is! String) return false;
    return value.runes.length <= max && (!required || value.trim().isNotEmpty);
  }
}
