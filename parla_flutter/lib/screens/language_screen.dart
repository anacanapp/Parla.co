import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../l10n/app_localizations.dart';
import '../l10n/names.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/common.dart';

/// Interface languages to choose from (see `openInterfaceLanguages`).
List<String> get choosableLanguages => openInterfaceLanguages;

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
    return choosableLanguages.contains(device) ? device : defaultLanguage;
  }

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
              for (final code in choosableLanguages)
                ParlaOptionCard(
                  selected: _selected == code,
                  child: RadioListTile<String>(
                    key: ValueKey('language-$code'),
                    value: code,
                    title: Text(languageName(l10n, code)),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
