import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';

/// M-02: value proposition and the three ways in.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context);
    final points = [
      (ParlaIconName.sparkle, l10n.welcomeBody1),
      (ParlaIconName.scan, l10n.welcomeBody2),
      (ParlaIconName.drop, l10n.welcomeBody3),
    ];
    return Scaffold(
      backgroundColor: ParlaColors.lemon,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                children: [
                  ExcludeSemantics(
                    child: Text(
                      'parla',
                      style: text.headlineMedium?.copyWith(letterSpacing: -.5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _Hero(),
                  const SizedBox(height: 20),
                  Semantics(
                    header: true,
                    child: Text(l10n.welcomeTitle, style: text.displayLarge),
                  ),
                  const SizedBox(height: 6),
                  Text(l10n.homeTagline, style: accentStyle(locale)),
                  const SizedBox(height: 16),
                  for (final (icon, line) in points)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: ParlaColors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: ParlaIcon(icon, size: 16),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              line,
                              style: text.bodyMedium?.copyWith(
                                color: ParlaColors.muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton(
                    onPressed: () => context.go(Routes.age),
                    child: Text(l10n.welcomeStart),
                  ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Three tilted cards hinting at routine, product check and habits.
/// Purely decorative.
class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    Widget card(Color color, ParlaIconName icon, double width, double angle) =>
        Transform.rotate(
          angle: angle,
          child: Container(
            width: width,
            height: 78,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(22),
              boxShadow: kSoftShadow,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: ParlaColors.white.withValues(alpha: .7),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: ParlaIcon(icon, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 8,
                        width: 80,
                        decoration: BoxDecoration(
                          color: ParlaColors.espresso.withValues(alpha: .7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: ParlaColors.espresso.withValues(alpha: .15),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

    return ExcludeSemantics(
      child: SizedBox(
        height: 220,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 6,
              child: card(ParlaColors.white, ParlaIconName.sun, 220, -.06),
            ),
            Positioned(
              right: 0,
              top: 78,
              child: card(ParlaColors.sky, ParlaIconName.check, 210, .05),
            ),
            Positioned(
              left: 24,
              top: 146,
              child: card(ParlaColors.sage, ParlaIconName.dumbbell, 200, -.03),
            ),
          ],
        ),
      ),
    );
  }
}
