import 'package:flutter/material.dart';

/// Parla Sun brand palette (brand guidelines v2.0, section 03).
///
/// Text is always [espresso], [sunInk] or [muted]: each passes WCAG AA on
/// [cream], [white], [lemon], [sky] and [sage]. [sun] is a surface and
/// accent colour only, never text on a light background.
abstract final class ParlaColors {
  static const sun = Color(0xFFFFCE00);
  static const cream = Color(0xFFFFF9E8);
  static const espresso = Color(0xFF1F1A14);
  static const lemon = Color(0xFFFFEDA1);
  static const sky = Color(0xFFCFE3F7);
  static const sage = Color(0xFFB8CBB0);
  static const sunInk = Color(0xFF7A5C00);
  static const white = Color(0xFFFFFFFF);

  /// Secondary text and inactive icons (7.6:1 on white).
  static const muted = Color(0xFF5C5246);

  /// Outline of an unchecked control (3.4:1 on white, enough for UI parts).
  static const outline = Color(0xFF8A8170);

  /// Progress fills that must stand out from their tile.
  static const waterFill = Color(0xFF3A5A7A);
  static const moveFill = Color(0xFF3F4A3A);
  static const moveTrack = Color(0xFFE3ECDE);
}

/// Smallest text size anywhere in the app (accessibility requirement).
const double kMinTextSize = 18;

/// Card shadow used across the app: soft, never a hard edge.
const List<BoxShadow> kSoftShadow = [
  BoxShadow(color: Color(0x0F1F1A14), blurRadius: 24, offset: Offset(0, 8)),
];

/// Fraunces Italic has no Cyrillic glyphs, so Russian accent lines use
/// Commissioner instead.
TextStyle accentStyle(Locale locale, {double size = 26}) {
  if (locale.languageCode == 'ru') {
    return TextStyle(
      fontFamily: 'Commissioner',
      fontWeight: FontWeight.w600,
      fontSize: size,
      height: 1.25,
      color: ParlaColors.espresso,
    );
  }
  return TextStyle(
    fontFamily: 'Fraunces',
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w400,
    fontSize: size,
    height: 1.25,
    color: ParlaColors.espresso,
  );
}

/// App theme: Commissioner everywhere, every text style at least 18 px.
ThemeData parlaTheme() {
  const ink = ParlaColors.espresso;
  TextStyle style(double size, FontWeight weight, {double height = 1.3}) =>
      TextStyle(
        fontFamily: 'Commissioner',
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: ink,
      );

  final textTheme = TextTheme(
    displayLarge: style(56, FontWeight.w700, height: 1),
    headlineLarge: style(44, FontWeight.w700, height: 1.1),
    headlineMedium: style(32, FontWeight.w700, height: 1.15),
    headlineSmall: style(26, FontWeight.w700, height: 1.2),
    titleLarge: style(24, FontWeight.w700, height: 1.2),
    titleMedium: style(20, FontWeight.w700),
    titleSmall: style(18, FontWeight.w700),
    bodyLarge: style(18, FontWeight.w400, height: 1.45),
    bodyMedium: style(18, FontWeight.w400, height: 1.45),
    bodySmall: style(18, FontWeight.w400, height: 1.4),
    labelLarge: style(20, FontWeight.w700),
    labelMedium: style(18, FontWeight.w600),
    labelSmall: style(18, FontWeight.w600),
  );

  final pill = RoundedRectangleBorder(borderRadius: BorderRadius.circular(28));
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Commissioner',
    scaffoldBackgroundColor: ParlaColors.cream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ParlaColors.sun,
      primary: ParlaColors.espresso,
      onPrimary: ParlaColors.cream,
      secondary: ParlaColors.sun,
      onSecondary: ParlaColors.espresso,
      surface: ParlaColors.cream,
      onSurface: ParlaColors.espresso,
    ),
    textTheme: textTheme,
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: ParlaColors.sun,
        foregroundColor: ParlaColors.espresso,
        minimumSize: const Size.fromHeight(56),
        shape: pill,
        textStyle: textTheme.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ParlaColors.espresso,
        minimumSize: const Size.fromHeight(56),
        shape: pill,
        side: const BorderSide(color: ParlaColors.espresso, width: 2),
        textStyle: textTheme.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ParlaColors.espresso,
        minimumSize: const Size(48, 48),
        textStyle: textTheme.titleSmall,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ParlaColors.espresso,
      contentTextStyle: style(18, FontWeight.w500).copyWith(
        color: ParlaColors.cream,
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
