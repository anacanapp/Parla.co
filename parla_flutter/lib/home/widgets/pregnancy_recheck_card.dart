import 'package:flutter/material.dart';
import 'package:parla_shared/parla_shared.dart';

import '../../l10n/app_localizations.dart';
import '../../parla_scope.dart';
import '../../sport/sport_labels.dart';
import '../../ui/common.dart';
import '../../ui/warm.dart';

/// RET-2: asks again about a pregnancy answer that is a year old (six
/// months for "after birth" in sport). It stays on Home until answered
/// (owner, 2026-11-25); the old answer keeps applying until then, and
/// nothing is deleted without the person's choice.
class PregnancyRecheckCards extends StatelessWidget {
  const PregnancyRecheckCards({
    super.key,
    required this.answers,
    required this.onSkinSaved,
  });

  /// The quiz answers (with the months the server stored), or `null`.
  final QuizAnswers? answers;

  /// Called after the skin quiz answer was saved, to load it again.
  final VoidCallback onSkinSaved;

  @override
  Widget build(BuildContext context) {
    final scope = ParlaScope.of(context);
    final now = scope.clock();
    final skin = answers?.of('pregnancy') ?? const <String>[];
    final skinDue = PregnancyRecheck.skinDue(
      skin,
      answers?.months['pregnancy'],
      now,
    );
    final sport = scope.sport;
    return ListenableBuilder(
      listenable: sport,
      builder: (context, _) {
        final sportDue = sport.pregnancyRecheckDue;
        if (!skinDue && !sportDue) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (skinDue) ...[
              _SkinCard(
                answer: skin,
                months: PregnancyRecheck.monthsSince(
                  answers?.months['pregnancy'],
                  now,
                ),
                onSaved: onSkinSaved,
              ),
              const SizedBox(height: 12),
            ],
            if (sportDue) ...[
              _SportCard(
                months: PregnancyRecheck.monthsSince(
                  sport.answers!.pregnancyMonth,
                  now,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        );
      },
    );
  }
}

String _skinLabel(BuildContext context, String id) {
  final language = ParlaScope.of(context).settings.language ?? defaultLanguage;
  final option = quizQuestion(
    'pregnancy',
  )!.options.firstWhere((o) => o.id == id, orElse: () => QuizOption(id, {}));
  return option.text[language] ?? option.text['az'] ?? id;
}

class _SkinCard extends StatelessWidget {
  const _SkinCard({
    required this.answer,
    required this.months,
    required this.onSaved,
  });

  final List<String> answer;
  final int months;
  final VoidCallback onSaved;

  Future<void> _save(BuildContext context, QuizAnswers answers) async {
    final scope = ParlaScope.of(context);
    final l10n = AppLocalizations.of(context);
    try {
      await scope.api.saveQuizAnswers(answers);
      if (context.mounted) showMessage(context, l10n.recheckSaved);
      onSaved();
    } on Object catch (error) {
      if (context.mounted) showError(context, errorMessage(l10n, error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final options = [
      for (final o in quizQuestion('pregnancy')!.options) o.id,
    ];
    return _RecheckCard(
      key: const ValueKey('recheck-skin'),
      body: l10n.recheckSkinBody(
        answer.map((id) => _skinLabel(context, id)).join(', '),
        months,
      ),
      onYes: () =>
          _save(context, QuizAnswers(chosen: {'pregnancy': List.of(answer)})),
      onChange: () async {
        final picked = await _pick(
          context,
          options,
          (id) => _skinLabel(context, id),
          answer.firstOrNull,
        );
        if (picked != null && context.mounted) {
          await _save(
            context,
            QuizAnswers(
              chosen: {
                'pregnancy': [picked],
              },
            ),
          );
        }
      },
      onRemove: () =>
          _save(context, const QuizAnswers(declined: {'pregnancy'})),
    );
  }
}

class _SportCard extends StatelessWidget {
  const _SportCard({required this.months});

  final int months;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final book = ParlaScope.of(context).sport;
    final current = book.answers!.pregnancy;
    return _RecheckCard(
      key: const ValueKey('recheck-sport'),
      body: l10n.recheckSportBody(pregnancyLabel(l10n, current), months),
      onYes: () async {
        await book.recheckPregnancy();
        if (context.mounted) showMessage(context, l10n.recheckSaved);
      },
      onChange: () async {
        final picked = await _pick(
          context,
          SportOptions.pregnancy,
          (id) => pregnancyLabel(l10n, id),
          current,
        );
        if (picked == null) return;
        await book.recheckPregnancy(picked);
        if (context.mounted) showMessage(context, l10n.recheckSaved);
      },
    );
  }
}

/// Picks one of [ids] in a sheet; `null` when closed.
Future<String?> _pick(
  BuildContext context,
  List<String> ids,
  String Function(String) label,
  String? current,
) {
  final l10n = AppLocalizations.of(context);
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text(
              l10n.recheckChooseTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          for (final id in ids)
            ListTile(
              key: ValueKey('recheck-option-$id'),
              title: Text(label(id)),
              trailing: id == current ? const Icon(Icons.check) : null,
              onTap: () => Navigator.of(context).pop(id),
            ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

class _RecheckCard extends StatelessWidget {
  const _RecheckCard({
    super.key,
    required this.body,
    required this.onYes,
    required this.onChange,
    this.onRemove,
  });

  final String body;
  final VoidCallback onYes;
  final VoidCallback onChange;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final key = (this.key! as ValueKey<String>).value;
    return SmokyGlass(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.recheckTitle,
            style: text.titleLarge?.copyWith(color: Warm.onCard),
          ),
          const SizedBox(height: 6),
          Text(body, style: text.bodyMedium?.copyWith(color: Warm.onCard)),
          const SizedBox(height: 6),
          Text(
            l10n.recheckPrivacy,
            style: text.bodySmall?.copyWith(color: Warm.onCardSoft),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton(
                key: ValueKey('$key-yes'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Warm.dayInk,
                ),
                onPressed: onYes,
                child: Text(l10n.recheckYes),
              ),
              OutlinedButton(
                key: ValueKey('$key-change'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                ),
                onPressed: onChange,
                child: Text(l10n.recheckChange),
              ),
              if (onRemove != null)
                TextButton(
                  key: ValueKey('$key-remove'),
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  onPressed: onRemove,
                  child: Text(l10n.recheckRemove),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
