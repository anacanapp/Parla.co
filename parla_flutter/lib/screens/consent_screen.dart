import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../services/parla_api.dart';
import '../ui/common.dart';

/// M-08: three separate consents, all off by default (checklist CON-1).
///
/// The full text shown is the exact text whose version and hash the server
/// records, taken from parla_shared in the current language.
class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  final Map<ConsentKind, bool> _granted = {
    for (final kind in ConsentKind.values) kind: false,
  };
  bool _busy = false;

  String _title(AppLocalizations l10n, ConsentKind kind) => switch (kind) {
    ConsentKind.health => l10n.consentHealthTitle,
    ConsentKind.analytics => l10n.consentAnalyticsTitle,
    ConsentKind.marketing => l10n.consentMarketingTitle,
  };

  Future<void> _finish() async {
    final scope = ParlaScope.of(context);
    final l10n = AppLocalizations.of(context);
    final onboarding = scope.onboarding;
    final language = scope.settings.language ?? defaultLanguage;
    if (onboarding.birthYear == null || onboarding.countryCode == null) {
      context.go(Routes.age);
      return;
    }

    setState(() => _busy = true);
    try {
      try {
        await scope.api.createProfile(
          birthYear: onboarding.birthYear!,
          birthdayPassedThisYear: onboarding.birthdayPassedThisYear,
          countryCode: onboarding.countryCode!,
          language: language,
        );
      } on ApiError catch (e) {
        // A retry after a failed consent call: the profile is already there.
        if (e.code != 'profile.exists') rethrow;
      }
      for (final kind in ConsentKind.values) {
        if (_granted[kind] != true) continue;
        await scope.api.decideConsent(
          kind: kind,
          granted: true,
          textVersion: currentConsentText(kind).version,
          language: language,
        );
      }
      onboarding.clear();
      if (mounted) context.go(Routes.home);
    } on Object catch (error) {
      if (mounted) showError(context, errorMessage(l10n, error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final language =
        ParlaScope.of(context).settings.language ?? defaultLanguage;
    return ParlaPage(
      title: l10n.consentTitle,
      primaryLabel: l10n.continueButton,
      onPrimary: _finish,
      busy: _busy,
      children: [
        Text(l10n.consentIntro),
        const SizedBox(height: 16),
        for (final kind in ConsentKind.values)
          _ConsentCard(
            key: ValueKey('consent-${kind.name}'),
            title: _title(l10n, kind),
            hint: kind == ConsentKind.health ? l10n.consentHealthHint : null,
            text: currentConsentText(kind),
            language: language,
            granted: _granted[kind]!,
            onChanged: (value) => setState(() => _granted[kind] = value),
          ),
      ],
    );
  }
}

class _ConsentCard extends StatelessWidget {
  const _ConsentCard({
    super.key,
    required this.title,
    required this.hint,
    required this.text,
    required this.language,
    required this.granted,
    required this.onChanged,
  });

  final String title;
  final String? hint;
  final ConsentText text;
  final String language;
  final bool granted;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final small = Theme.of(context).textTheme.bodySmall;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: Text(title),
            subtitle: hint == null ? null : Text(hint!),
            value: granted,
            onChanged: onChanged,
          ),
          ExpansionTile(
            title: Text(l10n.consentVersion(text.version), style: small),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [Text(text.bodyFor(language) ?? '')],
          ),
        ],
      ),
    );
  }
}
