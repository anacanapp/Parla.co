import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';

/// "Parla Mağaza tezliklə": information only. No sign-up for news here:
/// that would need a marketing consent, which is a separate decision.
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: ParlaColors.blush,
      appBar: AppBar(
        backgroundColor: ParlaColors.blush,
        leading: BackButton(onPressed: () => context.go(Routes.shoppingList)),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Text(
              l10n.soonBadge.toUpperCase(),
              style: text.labelMedium?.copyWith(
                color: ParlaColors.muted,
                letterSpacing: .8,
              ),
            ),
            const SizedBox(height: 6),
            Semantics(
              header: true,
              child: Text(l10n.shopTitle, style: text.displaySmall),
            ),
            const SizedBox(height: 12),
            Text(l10n.shopBody, style: text.bodyLarge),
            const SizedBox(height: 28),
            const ExcludeSemantics(
              child: Center(
                child: ParlaIcon(ParlaIconName.sparkle, size: 64),
              ),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: () => context.go(Routes.shoppingList),
              child: Text(l10n.shopOpenList),
            ),
          ],
        ),
      ),
    );
  }
}
