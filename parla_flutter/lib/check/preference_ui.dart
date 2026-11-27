import 'package:flutter/material.dart';
import 'package:parla_shared/parla_shared.dart';

import '../l10n/app_localizations.dart';
import '../ui/brand.dart';
import '../discover/content_library.dart';
import 'care_list.dart';

/// Label of a product preference (from the content sheet); the id itself
/// for one this version has no text for.
String preferenceLabel(AppLocalizations l10n, String id) =>
    ContentLibrary.catalogueText('preference', id, 'name', l10n.localeName) ??
    (preferenceTexts[id] == null
        ? null
        : pickTriple(preferenceTexts[id]![0], l10n.localeName)) ??
    id;

/// What a preference checks, in neutral words, or `null`.
String? preferenceHint(AppLocalizations l10n, String id) =>
    ContentLibrary.catalogueText('preference', id, 'hint', l10n.localeName) ??
    (preferenceTexts[id] == null
        ? null
        : pickTriple(preferenceTexts[id]![1], l10n.localeName));

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
        final hidden = ContentLibrary.hiddenIds('preference');
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
                  if (!hidden.contains(p.id))
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
