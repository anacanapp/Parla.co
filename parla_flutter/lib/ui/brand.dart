import 'package:flutter/material.dart';

/// Parla night palette (design 3.0, 2026-11-23: one dark mode only).
///
/// The names are the ones the screens already use, so each keeps its role:
/// [cream] is the page, [white] a card surface, [espresso] the main ink.
/// Text is always [espresso], [sunInk] or [muted]; each passes WCAG AA
/// (4.5:1) on [cream], [white], [lemon], [sky], [sage], [sageTint],
/// [blush] and [lilac] (checked in `test/night_palette_test.dart`).
/// A surface in [espresso] (the selected or main action) carries [white]
/// text, and [sun] carries [espresso] text.
abstract final class ParlaColors {
  /// Accent surface: selected chips and tabs, rings (plum, 4.9:1 under
  /// [espresso] text).
  static const sun = Color(0xFFA23C9A);

  /// The page background behind everything.
  static const cream = Color(0xFF0C0A1C);

  /// Main ink: text and icons, and the surface of the main action.
  static const espresso = Color(0xFFF4E9FF);

  /// Tinted surfaces (dark plum, blue and green).
  static const lemon = Color(0xFF2A1A40);
  static const sky = Color(0xFF172246);
  static const sage = Color(0xFF1E2C25);

  /// Accent text: eyebrows, accent lines, links.
  static const sunInk = Color(0xFFF0B8D4);

  /// Card surface (dark glass), and the text on an [espresso] surface.
  static const white = Color(0xFF1C1733);

  /// Secondary text and inactive icons (8.2:1 on [white]).
  static const muted = Color(0xFFB8AECB);

  /// Outline of an unchecked control (4:1 on [white]).
  static const outline = Color(0xFF7F7596);

  /// Hairlines, card borders and the track of progress bars.
  static const line = Color(0xFF332B4D);

  /// Dark tints for cards.
  static const sageTint = Color(0xFF1A261F);
  static const blush = Color(0xFF331A2B);
  static const lilac = Color(0xFF271D3F);

  /// Fitness section: deep blue surface and its light text (9:1).
  static const sportBlue = Color(0xFF1F2E8C);
  static const sportBlueText = Color(0xFFDCE4FF);

  /// Progress fills that must stand out from their tile.
  static const waterFill = Color(0xFF7C95FF);
  static const moveFill = Color(0xFFA9BCA6);
  static const moveTrack = Color(0xFF2B3A31);

  /// The small lime marker of the design (never text).
  static const marker = Color(0xFFE8F06A);
}

/// Font families bundled in `assets/fonts` (SIL OFL 1.1).
abstract final class ParlaFonts {
  /// Interface text: Onest covers Latin, Azerbaijani and Cyrillic, from
  /// ExtraLight (200) to ExtraBold (800).
  static const sans = 'Onest';

  /// Fallback for anything [sans] lacks.
  static const fallback = ['PlusJakartaSans'];

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
  static const cardRadius = 22.0;
  static const controlRadius = 16.0;
  static const buttonHeight = 52.0;
}

/// Card shadow used across the app: soft, never a hard edge.
const List<BoxShadow> kSoftShadow = [
  BoxShadow(color: Color(0x40000000), blurRadius: 24, offset: Offset(0, 8)),
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

  // Night design: thin, large headlines (Onest 200–300) and medium
  // titles; body text stays regular for legibility.
  final textTheme = TextTheme(
    displayLarge: style(40, FontWeight.w200, height: 1.05, letterSpacing: -1.2),
    displayMedium: style(32, FontWeight.w200, height: 1.05, letterSpacing: -.8),
    headlineLarge: style(30, FontWeight.w300, height: 1.1, letterSpacing: -.8),
    headlineMedium: style(
      24,
      FontWeight.w300,
      height: 1.15,
      letterSpacing: -.5,
    ),
    headlineSmall: style(20, FontWeight.w500, height: 1.2, letterSpacing: -.3),
    titleLarge: style(17, FontWeight.w600, height: 1.25),
    titleMedium: style(15, FontWeight.w600),
    titleSmall: style(14, FontWeight.w600),
    bodyLarge: style(16, FontWeight.w400, height: 1.45),
    bodyMedium: style(15, FontWeight.w400, height: 1.45),
    bodySmall: style(13, FontWeight.w400, height: 1.4),
    labelLarge: style(16, FontWeight.w600),
    labelMedium: style(13, FontWeight.w500),
    labelSmall: style(12, FontWeight.w600, letterSpacing: 1),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: ParlaFonts.sans,
    fontFamilyFallback: ParlaFonts.fallback,
    scaffoldBackgroundColor: ParlaColors.cream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ParlaColors.sun,
      brightness: Brightness.dark,
      primary: ParlaColors.espresso,
      onPrimary: ParlaColors.white,
      secondary: ParlaColors.sun,
      onSecondary: ParlaColors.espresso,
      surface: ParlaColors.cream,
      onSurface: ParlaColors.espresso,
      onSurfaceVariant: ParlaColors.muted,
      outline: ParlaColors.outline,
      outlineVariant: ParlaColors.line,
      surfaceContainerHighest: ParlaColors.white,
      error: const Color(0xFFFFB4C0),
      onError: const Color(0xFF3A0A14),
    ),
    dividerColor: ParlaColors.line,
    iconTheme: const IconThemeData(color: ParlaColors.espresso),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: ParlaColors.espresso,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: ParlaColors.espresso,
      linearTrackColor: ParlaColors.line,
    ),
    textTheme: textTheme,
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: ParlaColors.espresso,
        foregroundColor: ParlaColors.white,
        disabledBackgroundColor: ParlaColors.line,
        disabledForegroundColor: ParlaColors.muted,
        minimumSize: const Size.fromHeight(ParlaSpace.buttonHeight),
        shape: const StadiumBorder(),
        textStyle: textTheme.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ParlaColors.espresso,
        backgroundColor: ParlaColors.white,
        minimumSize: const Size.fromHeight(ParlaSpace.buttonHeight),
        shape: const StadiumBorder(),
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
    // Parla 2.0: capsules for chips, large rounded corners for cards,
    // dialogs and sheets.
    chipTheme: ChipThemeData(
      shape: const StadiumBorder(side: BorderSide(color: ParlaColors.line)),
      backgroundColor: ParlaColors.white,
      selectedColor: ParlaColors.sun,
      labelStyle: textTheme.labelLarge?.copyWith(color: ParlaColors.espresso),
      side: const BorderSide(color: ParlaColors.line),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      showCheckmark: false,
    ),
    cardTheme: CardThemeData(
      color: ParlaColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: ParlaColors.line),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: ParlaColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: ParlaColors.white,
      dragHandleColor: ParlaColors.outline,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ParlaColors.espresso,
      contentTextStyle: style(15, FontWeight.w500).copyWith(
        color: ParlaColors.white,
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
