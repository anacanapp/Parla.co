import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../ui/common.dart';

/// M-14 placeholder until the skin test and routine arrive (sprint 2).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ParlaPage(
      title: l10n.homeTitle,
      children: [Text(l10n.homePlaceholder)],
    );
  }
}
