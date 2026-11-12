/// Turns quiz answers into a routine (PRD M4).
///
/// SAMPLE RULES, NOT EXPERT-APPROVED. The safety rules are deliberately
/// conservative: when an answer that matters for safety is missing or
/// declined, the riskier step is left out rather than guessed.
library;

import 'quiz.dart';

/// Why a step was left out. Shown to the user so the routine is explainable.
enum RoutineExclusion {
  /// Retinoid skipped: pregnant, breastfeeding, or pregnancy not answered.
  retinoidPregnancy,

  /// Retinoid skipped: takes a retinoid or prescription skin medicine, or
  /// did not answer the medication question.
  retinoidMedication,

  /// Retinoid and vitamin C skipped for reactive or sensitive skin.
  sensitiveSkin,
}

/// Step ids for each part of the day, in order.
class RoutinePlan {
  const RoutinePlan({
    required this.morning,
    required this.evening,
    this.exclusions = const {},
  });

  final List<String> morning;
  final List<String> evening;
  final Set<RoutineExclusion> exclusions;
}

/// The plan for someone who has not taken the quiz.
const RoutinePlan defaultRoutinePlan = RoutinePlan(
  morning: ['cleanser', 'moisturiser', 'sunscreen'],
  evening: ['cleanser-pm', 'night-cream'],
);

RoutinePlan planRoutine(QuizAnswers a) {
  final minimal = a.has('routine_time', 'minimal');
  final sensitive =
      a.has('skin_sensitivity', 'often') ||
      a.has('conditions', 'rosacea') ||
      a.has('conditions', 'eczema');
  final exclusions = <RoutineExclusion>{};

  final moisturiser = a.has('skin_type', 'oily')
      ? 'moisturiser-light'
      : a.has('skin_type', 'dry')
      ? 'moisturiser-rich'
      : 'moisturiser';

  final morning = <String>['cleanser'];
  if (!minimal) {
    if (sensitive) {
      morning.add('soothing-serum');
      exclusions.add(RoutineExclusion.sensitiveSkin);
    } else {
      morning.add('vitamin-c');
    }
  }
  morning
    ..add(moisturiser)
    ..add('sunscreen');

  final wantsRetinoid = const [
    'fewer_breakouts',
    'even_tone',
    'glow',
  ].any((goal) => a.has('skin_goals', goal));

  final evening = <String>['makeup-off', 'cleanser-pm'];
  if (wantsRetinoid && !minimal) {
    final pregnancySafe = a.has('pregnancy', 'no');
    final medicationSafe =
        a.answered('medication') &&
        !a.has('medication', 'oral_retinoid') &&
        !a.has('medication', 'prescription_cream');
    if (!pregnancySafe) exclusions.add(RoutineExclusion.retinoidPregnancy);
    if (!medicationSafe) exclusions.add(RoutineExclusion.retinoidMedication);
    if (sensitive) exclusions.add(RoutineExclusion.sensitiveSkin);
    if (pregnancySafe && medicationSafe && !sensitive) {
      evening.add('retinoid-pm');
    }
  }
  evening.add('night-cream');
  if (!minimal) evening.add('lip-balm');

  return RoutinePlan(
    morning: morning,
    evening: evening,
    exclusions: exclusions,
  );
}
