import 'dart:math';

import 'package:parla_shared/parla_shared.dart';

import '../habits/habit_log.dart';
import '../services/parla_api.dart';
import '../sync/synced_document.dart';

/// A product checked recently ("Son yoxlanılanlar").
class RecentProduct {
  const RecentProduct({
    required this.code,
    required this.source,
    required this.name,
    this.brand,
    required this.at,
  });

  factory RecentProduct.fromJson(Map<String, Object?> json) => RecentProduct(
    code: json['code']! as String,
    source: json['source']! as String,
    name: json['name']! as String,
    brand: json['brand'] as String?,
    at: json['at']! as String,
  );

  final String code;
  final String source;
  final String name;
  final String? brand;

  /// Day of the check, "2026-11-15".
  final String at;

  Map<String, Object?> toJson() => {
    'code': code,
    'source': source,
    'name': name,
    if (brand != null) 'brand': brand,
    'at': at,
  };
}

/// One line of the shopping list.
class ShoppingItem {
  ShoppingItem({
    required this.id,
    required this.title,
    this.area = 'other',
    this.origin = 'own',
    this.code,
    this.source,
    this.bought = false,
  });

  factory ShoppingItem.fromJson(Map<String, Object?> json) => ShoppingItem(
    id: json['id']! as String,
    title: json['title']! as String,
    area: json['area'] as String? ?? 'other',
    origin: json['origin'] as String? ?? 'own',
    code: json['code'] as String?,
    source: json['source'] as String?,
    bought: json['bought'] as bool? ?? false,
  );

  final String id;
  final String title;

  /// "face", "hair", "body" or "other".
  final String area;

  /// "own" (typed), "check" (from a product) or "routine".
  final String origin;
  final String? code;
  final String? source;
  bool bought;

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'area': area,
    'origin': origin,
    if (code != null) 'code': code,
    if (source != null) 'source': source,
    'bought': bought,
  };
}

/// The "Yoxla" data: product preferences, recently checked products and
/// the shopping list. Kept like own routines: on the server (encrypted)
/// with a covering health consent, otherwise on this phone; see
/// [SyncedDocument].
class CareListBook extends SyncedDocument {
  CareListBook({
    required super.store,
    super.api,
    DateTime Function()? clock,
    Random? random,
  }) : _clock = clock ?? DateTime.now,
       _random = random ?? Random.secure();

  final DateTime Function() _clock;
  final Random _random;
  final List<String> _preferences = [];
  final List<RecentProduct> _recent = [];
  final List<ShoppingItem> _shopping = [];

  @override
  int get format => CareListRules.format;

  @override
  Future<String?> fetchRemote(ParlaApi api) => api.myCareList();

  @override
  Future<void> sendRemote(ParlaApi api, String json) => api.saveCareList(json);

  /// Picked preference ids this version knows, in display order.
  List<String> get preferences => [
    for (final p in productPreferences)
      if (_preferences.contains(p.id)) p.id,
  ];

  List<RecentProduct> get recent => List.unmodifiable(_recent);
  List<ShoppingItem> get shopping => List.unmodifiable(_shopping);

  int get boughtCount => _shopping.where((i) => i.bought).length;

  Future<void> setPreferences(Iterable<String> ids) {
    _preferences
      ..clear()
      ..addAll({
        for (final id in ids)
          if (productPreference(id) != null) id,
      });
    return changed();
  }

  /// Puts [product] first in the recent list (once per product).
  Future<void> addRecent({
    required String code,
    required String source,
    required String name,
    String? brand,
  }) {
    _recent.removeWhere((r) => r.code == code && r.source == source);
    _recent.insert(
      0,
      RecentProduct(
        code: _cut(code, CareListRules.maxCodeLength),
        source: source,
        name: _cut(name, CareListRules.maxProductNameLength),
        brand: brand == null ? null : _cut(brand, CareListRules.maxBrandLength),
        at: HabitLog.keyOf(_clock()),
      ),
    );
    if (_recent.length > CareListRules.maxRecent) _recent.removeLast();
    return changed();
  }

  Future<void> clearRecent() {
    _recent.clear();
    return changed();
  }

  /// Whether a product is already on the list.
  bool hasProduct(String code, String source) =>
      _shopping.any((i) => i.code == code && i.source == source);

  /// Adds an item; returns `false` when the list is full or [title] empty.
  Future<bool> addItem(
    String title, {
    String area = 'other',
    String origin = 'own',
    String? code,
    String? source,
  }) async {
    final clean = title.trim();
    if (clean.isEmpty || _shopping.length >= CareListRules.maxShopping) {
      return false;
    }
    _shopping.add(
      ShoppingItem(
        id: _newId(),
        title: _cut(clean, CareListRules.maxTitleLength),
        area: area,
        origin: origin,
        code: code == null ? null : _cut(code, CareListRules.maxCodeLength),
        source: source,
      ),
    );
    await changed();
    return true;
  }

  Future<void> toggleBought(String id) {
    for (final item in _shopping) {
      if (item.id == id) item.bought = !item.bought;
    }
    return changed();
  }

  Future<void> removeItem(String id) {
    _shopping.removeWhere((i) => i.id == id);
    return changed();
  }

  Future<void> removeBought() {
    _shopping.removeWhere((i) => i.bought);
    return changed();
  }

  @override
  Map<String, Object?> exportJson() => {
    'format': format,
    'preferences': preferences,
    'recent': [for (final r in _recent) r.toJson()],
    'shopping': [for (final i in _shopping) i.toJson()],
  };

  @override
  void load(Map<String, Object?> json) {
    clearContent();
    _preferences.addAll((json['preferences'] as List? ?? const []).cast());
    for (final r in (json['recent'] as List? ?? const [])) {
      _recent.add(RecentProduct.fromJson((r as Map).cast<String, Object?>()));
    }
    for (final i in (json['shopping'] as List? ?? const [])) {
      _shopping.add(ShoppingItem.fromJson((i as Map).cast<String, Object?>()));
    }
  }

  @override
  void clearContent() {
    _preferences.clear();
    _recent.clear();
    _shopping.clear();
  }

  @override
  bool get hasContent =>
      _preferences.isNotEmpty || _recent.isNotEmpty || _shopping.isNotEmpty;

  String _newId() => List.generate(
    10,
    (_) => 'abcdefghijklmnopqrstuvwxyz0123456789'[_random.nextInt(36)],
  ).join();

  static String _cut(String value, int max) {
    final runes = value.runes;
    return runes.length <= max
        ? value
        : String.fromCharCodes(runes.take(max)).trimRight();
  }
}
