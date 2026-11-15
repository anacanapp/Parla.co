import '../l10n/app_localizations.dart';

String goalLabel(AppLocalizations l10n, String id) => switch (id) {
  'tone' => l10n.sportGoalTone,
  'muscle' => l10n.sportGoalMuscle,
  'flexibility' => l10n.sportGoalFlexibility,
  'posture' => l10n.sportGoalPosture,
  'endurance' => l10n.sportGoalEndurance,
  _ => l10n.sportGoalRelax,
};

String sportAreaLabel(AppLocalizations l10n, String id) => switch (id) {
  'arms' => l10n.sportAreaArms,
  'legs' => l10n.sportAreaLegs,
  'core' => l10n.sportAreaCore,
  'glutes' => l10n.sportAreaGlutes,
  'back' => l10n.sportAreaBack,
  _ => l10n.sportAreaFull,
};

String sportTypeLabel(AppLocalizations l10n, String id) => switch (id) {
  'fitness' => l10n.sportTypeFitness,
  'pilates' => l10n.sportTypePilates,
  'wall_pilates' => l10n.sportTypeWallPilates,
  'stretching' => l10n.sportTypeStretching,
  _ => l10n.sportTypeCardio,
};

String levelLabel(AppLocalizations l10n, String id) => switch (id) {
  'beginner' => l10n.sportLevelBeginner,
  'intermediate' => l10n.sportLevelIntermediate,
  _ => l10n.sportLevelAdvanced,
};

String pregnancyLabel(AppLocalizations l10n, String id) => switch (id) {
  'pregnant' => l10n.sportPregPregnant,
  'postpartum' => l10n.sportPregPostpartum,
  _ => l10n.sportPregNo,
};

String injuryLabel(AppLocalizations l10n, String id) => switch (id) {
  'knee' => l10n.sportInjKnee,
  'back' => l10n.sportInjBack,
  'shoulder' => l10n.sportInjShoulder,
  _ => l10n.sportInjWrist,
};
