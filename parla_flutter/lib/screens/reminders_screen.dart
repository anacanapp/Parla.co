import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../habits/habit_sheets.dart';
import '../home/widgets/home_cards.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../reminders/reminder_settings.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/common.dart';
import '../ui/parla_icons.dart';

/// Formats [minutes] after midnight as a time in the user's convention.
String formatReminderTime(BuildContext context, int minutes) =>
    MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );

/// Reminder settings (part of M-26): three daily reminders, all off until
/// the user turns them on. Permission is asked on the first switch.
class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool _attached = false;
  bool _busy = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_attached) {
      _attached = true;
      ParlaScope.of(context).attachAccount();
    }
  }

  String _title(AppLocalizations l10n, ReminderKind kind) => switch (kind) {
    ReminderKind.morningRoutine => l10n.reminderMorningTitle,
    ReminderKind.eveningRoutine => l10n.reminderEveningTitle,
    ReminderKind.sleepLog => l10n.reminderSleepTitle,
  };

  ParlaIconName _icon(ReminderKind kind) => switch (kind) {
    ReminderKind.morningRoutine => ParlaIconName.sun,
    ReminderKind.eveningRoutine => ParlaIconName.moon,
    ReminderKind.sleepLog => ParlaIconName.routine,
  };

  Future<void> _toggle(ReminderKind kind, bool enabled) async {
    final scope = ParlaScope.of(context);
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    final ok = await scope.reminders.setEnabled(kind, enabled);
    if (!mounted) return;
    setState(() => _busy = false);
    if (!ok) showMessage(context, l10n.reminderPermissionDenied);
  }

  Future<void> _changeTime(ReminderKind kind) async {
    final scope = ParlaScope.of(context);
    final l10n = AppLocalizations.of(context);
    final result = await showStepperSheet(
      context,
      title: l10n.reminderTimeSheetTitle,
      icon: _icon(kind),
      initial: scope.reminders.settings[kind].minutes.toDouble(),
      step: 15,
      max: 24 * 60 - 15,
      format: (v) => formatReminderTime(context, v.round()),
    );
    if (result == null) return;
    await scope.reminders.setTime(kind, result.value.round());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final reminders = ParlaScope.of(context).reminders;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ParlaColors.cream,
        leading: BackButton(onPressed: () => context.go(Routes.habits)),
      ),
      body: ListenableBuilder(
        listenable: reminders,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          children: [
            Semantics(
              header: true,
              child: Text(l10n.remindersTitle, style: text.headlineMedium),
            ),
            const SizedBox(height: 8),
            Text(l10n.remindersIntro, style: text.bodyLarge),
            const SizedBox(height: 24),
            for (final kind in ReminderKind.values) ...[
              _ReminderCard(
                key: ValueKey('reminder-${kind.name}'),
                icon: _icon(kind),
                title: _title(l10n, kind),
                time: l10n.reminderAt(
                  formatReminderTime(
                    context,
                    reminders.settings[kind].minutes,
                  ),
                ),
                enabled: reminders.settings[kind].enabled,
                onToggle: _busy ? null : (on) => _toggle(kind, on),
                onChangeTime: () => _changeTime(kind),
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 12),
            Text(
              l10n.remindersNote,
              style: text.bodyMedium?.copyWith(color: ParlaColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({
    super.key,
    required this.icon,
    required this.title,
    required this.time,
    required this.enabled,
    required this.onToggle,
    required this.onChangeTime,
  });

  final ParlaIconName icon;
  final String title;
  final String time;
  final bool enabled;
  final ValueChanged<bool>? onToggle;
  final VoidCallback onChangeTime;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return SoftCard(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: ParlaIcon(icon, size: 28),
            title: Text(title, style: text.titleMedium),
            subtitle: Text(time, style: text.bodyMedium),
            value: enabled,
            onChanged: onToggle,
          ),
          TextButton(
            onPressed: onChangeTime,
            child: Text(
              l10n.reminderChangeTime,
              semanticsLabel: '${l10n.reminderChangeTime}: $title',
            ),
          ),
        ],
      ),
    );
  }
}
