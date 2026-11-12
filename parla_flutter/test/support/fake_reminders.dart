import 'package:parla/reminders/reminder_scheduler.dart';
import 'package:parla/reminders/reminder_settings.dart';

/// Records what would be scheduled on the device.
class FakeReminderScheduler implements ReminderScheduler {
  FakeReminderScheduler({this.permission = true});

  bool permission;
  int permissionRequests = 0;

  /// Scheduled reminders: kind to (hour, minute, body).
  final scheduled = <ReminderKind, (int, int, String)>{};

  @override
  bool get supported => true;

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return permission;
  }

  @override
  Future<void> scheduleDaily(
    ReminderKind kind,
    int hour,
    int minute,
    ReminderTexts texts,
  ) async => scheduled[kind] = (hour, minute, texts.body);

  @override
  Future<void> cancel(ReminderKind kind) async => scheduled.remove(kind);

  @override
  Future<void> cancelAll() async => scheduled.clear();
}
