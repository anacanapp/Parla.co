import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import 'reminder_scheduler.dart';
import 'reminder_settings.dart';

/// Reminder settings of the signed-in account and their scheduled
/// notifications on this device.
///
/// Settings are kept per account in the app preferences (times only, no
/// health data). Signing out cancels the notifications; signing in again
/// with the same account schedules them again.
class ReminderController extends ChangeNotifier {
  ReminderController({
    required this._scheduler,
    required this._language,
  });

  final ReminderScheduler _scheduler;

  /// The interface language, for the notification texts.
  final String Function() _language;

  ReminderSettings _settings = ReminderSettings();
  String? _accountId;
  bool _attached = false;

  bool get supported => _scheduler.supported;
  ReminderSettings get settings => _settings;

  static String _key(String accountId) => 'reminders.v1.$accountId';

  /// Loads [accountId]'s settings and schedules its enabled reminders.
  /// `null` (no account) cancels everything.
  Future<void> attach(String? accountId) async {
    if (_attached && accountId == _accountId) return;
    _accountId = accountId;
    _attached = true;
    _settings = ReminderSettings();
    if (accountId != null) {
      final prefs = await SharedPreferences.getInstance();
      if (_accountId != accountId) return; // Switched while reading.
      final raw = prefs.getString(_key(accountId));
      try {
        _settings = ReminderSettings.decode(
          raw == null ? null : jsonDecode(raw) as Map<String, Object?>,
        );
      } on Object {
        _settings = ReminderSettings();
      }
    }
    notifyListeners();
    await _reschedule();
  }

  /// Sign-out: cancels the notifications, keeps the settings.
  Future<void> detach() async {
    _accountId = null;
    _attached = false;
    _settings = ReminderSettings();
    notifyListeners();
    await _safely(_scheduler.cancelAll);
  }

  /// Account deletion: cancels the notifications and deletes the settings.
  Future<void> erase() async {
    final id = _accountId;
    await detach();
    if (id != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key(id));
    }
  }

  /// Turns [kind] on or off. Returns `false` when turning on failed because
  /// the system permission was refused; the reminder then stays off.
  Future<bool> setEnabled(ReminderKind kind, bool enabled) async {
    if (enabled && !await _safely(_scheduler.requestPermission, false)) {
      return false;
    }
    await _update(kind, _settings[kind].copyWith(enabled: enabled));
    return true;
  }

  /// Changes the time of [kind], in minutes after midnight.
  Future<void> setTime(ReminderKind kind, int minutes) =>
      _update(kind, _settings[kind].copyWith(minutes: minutes));

  /// Schedules again with the current language, e.g. after it changed.
  Future<void> refreshTexts() => _reschedule();

  Future<void> _update(ReminderKind kind, Reminder reminder) async {
    _settings = ReminderSettings({..._settings.reminders, kind: reminder});
    notifyListeners();
    final id = _accountId;
    if (id != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key(id), jsonEncode(_settings.toJson()));
    }
    await _apply(kind);
  }

  Future<void> _reschedule() async {
    for (final kind in ReminderKind.values) {
      await _apply(kind);
    }
  }

  Future<void> _apply(ReminderKind kind) async {
    if (!_scheduler.supported) return;
    final reminder = _settings[kind];
    if (!reminder.enabled || _accountId == null) {
      await _safely(() => _scheduler.cancel(kind));
      return;
    }
    await _safely(
      () => _scheduler.scheduleDaily(
        kind,
        reminder.hour,
        reminder.minute,
        _texts(kind),
      ),
    );
  }

  /// Neutral texts only: they show on the lock screen, so they never
  /// mention skin conditions or other health information.
  ReminderTexts _texts(ReminderKind kind) {
    final l10n = lookupAppLocalizations(Locale(_language()));
    return (
      title: l10n.appTitle,
      body: switch (kind) {
        ReminderKind.morningRoutine => l10n.reminderMorningBody,
        ReminderKind.eveningRoutine => l10n.reminderEveningBody,
        ReminderKind.sleepLog => l10n.reminderSleepBody,
      },
      channelName: l10n.remindersTitle,
    );
  }

  Future<T> _safely<T>(Future<T> Function() call, [T? fallback]) async {
    try {
      return await call();
    } on Object catch (error) {
      // A failing platform plugin must not break the app.
      debugPrint('Reminder call failed: ${error.runtimeType}');
      return fallback as T;
    }
  }
}
