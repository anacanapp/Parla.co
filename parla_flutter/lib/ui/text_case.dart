import 'package:flutter/widgets.dart';

/// Upper case that follows the language: in Azerbaijani (and Turkish) the
/// dotted i becomes İ and the dotless ı becomes I. Dart's
/// [String.toUpperCase] ignores the language and turns "i" into "I".
String upperCaseIn(String language, String text) =>
    language == 'az' || language == 'tr'
    ? text.replaceAll('i', 'İ').replaceAll('ı', 'I').toUpperCase()
    : text.toUpperCase();

/// [upperCaseIn] for the app's current language.
extension LocaleUpperCase on String {
  String upperIn(BuildContext context) =>
      upperCaseIn(Localizations.localeOf(context).languageCode, this);
}
