/// What the app may count for the anonymous usage statistics.
///
/// Counted only with the analytics consent. The app sends small batches of
/// counts ("recipe screen opened 3 times"); the server adds them to the
/// day's totals per country and platform and keeps no row per account.
library;

/// A tool or screen whose openings are counted.
enum UsageTool {
  home,
  habits,
  reminders,
  routineBuilder,
  check,
  productDetail,
  shoppingList,
  shop,
  sport,
  sportQuiz,
  workout,
  discover,
  blog,
  experts,
  nutrition,
  journal,
  messages,
  privacy,
}

/// One kind of counted event.
enum UsageEvent {
  /// The app was opened; the target is the app version.
  appOpen,

  /// A tool's screen was opened; the target is a [UsageTool] name.
  tool,

  /// An article was opened; the target is its slug.
  article,

  /// A recipe was opened; the target is its slug.
  recipe,

  /// A banner was shown; the target is its content id.
  bannerView,

  /// A banner was tapped; the target is its content id.
  bannerTap,

  /// A Shop product was opened; the target is its slug.
  product,

  /// A product's buy or partner-site button was tapped; the target is its
  /// slug.
  productTap,
}

/// The phone's operating system, counted with each report.
enum UsagePlatform { ios, android, other }

abstract final class UsageRules {
  /// Most different counts in one report.
  static const maxEntries = 100;

  /// Most a single count may add in one report.
  static const maxCount = 50;

  /// How long the keyed daily marks behind the active-account totals are
  /// kept (days). Needed for the weekly and monthly totals.
  static const markDays = 30;

  /// How long the daily totals are kept (months).
  static const keepMonths = 24;

  static final _slug = RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$');
  static final _id = RegExp(r'^[1-9][0-9]{0,9}$');
  static final _version = RegExp(r'^[0-9]{1,3}(\.[0-9]{1,3}){0,3}$');

  /// Whether [target] is valid for [event].
  static bool validTarget(UsageEvent event, String target) => switch (event) {
    UsageEvent.appOpen => _version.hasMatch(target),
    UsageEvent.tool => UsageTool.values.any((t) => t.name == target),
    UsageEvent.article ||
    UsageEvent.recipe ||
    UsageEvent.product ||
    UsageEvent.productTap => target.length <= 80 && _slug.hasMatch(target),
    UsageEvent.bannerView || UsageEvent.bannerTap => _id.hasMatch(target),
  };

  /// The key of one count in a report: `event|target`.
  static String key(UsageEvent event, String target) => '${event.name}|$target';

  /// Splits [key]; `null` when it is not a valid count key.
  static (UsageEvent, String)? parseKey(String key) {
    final bar = key.indexOf('|');
    if (bar < 1) return null;
    final name = key.substring(0, bar);
    final target = key.substring(bar + 1);
    for (final e in UsageEvent.values) {
      if (e.name == name) {
        return validTarget(e, target) ? (e, target) : null;
      }
    }
    return null;
  }

  /// The valid counts of [counts], each capped at [maxCount]; at most
  /// [maxEntries] are kept. Invalid keys and counts under 1 are dropped.
  static Map<(UsageEvent, String), int> clean(Map<String, int> counts) {
    final out = <(UsageEvent, String), int>{};
    for (final e in counts.entries) {
      if (out.length >= maxEntries) break;
      final parsed = parseKey(e.key);
      if (parsed == null || e.value < 1) continue;
      out[parsed] = e.value > maxCount ? maxCount : e.value;
    }
    return out;
  }
}
