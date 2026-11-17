import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../habits/habit_store.dart';
import '../services/parla_api.dart';

/// One JSON document per account that the server keeps encrypted when the
/// user's health consent covers it, with an encrypted copy on this phone
/// for offline use.
///
/// - On attach the phone copy loads first. With the consent, local changes
///   the server has not got yet (or a first upload) go up, otherwise the
///   server's copy comes down.
/// - Every change is written to the phone and then sent; when sending
///   fails (offline, no covering consent) it is sent on the next start.
/// - `pendingUpload` is a local-only flag and never sent.
abstract class SyncedDocument extends ChangeNotifier {
  SyncedDocument({required this._store, this._api});

  final HabitStore _store;
  final ParlaApi? _api;
  String? _accountId;
  bool _pending = false;
  bool _synced = false;
  bool _pushing = false;
  bool _pushAgain = false;

  /// The stored format version.
  int get format;

  /// The account this document belongs to, or `null`.
  String? get accountId => _accountId;

  /// Whether the server keeps this document for the account.
  bool get isSynced => _synced;

  /// Fetches the server copy, `null` when none or not covered.
  Future<String?> fetchRemote(ParlaApi api);

  /// Replaces the server copy.
  Future<void> sendRemote(ParlaApi api, String json);

  /// Replaces the content with [json] (already the right format).
  void load(Map<String, Object?> json);

  /// The content in the stored format (also the data export).
  Map<String, Object?> exportJson();

  /// Empties the content.
  void clearContent();

  /// Whether there is anything worth uploading.
  bool get hasContent;

  Future<void> attach(String? accountId) async {
    if (accountId == _accountId && accountId != null) return;
    _accountId = accountId;
    _reset();
    if (accountId != null) {
      try {
        final raw = await _store.read(accountId);
        if (raw != null && _accountId == accountId) {
          final json = jsonDecode(raw) as Map<String, Object?>;
          if (json['format'] == format) {
            load(json);
            _pending = json['pendingUpload'] == true;
          }
        }
      } on Object {
        _reset(); // Unreadable data is treated as empty.
      }
    }
    notifyListeners();
    if (accountId != null) await _sync(accountId);
  }

  /// Syncs again, for example after the user agreed to the current health
  /// consent text (pending local changes are sent then).
  Future<void> resync() async {
    final id = _accountId;
    if (id != null) await _sync(id);
  }

  void detach() {
    _accountId = null;
    _reset();
    notifyListeners();
  }

  /// Deletes the phone copy. The server deletes its copy with the account
  /// or the health consent.
  Future<void> erase() async {
    final id = _accountId;
    _reset();
    notifyListeners();
    if (id != null) await _store.delete(id);
  }

  /// Call after every change: notifies, writes the phone copy and sends.
  @protected
  Future<void> changed() async {
    if (_accountId == null) {
      notifyListeners();
      return;
    }
    _pending = true;
    notifyListeners();
    await _writeLocal();
    await _push();
  }

  void _reset() {
    clearContent();
    _pending = false;
    _synced = false;
  }

  Future<void> _sync(String accountId) async {
    final api = _api;
    if (api == null) return;
    try {
      if (!await api.hasHealthConsent()) return;
      final remote = await fetchRemote(api);
      if (_accountId != accountId) return;
      _synced = true;
      if (_pending || (remote == null && hasContent)) {
        await _push();
      } else if (remote != null) {
        final json = jsonDecode(remote) as Map<String, Object?>;
        if (json['format'] != format) return;
        load(json);
        notifyListeners();
        await _writeLocal();
      }
    } on Object catch (error) {
      debugPrint('$runtimeType not synced: ${error.runtimeType}');
    }
  }

  /// Sends the current state; one request at a time, the last state wins.
  Future<void> _push() async {
    final api = _api;
    final id = _accountId;
    if (api == null || id == null || !_synced) return;
    if (_pushing) {
      _pushAgain = true;
      return;
    }
    _pushing = true;
    try {
      do {
        _pushAgain = false;
        await sendRemote(api, jsonEncode(exportJson()));
      } while (_pushAgain && _accountId == id);
      if (_accountId == id) {
        _pending = false;
        await _writeLocal();
      }
    } on Object catch (error) {
      debugPrint('$runtimeType not sent: ${error.runtimeType}');
    } finally {
      _pushing = false;
    }
  }

  Future<void> _writeLocal() async {
    final id = _accountId;
    if (id == null) return;
    try {
      await _store.write(
        id,
        jsonEncode({...exportJson(), 'pendingUpload': _pending}),
      );
    } on Object catch (error) {
      debugPrint('$runtimeType not saved: ${error.runtimeType}');
    }
  }
}
