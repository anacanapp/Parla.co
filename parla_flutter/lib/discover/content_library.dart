import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/parla_api.dart';

/// Published articles, recipes and expert profiles, and the team's texts
/// and hidden flags for the app's catalogues (preferences, exercises,
/// routine steps). Loaded from the server and kept in the app preferences,
/// so the last copy shows offline. It is public content, nothing personal.
class ContentLibrary extends ChangeNotifier {
  ContentLibrary(this._api) {
    current = this;
  }

  static const kinds = [
    'article',
    'recipe',
    'expert',
    'preference',
    'exercise',
    'step',
    'banner',
    'message',
    'product',
  ];
  static const catalogueKinds = ['preference', 'exercise', 'step'];

  /// The signed-in user's country from the profile, for banner targeting
  /// on the phone (`null` until known).
  static String? country;

  /// The app's library, for the catalogue text lookups.
  static ContentLibrary? current;

  /// Published texts of a catalogue item, or `null` to use the app's own.
  static Map<String, Object?>? catalogueData(String kind, String id) {
    final item = current?.find(kind, id);
    if (item == null || item.data.isEmpty) return null;
    return item.data;
  }

  /// A published text field of a catalogue item in [language], or `null`.
  static String? catalogueText(
    String kind,
    String id,
    String key,
    String language,
  ) {
    final data = catalogueData(kind, id);
    if (data == null) return null;
    final v = ContentRules.pick(data[key], language);
    return v.isEmpty ? null : v;
  }

  /// Catalogue ids the team hid.
  static Set<String> hiddenIds(String kind) => {
    for (final i in current?.items(kind) ?? const <PublishedItem>[])
      if (i.hidden) i.slug,
  };
  static const _prefix = 'content.cache.';

  final ParlaApi _api;
  final Map<String, List<PublishedItem>> _items = {};
  final Set<String> _loaded = {};
  bool _offline = false;

  List<PublishedItem> items(String kind) => _items[kind] ?? const [];

  /// Whether [kind] has been loaded (from the server or the cache).
  bool isLoaded(String kind) => _loaded.contains(kind);

  /// The last load failed and the cached copy is shown.
  bool get offline => _offline;

  PublishedItem? find(String kind, String slug) {
    for (final i in items(kind)) {
      if (i.slug == slug) return i;
    }
    return null;
  }

  /// Loads every kind: the cached copy first, then the server's.
  Future<void> load() async {
    await Future.wait([for (final k in kinds) _load(k)]);
  }

  /// Loads the catalogue texts, hidden flags and banners (at app start).
  Future<void> loadCatalogue() async {
    await Future.wait([
      for (final k in [...catalogueKinds, 'banner', 'message']) _load(k),
    ]);
  }

  Future<void> _load(String kind) async {
    final prefs = await SharedPreferences.getInstance();
    if (!_loaded.contains(kind)) {
      final cached = prefs.getString('$_prefix$kind');
      if (cached != null) {
        try {
          _items[kind] = [
            for (final e in jsonDecode(cached) as List)
              PublishedItem.fromJson((e as Map).cast<String, Object?>()),
          ];
          _loaded.add(kind);
          notifyListeners();
        } on Object {
          await prefs.remove('$_prefix$kind');
        }
      }
    }
    try {
      final fresh = await _api.publishedContent(kind);
      _items[kind] = fresh;
      _loaded.add(kind);
      _offline = false;
      await prefs.setString(
        '$_prefix$kind',
        jsonEncode([for (final i in fresh) i.toJson()]),
      );
    } on Object catch (error) {
      _offline = true;
      _loaded.add(kind);
      debugPrint('Content not loaded: ${error.runtimeType}');
    }
    notifyListeners();
  }
}
