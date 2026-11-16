import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/parla_api.dart';

/// Published articles, recipes and expert profiles. Loaded from the server
/// and kept in the app preferences, so the last copy shows offline. It is
/// public content, nothing personal.
class ContentLibrary extends ChangeNotifier {
  ContentLibrary(this._api);

  static const kinds = ['article', 'recipe', 'expert'];
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
