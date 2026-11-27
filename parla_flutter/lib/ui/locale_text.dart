import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:parla_shared/parla_shared.dart';

/// The language of content shown here (articles, recipes, quiz and
/// workout texts): the interface language where Parla has its texts,
/// else the closest one (see `contentLanguageFor`).
String contentLanguageOf(BuildContext context) =>
    contentLanguageFor(Localizations.localeOf(context).languageCode);

/// The locale for dates and weekdays: the interface language when `intl`
/// knows it (not Turkmen), else the content language.
String dateLocaleOf(BuildContext context) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat.localeExists(locale) ? locale : contentLanguageOf(context);
}
