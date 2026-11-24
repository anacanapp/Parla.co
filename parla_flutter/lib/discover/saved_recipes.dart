import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The recipes the signed-in account saved (owner 2026-11-24). Only the
/// recipes' slugs, kept on this phone per account; never sent. Part of the
/// data download and erased with the account.
class SavedRecipes extends ChangeNotifier {
  SavedRecipes({Future<SharedPreferences> Function()? prefs})
    : _prefs = prefs ?? SharedPreferences.getInstance;

  final Future<SharedPreferences> Function() _prefs;
  String? _account;
  final List<String> _slugs = [];

  /// At most this many are kept.
  static const max = 200;

  static String _key(String account) => 'savedRecipes:$account';

  List<String> get slugs => List.unmodifiable(_slugs);

  bool contains(String slug) => _slugs.contains(slug);

  Future<void> attach(String? account) async {
    _account = account;
    _slugs.clear();
    if (account != null) {
      final saved = (await _prefs()).getStringList(_key(account));
      if (_account == account && saved != null) _slugs.addAll(saved);
    }
    notifyListeners();
  }

  void detach() {
    _account = null;
    _slugs.clear();
    notifyListeners();
  }

  /// Saves [slug], or removes it when it is already saved.
  Future<void> toggle(String slug) async {
    final account = _account;
    if (account == null) return;
    if (!_slugs.remove(slug)) {
      _slugs.insert(0, slug);
      if (_slugs.length > max) _slugs.removeLast();
    }
    notifyListeners();
    await (await _prefs()).setStringList(_key(account), _slugs);
  }

  List<String> exportJson() => slugs;

  Future<void> erase() async {
    final account = _account;
    _slugs.clear();
    notifyListeners();
    if (account != null) await (await _prefs()).remove(_key(account));
  }
}
