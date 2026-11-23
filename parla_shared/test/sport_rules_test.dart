import 'dart:convert';

import 'package:parla_shared/parla_shared.dart';
import 'package:test/test.dart';

SportAnswers _a({
  List<String> goals = const ['tone'],
  Set<String> areas = const {'full'},
  List<String> types = const ['fitness'],
  String level = 'intermediate',
  int days = 3,
  int minutes = 25,
  bool dumbbells = false,
  String pregnancy = 'no',
  Set<String> injuries = const {},
  bool doctorLimit = false,
}) => SportAnswers(
  goals: goals,
  areas: areas,
  types: types,
  level: level,
  days: days,
  minutes: minutes,
  dumbbells: dumbbells,
  pregnancy: pregnancy,
  injuries: injuries,
  doctorLimit: doctorLimit,
);

Iterable<Exercise> _all(SportPlan p) =>
    p.workouts.expand((w) => w.items.map((i) => i.exercise));

void main() {
  test('catalogue ids are unique and types and areas are known', () {
    final ids = [for (final e in exerciseCatalogue) e.id];
    expect(ids.toSet(), hasLength(ids.length));
    for (final e in exerciseCatalogue) {
      expect(
        [...SportOptions.types, ...SportOptions.sessionTypes],
        contains(e.type),
        reason: e.id,
      );
      expect(
        e.areas.every(
          [...SportOptions.areas, ...SportOptions.sessionAreas].contains,
        ),
        isTrue,
        reason: e.id,
      );
    }
    for (final type in SportOptions.types) {
      expect(
        exerciseCatalogue.where((e) => e.type == type).length,
        greaterThanOrEqualTo(5),
        reason: type,
      );
    }
  });

  test('face yoga is one fixed session, never part of a plan', () {
    final w = fixedWorkoutById(faceYogaWorkoutId)!;
    expect(w.type, 'face_yoga');
    expect(w.items, hasLength(12));
    expect(
      w.items.map((i) => i.exercise.id),
      exerciseCatalogue.where((e) => e.type == 'face_yoga').map((e) => e.id),
    );
    expect(w.minutes, inInclusiveRange(10, 15));
    for (final types in [
      ['fitness'],
      ['stretching'],
      [...SportOptions.types],
    ]) {
      final plan = planSport(_a(types: types, days: 5, minutes: 40));
      expect(_all(plan).where((e) => e.type == 'face_yoga'), isEmpty);
    }
    expect(fixedWorkoutById('w1'), isNull);
    // A finished face yoga session may be stored in the log.
    final doc = jsonEncode({
      'format': SportRules.format,
      'log': {
        '2026-11-23': ['w1', faceYogaWorkoutId],
      },
    });
    expect(SportRules.isValid(doc), isTrue);
  });

  test('three yoga sessions, never in a plan; safety answers trim them', () {
    expect(yogaWorkouts.map((w) => w.id), [
      'yoga_morning',
      'yoga_evening',
      'yoga_stretch',
    ]);
    for (final w in yogaWorkouts) {
      expect(fixedWorkoutById(w.id), same(w));
      expect(w.minutes, inInclusiveRange(8, 20), reason: w.id);
    }
    final plan = planSport(
      _a(types: [...SportOptions.types], days: 5, minutes: 40),
    );
    expect(_all(plan).where((e) => e.type == 'yoga'), isEmpty);
    final morning = fixedWorkoutById('yoga_morning')!;
    expect(withoutAvoided(morning, null), same(morning));
    final pregnant = withoutAvoided(morning, _a(pregnancy: 'pregnant'));
    final ids = pregnant.items.map((i) => i.exercise.id);
    expect(ids, isNot(contains('yoga_cobra')));
    expect(ids, isNot(contains('yoga_down_dog')));
    expect(ids, contains('yoga_mountain'));
    final wrist = withoutAvoided(morning, _a(injuries: {'wrist'}));
    expect(
      wrist.items.map((i) => i.exercise.id),
      isNot(contains('yoga_down_dog')),
    );
    final doc = jsonEncode({
      'format': SportRules.format,
      'log': {
        '2026-11-23': ['w1', 'face_yoga', 'yoga_morning', 'yoga_evening'],
      },
    });
    expect(SportRules.isValid(doc), isTrue);
  });

  test('one workout per day, types rotate, length follows minutes', () {
    final plan = planSport(
      _a(types: ['fitness', 'pilates', 'wall_pilates'], days: 4, minutes: 40),
    );
    expect(plan.workouts.map((w) => w.type), [
      'fitness',
      'pilates',
      'wall_pilates',
      'fitness',
    ]);
    expect(plan.workouts.map((w) => w.id), ['w1', 'w2', 'w3', 'w4']);
    for (final w in plan.workouts) {
      expect(w.items, hasLength(9));
      expect(w.items.map((i) => i.exercise.id).toSet(), hasLength(9));
    }
    expect(planSport(_a(minutes: 15)).workouts.first.items, hasLength(5));
  });

  test('exercises hidden by the team are never picked', () {
    final all = planSport(_a(days: 5, minutes: 40));
    final used = {
      for (final w in all.workouts)
        for (final i in w.items) i.exercise.id,
    };
    final hide = used.take(3).toSet();
    final plan = planSport(_a(days: 5, minutes: 40), exclude: hide);
    for (final w in plan.workouts) {
      expect(w.items, isNotEmpty);
      for (final i in w.items) {
        expect(hide, isNot(contains(i.exercise.id)));
      }
    }
  });

  test('chosen areas come first', () {
    final plan = planSport(_a(areas: {'arms'}, dumbbells: true));
    final first = plan.workouts.first.items.take(3);
    expect(first.every((i) => i.exercise.areas.contains('arms')), isTrue);
  });

  test('muscle gain means fewer, heavier sets with longer rest', () {
    final muscle = planSport(_a(goals: ['muscle'], level: 'advanced'));
    final item = muscle.workouts.first.items.firstWhere(
      (i) => i.exercise.mode == ExerciseMode.reps,
    );
    expect(item.sets, 4);
    expect(item.amount, 8);
    expect(item.restSeconds, 60);
  });

  test(
    'without dumbbells no dumbbell exercise; beginners get no hard ones',
    () {
      final plan = planSport(_a(level: 'beginner', areas: {'arms', 'legs'}));
      expect(_all(plan).any((e) => e.dumbbells), isFalse);
      expect(_all(plan).every((e) => e.level == 0), isTrue);
    },
  );

  test('injuries remove the exercises that load them', () {
    final plan = planSport(
      _a(injuries: {'knee', 'wrist'}, types: ['fitness', 'cardio'], days: 4),
    );
    for (final e in _all(plan)) {
      expect(
        e.avoid.contains('knee') || e.avoid.contains('wrist'),
        isFalse,
        reason: e.id,
      );
    }
  });

  test('pregnancy and after birth give a gentle plan', () {
    for (final p in ['pregnant', 'postpartum']) {
      final plan = planSport(
        _a(pregnancy: p, level: 'advanced', types: ['fitness', 'pilates']),
      );
      expect(plan.gentle, isTrue);
      expect(plan.workouts, isNotEmpty);
      for (final e in _all(plan)) {
        expect(e.avoid, isNot(contains('pregnancy')), reason: e.id);
        expect(e.level, 0, reason: e.id);
      }
    }
  });

  test("a doctor's limit builds no plan", () {
    final plan = planSport(_a(doctorLimit: true));
    expect(plan.blocked, isTrue);
    expect(plan.workouts, isEmpty);
  });

  group('stored document', () {
    String doc(Object? answers, {Object? log}) => jsonEncode({
      'format': 1,
      'answers': answers,
      'log': log ?? {},
      'sound': true,
    });

    test('valid answers and log pass', () {
      expect(
        SportRules.isValid(
          doc(
            _a().toJson(),
            log: {
              '2026-11-15': ['w1'],
            },
          ),
        ),
        isTrue,
      );
    });

    test('unknown options, fields and workout ids are refused', () {
      expect(
        SportRules.isValid(doc({..._a().toJson(), 'weight': 60})),
        isFalse,
      );
      expect(
        SportRules.isValid(
          doc({
            ..._a().toJson(),
            'goals': ['slim_arms'],
          }),
        ),
        isFalse,
      );
      expect(
        SportRules.isValid(
          doc({
            ..._a().toJson(),
            'goals': ['tone', 'muscle', 'relax'],
          }),
        ),
        isFalse,
      );
      expect(
        SportRules.isValid(
          doc(
            _a().toJson(),
            log: {
              '2026-11-15': ['x'],
            },
          ),
        ),
        isFalse,
      );
    });
  });
}
