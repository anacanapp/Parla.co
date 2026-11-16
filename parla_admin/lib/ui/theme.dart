import 'package:flutter/material.dart';

/// Parla colours for the panel (the app's brand, calmer for long work).
abstract final class AdminColors {
  static const sun = Color(0xFFFFCE00);
  static const cream = Color(0xFFFFF9E8);
  static const espresso = Color(0xFF1F1A14);
  static const muted = Color(0xFF5C5246);
  static const line = Color(0xFFEFE4C6);
  static const white = Color(0xFFFFFFFF);
}

ThemeData adminTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AdminColors.sun,
    primary: AdminColors.espresso,
    surface: AdminColors.white,
  );
  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: AdminColors.cream,
    useMaterial3: true,
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      filled: true,
      fillColor: AdminColors.white,
    ),
  );
}

/// A centred card for the sign-in steps.
class AuthCard extends StatelessWidget {
  const AuthCard({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Card(
            elevation: 0,
            color: AdminColors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'parla · admin',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AdminColors.muted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Semantics(
                    header: true,
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
