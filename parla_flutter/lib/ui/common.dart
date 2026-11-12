import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/parla_api.dart';

/// Shared page layout: a scrollable body with a primary action at the bottom.
class ParlaPage extends StatelessWidget {
  const ParlaPage({
    super.key,
    required this.title,
    required this.children,
    this.primaryLabel,
    this.onPrimary,
    this.secondary = const [],
    this.busy = false,
  });

  final String title;
  final List<Widget> children;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final List<Widget> secondary;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                children: [
                  Text(title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  ...children,
                ],
              ),
            ),
            if (primaryLabel != null || secondary.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (primaryLabel != null)
                      FilledButton(
                        onPressed: busy ? null : onPrimary,
                        child: busy
                            ? const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(primaryLabel!),
                      ),
                    ...secondary,
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Translates an [ApiError] code into a message for the user.
String errorMessage(AppLocalizations l10n, Object error) {
  if (error is! ApiError) return l10n.errorGeneric;
  return switch (error.code) {
    'age.minor' => l10n.error_age_minor,
    'age.needs_confirmation' => l10n.error_age_needs_confirmation,
    'age.invalid' => l10n.error_age_invalid,
    'country.closed' => l10n.error_country_closed,
    'language.unsupported' => l10n.error_language_unsupported,
    'profile.exists' => l10n.error_profile_exists,
    'consent.outdated_version' => l10n.error_consent_outdated_version,
    'consent.health_required' => l10n.error_consent_health_required,
    _ => l10n.errorGeneric,
  };
}

void showError(BuildContext context, String message) =>
    showMessage(context, message);

/// Shows a short message at the bottom of the screen.
void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
