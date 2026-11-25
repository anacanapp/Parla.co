import '../l10n/app_localizations.dart';

/// The name of a plan workout by its id ("w2", "p1", "v3"), instead of a
/// bare number (owner 2026-11-24). Each section has seven names; an unknown
/// id falls back to "Workout N".
String workoutName(AppLocalizations l10n, String id) => switch (id) {
  'w1' => l10n.sportWorkoutName_w1,
  'w2' => l10n.sportWorkoutName_w2,
  'w3' => l10n.sportWorkoutName_w3,
  'w4' => l10n.sportWorkoutName_w4,
  'w5' => l10n.sportWorkoutName_w5,
  'w6' => l10n.sportWorkoutName_w6,
  'w7' => l10n.sportWorkoutName_w7,
  'p1' => l10n.sportWorkoutName_p1,
  'p2' => l10n.sportWorkoutName_p2,
  'p3' => l10n.sportWorkoutName_p3,
  'p4' => l10n.sportWorkoutName_p4,
  'p5' => l10n.sportWorkoutName_p5,
  'p6' => l10n.sportWorkoutName_p6,
  'p7' => l10n.sportWorkoutName_p7,
  'v1' => l10n.sportWorkoutName_v1,
  'v2' => l10n.sportWorkoutName_v2,
  'v3' => l10n.sportWorkoutName_v3,
  'v4' => l10n.sportWorkoutName_v4,
  'v5' => l10n.sportWorkoutName_v5,
  'v6' => l10n.sportWorkoutName_v6,
  'v7' => l10n.sportWorkoutName_v7,
  _ => l10n.sportWorkoutTitle(int.tryParse(id.substring(1)) ?? 1),
};
