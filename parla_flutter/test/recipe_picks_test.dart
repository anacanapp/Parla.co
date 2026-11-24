import 'package:flutter_test/flutter_test.dart';
import 'package:parla/discover/recipe_picks.dart';
import 'package:parla/services/parla_api.dart';

PublishedItem _r(String slug, List<String> groups) => PublishedItem(
  id: slug.hashCode,
  kind: 'recipe',
  slug: slug,
  category: 'lunch',
  publishedAt: DateTime.utc(2026, 11, 1),
  data: {'groups': groups},
);

void main() {
  final recipes = [
    for (var i = 0; i < 20; i++) _r('r$i', i.isEven ? ['fruit'] : ['protein']),
    _r('both', ['fruit', 'protein', 'vegetables']),
  ];

  test("today's pick stays the same all day and changes over days", () {
    final morning = dailyRecipe(recipes, DateTime(2026, 11, 24, 7));
    final evening = dailyRecipe(recipes, DateTime(2026, 11, 24, 22));
    expect(morning!.slug, evening!.slug);
    final week = {
      for (var d = 1; d <= 14; d++)
        dailyRecipe(recipes, DateTime(2026, 11, d))!.slug,
    };
    expect(week.length, greaterThan(3));
    expect(dailyRecipe(const [], DateTime(2026, 11, 24)), isNull);
  });

  test('plate ideas add missing groups, most first, none when full', () {
    final ideas = plateIdeas(recipes, ['vegetables'], DateTime(2026, 11, 24));
    expect(ideas, hasLength(3));
    expect(ideas.first.slug, 'both');
    final onlyProtein = plateIdeas(
      recipes,
      ['fruit', 'vegetables', 'whole_grain', 'healthy_fat', 'dairy'],
      DateTime(2026, 11, 24),
    );
    expect(
      onlyProtein.every((r) => (r.data['groups'] as List).contains('protein')),
      isTrue,
    );
    expect(
      plateIdeas(recipes, [
        'vegetables',
        'fruit',
        'protein',
        'whole_grain',
        'healthy_fat',
        'dairy',
      ], DateTime(2026, 11, 24)),
      isEmpty,
    );
  });
}
