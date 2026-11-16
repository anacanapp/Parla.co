/// Turns quiz answers into face, hair and body routines (PRD M4).
///
/// The steps and rules come from the content sheet ("rutin_addimlari",
/// "rutin_qaydalari"); see `routine_content.dart`. DRAFT, NOT
/// EXPERT-APPROVED.
///
/// How the rules apply (the sheet's priority note):
/// 1. Every matching "add" rule adds its steps (the base rules match
///    everyone).
/// 2. Every matching "remove" rule removes its steps, and removing always
///    wins over adding.
/// 3. Safety is conservative: a step marked unsafe in pregnancy is left out
///    unless the pregnancy answer is "no", so a skipped or declined answer
///    also leaves it out. If the medication question is not answered, the
///    actives a prescription would rule out are left out too. Steps not
///    suited to sensitive skin are left out when the skin reacts often.
/// 4. "Reduce" and "note" rules do not change the steps; their notes are
///    shown with the routine, and their preferences are suggested for
///    Check.
library;

import 'quiz.dart';

part 'routine_content.dart';

enum RoutineArea { face, hair, body }

enum RoutineSlot { morning, evening, weekly }

/// When a step is done, as the sheet says it.
enum StepTime {
  morning,
  evening,
  both,
  weekly,

  /// On hair-wash days: every morning for daily washers, else weekly.
  washDay,
}

/// One care step's facts (texts live in the app).
class RoutineStepInfo {
  const RoutineStepInfo(
    this.id,
    this.area,
    this.time,
    this.order, {
    this.pregnancyUnsafe = false,
    this.sensitiveOk = true,
  });

  final String id;
  final RoutineArea area;
  final StepTime time;

  /// Order within the area and part of the day.
  final int order;

  /// Left out in pregnancy, breastfeeding, when trying to conceive, and
  /// when the pregnancy question is not answered "no".
  final bool pregnancyUnsafe;

  /// Suitable for skin that reacts often.
  final bool sensitiveOk;
}

enum RuleAction { add, remove, reduce, note }

/// One routine rule: when [question] (null: everyone) has one of
/// [answers], do [action] to [steps]; [preferences] are Check filters the
/// rule suggests.
class RoutineRule {
  const RoutineRule(
    this.id, {
    required this.question,
    required this.answers,
    required this.action,
    required this.steps,
    required this.preferences,
    required this.note,
  });

  final String id;
  final String? question;
  final Set<String> answers;
  final RuleAction action;
  final List<String> steps;
  final List<String> preferences;

  /// Shown to the user, per language.
  final Map<String, String> note;

  bool matches(QuizAnswers? a) {
    final q = question;
    if (q == null) return true;
    if (a == null) return false;
    return answers.any((x) => a.has(q, x));
  }
}

RoutineStepInfo? routineStepInfo(String id) {
  for (final s in routineStepCatalogue) {
    if (s.id == id) return s;
  }
  return null;
}

/// Steps for each part of the day in one area.
class AreaPlan {
  const AreaPlan({
    this.morning = const [],
    this.evening = const [],
    this.weekly = const [],
  });

  final List<String> morning;
  final List<String> evening;
  final List<String> weekly;

  List<String> slot(RoutineSlot s) => switch (s) {
    RoutineSlot.morning => morning,
    RoutineSlot.evening => evening,
    RoutineSlot.weekly => weekly,
  };

  bool get isEmpty => morning.isEmpty && evening.isEmpty && weekly.isEmpty;
}

/// The routine for some answers: the plan per area, the notes of the
/// matching rules (beyond the base ones) and the suggested Check filters.
class RoutineResult {
  const RoutineResult(this.plans, this.notes, this.preferences);

  final Map<RoutineArea, AreaPlan> plans;

  /// Matching rules that explain the routine (not the base rules), in the
  /// sheet's order.
  final List<RoutineRule> notes;

  /// Check filter ids the answers suggest.
  final Set<String> preferences;
}

const _pregnancySafe = 'no';

/// Removed when the medication question is not answered (as for a
/// prescription skin medicine).
const _unansweredMedicationRemoves = {
  'retinoid-pm',
  'face-bha-pm',
  'face-exfoliant-weekly',
};

/// Builds the routine for [answers] (`null`: before the quiz, base routine
/// only).
RoutineResult buildRoutine(QuizAnswers? answers) {
  final chosen = <String>{};
  final removed = <String>{};
  final notes = <RoutineRule>[];
  final preferences = <String>{};
  for (final rule in routineRuleList) {
    if (!rule.matches(answers)) continue;
    switch (rule.action) {
      case RuleAction.add:
        chosen.addAll(rule.steps);
      case RuleAction.remove:
        removed.addAll(rule.steps);
      case RuleAction.reduce || RuleAction.note:
        break;
    }
    preferences.addAll(rule.preferences);
    if (rule.question != null) notes.add(rule);
  }
  final a = answers;
  if (a != null) {
    if (!a.answered('medications')) {
      removed.addAll(_unansweredMedicationRemoves);
    }
  }
  final pregnancyOk = a != null && a.has('pregnancy', _pregnancySafe);
  final reactive = a != null && a.has('sensitivity', 'often');
  final washDaily = a != null && a.has('wash_frequency', 'daily');

  final steps = [
    for (final s in routineStepCatalogue)
      if (chosen.contains(s.id) &&
          !removed.contains(s.id) &&
          (pregnancyOk || !s.pregnancyUnsafe) &&
          (!reactive || s.sensitiveOk))
        s,
  ];

  AreaPlan plan(RoutineArea area) {
    final mine = steps.where((s) => s.area == area).toList()
      ..sort((x, y) => x.order.compareTo(y.order));
    List<String> at(bool Function(RoutineStepInfo) when) => [
      for (final s in mine)
        if (when(s)) s.id,
    ];
    return AreaPlan(
      morning: at(
        (s) =>
            s.time == StepTime.morning ||
            s.time == StepTime.both ||
            (s.time == StepTime.washDay && washDaily),
      ),
      evening: at((s) => s.time == StepTime.evening || s.time == StepTime.both),
      weekly: at(
        (s) =>
            s.time == StepTime.weekly ||
            (s.time == StepTime.washDay && !washDaily),
      ),
    );
  }

  return RoutineResult(
    {for (final area in RoutineArea.values) area: plan(area)},
    notes,
    preferences,
  );
}

/// The plan for [area] (`null` answers: base routine).
AreaPlan planArea(RoutineArea area, QuizAnswers? a) =>
    buildRoutine(a).plans[area]!;

/// Face steps for the morning and evening (the Today screen).
class RoutinePlan {
  const RoutinePlan({required this.morning, required this.evening});

  final List<String> morning;
  final List<String> evening;
}

RoutinePlan planRoutine(QuizAnswers a) {
  final face = planArea(RoutineArea.face, a);
  return RoutinePlan(morning: face.morning, evening: face.evening);
}

/// The plan for someone who has not taken the quiz.
final RoutinePlan defaultRoutinePlan = () {
  final face = planArea(RoutineArea.face, null);
  return RoutinePlan(morning: face.morning, evening: face.evening);
}();
