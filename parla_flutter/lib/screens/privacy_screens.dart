import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../check/glass_bits.dart';
import '../push/push_client.dart';
import '../reminders/reminder_settings.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../home/widgets/parla_nav_bar.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/warm.dart';
import '../ui/parla_icons.dart';
import '../ui/parla_ui.dart';
import '../ui/common.dart';

/// M-25/M-27/M-28: profile and privacy centre. Every right is reachable in
/// one or two taps (checklist CON-5, DEL-1, EXP-1).
class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  Map<ConsentKind, bool>? _consents;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final l10n = AppLocalizations.of(context);
    try {
      final states = await ParlaScope.of(context).api.consentStates();
      if (mounted) setState(() => _consents = states);
    } on Object catch (error) {
      if (mounted) showError(context, errorMessage(l10n, error));
    }
  }

  String _title(AppLocalizations l10n, ConsentKind kind) => switch (kind) {
    ConsentKind.health => l10n.consentHealthTitle,
    ConsentKind.analytics => l10n.consentAnalyticsTitle,
    ConsentKind.marketing => l10n.consentMarketingTitle,
  };

  Future<void> _change(ConsentKind kind, bool granted) async {
    final scope = ParlaScope.of(context);
    final l10n = AppLocalizations.of(context);
    if (kind == ConsentKind.health && !granted) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.privacyHealthWithdrawTitle),
          content: Text(l10n.privacyHealthWithdrawBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.privacyCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.privacyWithdraw),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    setState(() => _busy = true);
    try {
      await scope.api.decideConsent(
        kind: kind,
        granted: granted,
        textVersion: currentConsentText(kind).version,
        language: scope.settings.language ?? defaultLanguage,
      );
      if (kind == ConsentKind.analytics) scope.usage.setEnabled(granted);
      if (mounted) setState(() => _consents = {..._consents!, kind: granted});
    } on Object catch (error) {
      if (mounted) showError(context, errorMessage(l10n, error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _export() => exportAndShare(context, (busy) {
    if (mounted) setState(() => _busy = busy);
  });

  Future<void> _signOut() async {
    final scope = ParlaScope.of(context);
    // This phone stops getting the account's notifications.
    final token = await PushPrefs.token();
    if (token != null) {
      try {
        await scope.api.unregisterPush(token);
      } on Object {
        // Offline: the token expires on the server after 90 days unseen.
      }
      await PushPrefs.setToken(null);
    }
    await scope.api.signOut();
    // Habit entries and reminder settings stay on the device under this
    // account and come back when the same account signs in again.
    await scope.detachAccount();
    if (mounted) context.go(Routes.welcome);
  }

  Future<void> _deleteHabits() async {
    final scope = ParlaScope.of(context);
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.privacyHabitsDeleteTitle),
        content: Text(l10n.privacyHabitsDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.privacyCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.privacyHabitsDelete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await scope.habits.attach(scope.api.accountId);
    await scope.habits.erase();
    if (mounted) showMessage(context, l10n.privacyHabitsDeleted);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final consents = _consents;
    final reminders = ParlaScope.of(context).reminders;
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const ParlaNavBar(selected: ParlaTab.profile),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 120),
          children: [
            WarmHeader(title: l10n.navProfile),
            const SizedBox(height: 14),
            // The account card: what the app keeps, and the user's rights.
            SquircleCard(
              tone: SquircleTone.rose,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const RingIcon(icon: ParlaIconName.profile, size: 56),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.privacyTitle,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.privacyIntro,
                          style: const TextStyle(
                            fontSize: kMinTextSize,
                            height: 1.35,
                            color: Warm.onCardSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ListenableBuilder(
              listenable: reminders,
              builder: (context, _) {
                final on = ReminderKind.values
                    .where((k) => reminders.settings[k].enabled)
                    .length;
                final given = consents == null
                    ? null
                    : ConsentKind.values
                          .where((k) => consents[k] ?? false)
                          .length;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: StatPill(
                        key: const ValueKey('privacy-reminders'),
                        title: l10n.remindersTitle,
                        value: '$on',
                        icon: ParlaIconName.moon,
                        height: 104,
                        semanticLabel:
                            '${l10n.remindersTitle}: '
                            '${on == 0 ? l10n.remindersSummaryOff : l10n.remindersSummaryOn(on)}',
                        onTap: () => context.push(Routes.reminders),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatPill(
                        title: l10n.privacyConsentsTitle,
                        value: given == null
                            ? '…'
                            : '$given/${ConsentKind.values.length}',
                        icon: ParlaIconName.lock,
                        tint: SmokyTint.burnt,
                        height: 104,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Semantics(
                header: true,
                child: Text(
                  l10n.privacyConsentsTitle,
                  style: text.titleLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Warm.ink,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _SmokyGroup(
              children: consents == null
                  ? const [
                      Padding(
                        padding: EdgeInsets.all(18),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                    ]
                  : [
                      for (final kind in ConsentKind.values)
                        SwitchListTile(
                          key: ValueKey('consent-switch-${kind.name}'),
                          contentPadding: const EdgeInsets.fromLTRB(
                            20,
                            4,
                            12,
                            4,
                          ),
                          activeThumbColor: Warm.black,
                          activeTrackColor: Colors.white,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: const Color(0x33FFFFFF),
                          title: Text(
                            _title(l10n, kind),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Warm.onCard,
                            ),
                          ),
                          value: consents[kind] ?? false,
                          onChanged: _busy
                              ? null
                              : (value) => _change(kind, value),
                        ),
                    ],
            ),
            const SizedBox(height: 10),
            _ActionCard(
              title: l10n.privacyExportTitle,
              body: l10n.privacyExportBody,
              button: _WhitePill(
                label: l10n.privacyExportButton,
                onPressed: _busy ? null : _export,
              ),
            ),
            const SizedBox(height: 10),
            _ActionCard(
              title: l10n.privacyHabitsTitle,
              body: l10n.privacyHabitsBody,
              button: _WhitePill(
                key: const ValueKey('delete-habits'),
                label: l10n.privacyHabitsDelete,
                onPressed: _busy ? null : _deleteHabits,
              ),
            ),
            const SizedBox(height: 10),
            _SmokyGroup(
              children: [
                _SmokyRow(
                  key: const ValueKey('privacy-legal'),
                  icon: ParlaIconName.book,
                  label: l10n.privacyLegalTitle,
                  onTap: () => context.go(Routes.legal),
                ),
                _SmokyRow(
                  key: const ValueKey('privacy-delete'),
                  icon: ParlaIconName.minus,
                  label: l10n.privacyDeleteTitle,
                  color: Glass.dangerOnSmoke,
                  onTap: () => context.go(Routes.deleteAccount),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Semantics(
              button: true,
              child: Material(
                color: Warm.black,
                shape: const StadiumBorder(),
                child: InkWell(
                  customBorder: const StadiumBorder(),
                  onTap: _signOut,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 56),
                    child: Center(
                      child: Text(
                        l10n.privacySignOut,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Rows in one smoky glass card, split by faint lines.
class _SmokyGroup extends StatelessWidget {
  const _SmokyGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SmokyGlass(
    radius: 36,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const Divider(height: 1, color: Color(0x1FFFFFFF)),
          children[i],
        ],
      ],
    ),
  );
}

/// A row of a [_SmokyGroup]: icon, label and a chevron.
class _SmokyRow extends StatelessWidget {
  const _SmokyRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Warm.onCard,
  });

  final ParlaIconName icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 58),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            ExcludeSemantics(child: ParlaIcon(icon, size: 18, color: color)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: TextStyle(fontSize: 15, color: color)),
            ),
            const ExcludeSemantics(
              child: Icon(Icons.chevron_right, color: Warm.onCardSoft),
            ),
          ],
        ),
      ),
    ),
  );
}

/// A white capsule action on smoky glass (dark text), full width.
class _WhitePill extends StatelessWidget {
  const _WhitePill({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: onPressed != null,
    child: Material(
      color: onPressed == null ? const Color(0x99FFFFFF) : Colors.white,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, color: Warm.black),
            ),
          ),
        ),
      ),
    ),
  );
}

/// A smoky glass card with a title, a line of text and one action.
class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.body,
    required this.button,
  });

  final String title;
  final String body;
  final Widget button;

  @override
  Widget build(BuildContext context) => SmokyGlass(
    radius: 36,
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: const TextStyle(fontSize: 17)),
        const SizedBox(height: 6),
        Text(
          body,
          style: const TextStyle(
            fontSize: 13,
            height: 1.4,
            color: Warm.onCardSoft,
          ),
        ),
        const SizedBox(height: 14),
        button,
      ],
    ),
  );
}

/// Exports the user's data and opens the share sheet. Shared by the privacy
/// centre and the delete screen.
Future<void> exportAndShare(
  BuildContext context,
  ValueChanged<bool> setBusy,
) async {
  final scope = ParlaScope.of(context);
  final l10n = AppLocalizations.of(context);
  setBusy(true);
  try {
    final server = await scope.api.exportMyData();
    // Habit entries live only on this device; add them so the file holds
    // everything Parla keeps about the user (data portability).
    await scope.attachAccount();
    final data = jsonDecode(server) as Map<String, Object?>;
    data['deviceHabits'] = scope.habits.exportJson();
    data['deviceReminders'] = scope.reminders.settings.toJson();
    data['deviceRoutines'] = scope.routines.exportJson();
    data['deviceCareList'] = scope.careList.exportJson();
    data['deviceSport'] = scope.sport.exportJson();
    data['deviceNutrition'] = scope.nutrition.exportJson();
    data['deviceJournal'] = scope.journal.exportJson();
    await scope.shareExport(
      const JsonEncoder.withIndent('  ').convert(data),
    );
  } on Object catch (error) {
    if (context.mounted) showError(context, errorMessage(l10n, error));
  } finally {
    setBusy(false);
  }
}

/// M-34: legal documents and the "not medical advice" statement.
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final language =
        ParlaScope.of(context).settings.language ?? defaultLanguage;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: roundBackWidth,
        leading: Padding(
          padding: const EdgeInsetsDirectional.only(start: 14),
          child: Center(
            child: GlassBack(onPressed: () => context.go(Routes.privacy)),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          Semantics(
            header: true,
            child: Text(
              l10n.legalTitle,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w200,
                letterSpacing: -1,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(l10n.legalMedicalTitle, style: text.titleLarge),
          const SizedBox(height: 6),
          Text(l10n.legalMedicalBody, style: text.bodyLarge),
          const SizedBox(height: 24),
          Text(l10n.legalPolicyTitle, style: text.titleLarge),
          const SizedBox(height: 6),
          Text(l10n.legalPolicyBody, style: text.bodyLarge),
          const SizedBox(height: 24),
          Text(l10n.legalConsentsTitle, style: text.titleLarge),
          for (final kind in ConsentKind.values) ...[
            const SizedBox(height: 12),
            GlassCard(
              radius: 28,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.consentVersion(currentConsentText(kind).version),
                    style: text.labelMedium?.copyWith(
                      color: ParlaColors.sunInk,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    currentConsentText(kind).bodyFor(language) ?? '',
                    style: text.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// M-32: delete the account after typing the confirmation word.
class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _confirm = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _confirm.dispose();
    super.dispose();
  }

  /// Case-insensitive match that treats Azerbaijani İ/ı correctly.
  static String _fold(String s) =>
      s.trim().replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase();

  Future<void> _delete() async {
    final scope = ParlaScope.of(context);
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      // Load first so the right account's entries are known, then delete
      // the device entries only once the server deletion succeeded.
      await scope.attachAccount();
      await scope.api.deleteAccount();
      await scope.eraseAccountData();
      scope.onboarding.clear();
      if (mounted) context.go(Routes.accountDeleted);
    } on Object catch (error) {
      if (mounted) showError(context, errorMessage(l10n, error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final word = l10n.deleteConfirmWord;
    final matches = _fold(_confirm.text) == _fold(word);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: roundBackWidth,
        leading: Padding(
          padding: const EdgeInsetsDirectional.only(start: 14),
          child: Center(
            child: GlassBack(onPressed: () => context.go(Routes.privacy)),
          ),
        ),
      ),
      body: ParlaPage(
        title: l10n.deleteTitle,
        primaryLabel: l10n.deleteButton,
        onPrimary: matches ? _delete : null,
        busy: _busy,
        children: [
          Text(l10n.deleteWhatGoes),
          const SizedBox(height: 12),
          Text(
            l10n.deleteWhatStays,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: ParlaColors.muted),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: _busy
                ? null
                : () => exportAndShare(context, (busy) {
                    if (mounted) setState(() => _busy = busy);
                  }),
            child: Text(l10n.deleteExportFirst),
          ),
          const SizedBox(height: 24),
          TextField(
            key: const ValueKey('delete-confirm'),
            controller: _confirm,
            decoration: InputDecoration(
              labelText: l10n.deleteConfirmLabel(word),
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }
}

/// M-33: confirmation after deletion.
class AccountDeletedScreen extends StatelessWidget {
  const AccountDeletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ParlaPage(
      title: l10n.deletedTitle,
      primaryLabel: l10n.close,
      onPrimary: () => context.go(Routes.welcome),
      children: [Text(l10n.deletedBody)],
    );
  }
}
