/// The reminders Parla offers. All are off until the user turns one on.
enum ReminderKind {
  morningRoutine(notificationId: 101, defaultMinutes: 8 * 60),
  eveningRoutine(notificationId: 102, defaultMinutes: 21 * 60 + 30),
  sleepLog(notificationId: 103, defaultMinutes: 9 * 60);

  const ReminderKind({
    required this.notificationId,
    required this.defaultMinutes,
  });

  /// Stable id of the scheduled notification.
  final int notificationId;

  /// Suggested time, in minutes after midnight.
  final int defaultMinutes;
}

/// One reminder: on or off, and its time in minutes after midnight.
class Reminder {
  const Reminder({required this.enabled, required this.minutes});

  final bool enabled;
  final int minutes;

  int get hour => minutes ~/ 60;
  int get minute => minutes % 60;

  Reminder copyWith({bool? enabled, int? minutes}) => Reminder(
    enabled: enabled ?? this.enabled,
    minutes: minutes ?? this.minutes,
  );
}

/// Reminder settings of one account.
class ReminderSettings {
  ReminderSettings([Map<ReminderKind, Reminder>? reminders])
    : reminders = {
        for (final kind in ReminderKind.values)
          kind:
              reminders?[kind] ??
              Reminder(enabled: false, minutes: kind.defaultMinutes),
      };

  /// Parses stored settings; anything unreadable falls back to all off.
  factory ReminderSettings.decode(Map<String, Object?>? json) {
    final reminders = <ReminderKind, Reminder>{};
    for (final kind in ReminderKind.values) {
      final raw = json?[kind.name];
      if (raw is! Map) continue;
      final minutes = raw['minutes'];
      final enabled = raw['enabled'];
      if (minutes is int && minutes >= 0 && minutes < 24 * 60) {
        reminders[kind] = Reminder(enabled: enabled == true, minutes: minutes);
      }
    }
    return ReminderSettings(reminders);
  }

  final Map<ReminderKind, Reminder> reminders;

  Reminder operator [](ReminderKind kind) => reminders[kind]!;

  Map<String, Object?> toJson() => {
    for (final e in reminders.entries)
      e.key.name: {'enabled': e.value.enabled, 'minutes': e.value.minutes},
  };
}
