/// The 18+ age gate (PRD: M1, US-02).
///
/// Parla only stores the birth year (data minimisation, see the data map).
/// A birth year alone cannot tell whether someone who turns 18 this year has
/// already had their birthday, so that case asks one extra yes/no question
/// instead of guessing.
library;

/// Minimum age to use Parla.
const int minimumAge = 18;

/// Birth years before this are treated as input errors.
const int oldestAcceptedBirthYear = 1900;

/// Outcome of [checkAge].
enum AgeCheck {
  /// The person is at least [minimumAge] years old.
  adult,

  /// The person is younger than [minimumAge]. Nothing may be stored.
  minor,

  /// The person turns [minimumAge] this calendar year. Ask whether the
  /// birthday has already passed and call [checkAge] again with the answer.
  needsBirthdayConfirmation,

  /// The birth year is outside the accepted range.
  invalid,
}

/// Checks a birth year against the 18+ rule.
///
/// [birthdayPassedThisYear] is only consulted when the person turns
/// [minimumAge] in the year of [today].
AgeCheck checkAge({
  required int birthYear,
  required DateTime today,
  bool? birthdayPassedThisYear,
}) {
  if (birthYear < oldestAcceptedBirthYear || birthYear > today.year) {
    return AgeCheck.invalid;
  }
  final yearsApart = today.year - birthYear;
  if (yearsApart > minimumAge) return AgeCheck.adult;
  if (yearsApart < minimumAge) return AgeCheck.minor;
  if (birthdayPassedThisYear == null) return AgeCheck.needsBirthdayConfirmation;
  return birthdayPassedThisYear ? AgeCheck.adult : AgeCheck.minor;
}
