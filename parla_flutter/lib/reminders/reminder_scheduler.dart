import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'reminder_settings.dart';

/// The localized texts of one reminder notification.
typedef ReminderTexts = ({String title, String body, String channelName});

/// Schedules daily reminders on the device.
///
/// Implementations must not send anything off the device: reminders are
/// local notifications, never push messages.
abstract interface class ReminderScheduler {
  /// Whether reminders work on this platform (Android and iOS only).
  bool get supported;

  /// Asks the system for permission to show notifications.
  Future<bool> requestPermission();

  /// Schedules [kind] every day at [hour]:[minute], replacing an earlier one.
  Future<void> scheduleDaily(
    ReminderKind kind,
    int hour,
    int minute,
    ReminderTexts texts,
  );

  Future<void> cancel(ReminderKind kind);

  Future<void> cancelAll();
}

/// The next [hour]:[minute] strictly after [now], in [now]'s time zone.
tz.TZDateTime nextInstance(tz.TZDateTime now, int hour, int minute) {
  var next = tz.TZDateTime(
    now.location,
    now.year,
    now.month,
    now.day,
    hour,
    minute,
  );
  if (!next.isAfter(now)) {
    next = tz.TZDateTime(
      now.location,
      now.year,
      now.month,
      now.day + 1,
      hour,
      minute,
    );
  }
  return next;
}

/// [ReminderScheduler] backed by flutter_local_notifications.
class LocalReminderScheduler implements ReminderScheduler {
  LocalReminderScheduler([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _ready;

  @override
  bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> _init() => _ready ??= () async {
    tz_data.initializeTimeZones();
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } on Object {
      // Unknown zone name: keep UTC rather than not reminding at all.
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        // Permission is asked only when the user turns a reminder on.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }();

  @override
  Future<bool> requestPermission() async {
    await _init();
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission() ??
          false;
    }
    return await _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, sound: true) ??
        false;
  }

  @override
  Future<void> scheduleDaily(
    ReminderKind kind,
    int hour,
    int minute,
    ReminderTexts texts,
  ) async {
    await _init();
    await _plugin.zonedSchedule(
      id: kind.notificationId,
      scheduledDate: nextInstance(tz.TZDateTime.now(tz.local), hour, minute),
      title: texts.title,
      body: texts.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'reminders',
          texts.channelName,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      // Inexact: no exact-alarm permission, a few minutes late is fine.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> cancel(ReminderKind kind) async {
    await _init();
    await _plugin.cancel(id: kind.notificationId);
  }

  @override
  Future<void> cancelAll() async {
    await _init();
    for (final kind in ReminderKind.values) {
      await _plugin.cancel(id: kind.notificationId);
    }
  }
}
