import 'package:flutter/foundation.dart';

import 'routine.dart';

/// State of the home screen (M-14): which routine is shown, which steps are
/// done today, and today's water count.
///
/// Held in memory only for now. Persisting habit data comes with the health
/// consent and encrypted storage (privacy checklist ENC-3, CON-2).
class HomeController extends ChangeNotifier {
  HomeController({required DateTime now})
    : _kind = now.hour < 15 ? RoutineKind.morning : RoutineKind.evening;

  static const waterGoal = 8;

  RoutineKind _kind;
  final Map<RoutineKind, Set<String>> _done = {
    for (final kind in RoutineKind.values) kind: <String>{},
  };
  int _water = 0;

  RoutineKind get kind => _kind;
  int get water => _water;

  bool isDone(String stepId) => _done[_kind]!.contains(stepId);

  void selectKind(RoutineKind kind) {
    if (kind == _kind) return;
    _kind = kind;
    notifyListeners();
  }

  void toggle(String stepId) {
    final done = _done[_kind]!;
    if (!done.remove(stepId)) done.add(stepId);
    notifyListeners();
  }

  void restart() {
    _done[_kind]!.clear();
    notifyListeners();
  }

  void addWater() {
    if (_water >= waterGoal) return;
    _water++;
    notifyListeners();
  }

  void removeWater() {
    if (_water == 0) return;
    _water--;
    notifyListeners();
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
