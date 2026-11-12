import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/common.dart';

/// M-07: country of residence, which decides the data region.
class CountryScreen extends StatefulWidget {
  const CountryScreen({super.key});

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  String? _selected;

  String _name(AppLocalizations l10n, String code) => switch (code) {
    'AZ' => l10n.countryName_AZ,
    'TR' => l10n.countryName_TR,
    'KZ' => l10n.countryName_KZ,
    'UZ' => l10n.countryName_UZ,
    _ => code,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ParlaPage(
      title: l10n.countryTitle,
      primaryLabel: l10n.continueButton,
      onPrimary: _selected == null
          ? null
          : () {
              ParlaScope.of(context).onboarding.countryCode = _selected;
              context.go(Routes.consents);
            },
      children: [
        Text(l10n.countryWhy),
        const SizedBox(height: 16),
        RadioGroup<String>(
          groupValue: _selected,
          onChanged: (value) => setState(() => _selected = value),
          child: Column(
            children: [
              for (final market in markets)
                RadioListTile<String>(
                  key: ValueKey('country-${market.countryCode}'),
                  value: market.countryCode,
                  enabled: market.open,
                  title: Text(_name(l10n, market.countryCode)),
                  subtitle: market.open ? null : Text(l10n.countryComingSoon),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
