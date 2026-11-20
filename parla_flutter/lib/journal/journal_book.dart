import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../habits/habit_store.dart';

/// Limits of the journal, so it fits the platform's secure storage.
abstract final class JournalRules {
  static const format = 1;

  /// Longest entry, in characters.
  static const maxLength = 4000;

  /// Most entries kept; the user deletes old ones to add more.
  static const maxEntries = 1500;
}

/// One journal entry: free text written on a day.
@immutable
class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.text,
  });

  factory JournalEntry.fromJson(Map<String, Object?> json) => JournalEntry(
    id: json['id']! as String,
    createdAt: DateTime.parse(json['createdAt']! as String),
    updatedAt: DateTime.parse(json['updatedAt']! as String),
    text: json['text']! as String,
  );

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String text;

  Map<String, Object?> toJson() => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'text': text,
  };
}

/// The private journal of the signed-in account.
///
/// Kept only on this phone, in the platform's encrypted storage (iOS
/// Keychain, Android Keystore), one entry per account. Unlike the other
/// documents it is never sent to the server, not even with the health
/// consent: the Parla team cannot read it (owner's decision, 2026-11-20).
/// It is lost with the phone or when the app is removed; the data export
/// holds a copy the user can keep.
class JournalBook extends ChangeNotifier {
  JournalBook({required this._store, DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final HabitStore _store;
  final DateTime Function() _clock;
  final _random = Random.secure();

  String? _accountId;
  List<JournalEntry> _entries = [];
  bool _loaded = false;

  /// Whether the signed-in account's entries are loaded.
  bool get loaded => _loaded;

  /// Newest first.
  List<JournalEntry> get entries => List.unmodifiable(_entries);

  JournalEntry? find(String id) =>
      _entries.where((e) => e.id == id).firstOrNull;

  Future<void> attach(String? accountId) async {
    if (accountId == _accountId && accountId != null && _loaded) return;
    _accountId = accountId;
    _entries = [];
    _loaded = false;
    if (accountId != null) {
      try {
        final raw = await _store.read(accountId);
        if (raw != null && _accountId == accountId) _load(raw);
      } on Object {
        // Unreadable storage: start empty rather than fail the app.
      }
    }
    _loaded = accountId != null;
    notifyListeners();
  }

  void detach() {
    _accountId = null;
    _entries = [];
    _loaded = false;
    notifyListeners();
  }

  /// Deletes every entry of the signed-in account from this phone.
  Future<void> erase() async {
    final id = _accountId;
    _entries = [];
    if (id != null) await _store.delete(id);
    notifyListeners();
  }

  /// Adds an entry, or changes [id]'s text. Blank text deletes [id].
  /// Returns `false` when the journal is full.
  Future<bool> save({String? id, required String text}) async {
    final trimmed = text.trim();
    final clipped = trimmed.length > JournalRules.maxLength
        ? trimmed.substring(0, JournalRules.maxLength)
        : trimmed;
    final now = _clock();
    if (id != null) {
      final i = _entries.indexWhere((e) => e.id == id);
      if (i >= 0) {
        if (clipped.isEmpty) return delete(id).then((_) => true);
        final old = _entries[i];
        _entries[i] = JournalEntry(
          id: old.id,
          createdAt: old.createdAt,
          updatedAt: now,
          text: clipped,
        );
        await _write();
        return true;
      }
    }
    if (clipped.isEmpty) return true;
    if (_entries.length >= JournalRules.maxEntries) return false;
    _entries.insert(
      0,
      JournalEntry(
        id: _newId(),
        createdAt: now,
        updatedAt: now,
        text: clipped,
      ),
    );
    await _write();
    return true;
  }

  Future<void> delete(String id) async {
    _entries.removeWhere((e) => e.id == id);
    await _write();
  }

  /// For the user's data export.
  Map<String, Object?> exportJson() => {
    'format': JournalRules.format,
    'entries': [for (final e in _entries) e.toJson()],
  };

  void _load(String raw) {
    final json = jsonDecode(raw) as Map<String, Object?>;
    _entries = [
      for (final e in (json['entries'] as List? ?? const []))
        JournalEntry.fromJson((e as Map).cast<String, Object?>()),
    ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> _write() async {
    notifyListeners();
    final id = _accountId;
    if (id == null) return;
    await _store.write(id, jsonEncode(exportJson()));
  }

  String _newId() => List.generate(
    12,
    (_) => _random.nextInt(256),
  ).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}
