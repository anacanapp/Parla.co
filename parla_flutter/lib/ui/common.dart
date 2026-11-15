import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/parla_api.dart';
import 'brand.dart';
import 'parla_icons.dart';

/// Shared page layout: an optional back button and step progress, an
/// eyebrow, a title and subtitle, a scrollable body and the primary action
/// pinned at the bottom.
class ParlaPage extends StatelessWidget {
  const ParlaPage({
    super.key,
    required this.title,
    required this.children,
    this.eyebrow,
    this.subtitle,
    this.step,
    this.steps,
    this.onBack,
    this.primaryLabel,
    this.onPrimary,
    this.secondary = const [],
    this.busy = false,
  });

  final String title;
  final List<Widget> children;

  /// Short upper-case label above the title, e.g. "STEP" or "PRIVACY".
  final String? eyebrow;
  final String? subtitle;

  /// 1-based position in a flow of [steps] screens; shows a progress bar.
  final int? step;
  final int? steps;
  final VoidCallback? onBack;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final List<Widget> secondary;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final hasTopBar = onBack != null || step != null;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (hasTopBar)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 20, 0),
                child: _TopBar(onBack: onBack, step: step, steps: steps),
              ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20, hasTopBar ? 20 : 28, 20, 16),
                children: [
                  if (eyebrow != null) ...[
                    Text(
                      eyebrow!.toUpperCase(),
                      style: text.labelSmall?.copyWith(
                        color: ParlaColors.sunInk,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  Semantics(
                    header: true,
                    child: Text(title, style: text.headlineLarge),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle!,
                      style: text.bodyMedium?.copyWith(
                        color: ParlaColors.muted,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  ...children,
                ],
              ),
            ),
            if (primaryLabel != null || secondary.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                                  color: ParlaColors.white,
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

class _TopBar extends StatelessWidget {
  const _TopBar({this.onBack, this.step, this.steps});

  final VoidCallback? onBack;
  final int? step;
  final int? steps;

  @override
  Widget build(BuildContext context) {
    final back = onBack;
    final current = step;
    final total = steps;
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          if (back != null)
            Material(
              color: ParlaColors.white,
              borderRadius: BorderRadius.circular(12),
              child: IconButton(
                onPressed: back,
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                icon: const ParlaIcon(ParlaIconName.arrowLeft, size: 20),
                constraints: const BoxConstraints.tightFor(
                  width: 44,
                  height: 44,
                ),
              ),
            ),
          if (back != null) const SizedBox(width: 12),
          if (current != null && total != null) ...[
            Expanded(
              child: Semantics(
                label: '$current / $total',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: current / total,
                    minHeight: 6,
                    backgroundColor: ParlaColors.line,
                    color: ParlaColors.espresso,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ExcludeSemantics(
              child: Text(
                '$current/$total',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: ParlaColors.muted,
                ),
              ),
            ),
          ] else
            const Spacer(),
        ],
      ),
    );
  }
}

/// A white rounded card around a choice (radio, switch, checkbox), with a
/// dark outline when selected.
class ParlaOptionCard extends StatelessWidget {
  const ParlaOptionCard({
    super.key,
    required this.child,
    this.selected = false,
  });

  final Widget child;
  final bool selected;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: ParlaColors.white,
        borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
        border: Border.all(
          color: selected ? ParlaColors.espresso : Colors.transparent,
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(type: MaterialType.transparency, child: child),
    ),
  );
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
    'product.query_invalid' => l10n.error_product_query_invalid,
    'product.source_unavailable' => l10n.error_product_source_unavailable,
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
