import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Where an account's habit log is kept on this device.
///
/// Habit data never leaves the device. Each account has its own entry, so a
/// second person signing in on a shared phone does not see the first
/// person's habits.
abstract interface class HabitStore {
  Future<String?> read(String accountId);
  Future<void> write(String accountId, String data);
  Future<void> delete(String accountId);
}

/// [HabitStore] in the platform's encrypted storage: the iOS Keychain and,
/// on Android, values encrypted with a key held in the Android Keystore.
class SecureHabitStore implements HabitStore {
  const SecureHabitStore([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;

  static const _prefix = 'parla.habits.';
  static const _installedKey = 'habitStoreInstalled';

  static String _key(String accountId) => '${_prefix}v1.$accountId';

  /// Deletes habit entries left over from an earlier installation.
  ///
  /// iOS keeps Keychain items after the app is removed, so without this a
  /// reinstall would bring old habit data back. App preferences are removed
  /// with the app, so a missing marker means a fresh installation.
  static Future<void> forgetAfterReinstall({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_installedKey) ?? false) return;
    final all = await storage.readAll();
    for (final key in all.keys.where((k) => k.startsWith(_prefix)).toList()) {
      await storage.delete(key: key);
    }
    await prefs.setBool(_installedKey, true);
  }

  @override
  Future<String?> read(String accountId) => _storage.read(key: _key(accountId));

  @override
  Future<void> write(String accountId, String data) =>
      _storage.write(key: _key(accountId), value: data);

  @override
  Future<void> delete(String accountId) =>
      _storage.delete(key: _key(accountId));
}

/// In-memory [HabitStore] for tests and for guests (nothing is kept).
class MemoryHabitStore implements HabitStore {
  final data = <String, String>{};

  @override
  Future<String?> read(String accountId) async => data[accountId];

  @override
  Future<void> write(String accountId, String value) async =>
      data[accountId] = value;

  @override
  Future<void> delete(String accountId) async => data.remove(accountId);
}
