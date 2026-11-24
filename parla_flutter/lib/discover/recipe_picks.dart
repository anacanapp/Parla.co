import 'dart:math';

import 'package:parla_shared/parla_shared.dart';

import '../services/parla_api.dart';

/// Days since 1970-01-01 of [day]'s calendar date.
int _dayNumber(DateTime day) =>
    DateTime.utc(day.year, day.month, day.day).millisecondsSinceEpoch ~/
    Duration.millisecondsPerDay;

/// Today's pick (owner 2026-11-24): one recipe a day, chosen at random but
/// the same all day and on every phone, so it does not change on refresh.
PublishedItem? dailyRecipe(List<PublishedItem> recipes, DateTime day) {
  if (recipes.isEmpty) return null;
  final sorted = [...recipes]..sort((a, b) => a.slug.compareTo(b.slug));
  return sorted[Random(_dayNumber(day)).nextInt(sorted.length)];
}

/// Up to [max] recipes that add the plate groups not ticked yet today,
/// the ones adding most first (a day-based order breaks ties). Empty when
/// the plate is full.
List<PublishedItem> plateIdeas(
  List<PublishedItem> recipes,
  Iterable<String> plate,
  DateTime day, {
  int max = 3,
}) {
  final missing = ContentRules.plateGroups.toSet().difference(plate.toSet());
  if (missing.isEmpty) return const [];
  int adds(PublishedItem r) =>
      (r.data['groups'] as List? ?? const []).where(missing.contains).length;
  final candidates = [
    for (final r in recipes)
      if (adds(r) > 0) r,
  ]..sort((a, b) => a.slug.compareTo(b.slug));
  candidates.shuffle(Random(_dayNumber(day) + 1));
  // List.sort is not stable: keep the shuffled order for ties by index.
  final order = {for (final (i, r) in candidates.indexed) r.slug: i};
  candidates.sort((a, b) {
    final byAdds = adds(b).compareTo(adds(a));
    return byAdds != 0 ? byAdds : order[a.slug]!.compareTo(order[b.slug]!);
  });
  return candidates.take(max).toList();
}
