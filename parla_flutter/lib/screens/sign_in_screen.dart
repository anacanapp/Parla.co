import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/common.dart';

/// M-05 and M-06: sign in or create an account with an emailed one-time code.
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  Future<void> _afterSignIn(BuildContext context) async {
    final scope = ParlaScope.of(context);
    final l10n = AppLocalizations.of(context);
    try {
      final profile = await scope.api.myProfile();
      if (!context.mounted) return;
      if (profile != null) {
        context.go(Routes.home);
      } else if (scope.onboarding.hasAge) {
        context.go(Routes.country);
      } else {
        // Signed in from "I already have an account" without a profile:
        // the age gate still has to run.
        context.go(Routes.age);
      }
    } on Object catch (error) {
      if (context.mounted) showError(context, errorMessage(l10n, error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ParlaPage(
      title: l10n.signInTitle,
      children: [
        Text(l10n.signInBody),
        const SizedBox(height: 24),
        ParlaScope.of(context).api.buildSignIn(
          context,
          onSignedIn: () => _afterSignIn(context),
          onError: (_) => showError(context, l10n.signInFailed),
        ),
      ],
    );
  }
}
