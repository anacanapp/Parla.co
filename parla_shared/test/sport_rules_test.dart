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
      _a(types: ['fitness', 'cardio'], days: 4, minutes: 40),
    );
    expect(plan.workouts.map((w) => w.type), [
      'fitness',
      'cardio',
      'fitness',
      'cardio',
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

  test('each section plans only with its own types and ids', () {
    final mixed = _a(types: ['fitness', 'pilates', 'cardio'], days: 3);
    final fitness = planSport(mixed);
    expect(fitness.workouts.map((w) => w.type), [
      'fitness',
      'cardio',
      'fitness',
    ]);
    for (final (section, prefix) in [('pilates', 'p'), ('wall_pilates', 'v')]) {
      final plan = planSport(mixed, section: section);
      expect(plan.workouts.map((w) => w.id), [
        '${prefix}1',
        '${prefix}2',
        '${prefix}3',
      ]);
      expect(plan.workouts.map((w) => w.type).toSet(), {section});
      // Short of moves (safety), a section fills with stretching only.
      expect(
        _all(
          plan,
        ).map((e) => e.type).toSet().difference({section, 'stretching'}),
        isEmpty,
      );
    }
    // A section without any of its types still plans its own type.
    expect(
      planSport(_a(types: ['pilates']), section: 'fitness').workouts.first.type,
      'fitness',
    );
  });

  test('a workout id names its section', () {
    expect(SportOptions.sectionOfWorkout('w2'), 'fitness');
    expect(SportOptions.sectionOfWorkout('p1'), 'pilates');
    expect(SportOptions.sectionOfWorkout('v3'), 'wall_pilates');
    expect(SportOptions.sectionOfWorkout('yoga_evening'), 'yoga');
    expect(SportOptions.sectionOfWorkout('face_yoga'), 'face_yoga');
  });

  test('sections share the latest safety answers', () {
    final pilates = _a(types: ['pilates']);
    final latest = _a(pregnancy: 'pregnant', injuries: {'knee'});
    final synced = pilates.withSafetyOf(latest);
    expect(synced.pregnancy, 'pregnant');
    expect(synced.injuries, {'knee'});
    expect(synced.types, ['pilates']);
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

    test('the video sound switch is a bool', () {
      Map<String, Object?> base() =>
          jsonDecode(doc(_a().toJson())) as Map<String, Object?>;
      expect(
        SportRules.isValid(jsonEncode({...base(), 'videoSound': false})),
        isTrue,
      );
      expect(
        SportRules.isValid(jsonEncode({...base(), 'videoSound': 'on'})),
        isFalse,
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

    test('other sections are stored beside the fitness answers', () {
      String withSections(Map<String, Object?> sections) => jsonEncode({
        'format': 1,
        'answers': _a().toJson(),
        'sections': sections,
        'log': {
          '2026-11-15': ['w1', 'p1', 'v2', 'yoga_evening'],
        },
        'sound': true,
      });
      expect(
        SportRules.isValid(
          withSections({
            'pilates': _a(types: ['pilates']).toJson(),
            'wall_pilates': _a(types: ['wall_pilates']).toJson(),
          }),
        ),
        isTrue,
      );
      // Fitness lives in "answers"; unknown sections and foreign types are
      // refused.
      expect(
        SportRules.isValid(withSections({'fitness': _a().toJson()})),
        isFalse,
      );
      expect(
        SportRules.isValid(withSections({'yoga': _a().toJson()})),
        isFalse,
      );
      expect(
        SportRules.isValid(withSections({'pilates': _a().toJson()})),
        isFalse,
      );
    });
  });

  group('monthly plan', () {
    test('suggested weekdays leave rest days and chosen ones round-trip', () {
      expect(_a(days: 3).weekdays, [1, 3, 5]);
      expect(_a(days: 7).weekdays, [1, 2, 3, 4, 5, 6, 7]);
      final chosen = SportAnswers.fromJson({
        ..._a(days: 2).toJson(),
        'weekdays': [6, 2],
        'start': '2026-11-23',
      });
      expect(chosen.weekdays, [2, 6]);
      expect(chosen.start, '2026-11-23');
      // A list that does not match the day count falls back.
      expect(
        SportAnswers.fromJson({
          ..._a(days: 3).toJson(),
          'weekdays': [1],
        }).weekdays,
        [1, 3, 5],
      );
    });

    test('the stored document checks weekdays, start and 7 workouts', () {
      String doc(Map<String, Object?> answers) => jsonEncode({
        'format': SportRules.format,
        'answers': answers,
        'log': {
          '2026-11-23': ['w7'],
        },
      });
      final ok = {..._a(days: 7).toJson(), 'start': '2026-11-23'};
      expect(SportRules.isValid(doc(ok)), isTrue);
      expect(
        SportRules.isValid(
          doc({
            ...ok,
            'weekdays': [1, 2],
          }),
        ),
        isFalse,
      );
      expect(
        SportRules.isValid(
          doc({
            ...ok,
            'weekdays': [1, 1, 2, 3, 4, 5, 6],
          }),
        ),
        isFalse,
      );
      expect(SportRules.isValid(doc({...ok, 'start': 'soon'})), isFalse);
      expect(SportRules.isValid(doc({..._a(days: 6).toJson()})), isFalse);
      // Documents from before the monthly plan stay valid.
      final old = _a().toJson()..remove('weekdays');
      expect(SportRules.isValid(doc(old)), isTrue);
    });

    test('every day has two light stretching days', () {
      final plan = planSport(_a(days: 7, minutes: 40));
      expect(plan.workouts, hasLength(7));
      expect(plan.workouts.map((w) => w.id).last, 'w7');
      expect(plan.workouts[2].type, 'stretching');
      expect(plan.workouts[5].type, 'stretching');
      expect(plan.workouts[0].type, 'fitness');
    });

    test('doses grow in weeks 2 and 3 and ease off in week 4', () {
      int reps(int week) => planSport(_a(), week: week).workouts.first.items
          .firstWhere((i) => i.exercise.mode == ExerciseMode.reps)
          .amount;
      expect(reps(1), reps(0) + 1);
      expect(reps(2), reps(0) + 2);
      expect(reps(3), reps(0) - 2);
      // The gentle plan does not grow.
      int gentle(int week) => planSport(
        _a(pregnancy: 'pregnant'),
        week: week,
      ).workouts.first.items.first.amount;
      expect(gentle(2), gentle(0));
    });

    test('the month maps dates to workouts and rest days', () {
      final a = SportAnswers.fromJson({
        ..._a(days: 3).toJson(),
        'start': '2026-11-25',
      });
      final start = SportMonth.startOf(a)!;
      expect(SportMonth.indexOf(start, DateTime(2026, 11, 24)), isNull);
      expect(SportMonth.indexOf(start, DateTime(2026, 11, 25, 23)), 0);
      expect(SportMonth.indexOf(start, DateTime(2026, 12, 22)), 27);
      expect(SportMonth.indexOf(start, DateTime(2026, 12, 23)), isNull);
      expect(SportMonth.weekOf(20), 2);
      // 25 Nov 2026 is a Wednesday: the second workout (Mon, Wed, Fri).
      expect(SportMonth.workoutOn(a, start, DateTime(2026, 11, 25)), 1);
      expect(SportMonth.workoutOn(a, start, DateTime(2026, 11, 26)), isNull);
      expect(SportMonth.workoutOn(a, start, DateTime(2026, 11, 27)), 2);
      expect(SportMonth.keyOf(DateTime(2026, 3, 4)), '2026-03-04');
    });
  });
}
