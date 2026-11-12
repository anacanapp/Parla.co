import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../home/widgets/home_cards.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/brand.dart';
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
    await ParlaScope.of(context).api.signOut();
    if (mounted) context.go(Routes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final consents = _consents;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ParlaColors.cream,
        leading: BackButton(onPressed: () => context.go(Routes.home)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          Semantics(
            header: true,
            child: Text(l10n.privacyTitle, style: text.headlineMedium),
          ),
          const SizedBox(height: 8),
          Text(l10n.privacyIntro, style: text.bodyLarge),
          const SizedBox(height: 24),
          Text(l10n.privacyConsentsTitle, style: text.headlineSmall),
          const SizedBox(height: 12),
          SoftCard(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: consents == null
                ? const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Column(
                    children: [
                      for (final kind in ConsentKind.values)
                        SwitchListTile(
                          key: ValueKey('consent-switch-${kind.name}'),
                          title: Text(_title(l10n, kind)),
                          value: consents[kind] ?? false,
                          onChanged: _busy
                              ? null
                              : (value) => _change(kind, value),
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: 24),
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.privacyExportTitle, style: text.titleLarge),
                const SizedBox(height: 6),
                Text(l10n.privacyExportBody, style: text.bodyMedium),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: _busy ? null : _export,
                  child: Text(l10n.privacyExportButton),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _LinkTile(
            label: l10n.privacyLegalTitle,
            onTap: () => context.go(Routes.legal),
          ),
          _LinkTile(label: l10n.privacySignOut, onTap: _signOut),
          _LinkTile(
            label: l10n.privacyDeleteTitle,
            onTap: () => context.go(Routes.deleteAccount),
          ),
        ],
      ),
    );
  }
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
    final json = await scope.api.exportMyData();
    await scope.shareExport(json);
  } on Object catch (error) {
    if (context.mounted) showError(context, errorMessage(l10n, error));
  } finally {
    setBusy(false);
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
    minVerticalPadding: 14,
    title: Text(label, style: Theme.of(context).textTheme.titleMedium),
    trailing: const Icon(Icons.chevron_right, color: ParlaColors.espresso),
    onTap: onTap,
  );
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
        backgroundColor: ParlaColors.cream,
        leading: BackButton(onPressed: () => context.go(Routes.privacy)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          Semantics(
            header: true,
            child: Text(l10n.legalTitle, style: text.headlineMedium),
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
            SoftCard(
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
      await scope.api.deleteAccount();
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
        backgroundColor: ParlaColors.cream,
        leading: BackButton(onPressed: () => context.go(Routes.privacy)),
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
