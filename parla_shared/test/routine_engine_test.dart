import 'package:parla_shared/parla_shared.dart';
import 'package:test/test.dart';

QuizAnswers _a(
  Map<String, List<String>> chosen, {
  Set<String> declined = const {},
}) => QuizAnswers(chosen: chosen, declined: declined);

/// Someone who would get a retinoid if nothing ruled it out.
const _candidate = {
  'skin_type': ['normal'],
  'sensitivity': ['never'],
  'concerns': ['fine_lines'],
  'routine_level': ['standard'],
  'actives_experience': ['some'],
  'pregnancy': ['no'],
  'medications': ['none'],
  'wash_frequency': ['every_2_3'],
};

List<String> _all(RoutineResult r) => [
  for (final p in r.plans.values) ...[...p.morning, ...p.evening, ...p.weekly],
];

void main() {
  test('every step and rule refers to known steps and questions', () {
    final ids = {for (final s in routineStepCatalogue) s.id};
    expect(ids, hasLength(34));
    for (final rule in routineRuleList) {
      for (final s in rule.steps) {
        expect(ids, contains(s), reason: rule.id);
      }
      final q = rule.question;
      if (q != null) {
        final question = quizQuestion(q);
        expect(question, isNotNull, reason: rule.id);
        for (final answer in rule.answers) {
          expect(question!.option(answer), isNotNull, reason: rule.id);
        }
      }
      for (final p in rule.preferences) {
        expect(productPreference(p), isNotNull, reason: rule.id);
      }
      for (final language in supportedLanguages) {
        expect(rule.note[language], isNotEmpty, reason: rule.id);
      }
    }
  });

  test('before the quiz: the base routines', () {
    final r = buildRoutine(null);
    expect(r.plans[RoutineArea.face]!.morning, [
      'face-cleanser-am',
      'face-moisturiser',
      'face-sunscreen-am',
    ]);
    expect(
      r.plans[RoutineArea.face]!.evening,
      containsAll(['face-cleanser-pm', 'face-moisturiser']),
    );
    expect(_all(r), containsAll(['hair-shampoo', 'body-cleanser']));
    expect(_all(r), isNot(contains('retinoid-pm')));
  });

  test('a safe candidate gets the retinoid at night', () {
    final r = buildRoutine(_a(_candidate));
    expect(r.plans[RoutineArea.face]!.evening, contains('retinoid-pm'));
  });

  for (final p in ['pregnant', 'breastfeeding', 'trying', 'prefer_not']) {
    test('no retinoid when pregnancy is $p', () {
      final r = buildRoutine(
        _a({
          ..._candidate,
          'pregnancy': [p],
        }),
      );
      expect(_all(r), isNot(contains('retinoid-pm')));
      expect(r.notes.map((n) => n.id), contains('rule-pregnancy-no-retinoid'));
    });
  }

  test('no retinoid when pregnancy is skipped (never guessed)', () {
    final answers = Map.of(_candidate)..remove('pregnancy');
    final r = buildRoutine(_a(answers, declined: {'pregnancy'}));
    expect(_all(r), isNot(contains('retinoid-pm')));
  });

  test('isotretinoin removes actives and adds barrier care', () {
    final r = buildRoutine(
      _a({
        ..._candidate,
        'medications': ['oral_isotretinoin'],
        'concerns': ['breakouts', 'fine_lines'],
      }),
    );
    expect(
      _all(r),
      isNot(
        containsAll(['retinoid-pm', 'face-bha-pm', 'face-exfoliant-weekly']),
      ),
    );
    expect(_all(r), containsAll(['face-barrier-cream-pm', 'face-lip-balm']));
  });

  test('unanswered medication leaves out the actives', () {
    final answers = Map.of(_candidate)..remove('medications');
    expect(_all(buildRoutine(_a(answers))), isNot(contains('retinoid-pm')));
  });

  test('skin that reacts often loses vitamin C and acids', () {
    final r = buildRoutine(
      _a({
        ..._candidate,
        'sensitivity': ['often'],
        'concerns': ['dark_spots', 'breakouts'],
      }),
    );
    expect(_all(r), isNot(contains('face-vitamin-c')));
    expect(_all(r), isNot(contains('face-bha-pm')));
    expect(r.preferences, contains('fragrance_free'));
  });

  test('concerns, makeup and minimal level follow the sheet', () {
    final r = buildRoutine(
      _a({
        ..._candidate,
        'skin_type': ['oily'],
        'makeup_spf': ['daily'],
        'routine_level': ['minimal'],
        'concerns': ['dryness'],
      }),
    );
    final face = r.plans[RoutineArea.face]!;
    expect(face.evening, contains('face-oil-cleanser-pm'));
    expect(face.morning, contains('face-niacinamide'));
    // Minimal removes the hydrating mask even though dryness adds it.
    expect(face.weekly, isNot(contains('face-mask-hydrating')));
  });

  test('hair: wash-day steps follow how often the hair is washed', () {
    QuizAnswers wash(String often) => _a({
      ..._candidate,
      'wash_frequency': [often],
      'hair_type': ['curly'],
    });
    final daily = buildRoutine(wash('daily')).plans[RoutineArea.hair]!;
    expect(daily.morning, containsAll(['hair-shampoo', 'hair-leave-in']));
    final weekly = buildRoutine(wash('weekly')).plans[RoutineArea.hair]!;
    expect(weekly.weekly, containsAll(['hair-shampoo', 'hair-conditioner']));
    expect(weekly.morning, contains('hair-detangle'));
  });

  test('body and allergies', () {
    final r = buildRoutine(
      _a({
        ..._candidate,
        'body_concerns': ['back_acne', 'cracked_heels'],
        'allergies': ['lanolin', 'preservatives'],
        'sun_exposure': ['high'],
      }),
    );
    final body = r.plans[RoutineArea.body]!;
    expect([
      ...body.morning,
      ...body.evening,
    ], containsAll(['body-bha-wash', 'body-foot-cream', 'body-sunscreen']));
    expect(r.preferences, containsAll(['lanolin_free', 'preservative_alert']));
  });

  test('the Today plan is the face routine', () {
    final plan = planRoutine(_a(_candidate));
    expect(plan.morning, planArea(RoutineArea.face, _a(_candidate)).morning);
    expect(defaultRoutinePlan.morning, contains('face-sunscreen-am'));
  });
}
