import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../discover/content_library.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import 'legal_docs.dart';
import '../ui/common.dart';

/// M-05 and M-06: sign in or create an account with an emailed one-time code.
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  Future<void> _afterSignIn(BuildContext context) async {
    final scope = ParlaScope.of(context);
    final l10n = AppLocalizations.of(context);
    try {
      final profile = await scope.api.myProfile();
      ContentLibrary.country = profile?.countryCode;
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
      eyebrow: l10n.onboardingStepAccount,
      subtitle: l10n.signInBody,
      step: ParlaScope.of(context).onboarding.hasAge ? 2 : null,
      steps: 4,
      onBack: () => context.go(
        ParlaScope.of(context).onboarding.hasAge ? Routes.age : Routes.welcome,
      ),
      children: [
        ParlaScope.of(context).api.buildSignIn(
          context,
          onSignedIn: () => _afterSignIn(context),
          onError: (_) => showError(context, l10n.signInFailed),
        ),
        const SizedBox(height: 20),
        const _LegalNote(),
      ],
    );
  }
}

/// What creating an account means, with the terms and the privacy policy
/// one tap away (they open over this screen; back returns here).
class _LegalNote extends StatelessWidget {
  const _LegalNote();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    Widget link(String label, LegalDoc doc) => TextButton(
      key: ValueKey('sign-in-legal-${doc.name}'),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        minimumSize: const Size(48, 48),
      ),
      onPressed: () => context.push(Routes.legalDoc, extra: doc),
      child: Text(label),
    );
    return Column(
      key: const ValueKey('sign-in-legal'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.signInLegalNote, style: text.bodyMedium),
        Wrap(
          spacing: 8,
          children: [
            link(l10n.legalTerms, LegalDoc.terms),
            link(l10n.legalPrivacyPolicy, LegalDoc.privacy),
          ],
        ),
      ],
    );
  }
}
