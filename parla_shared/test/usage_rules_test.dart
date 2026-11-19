import 'package:parla_shared/parla_shared.dart';
import 'package:test/test.dart';

void main() {
  group('UsageRules', () {
    test('accepts valid keys only', () {
      expect(UsageRules.parseKey('tool|shop'), (UsageEvent.tool, 'shop'));
      expect(UsageRules.parseKey('recipe|green-salad'), isNotNull);
      expect(UsageRules.parseKey('bannerTap|12'), isNotNull);
      expect(UsageRules.parseKey('appOpen|1.4.2'), isNotNull);
      expect(UsageRules.parseKey('tool|unknown'), isNull);
      expect(UsageRules.parseKey('recipe|Not A Slug'), isNull);
      expect(UsageRules.parseKey('bannerView|0'), isNull);
      expect(UsageRules.parseKey('appOpen|beta'), isNull);
      expect(UsageRules.parseKey('health|skin'), isNull);
      expect(UsageRules.parseKey('|x'), isNull);
    });

    test('clean caps counts and drops bad entries', () {
      final out = UsageRules.clean({
        'tool|check': 500,
        'tool|shop': 0,
        'nope|x': 3,
        'article|hello': 2,
      });
      expect(out, {
        (UsageEvent.tool, 'check'): UsageRules.maxCount,
        (UsageEvent.article, 'hello'): 2,
      });
    });

    test('clean keeps at most maxEntries', () {
      final many = {for (var i = 1; i <= 300; i++) 'bannerView|$i': 1};
      expect(UsageRules.clean(many).length, UsageRules.maxEntries);
    });
  });
}
