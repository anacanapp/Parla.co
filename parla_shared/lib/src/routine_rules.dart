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

/// The three care areas of the Routine tab.
enum RoutineArea { face, hair, body }

/// When a step is done: every morning, every evening, or once a week.
enum RoutineSlot { morning, evening, weekly }

/// Steps of one care area per slot, in order. Any slot may be empty.
class AreaPlan {
  const AreaPlan({
    this.morning = const [],
    this.evening = const [],
    this.weekly = const [],
  });

  final List<String> morning;
  final List<String> evening;
  final List<String> weekly;

  List<String> slot(RoutineSlot slot) => switch (slot) {
    RoutineSlot.morning => morning,
    RoutineSlot.evening => evening,
    RoutineSlot.weekly => weekly,
  };

  bool get isEmpty => morning.isEmpty && evening.isEmpty && weekly.isEmpty;
}

/// Hair care from the hair answers (SAMPLE RULES, NOT EXPERT-APPROVED).
///
/// Without answers (no quiz yet) the basic wash-day routine is used.
/// Washing is a weekly slot: how often people wash differs a lot, so the
/// app asks for it once a week rather than prescribing a frequency.
AreaPlan planHair(QuizAnswers? a) {
  bool has(String id, String option) => a?.has(id, option) ?? false;
  final textured = has('hair_type', 'curly') || has('hair_type', 'coily');
  final dry = has('hair_concerns', 'dryness');
  final frizz = has('hair_concerns', 'frizz');
  final breakage = has('hair_concerns', 'breakage');
  final oily = has('hair_concerns', 'oiliness');

  final morning = <String>['hair-detangle'];
  if ((textured || dry || frizz) && !oily) morning.add('hair-leave-in');

  final evening = <String>[if (breakage || textured) 'hair-night-protect'];

  final weekly = <String>['hair-wash', 'hair-conditioner'];
  if (dry || breakage || textured) weekly.add('hair-mask');
  if (oily) weekly.add('hair-scalp-care');

  return AreaPlan(morning: morning, evening: evening, weekly: weekly);
}

/// Body care (SAMPLE RULES, NOT EXPERT-APPROVED).
///
/// The quiz has no body questions yet, so everyone gets the same basic
/// routine; sensitive skin skips the scrub and outdoor days add sunscreen.
AreaPlan planBody(QuizAnswers? a) {
  bool has(String id, String option) => a?.has(id, option) ?? false;
  final sensitive =
      has('skin_sensitivity', 'often') ||
      has('conditions', 'eczema') ||
      has('conditions', 'psoriasis');
  return AreaPlan(
    morning: [
      'body-shower',
      if (!has('sun_exposure', 'indoors')) 'body-sunscreen',
    ],
    evening: const ['body-lotion'],
    weekly: [if (!sensitive) 'body-scrub', 'body-hands-feet'],
  );
}

/// The face plan as an [AreaPlan] (face has no weekly steps yet).
AreaPlan facePlan(QuizAnswers? a) {
  final plan = a == null ? defaultRoutinePlan : planRoutine(a);
  return AreaPlan(morning: plan.morning, evening: plan.evening);
}

/// The plan for [area].
AreaPlan planArea(RoutineArea area, QuizAnswers? a) => switch (area) {
  RoutineArea.face => facePlan(a),
  RoutineArea.hair => planHair(a),
  RoutineArea.body => planBody(a),
};
