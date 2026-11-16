import 'package:parla_shared/parla_shared.dart';

import '../habits/habit_log.dart';
import '../services/parla_api.dart';
import '../sync/synced_document.dart';

/// The daily plate: which food groups the user had each day. No calories
/// or amounts. Kept like the other documents (server with the covering
/// health consent, otherwise this phone); see [SyncedDocument].
class NutritionBook extends SyncedDocument {
  NutritionBook({required super.store, super.api, DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  final Map<String, Set<String>> _plates = {};

  @override
  int get format => NutritionRules.format;

  @override
  Future<String?> fetchRemote(ParlaApi api) => api.myNutrition();

  @override
  Future<void> sendRemote(ParlaApi api, String json) => api.saveNutrition(json);

  /// Today's groups, in display order.
  List<String> get today {
    final day = _plates[HabitLog.keyOf(_clock())] ?? const {};
    return [
      for (final g in ContentRules.plateGroups)
        if (day.contains(g)) g,
    ];
  }

  Future<void> toggle(String group) {
    final day = _plates.putIfAbsent(HabitLog.keyOf(_clock()), () => <String>{});
    if (!day.remove(group)) day.add(group);
    final now = _clock();
    final oldest = DateTime(
      now.year,
      now.month,
      now.day - NutritionRules.keepDays,
    );
    _plates.removeWhere(
      (d, groups) => groups.isEmpty || DateTime.parse(d).isBefore(oldest),
    );
    return changed();
  }

  @override
  Map<String, Object?> exportJson() => {
    'format': format,
    'plates': {
      for (final e in _plates.entries)
        if (e.value.isNotEmpty)
          e.key: [
            for (final g in ContentRules.plateGroups)
              if (e.value.contains(g)) g,
          ],
    },
  };

  @override
  void load(Map<String, Object?> json) {
    _plates.clear();
    final plates = (json['plates'] as Map?)?.cast<String, Object?>() ?? {};
    for (final e in plates.entries) {
      _plates[e.key] = {...(e.value! as List).cast<String>()};
    }
  }

  @override
  void clearContent() => _plates.clear();

  @override
  bool get hasContent => _plates.isNotEmpty;
}
