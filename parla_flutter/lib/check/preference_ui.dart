import 'package:flutter/material.dart';
import 'package:parla_shared/parla_shared.dart';

import '../l10n/app_localizations.dart';
import '../ui/brand.dart';
import 'care_list.dart';

/// Label of a product preference; the id itself for one this version has
/// no text for.
String preferenceLabel(AppLocalizations l10n, String id) => switch (id) {
  'fragrance_free' => l10n.prefFragranceFree,
  'alcohol_free' => l10n.prefAlcoholFree,
  'sulfate_free' => l10n.prefSulfateFree,
  'silicone_free' => l10n.prefSiliconeFree,
  'paraben_free' => l10n.prefParabenFree,
  'vegan' => l10n.prefVegan,
  _ => id,
};

/// A short note on what a preference checks, or `null`.
String? preferenceHint(AppLocalizations l10n, String id) => switch (id) {
  'alcohol_free' => l10n.prefAlcoholFreeHint,
  'vegan' => l10n.prefVeganHint,
  _ => null,
};

/// Lets the user pick her preferences; saves them to [book].
Future<void> editPreferences(BuildContext context, CareListBook book) async {
  final picked = {...book.preferences};
  final saved = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        final l10n = AppLocalizations.of(context);
        final text = Theme.of(context).textTheme;
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    l10n.checkPrefsSheetTitle,
                    style: text.headlineSmall,
                  ),
                ),
                const SizedBox(height: 8),
                for (final p in productPreferences)
                  CheckboxListTile(
                    key: ValueKey('pref-${p.id}'),
                    contentPadding: EdgeInsets.zero,
                    value: picked.contains(p.id),
                    onChanged: (on) => setState(() {
                      if (on ?? false) {
                        picked.add(p.id);
                      } else {
                        picked.remove(p.id);
                      }
                    }),
                    title: Text(preferenceLabel(l10n, p.id)),
                    subtitle: preferenceHint(l10n, p.id) == null
                        ? null
                        : Text(
                            preferenceHint(l10n, p.id)!,
                            style: text.bodySmall?.copyWith(
                              color: ParlaColors.muted,
                            ),
                          ),
                  ),
                const SizedBox(height: 12),
                FilledButton(
                  key: const ValueKey('prefs-save'),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(l10n.checkPrefsSave),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
  if (saved ?? false) await book.setPreferences(picked);
}

/// The picked preferences as small chips.
class PreferenceChips extends StatelessWidget {
  const PreferenceChips({super.key, required this.ids});

  final List<String> ids;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final id in ids)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: ParlaColors.sageTint,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              preferenceLabel(l10n, id),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
      ],
    );
  }
}
