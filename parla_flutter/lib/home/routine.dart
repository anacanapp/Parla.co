import 'dart:ui';

import 'package:parla_shared/parla_shared.dart';

import '../discover/content_library.dart';
import '../ui/brand.dart';

/// Morning or evening care routine.
enum RoutineKind { morning, evening }

/// One step of a routine, already in the user's language.
class RoutineStep {
  const RoutineStep({
    required this.id,
    required this.title,
    required this.meta,
    required this.tip,
    required this.minutes,
    required this.tile,
    this.approvedByDermatologist = false,
  });

  final String id;
  final String title;

  /// How to do it, one or two sentences.
  final String meta;

  /// Why it matters or a tip.
  final String tip;
  final int minutes;
  final Color tile;

  /// Only content approved by an expert may show the "approved by a
  /// dermatologist" badge.
  final bool approvedByDermatologist;
}

int _index(String language) => switch (language) {
  'ru' => 1,
  'en' => 2,
  _ => 0,
};

/// DRAFT CONTENT from the content sheet ("rutin_addimlari"), not reviewed
/// by a dermatologist yet, so the badge never shows for it.
List<RoutineStep> routineSteps(List<String> ids, String language) {
  final i = _index(language);
  final hidden = ContentLibrary.hiddenIds('step');
  String text(String id, String key, String fallback) =>
      ContentLibrary.catalogueText('step', id, key, language) ?? fallback;
  return [
    for (final id in ids)
      if (!hidden.contains(id))
        if (routineStepTexts[id] case final t?)
          RoutineStep(
            id: id,
            title: text(id, 'title', t[0][i]),
            meta: text(id, 'how', t[1][i]),
            tip: ContentLibrary.catalogueData('step', id) != null
                ? text(id, 'tip', '')
                : t[2][i],
            minutes: int.tryParse(t[4][0]) ?? 1,
            tile: _tile(id),
          ),
  ];
}

/// Every step id that has text (for tests).
Iterable<String> knownStepIds(String language) => routineStepTexts.keys;

Color _tile(String id) {
  final area = routineStepInfo(id)?.area;
  if (id.contains('sunscreen') || id.contains('scalp-sun')) {
    return ParlaColors.sun;
  }
  return switch (area) {
    RoutineArea.hair => ParlaColors.lilac,
    RoutineArea.body => ParlaColors.sky,
    _ => id.endsWith('-pm') ? ParlaColors.sky : ParlaColors.sage,
  };
}
