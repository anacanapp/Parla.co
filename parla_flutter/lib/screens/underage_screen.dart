import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../routes.dart';
import '../ui/common.dart';

/// M-04: shown to people under 18. Nothing they entered is kept.
class UnderageScreen extends StatelessWidget {
  const UnderageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ParlaPage(
      title: l10n.underageTitle,
      primaryLabel: l10n.close,
      onPrimary: () => context.go(Routes.welcome),
      children: [Text(l10n.underageBody)],
    );
  }
}
