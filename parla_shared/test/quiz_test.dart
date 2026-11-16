import 'package:parla_shared/parla_shared.dart';
import 'package:test/test.dart';

QuizAnswers _answers(
  Map<String, List<String>> chosen, {
  Set<String> declined = const {},
}) => QuizAnswers(chosen: chosen, declined: declined);

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
      expect(allergies.accepts(['fragrance', 'lanolin']), isTrue);
      expect(allergies.accepts(['fragrance', 'none']), isFalse);
      expect(allergies.accepts(['lanolin', 'lanolin']), isFalse);
      expect(allergies.accepts(['nickel']), isFalse);
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

  test('the sheet questions are all there, with why we ask', () {
    expect(quizQuestions.map((q) => q.id), [
      'skin_type',
      'sensitivity',
      'concerns',
      'pregnancy',
      'medications',
      'allergies',
      'sun_exposure',
      'makeup_spf',
      'routine_level',
      'actives_experience',
      'fragrance_pref',
      'body_skin',
      'body_concerns',
      'hair_type',
      'scalp',
      'hair_concerns',
      'heat_styling',
      'wash_frequency',
      'hair_treated',
      'warning_signs',
    ]);
    // The age comes from the birth year; under 18 cannot sign up.
    expect(quizQuestion('age_range'), isNull);
    for (final q in quizQuestions.where((q) => q.id != 'warning_signs')) {
      for (final language in supportedLanguages) {
        expect(q.why[language], isNotEmpty, reason: '${q.id} $language');
      }
    }
    expect(
      [for (final q in quizQuestions.where((q) => q.sensitive)) q.id],
      ['pregnancy', 'medications', 'allergies'],
    );
  });
}
