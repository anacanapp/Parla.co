import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/common.dart';

/// M-01: interface language on first launch.
class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String? _selected;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selected ??= _deviceLanguage(context);
  }

  static String _deviceLanguage(BuildContext context) {
    final device = Localizations.localeOf(context).languageCode;
    return supportedLanguages.contains(device) ? device : defaultLanguage;
  }

  String _name(AppLocalizations l10n, String code) => switch (code) {
    'az' => l10n.languageName_az,
    'ru' => l10n.languageName_ru,
    _ => l10n.languageName_en,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ParlaPage(
      title: l10n.languageTitle,
      primaryLabel: l10n.continueButton,
      onPrimary: () async {
        await ParlaScope.of(context).settings.setLanguage(_selected!);
        if (context.mounted) context.go(Routes.welcome);
      },
      children: [
        RadioGroup<String>(
          groupValue: _selected,
          onChanged: (value) => setState(() => _selected = value),
          child: Column(
            children: [
              for (final code in supportedLanguages)
                RadioListTile<String>(
                  key: ValueKey('language-$code'),
                  value: code,
                  title: Text(_name(l10n, code)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
