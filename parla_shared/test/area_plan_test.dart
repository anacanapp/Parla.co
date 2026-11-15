import 'package:parla_shared/parla_shared.dart';
import 'package:test/test.dart';

QuizAnswers _a(Map<String, List<String>> chosen) => QuizAnswers(chosen: chosen);

void main() {
  group('hair', () {
    test('without answers: detangle every morning, wash day once a week', () {
      final plan = planHair(null);
      expect(plan.morning, ['hair-detangle']);
      expect(plan.evening, isEmpty);
      expect(plan.weekly, ['hair-wash', 'hair-conditioner']);
    });

    test('dry or curly hair adds a leave-in and a weekly mask', () {
      final plan = planHair(
        _a({
          'hair_type': ['curly'],
          'hair_concerns': ['dryness'],
        }),
      );
      expect(plan.morning, contains('hair-leave-in'));
      expect(plan.weekly, contains('hair-mask'));
      expect(plan.evening, ['hair-night-protect']);
    });

    test('oily hair gets scalp care and no leave-in', () {
      final plan = planHair(
        _a({
          'hair_type': ['straight'],
          'hair_concerns': ['oiliness', 'frizz'],
        }),
      );
      expect(plan.morning, isNot(contains('hair-leave-in')));
      expect(plan.weekly, contains('hair-scalp-care'));
    });
  });

  group('body', () {
    test('everyone gets shower, lotion and hands and feet care', () {
      final plan = planBody(null);
      expect(plan.morning, contains('body-shower'));
      expect(plan.evening, ['body-lotion']);
      expect(plan.weekly, contains('body-hands-feet'));
    });

    test('sensitive skin skips the scrub', () {
      final plan = planBody(
        _a({
          'skin_sensitivity': ['often'],
        }),
      );
      expect(plan.weekly, isNot(contains('body-scrub')));
    });

    test('mostly indoors skips body sunscreen', () {
      expect(
        planBody(
          _a({
            'sun_exposure': ['indoors'],
          }),
        ).morning,
        isNot(contains('body-sunscreen')),
      );
      expect(planBody(null).morning, contains('body-sunscreen'));
    });
  });

  test('face keeps its morning and evening plan and has no weekly steps', () {
    final face = planArea(RoutineArea.face, null);
    expect(face.morning, defaultRoutinePlan.morning);
    expect(face.weekly, isEmpty);
  });

  test('every area plan uses unique step ids across areas', () {
    final answers = _a({
      'hair_type': ['coily'],
      'hair_concerns': ['dryness', 'breakage'],
    });
    final ids = <String>[
      for (final area in RoutineArea.values)
        for (final slot in RoutineSlot.values)
          ...planArea(area, answers).slot(slot),
    ];
    expect(ids.toSet().length, ids.length);
  });
}
