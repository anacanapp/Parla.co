/// RET-2: answers about pregnancy are asked again after a while, so the
/// app does not keep acting on one that is out of date (owner,
/// 2026-11-25).
///
/// - Skin quiz: "pregnant", "breastfeeding" and "planning" are asked again
///   12 months after they were given or last confirmed.
/// - Sport: "pregnant" after 12 months, "the six months after birth" after
///   6 months.
/// - "No" and "prefer not to say" are never asked again.
/// - Until the person answers, the old answer keeps applying (it is the
///   careful one) and the card stays on Home; nothing is deleted
///   automatically.
///
/// Periods are proposals: a doctor or physiotherapist should confirm the 6
/// months, and the lawyer the 12.
library;

abstract final class PregnancyRecheck {
  /// Answers saved before the months were recorded count from this month
  /// (the release of this rule), so nobody is asked at once.
  static const since = '2026-11';

  static const skinOptions = {'pregnant', 'breastfeeding', 'trying'};

  /// "2026-11" for [d].
  static String monthOf(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}';

  static final _month = RegExp(r'^\d{4}-(0[1-9]|1[0-2])$');

  /// Whether [month] is a "2026-11" month.
  static bool isMonth(Object? month) =>
      month is String && _month.hasMatch(month);

  /// Whole months from [month] ("2026-11") to [now].
  static int monthsSince(String? month, DateTime now) {
    final m = isMonth(month) ? month! : since;
    final year = int.parse(m.substring(0, 4));
    final mon = int.parse(m.substring(5));
    return (now.year - year) * 12 + now.month - mon;
  }

  /// Months after which the skin quiz answer [optionIds] is asked again, or
  /// `null` when it never is.
  static int? skinPeriod(List<String> optionIds) =>
      optionIds.any(skinOptions.contains) ? 12 : null;

  /// Months after which the sport answer [pregnancy] is asked again, or
  /// `null` when it never is.
  static int? sportPeriod(String pregnancy) => switch (pregnancy) {
    'pregnant' => 12,
    'postpartum' => 6,
    _ => null,
  };

  /// Whether the skin quiz pregnancy answer is due to be asked again.
  static bool skinDue(List<String> optionIds, String? month, DateTime now) {
    final period = skinPeriod(optionIds);
    return period != null && monthsSince(month, now) >= period;
  }

  /// Whether the sport pregnancy answer is due to be asked again.
  static bool sportDue(String pregnancy, String? month, DateTime now) {
    final period = sportPeriod(pregnancy);
    return period != null && monthsSince(month, now) >= period;
  }
}
