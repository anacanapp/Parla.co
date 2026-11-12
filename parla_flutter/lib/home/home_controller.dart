import 'package:flutter/foundation.dart';

import '../habits/habit_tracker.dart';
import 'routine.dart';

/// State of the home screen (M-14): which routine is shown. Done steps and
/// today's water come from the [HabitTracker], which keeps them on the
/// device.
class HomeController extends ChangeNotifier {
  HomeController({required DateTime now, required this.habits})
    : _kind = now.hour < 15 ? RoutineKind.morning : RoutineKind.evening {
    habits.addListener(notifyListeners);
  }

  static const waterGoal = HabitTracker.waterGoal;

  final HabitTracker habits;
  RoutineKind _kind;

  RoutineKind get kind => _kind;
  int get water => habits.water;

  bool isDone(String stepId) => habits.isDone(_kind, stepId);

  void selectKind(RoutineKind kind) {
    if (kind == _kind) return;
    _kind = kind;
    notifyListeners();
  }

  void toggle(String stepId) => habits.toggleStep(_kind, stepId);

  void restart() => habits.restart(_kind);

  void addWater() => habits.addWater();

  void removeWater() => habits.removeWater();

  @override
  void dispose() {
    habits.removeListener(notifyListeners);
    super.dispose();
  }
}

/// Progress of one routine, derived from its steps and the controller.
class RoutineProgress {
  RoutineProgress(this.steps, HomeController controller)
    : done = [for (final s in steps) controller.isDone(s.id)];

  final List<RoutineStep> steps;
  final List<bool> done;

  int get total => steps.length;
  int get doneCount => done.where((d) => d).length;
  bool get allDone => total > 0 && doneCount == total;
  double get fraction => total == 0 ? 0 : doneCount / total;

  /// The first step not done yet, or `null` when all are done.
  RoutineStep? get next {
    final i = done.indexOf(false);
    return i < 0 ? null : steps[i];
  }

  int get nextNumber => done.indexOf(false) + 1;

  int get minutesLeft => [
    for (var i = 0; i < total; i++)
      if (!done[i]) steps[i].minutes,
  ].fold(0, (a, b) => a + b);
}
