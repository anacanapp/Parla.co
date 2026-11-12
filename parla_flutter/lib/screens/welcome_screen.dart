import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../routes.dart';
import '../ui/common.dart';

/// M-02: value proposition and the three ways in.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final body = Theme.of(context).textTheme.bodyLarge;
    return ParlaPage(
      title: l10n.welcomeTitle,
      primaryLabel: l10n.welcomeStart,
      onPrimary: () => context.go(Routes.age),
      secondary: [
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => context.go(Routes.guest),
          child: Text(l10n.welcomeBrowse),
        ),
        TextButton(
          onPressed: () => context.go(Routes.signIn),
          child: Text(l10n.welcomeSignIn),
        ),
      ],
      children: [
        for (final line in [
          l10n.welcomeBody1,
          l10n.welcomeBody2,
          l10n.welcomeBody3,
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(line, style: body),
          ),
      ],
    );
  }
}
