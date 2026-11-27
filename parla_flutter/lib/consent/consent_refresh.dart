import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../home/widgets/home_cards.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/common.dart';

/// Whether [granted] is an older health consent text than the current one.
bool healthConsentOutdated(String? granted) =>
    granted != null &&
    granted != currentConsentText(ConsentKind.health).version;

/// On Today: shown when the user agreed to an older health consent text
/// (CON-3). Nothing changes until the user agrees on the next screen.
class ConsentRefreshCard extends StatefulWidget {
  const ConsentRefreshCard({super.key});

  @override
  State<ConsentRefreshCard> createState() => _ConsentRefreshCardState();
}

class _ConsentRefreshCardState extends State<ConsentRefreshCard> {
  bool _show = false;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    ParlaScope.of(context).api.grantedHealthVersion().then(
      (v) {
        if (mounted) setState(() => _show = healthConsentOutdated(v));
      },
      onError: (Object _) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_show) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SoftCard(
        key: const ValueKey('consent-refresh-card'),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.consentRefreshCardTitle, style: text.titleMedium),
            const SizedBox(height: 4),
            Text(l10n.consentRefreshCardBody, style: text.bodyMedium),
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton(
                key: const ValueKey('consent-refresh-open'),
                onPressed: () => context.go(Routes.consentRefresh),
                child: Text(l10n.consentRefreshOpen),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The current health consent text with "I agree" and "Not now".
class ConsentRefreshScreen extends StatefulWidget {
  const ConsentRefreshScreen({super.key});

  @override
  State<ConsentRefreshScreen> createState() => _ConsentRefreshScreenState();
}

class _ConsentRefreshScreenState extends State<ConsentRefreshScreen> {
  bool _busy = false;

  Future<void> _agree() async {
    final scope = ParlaScope.of(context);
    final l10n = AppLocalizations.of(context);
    final language = scope.settings.contentLanguage;
    setState(() => _busy = true);
    try {
      await scope.api.decideConsent(
        kind: ConsentKind.health,
        granted: true,
        textVersion: currentConsentText(ConsentKind.health).version,
        language: language,
      );
      // Data kept on the phone until now is sent (encrypted).
      await scope.resyncDocuments();
      if (!mounted) return;
      showMessage(context, l10n.consentRefreshDone);
      context.go(Routes.home);
    } on Object catch (error) {
      if (mounted) showError(context, errorMessage(l10n, error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final language = ParlaScope.of(context).settings.contentLanguage;
    return ParlaPage(
      title: l10n.consentRefreshTitle,
      onBack: () => context.go(Routes.home),
      primaryLabel: l10n.consentRefreshAgree,
      onPrimary: _agree,
      busy: _busy,
      secondary: [
        TextButton(
          key: const ValueKey('consent-refresh-later'),
          onPressed: () => context.go(Routes.home),
          child: Text(l10n.consentRefreshLater),
        ),
      ],
      children: [
        Text(l10n.consentRefreshIntro),
        const SizedBox(height: 16),
        SoftCard(
          padding: const EdgeInsets.all(16),
          child: Text(
            currentConsentText(ConsentKind.health).bodyFor(language) ?? '',
            key: const ValueKey('consent-refresh-text'),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          currentConsentText(ConsentKind.health).version,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: ParlaColors.muted),
        ),
      ],
    );
  }
}
