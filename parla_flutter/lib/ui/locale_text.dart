import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:parla_shared/parla_shared.dart';

/// The language texts are picked in here (articles, recipes, quiz and
/// workout texts): the interface language. The pickers (`ContentRules.pick`,
/// `pickTriple`) use its translation or the closest of az/ru/en.
String contentLanguageOf(BuildContext context) =>
    Localizations.localeOf(context).languageCode;

/// The locale for dates and weekdays: the interface language when `intl`
/// knows it (not Turkmen), else the content language.
String dateLocaleOf(BuildContext context) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat.localeExists(locale)
      ? locale
      : contentLanguageFor(contentLanguageOf(context));
}
