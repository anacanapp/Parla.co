/// Workout plan rules for the Fitness tab: the questions, the exercise
/// catalogue and how a weekly plan is built from the answers.
///
/// Rules (product decision):
/// - Goals talk about tone and strength, never about "slimming" a body part:
///   spot reduction is not possible and must not be promised.
/// - Safety answers (pregnancy, after birth, injuries, a doctor's limit)
///   remove exercises; a doctor's limit builds no plan at all.
/// - Texts and numbers are drafts by the Parla team, NOT REVIEWED by a
///   trainer or physiotherapist yet.
library;

import 'dart:convert';

/// Question option ids.
abstract final class SportOptions {
  static const goals = [
    'tone',
    'muscle',
    'flexibility',
    'posture',
    'endurance',
    'relax',
  ];
  static const areas = ['arms', 'legs', 'core', 'glutes', 'back', 'full'];
  static const types = [
    'fitness',
    'pilates',
    'wall_pilates',
    'stretching',
    'cardio',
  ];
  static const levels = ['beginner', 'intermediate', 'advanced'];
  static const days = [2, 3, 4, 5];
  static const minutes = [15, 25, 40];
  static const pregnancy = ['no', 'pregnant', 'postpartum'];
  static const injuries = ['knee', 'back', 'shoulder', 'wrist'];

  static const maxGoals = 2;

  /// Types with a fixed session instead of a weekly plan. They are not
  /// asked about in the questions and the plan never picks them.
  static const sessionTypes = ['face_yoga', 'yoga'];

  /// Areas of the fixed sessions (not asked about in the questions).
  static const sessionAreas = ['face'];
}

/// The answers to the sport questions.
class SportAnswers {
  const SportAnswers({
    required this.goals,
    required this.areas,
    required this.types,
    required this.level,
    required this.days,
    required this.minutes,
    this.dumbbells = false,
    this.pregnancy = 'no',
    this.injuries = const {},
    this.doctorLimit = false,
  });

  factory SportAnswers.fromJson(Map<String, Object?> json) => SportAnswers(
    goals: [...(json['goals'] as List? ?? const []).cast<String>()],
    areas: {...(json['areas'] as List? ?? const []).cast<String>()},
    types: [...(json['types'] as List? ?? const []).cast<String>()],
    level: json['level'] as String? ?? 'beginner',
    days: (json['days'] as num?)?.toInt() ?? 3,
    minutes: (json['minutes'] as num?)?.toInt() ?? 25,
    dumbbells: json['dumbbells'] as bool? ?? false,
    pregnancy: json['pregnancy'] as String? ?? 'no',
    injuries: {...(json['injuries'] as List? ?? const []).cast<String>()},
    doctorLimit: json['doctorLimit'] as bool? ?? false,
  );

  /// One or two goals, the first is the main one.
  final List<String> goals;
  final Set<String> areas;

  /// Workout types in the order they rotate through the week.
  final List<String> types;
  final String level;
  final int days;
  final int minutes;
  final bool dumbbells;
  final String pregnancy;
  final Set<String> injuries;

  /// A doctor said not to exercise, or to ask first.
  final bool doctorLimit;

  int get levelIndex => SportOptions.levels.indexOf(level).clamp(0, 2);

  Map<String, Object?> toJson() => {
    'goals': goals,
    'areas': [
      for (final a in SportOptions.areas)
        if (areas.contains(a)) a,
    ],
    'types': types,
    'level': level,
    'days': days,
    'minutes': minutes,
    'dumbbells': dumbbells,
    'pregnancy': pregnancy,
    'injuries': [
      for (final i in SportOptions.injuries)
        if (injuries.contains(i)) i,
    ],
    'doctorLimit': doctorLimit,
  };
}

/// How an exercise is counted.
enum ExerciseMode {
  /// Sets of repetitions.
  reps,

  /// Holding a position for some seconds.
  hold,

  /// Moving for some seconds.
  timed,
}

/// One exercise in the catalogue.
class Exercise {
  const Exercise(
    this.id,
    this.type,
    this.areas, {
    this.mode = ExerciseMode.reps,
    this.level = 0,
    this.dumbbells = false,
    this.avoid = const {},
  });

  final String id;
  final String type;
  final Set<String> areas;
  final ExerciseMode mode;

  /// The lowest level it suits (0 beginner, 1 intermediate, 2 advanced).
  final int level;

  /// Needs dumbbells.
  final bool dumbbells;

  /// Left out for these: injuries, 'pregnancy' (also after birth).
  final Set<String> avoid;
}

const _p = 'pregnancy';

/// Every exercise, in a stable order. Text in the app by [Exercise.id].
const exerciseCatalogue = <Exercise>[
  // Fitness: strength and tone.
  Exercise('squat', 'fitness', {'legs', 'glutes'}, avoid: {'knee'}),
  Exercise('sumo_squat', 'fitness', {'legs', 'glutes'}, avoid: {'knee'}),
  Exercise(
    'reverse_lunge',
    'fitness',
    {'legs', 'glutes'},
    level: 1,
    avoid: {'knee', _p},
  ),
  Exercise('glute_bridge', 'fitness', {'glutes', 'back'}, avoid: {_p}),
  Exercise('donkey_kick', 'fitness', {'glutes'}, avoid: {'wrist'}),
  Exercise('calf_raise', 'fitness', {'legs'}),
  Exercise(
    'knee_pushup',
    'fitness',
    {'arms', 'core'},
    avoid: {'wrist', 'shoulder', _p},
  ),
  Exercise(
    'pushup',
    'fitness',
    {'arms', 'core'},
    level: 2,
    avoid: {'wrist', 'shoulder', _p},
  ),
  Exercise(
    'chair_dip',
    'fitness',
    {'arms'},
    level: 1,
    avoid: {'shoulder', 'wrist'},
  ),
  Exercise('db_row', 'fitness', {'back', 'arms'}, dumbbells: true),
  Exercise(
    'db_press',
    'fitness',
    {'arms'},
    dumbbells: true,
    avoid: {'shoulder'},
  ),
  Exercise('db_curl', 'fitness', {'arms'}, dumbbells: true),
  Exercise(
    'db_deadlift',
    'fitness',
    {'legs', 'glutes', 'back'},
    level: 1,
    dumbbells: true,
    avoid: {'back', _p},
  ),
  Exercise(
    'plank',
    'fitness',
    {'core'},
    mode: ExerciseMode.hold,
    avoid: {'wrist', 'shoulder', _p},
  ),
  Exercise(
    'side_plank',
    'fitness',
    {'core'},
    mode: ExerciseMode.hold,
    level: 1,
    avoid: {'shoulder', _p},
  ),
  Exercise('dead_bug', 'fitness', {'core'}, avoid: {_p}),
  Exercise('superman', 'fitness', {'back'}, avoid: {'back', _p}),
  // Added from the content sheet ("hereketler").
  Exercise(
    'side_lunge',
    'fitness',
    {'legs', 'glutes'},
    level: 1,
    avoid: {'knee', _p},
  ),
  Exercise('step_up', 'fitness', {'legs', 'glutes'}, avoid: {'knee'}),
  Exercise(
    'bicycle_crunch',
    'fitness',
    {'core'},
    level: 1,
    avoid: {'back', _p},
  ),
  // Pilates on a mat.
  Exercise(
    'pil_hundred',
    'pilates',
    {'core'},
    mode: ExerciseMode.timed,
    level: 1,
    avoid: {'back', _p},
  ),
  Exercise('pil_single_leg_stretch', 'pilates', {'core'}, avoid: {_p}),
  Exercise(
    'pil_criss_cross',
    'pilates',
    {'core'},
    level: 1,
    avoid: {'back', _p},
  ),
  Exercise('pil_leg_circles', 'pilates', {'legs', 'core'}, avoid: {_p}),
  Exercise(
    'pil_swimming',
    'pilates',
    {'back', 'glutes'},
    mode: ExerciseMode.timed,
    avoid: {'back', _p},
  ),
  Exercise('pil_side_kick', 'pilates', {'legs', 'glutes'}),
  Exercise('pil_clam', 'pilates', {'glutes'}),
  Exercise('pil_roll_down', 'pilates', {'back', 'core'}, avoid: {'back'}),
  Exercise(
    'pil_bird_dog',
    'pilates',
    {'core', 'back', 'glutes'},
    avoid: {'wrist'},
  ),
  // Wall pilates.
  Exercise(
    'wall_sit',
    'wall_pilates',
    {'legs', 'glutes'},
    mode: ExerciseMode.hold,
    avoid: {'knee'},
  ),
  Exercise('wall_bridge', 'wall_pilates', {'glutes', 'legs'}, avoid: {_p}),
  Exercise('wall_pushup', 'wall_pilates', {'arms'}, avoid: {'wrist'}),
  Exercise('wall_angel', 'wall_pilates', {'back', 'arms'}, avoid: {'shoulder'}),
  Exercise('wall_side_leg_lift', 'wall_pilates', {'legs', 'glutes'}),
  Exercise('wall_calf_raise', 'wall_pilates', {'legs'}),
  Exercise('wall_roll_down', 'wall_pilates', {'back', 'core'}, avoid: {'back'}),
  // Stretching.
  Exercise('cat_cow', 'stretching', {'back'}, mode: ExerciseMode.timed),
  Exercise(
    'child_pose',
    'stretching',
    {'back'},
    mode: ExerciseMode.hold,
    avoid: {'knee'},
  ),
  Exercise('hamstring_stretch', 'stretching', {
    'legs',
  }, mode: ExerciseMode.hold),
  Exercise(
    'hip_flexor_stretch',
    'stretching',
    {'legs', 'glutes'},
    mode: ExerciseMode.hold,
    avoid: {'knee'},
  ),
  Exercise('chest_opener', 'stretching', {
    'arms',
    'back',
  }, mode: ExerciseMode.hold),
  Exercise('figure_four', 'stretching', {'glutes'}, mode: ExerciseMode.hold),
  Exercise('side_stretch', 'stretching', {
    'core',
    'back',
  }, mode: ExerciseMode.hold),
  // Low-impact cardio.
  Exercise('march', 'cardio', {'legs'}, mode: ExerciseMode.timed),
  Exercise('step_jack', 'cardio', {'legs', 'arms'}, mode: ExerciseMode.timed),
  Exercise(
    'knee_drive',
    'cardio',
    {'legs', 'core'},
    mode: ExerciseMode.timed,
    avoid: {'knee'},
  ),
  Exercise(
    'boxer_step',
    'cardio',
    {'arms', 'core'},
    mode: ExerciseMode.timed,
    avoid: {'shoulder'},
  ),
  Exercise(
    'mountain_climber',
    'cardio',
    {'core', 'legs'},
    mode: ExerciseMode.timed,
    level: 1,
    avoid: {'wrist', 'shoulder', _p},
  ),
  Exercise(
    'jumping_jack',
    'cardio',
    {'legs', 'arms'},
    mode: ExerciseMode.timed,
    level: 1,
    avoid: {'knee', _p},
  ),
  Exercise(
    'high_knees',
    'cardio',
    {'legs', 'core'},
    mode: ExerciseMode.timed,
    level: 2,
    avoid: {'knee', _p},
  ),
  Exercise(
    'skater_step',
    'cardio',
    {'legs', 'glutes'},
    mode: ExerciseMode.timed,
    level: 1,
    avoid: {'knee', _p},
  ),
  // Face yoga: one fixed session (faceYogaWorkout), never in a plan.
  Exercise('fy_forehead_smooth', 'face_yoga', {
    'face',
  }, mode: ExerciseMode.timed),
  Exercise('fy_brow_lift', 'face_yoga', {'face'}, mode: ExerciseMode.hold),
  Exercise('fy_eye_v', 'face_yoga', {'face'}, mode: ExerciseMode.hold),
  Exercise('fy_cheek_lift', 'face_yoga', {'face'}, mode: ExerciseMode.hold),
  Exercise('fy_fish_face', 'face_yoga', {'face'}, mode: ExerciseMode.hold),
  Exercise('fy_air_puff', 'face_yoga', {'face'}, mode: ExerciseMode.timed),
  Exercise('fy_jaw_release', 'face_yoga', {'face'}, mode: ExerciseMode.timed),
  Exercise('fy_neck_kiss', 'face_yoga', {'face'}, mode: ExerciseMode.hold),
  Exercise('fy_vowels', 'face_yoga', {'face'}, mode: ExerciseMode.timed),
  Exercise('fy_lion_face', 'face_yoga', {'face'}, mode: ExerciseMode.hold),
  Exercise('fy_temple_circles', 'face_yoga', {
    'face',
  }, mode: ExerciseMode.timed),
  Exercise('fy_smile_lines', 'face_yoga', {'face'}, mode: ExerciseMode.hold),
  // Yoga: three fixed sessions (yogaWorkouts), never in a plan. Gentle,
  // beginner poses only: no inversions, no deep backbends.
  Exercise('yoga_mountain', 'yoga', {'full'}, mode: ExerciseMode.hold),
  Exercise('yoga_arms_up', 'yoga', {'back', 'arms'}, mode: ExerciseMode.timed),
  Exercise('yoga_forward_fold', 'yoga', {
    'legs',
    'back',
  }, mode: ExerciseMode.hold),
  Exercise('yoga_low_lunge', 'yoga', {'legs'}, mode: ExerciseMode.hold),
  Exercise(
    'yoga_down_dog',
    'yoga',
    {'arms', 'legs', 'back'},
    mode: ExerciseMode.hold,
    avoid: {'wrist', 'shoulder', _p},
  ),
  Exercise(
    'yoga_cobra',
    'yoga',
    {'back'},
    mode: ExerciseMode.hold,
    avoid: {'back', _p},
  ),
  Exercise('yoga_warrior2', 'yoga', {'legs', 'core'}, mode: ExerciseMode.hold),
  Exercise('yoga_tree', 'yoga', {'legs', 'core'}, mode: ExerciseMode.hold),
  Exercise('yoga_triangle', 'yoga', {'legs', 'core'}, mode: ExerciseMode.hold),
  Exercise('yoga_seated_twist', 'yoga', {'back'}, mode: ExerciseMode.hold),
  Exercise('yoga_reclined_twist', 'yoga', {
    'back',
    'glutes',
  }, mode: ExerciseMode.hold),
  Exercise('yoga_savasana', 'yoga', {'full'}, mode: ExerciseMode.timed),
];

/// Id of the face yoga session (also in the log of finished workouts).
const faceYogaWorkoutId = 'face_yoga';

/// The face yoga session: the 12 moves with the doses of the content
/// document ("Üz yoqası: tətbiq məzmunu", 2026-11-22). Amounts are seconds;
/// a set is one hold or one timed round. DRAFT, NOT REVIEWED by a
/// cosmetologist or dermatologist yet.
final faceYogaWorkout = Workout(
  id: faceYogaWorkoutId,
  type: 'face_yoga',
  focus: const ['face'],
  items: [
    for (final (id, sets, seconds, rest) in const [
      ('fy_forehead_smooth', 3, 30, 10),
      ('fy_brow_lift', 5, 10, 5),
      ('fy_eye_v', 5, 3, 5),
      ('fy_cheek_lift', 5, 10, 5),
      ('fy_fish_face', 3, 10, 5),
      ('fy_air_puff', 1, 30, 5),
      ('fy_jaw_release', 1, 30, 5),
      ('fy_neck_kiss', 5, 10, 5),
      ('fy_vowels', 2, 10, 5),
      ('fy_lion_face', 3, 3, 5),
      ('fy_temple_circles', 1, 30, 5),
      ('fy_smile_lines', 5, 10, 5),
    ])
      WorkoutItem(
        exercise: exerciseById(id)!,
        sets: sets,
        amount: seconds,
        restSeconds: rest,
      ),
  ],
);

/// A yoga session from (exercise id, sets, seconds, rest). A one-sided pose
/// has 2 sets: one for each side.
Workout _yoga(String id, List<(String, int, int, int)> items) => Workout(
  id: id,
  type: 'yoga',
  focus: const ['full'],
  items: [
    for (final (exercise, sets, seconds, rest) in items)
      WorkoutItem(
        exercise: exerciseById(exercise)!,
        sets: sets,
        amount: seconds,
        restSeconds: rest,
      ),
  ],
);

/// The yoga sessions: morning flow, evening calm and a stretch. DRAFT, NOT
/// REVIEWED by a yoga teacher yet.
final yogaWorkouts = [
  _yoga('yoga_morning', const [
    ('yoga_mountain', 1, 30, 5),
    ('yoga_arms_up', 1, 30, 5),
    ('yoga_forward_fold', 1, 30, 5),
    ('yoga_low_lunge', 2, 30, 5),
    ('yoga_down_dog', 1, 30, 10),
    ('yoga_cobra', 2, 20, 10),
    ('child_pose', 1, 40, 5),
    ('yoga_warrior2', 2, 30, 5),
    ('yoga_tree', 2, 30, 5),
    ('yoga_savasana', 1, 90, 0),
  ]),
  _yoga('yoga_evening', const [
    ('cat_cow', 1, 45, 5),
    ('child_pose', 1, 45, 5),
    ('yoga_seated_twist', 2, 30, 5),
    ('hamstring_stretch', 1, 45, 5),
    ('figure_four', 2, 30, 5),
    ('yoga_reclined_twist', 2, 30, 5),
    ('yoga_savasana', 1, 120, 0),
  ]),
  _yoga('yoga_stretch', const [
    ('yoga_arms_up', 1, 30, 5),
    ('yoga_forward_fold', 1, 40, 5),
    ('yoga_low_lunge', 2, 30, 5),
    ('yoga_triangle', 2, 30, 5),
    ('side_stretch', 1, 40, 5),
    ('chest_opener', 1, 40, 5),
    ('hip_flexor_stretch', 2, 30, 5),
    ('yoga_reclined_twist', 2, 30, 5),
    ('yoga_savasana', 1, 60, 0),
  ]),
];

/// Every fixed session (face yoga and the yoga sessions).
final fixedWorkouts = [faceYogaWorkout, ...yogaWorkouts];

/// [w] without the moves [a]'s safety answers leave out (injuries,
/// pregnancy or after birth), like the weekly plan does.
Workout withoutAvoided(Workout w, SportAnswers? a) {
  if (a == null) return w;
  final avoid = {...a.injuries, if (a.pregnancy != 'no') _p};
  if (avoid.isEmpty) return w;
  return Workout(
    id: w.id,
    type: w.type,
    focus: w.focus,
    items: [
      for (final i in w.items)
        if (i.exercise.avoid.intersection(avoid).isEmpty) i,
    ],
  );
}

/// The fixed sessions, by id.
Workout? fixedWorkoutById(String id) {
  for (final w in fixedWorkouts) {
    if (w.id == id) return w;
  }
  return null;
}

Exercise? exerciseById(String id) {
  for (final e in exerciseCatalogue) {
    if (e.id == id) return e;
  }
  return null;
}

/// One exercise in a workout with how much of it.
class WorkoutItem {
  const WorkoutItem({
    required this.exercise,
    required this.sets,
    required this.amount,
    required this.restSeconds,
  });

  final Exercise exercise;
  final int sets;

  /// Repetitions, or seconds for hold and timed exercises.
  final int amount;
  final int restSeconds;

  /// Rough length of the item in seconds (3 s per repetition).
  int get seconds {
    final work = exercise.mode == ExerciseMode.reps ? amount * 3 : amount;
    return sets * work + (sets - 1) * restSeconds;
  }
}

class Workout {
  const Workout({
    required this.id,
    required this.type,
    required this.focus,
    required this.items,
  });

  /// "w1" … "w5", stable for the same answers.
  final String id;
  final String type;

  /// The areas this workout leans on.
  final List<String> focus;
  final List<WorkoutItem> items;

  int get minutes =>
      (items.fold(0, (sum, i) => sum + i.seconds + 20) / 60).ceil();
}

class SportPlan {
  const SportPlan(this.workouts, {this.blocked = false, this.gentle = false});

  final List<Workout> workouts;

  /// A doctor's limit: no plan, the app asks to talk to the doctor first.
  final bool blocked;

  /// Gentle plan (pregnancy or after birth): ask the doctor too.
  final bool gentle;
}

/// Builds the weekly plan for [a].
/// The weekly plan for [a]. Exercises in [exclude] (hidden by the team in
/// the admin panel) are never picked.
SportPlan planSport(SportAnswers a, {Set<String> exclude = const {}}) {
  if (a.doctorLimit) return const SportPlan([], blocked: true);
  final gentle = a.pregnancy != 'no';
  final avoid = {...a.injuries, if (gentle) _p};
  final level = gentle ? 0 : a.levelIndex;
  final types = a.types.where(SportOptions.types.contains).toList();
  if (types.isEmpty) types.add('fitness');
  final focusAll = a.areas.isEmpty || a.areas.contains('full');
  final areas = focusAll
      ? const ['full']
      : [
          for (final x in SportOptions.areas)
            if (a.areas.contains(x)) x,
        ];
  final count = switch (a.minutes) {
    <= 15 => 5,
    <= 25 => 7,
    _ => 9,
  };

  bool allowed(Exercise e) =>
      !exclude.contains(e.id) &&
      e.level <= level &&
      (!e.dumbbells || a.dumbbells) &&
      e.avoid.intersection(avoid).isEmpty;

  final workouts = <Workout>[];
  for (var day = 0; day < a.days.clamp(2, 5); day++) {
    final type = types[day % types.length];
    final focus = areas.length <= 2
        ? areas
        : [
            areas[(day * 2) % areas.length],
            areas[(day * 2 + 1) % areas.length],
          ];
    final pool = exerciseCatalogue
        .where((e) => e.type == type && allowed(e))
        .toList();
    // Exercises for the focus first, then the rest of the type, starting at
    // a different place each day so the week does not repeat.
    final inFocus = focusAll
        ? pool
        : pool.where((e) => e.areas.any(focus.contains)).toList();
    final others = pool.where((e) => !inFocus.contains(e)).toList();
    final picked = <Exercise>[
      ..._rotate(inFocus, day),
      ..._rotate(others, day),
    ];
    // Not enough of this type (safety or equipment): fill with stretching.
    if (picked.length < count) {
      picked.addAll(
        exerciseCatalogue.where(
          (e) => e.type == 'stretching' && allowed(e) && !picked.contains(e),
        ),
      );
    }
    final chosen = picked.take(count).toList();
    // Finish strength and cardio days with a stretch.
    if (type != 'stretching' && count >= 7) {
      final stretch = exerciseCatalogue.firstWhere(
        (e) => e.type == 'stretching' && allowed(e) && !chosen.contains(e),
        orElse: () => chosen.last,
      );
      if (!chosen.contains(stretch)) chosen[chosen.length - 1] = stretch;
    }
    workouts.add(
      Workout(
        id: 'w${day + 1}',
        type: type,
        focus: focus,
        items: [for (final e in chosen) _dose(e, a, level, gentle)],
      ),
    );
  }
  return SportPlan(workouts, gentle: gentle);
}

List<Exercise> _rotate(List<Exercise> list, int by) {
  if (list.isEmpty) return list;
  final start = (by * 3) % list.length;
  return [...list.skip(start), ...list.take(start)];
}

WorkoutItem _dose(Exercise e, SportAnswers a, int level, bool gentle) {
  final goal = a.goals.isEmpty ? 'tone' : a.goals.first;
  if (e.mode != ExerciseMode.reps) {
    final seconds = gentle ? 20 : const [30, 40, 45][level];
    final sets = e.type == 'stretching' ? 1 : (level == 0 ? 2 : 3);
    return WorkoutItem(
      exercise: e,
      sets: sets,
      amount: seconds,
      restSeconds: 15,
    );
  }
  final (sets, reps, rest) = switch (goal) {
    'muscle' => (const [3, 3, 4][level], const [10, 10, 8][level], 60),
    'endurance' => (const [2, 3, 3][level], const [15, 18, 20][level], 30),
    _ => (const [2, 3, 3][level], const [12, 12, 15][level], 30),
  };
  return WorkoutItem(
    exercise: e,
    sets: gentle ? 2 : sets,
    amount: gentle ? 10 : reps,
    restSeconds: gentle ? 30 : rest,
  );
}

/// Rules for the stored sport document: the answers, the log of finished
/// workouts and the sound setting. The app checks before sending, the
/// server before storing (encrypted, with the covering health consent,
/// because the answers include pregnancy and injuries).
abstract final class SportRules {
  static const format = 1;
  static const keepLogDays = 90;
  static const maxBytes = 32 * 1024;

  static final _date = RegExp(r'^\d{4}-\d{2}-\d{2}$');
  static final _workout = RegExp(
    r'^(w[1-5]|face_yoga|yoga_morning|yoga_evening|yoga_stretch)$',
  );

  static bool isValid(String encoded) {
    if (utf8.encode(encoded).length > maxBytes) return false;
    final Object? json;
    try {
      json = jsonDecode(encoded);
    } on FormatException {
      return false;
    }
    if (json is! Map<String, Object?>) return false;
    if (!json.keys.every({'format', 'answers', 'log', 'sound'}.contains)) {
      return false;
    }
    if (json['format'] != format) return false;
    final sound = json['sound'];
    if (sound != null && sound is! bool) return false;

    final answers = json['answers'];
    if (answers != null && !_answersValid(answers)) return false;

    final log = json['log'] ?? const <String, Object?>{};
    if (log is! Map<String, Object?> || log.length > keepLogDays + 1) {
      return false;
    }
    for (final MapEntry(:key, :value) in log.entries) {
      if (!_date.hasMatch(key) || DateTime.tryParse(key) == null) return false;
      if (value is! List || value.length > 9) return false;
      if (!value.every((w) => w is String && _workout.hasMatch(w))) {
        return false;
      }
    }
    return true;
  }

  static bool _answersValid(Object answers) {
    if (answers is! Map<String, Object?>) return false;
    const keys = {
      'goals',
      'areas',
      'types',
      'level',
      'days',
      'minutes',
      'dumbbells',
      'pregnancy',
      'injuries',
      'doctorLimit',
    };
    if (!answers.keys.every(keys.contains)) return false;
    bool listOf(Object? v, List<String> allowed, int max) =>
        v is List &&
        v.length <= max &&
        v.every((x) => x is String && allowed.contains(x)) &&
        v.toSet().length == v.length;
    if (!listOf(answers['goals'], SportOptions.goals, SportOptions.maxGoals)) {
      return false;
    }
    if (!listOf(answers['areas'], SportOptions.areas, 6)) return false;
    if (!listOf(answers['types'], SportOptions.types, 5)) return false;
    if (!listOf(answers['injuries'] ?? const [], SportOptions.injuries, 4)) {
      return false;
    }
    if (!SportOptions.levels.contains(answers['level'])) return false;
    if (!SportOptions.days.contains(answers['days'])) return false;
    if (!SportOptions.minutes.contains(answers['minutes'])) return false;
    if (!SportOptions.pregnancy.contains(answers['pregnancy'] ?? 'no')) {
      return false;
    }
    for (final k in ['dumbbells', 'doctorLimit']) {
      final v = answers[k];
      if (v != null && v is! bool) return false;
    }
    return true;
  }
}
