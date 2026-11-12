import 'package:parla_shared/parla_shared.dart';
import 'package:test/test.dart';

QuizAnswers _answers(
  Map<String, List<String>> chosen, {
  Set<String> declined = const {},
}) => QuizAnswers(chosen: chosen, declined: declined);

/// Someone who would get a retinoid if nothing ruled it out.
const _retinoidCandidate = {
  'skin_type': ['normal'],
  'skin_sensitivity': ['rarely'],
  'skin_goals': ['glow'],
  'routine_time': ['standard'],
  'pregnancy': ['no'],
  'medication': ['none'],
};

void main() {
  group('quiz content', () {
    test('ids are unique and every text exists in every language', () {
      final ids = quizQuestions.map((q) => q.id).toList();
      expect(ids.toSet().length, ids.length);
      for (final q in quizQuestions) {
        for (final language in supportedLanguages) {
          expect(q.text[language], isNotEmpty, reason: '${q.id} $language');
          for (final o in q.options) {
            expect(
              o.text[language],
              isNotEmpty,
              reason: '${q.id}.${o.id} $language',
            );
          }
        }
        final optionIds = q.options.map((o) => o.id).toList();
        expect(optionIds.toSet().length, optionIds.length, reason: q.id);
      }
    });

    test('sample content is never marked approved', () {
      expect(quizQuestions.where((q) => q.approved), isEmpty);
    });

    test('health questions are sensitive and declinable', () {
      for (final q in quizQuestions.where(
        (q) => q.section == QuizSection.health,
      )) {
        expect(q.sensitive, isTrue, reason: q.id);
        expect(q.declinable, isTrue, reason: q.id);
      }
    });

    test('warning signs are never stored', () {
      expect(quizQuestion('warning_signs')!.stored, isFalse);
    });

    test('answer validation', () {
      final skin = quizQuestion('skin_type')!;
      expect(skin.accepts(['oily']), isTrue);
      expect(skin.accepts([]), isFalse);
      expect(skin.accepts(['oily', 'dry']), isFalse);
      expect(skin.accepts(['shiny']), isFalse);

      final allergies = quizQuestion('allergies')!;
      expect(allergies.accepts(['fragrance', 'nickel']), isTrue);
      expect(allergies.accepts(['fragrance', 'none']), isFalse);
      expect(allergies.accepts(['nickel', 'nickel']), isFalse);
    });

    test('red flags', () {
      expect(hasRedFlag(_answers({})), isFalse);
      expect(
        hasRedFlag(
          _answers({
            'warning_signs': ['none'],
          }),
        ),
        isFalse,
      );
      expect(
        hasRedFlag(
          _answers({
            'warning_signs': ['changing_mole'],
          }),
        ),
        isTrue,
      );
    });
  });

  group('routine rules', () {
    test('a safe candidate gets a retinoid in the evening', () {
      final plan = planRoutine(_answers(_retinoidCandidate));
      expect(plan.evening, contains('retinoid-pm'));
      expect(plan.morning, contains('vitamin-c'));
      expect(plan.exclusions, isEmpty);
    });

    for (final pregnancy in ['pregnant', 'breastfeeding']) {
      test('no retinoid when $pregnancy', () {
        final plan = planRoutine(
          _answers({
            ..._retinoidCandidate,
            'pregnancy': [pregnancy],
          }),
        );
        expect(plan.evening, isNot(contains('retinoid-pm')));
        expect(plan.exclusions, contains(RoutineExclusion.retinoidPregnancy));
      });
    }

    test('no retinoid when pregnancy is declined (never guessed)', () {
      final answers = Map.of(_retinoidCandidate)..remove('pregnancy');
      final plan = planRoutine(_answers(answers, declined: {'pregnancy'}));
      expect(plan.evening, isNot(contains('retinoid-pm')));
      expect(plan.exclusions, contains(RoutineExclusion.retinoidPregnancy));
    });

    test('no retinoid with oral retinoids or unanswered medication', () {
      final onIsotretinoin = planRoutine(
        _answers({
          ..._retinoidCandidate,
          'medication': ['oral_retinoid'],
        }),
      );
      expect(onIsotretinoin.evening, isNot(contains('retinoid-pm')));

      final unanswered = Map.of(_retinoidCandidate)..remove('medication');
      final plan = planRoutine(_answers(unanswered));
      expect(plan.evening, isNot(contains('retinoid-pm')));
      expect(plan.exclusions, contains(RoutineExclusion.retinoidMedication));
    });

    test('sensitive skin gets a soothing serum and no actives', () {
      final plan = planRoutine(
        _answers({
          ..._retinoidCandidate,
          'conditions': ['rosacea'],
        }),
      );
      expect(plan.morning, contains('soothing-serum'));
      expect(plan.morning, isNot(contains('vitamin-c')));
      expect(plan.evening, isNot(contains('retinoid-pm')));
    });

    test('minimal routine keeps only the essentials', () {
      final plan = planRoutine(
        _answers({
          ..._retinoidCandidate,
          'routine_time': ['minimal'],
        }),
      );
      expect(plan.morning, ['cleanser', 'moisturiser', 'sunscreen']);
      expect(plan.evening, isNot(contains('retinoid-pm')));
    });

    test('moisturiser follows skin type; sunscreen is always in', () {
      expect(
        planRoutine(
          _answers({
            'skin_type': ['oily'],
          }),
        ).morning,
        contains('moisturiser-light'),
      );
      expect(
        planRoutine(
          _answers({
            'skin_type': ['dry'],
          }),
        ).morning,
        contains('moisturiser-rich'),
      );
      expect(planRoutine(_answers({})).morning, contains('sunscreen'));
    });
  });
}
