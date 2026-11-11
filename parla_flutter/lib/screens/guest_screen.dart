import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../routes.dart';
import '../ui/common.dart';

/// M-20 placeholder for guests until product search arrives.
class GuestScreen extends StatelessWidget {
  const GuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ParlaPage(
      title: l10n.guestTitle,
      primaryLabel: l10n.welcomeStart,
      onPrimary: () => context.go(Routes.age),
      children: [Text(l10n.guestPlaceholder)],
    );
  }
}
