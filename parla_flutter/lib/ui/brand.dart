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

  /// Hairlines and the track of progress bars on cream.
  static const line = Color(0xFFEFE4C6);

  /// Light tints for cards (redesign 2026-11).
  static const sageTint = Color(0xFFE4EDDF);
  static const blush = Color(0xFFF7E1E1);
  static const lilac = Color(0xFFEBE3F5);

  /// Fitness section (redesign 2026-11): deep blue surface and its light
  /// text (contrast 9.8:1).
  static const sportBlue = Color(0xFF1E3A5F);
  static const sportBlueText = Color(0xFFDCE8F5);

  /// Progress fills that must stand out from their tile.
  static const waterFill = Color(0xFF3A5A7A);
  static const moveFill = Color(0xFF3F4A3A);
  static const moveTrack = Color(0xFFE3ECDE);
}

/// Font families bundled in `assets/fonts` (SIL OFL 1.1).
abstract final class ParlaFonts {
  /// Interface text. Has no Cyrillic glyphs, so [fallback] draws Russian.
  static const sans = 'PlusJakartaSans';

  /// Cyrillic (and Azerbaijani) fallback for [sans].
  static const fallback = ['Onest'];

  /// Italic accent lines; covers Latin, Azerbaijani and Cyrillic.
  static const accent = 'PlayfairDisplay';
}

/// Smallest text size anywhere in the app, before the user's own system
/// text scaling (Apple and Google guidance). The app follows the system
/// text size, so people who need larger text get it everywhere.
const double kMinTextSize = 12;

/// Spacing and corner radii of the compact layout.
abstract final class ParlaSpace {
  static const page = 16.0;
  static const gap = 12.0;
  static const cardRadius = 18.0;
  static const controlRadius = 14.0;
  static const buttonHeight = 52.0;
}

/// Card shadow used across the app: soft, never a hard edge.
const List<BoxShadow> kSoftShadow = [
  BoxShadow(color: Color(0x0F1F1A14), blurRadius: 24, offset: Offset(0, 8)),
];

/// The italic accent line ("Hər gün bir az daha sən."). Playfair Display
/// has Cyrillic, so the same face serves all three languages; [locale] is
/// kept for callers and future per-language tuning.
TextStyle accentStyle(Locale locale, {double size = 20}) => TextStyle(
  fontFamily: ParlaFonts.accent,
  fontStyle: FontStyle.italic,
  fontWeight: FontWeight.w500,
  fontSize: size,
  height: 1.25,
  color: ParlaColors.sunInk,
);

/// App theme: compact type scale, body text 15–16 px, nothing under
/// [kMinTextSize].
ThemeData parlaTheme() {
  const ink = ParlaColors.espresso;
  TextStyle style(
    double size,
    FontWeight weight, {
    double height = 1.3,
    double letterSpacing = 0,
  }) => TextStyle(
    fontFamily: ParlaFonts.sans,
    fontFamilyFallback: ParlaFonts.fallback,
    fontSize: size,
    fontWeight: weight,
    height: height,
    letterSpacing: letterSpacing,
    color: ink,
  );

  final textTheme = TextTheme(
    displayLarge: style(34, FontWeight.w800, height: 1.08, letterSpacing: -1),
    headlineLarge: style(28, FontWeight.w800, height: 1.12, letterSpacing: -.6),
    headlineMedium: style(
      24,
      FontWeight.w800,
      height: 1.15,
      letterSpacing: -.5,
    ),
    headlineSmall: style(20, FontWeight.w800, height: 1.2, letterSpacing: -.3),
    titleLarge: style(17, FontWeight.w800, height: 1.25),
    titleMedium: style(15, FontWeight.w700),
    titleSmall: style(14, FontWeight.w700),
    bodyLarge: style(16, FontWeight.w400, height: 1.45),
    bodyMedium: style(15, FontWeight.w400, height: 1.45),
    bodySmall: style(13, FontWeight.w400, height: 1.4),
    labelLarge: style(16, FontWeight.w700),
    labelMedium: style(13, FontWeight.w600),
    labelSmall: style(12, FontWeight.w700, letterSpacing: 1),
  );

  final rounded = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  );
  return ThemeData(
    useMaterial3: true,
    fontFamily: ParlaFonts.sans,
    fontFamilyFallback: ParlaFonts.fallback,
    scaffoldBackgroundColor: ParlaColors.cream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ParlaColors.sun,
      primary: ParlaColors.espresso,
      onPrimary: ParlaColors.white,
      secondary: ParlaColors.sun,
      onSecondary: ParlaColors.espresso,
      surface: ParlaColors.cream,
      onSurface: ParlaColors.espresso,
    ),
    textTheme: textTheme,
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: ParlaColors.espresso,
        foregroundColor: ParlaColors.white,
        disabledBackgroundColor: ParlaColors.line,
        disabledForegroundColor: ParlaColors.muted,
        minimumSize: const Size.fromHeight(ParlaSpace.buttonHeight),
        shape: rounded,
        textStyle: textTheme.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ParlaColors.espresso,
        backgroundColor: ParlaColors.white,
        minimumSize: const Size.fromHeight(ParlaSpace.buttonHeight),
        shape: rounded,
        side: const BorderSide(color: ParlaColors.line, width: 1.5),
        textStyle: textTheme.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ParlaColors.espresso,
        minimumSize: const Size(44, 44),
        textStyle: textTheme.titleMedium,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ParlaColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ParlaSpace.controlRadius),
        borderSide: const BorderSide(color: ParlaColors.line, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ParlaSpace.controlRadius),
        borderSide: const BorderSide(color: ParlaColors.line, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ParlaSpace.controlRadius),
        borderSide: const BorderSide(color: ParlaColors.espresso, width: 2),
      ),
      labelStyle: textTheme.bodyMedium?.copyWith(color: ParlaColors.muted),
      hintStyle: textTheme.bodyMedium?.copyWith(color: ParlaColors.outline),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ParlaColors.espresso,
      contentTextStyle: style(15, FontWeight.w500).copyWith(
        color: ParlaColors.cream,
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
