import 'package:flutter/material.dart';

/// Parla Sun colours for the panel: the app's brand, calmer for long work.
/// Text colours pass WCAG AA on [white] and [canvas].
abstract final class AdminColors {
  static const sun = Color(0xFFFFCE00);
  static const sunSoft = Color(0xFFFFF3C2);
  static const sunLine = Color(0xFFF5DD7A);
  static const cream = Color(0xFFFFF9E8);
  static const canvas = Color(0xFFFBF8F1);
  static const espresso = Color(0xFF1F1A14);
  static const ink = Color(0xFF3D342A);
  static const muted = Color(0xFF5C5246);
  static const subtle = Color(0xFF6B6052);
  static const line = Color(0xFFEFE7D3);
  static const field = Color(0xFFE4DAC2);
  static const hover = Color(0xFFF3EEE2);
  static const white = Color(0xFFFFFFFF);
  static const danger = Color(0xFF9A3A1B);
  static const dangerSoft = Color(0xFFFBE6DC);
}

const adminFont = 'PlusJakartaSans';
const adminFontFallback = ['Onest'];

/// Corner radii used across the panel.
abstract final class AdminRadius {
  static const card = 16.0;
  static const control = 12.0;
  static const pill = 999.0;
}

ThemeData adminTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AdminColors.sun,
    primary: AdminColors.espresso,
    onPrimary: AdminColors.white,
    secondary: AdminColors.sun,
    onSecondary: AdminColors.espresso,
    surface: AdminColors.white,
    onSurface: AdminColors.espresso,
    error: AdminColors.danger,
    outline: AdminColors.field,
    outlineVariant: AdminColors.line,
  );
  final base = ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    fontFamily: adminFont,
    fontFamilyFallback: adminFontFallback,
  );
  final text = base.textTheme
      .apply(
        bodyColor: AdminColors.espresso,
        displayColor: AdminColors.espresso,
        fontFamily: adminFont,
        fontFamilyFallback: adminFontFallback,
      )
      .copyWith(
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.6,
          color: AdminColors.espresso,
        ),
        headlineSmall: base.textTheme.headlineSmall?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
          color: AdminColors.espresso,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AdminColors.espresso,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AdminColors.espresso,
        ),
        titleSmall: base.textTheme.titleSmall?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AdminColors.ink,
        ),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(
          fontSize: 16,
          height: 1.5,
          color: AdminColors.espresso,
        ),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          fontSize: 15,
          height: 1.45,
          color: AdminColors.espresso,
        ),
        bodySmall: base.textTheme.bodySmall?.copyWith(
          fontSize: 13,
          height: 1.45,
          color: AdminColors.subtle,
        ),
        labelLarge: base.textTheme.labelLarge?.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      );
  final control = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AdminRadius.control),
  );
  const buttonText = TextStyle(
    fontFamily: adminFont,
    fontFamilyFallback: adminFontFallback,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );
  OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AdminRadius.control),
    borderSide: BorderSide(color: c, width: w),
  );
  return base.copyWith(
    scaffoldBackgroundColor: AdminColors.canvas,
    textTheme: text,
    dividerTheme: const DividerThemeData(
      color: AdminColors.line,
      thickness: 1,
      space: 1,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: AdminColors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AdminRadius.card),
        side: const BorderSide(color: AdminColors.line),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AdminColors.espresso,
        foregroundColor: AdminColors.white,
        disabledBackgroundColor: AdminColors.hover,
        disabledForegroundColor: AdminColors.subtle,
        minimumSize: const Size(64, 44),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        shape: control,
        textStyle: buttonText,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AdminColors.espresso,
        backgroundColor: AdminColors.white,
        minimumSize: const Size(64, 44),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        side: const BorderSide(color: AdminColors.field),
        shape: control,
        textStyle: buttonText.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AdminColors.espresso,
        minimumSize: const Size(44, 44),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shape: control,
        textStyle: buttonText.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AdminColors.muted,
        minimumSize: const Size(44, 44),
        shape: control,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AdminColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      labelStyle: const TextStyle(color: AdminColors.muted),
      floatingLabelStyle: const TextStyle(
        color: AdminColors.ink,
        fontWeight: FontWeight.w600,
      ),
      helperStyle: const TextStyle(color: AdminColors.subtle, fontSize: 13),
      hintStyle: const TextStyle(color: AdminColors.subtle),
      border: border(AdminColors.field),
      enabledBorder: border(AdminColors.field),
      disabledBorder: border(AdminColors.line),
      focusedBorder: border(AdminColors.espresso, 1.6),
      errorBorder: border(AdminColors.danger),
      focusedErrorBorder: border(AdminColors.danger, 1.6),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AdminColors.white,
      selectedColor: AdminColors.sunSoft,
      checkmarkColor: AdminColors.espresso,
      side: const BorderSide(color: AdminColors.field),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AdminRadius.pill),
      ),
      labelStyle: const TextStyle(
        fontFamily: adminFont,
        fontFamilyFallback: adminFontFallback,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AdminColors.ink,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: AdminColors.espresso,
      unselectedLabelColor: AdminColors.muted,
      indicatorColor: AdminColors.sun,
      dividerColor: AdminColors.line,
      labelStyle: TextStyle(
        fontFamily: adminFont,
        fontFamilyFallback: adminFontFallback,
        fontWeight: FontWeight.w700,
        fontSize: 15,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AdminColors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titleTextStyle: text.titleLarge?.copyWith(fontSize: 20),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AdminColors.espresso,
      contentTextStyle: const TextStyle(
        fontFamily: adminFont,
        fontFamilyFallback: adminFontFallback,
        color: AdminColors.white,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AdminRadius.control),
      ),
      width: 440,
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      minVerticalPadding: 12,
      titleTextStyle: TextStyle(
        fontFamily: adminFont,
        fontFamilyFallback: adminFontFallback,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AdminColors.espresso,
      ),
      subtitleTextStyle: TextStyle(
        fontFamily: adminFont,
        fontFamilyFallback: adminFontFallback,
        fontSize: 13,
        color: AdminColors.subtle,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? AdminColors.espresso
            : AdminColors.white,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? AdminColors.sun
            : AdminColors.field,
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AdminColors.espresso,
      linearTrackColor: AdminColors.sunSoft,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AdminColors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AdminRadius.control),
        side: const BorderSide(color: AdminColors.line),
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AdminColors.espresso,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        fontFamily: adminFont,
        color: AdminColors.white,
        fontSize: 13,
      ),
    ),
  );
}

/// The Parla mark: the Smile Curve in a sun.
class ParlaMark extends StatelessWidget {
  const ParlaMark({super.key, this.size = 32, this.inverse = false});

  final double size;
  final bool inverse;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: inverse ? AdminColors.espresso : AdminColors.sun,
      ),
      alignment: Alignment.center,
      child: CustomPaint(
        size: Size(size * 0.56, size * 0.3),
        painter: _SmilePainter(
          inverse ? AdminColors.sun : AdminColors.espresso,
        ),
      ),
    ),
  );
}

class _SmilePainter extends CustomPainter {
  _SmilePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.height * 0.26;
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.1, h * 0.2)
      ..quadraticBezierTo(w * 0.5, h * 1.25, w * 0.9, h * 0.2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SmilePainter old) => old.color != color;
}

/// The sign-in steps: a brand panel beside the form on wide screens, the
/// form alone on narrow ones.
class AuthCard extends StatelessWidget {
  const AuthCard({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final form = Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!wide) ...[
                const Row(
                  children: [
                    ParlaMark(size: 36),
                    SizedBox(width: 10),
                    Text(
                      'parla',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
              Semantics(
                header: true,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 18),
              ...children,
            ],
          ),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: AdminColors.canvas,
      body: wide
          ? Row(
              children: [
                const Expanded(flex: 11, child: _BrandPanel()),
                Expanded(flex: 10, child: form),
              ],
            )
          : form,
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: ClipRect(
      child: ColoredBox(
        color: AdminColors.sun,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              right: -180,
              bottom: -200,
              child: Container(
                width: 560,
                height: 560,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFDD4D),
                ),
              ),
            ),
            Positioned(
              right: 60,
              bottom: 80,
              child: Container(
                width: 220,
                height: 220,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFE680),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ParlaMark(size: 40, inverse: true),
                      SizedBox(width: 12),
                      Text(
                        'parla',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  SizedBox(
                    width: 440,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Komanda üçün iş masası',
                          style: TextStyle(
                            fontFamily: 'PlayfairDisplay',
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            fontSize: 44,
                            height: 1.1,
                            color: AdminColors.espresso,
                          ),
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Məzmun, ekspert rəyi, dəstək və statistika: hamısı '
                          'bir yerdə.',
                          style: TextStyle(
                            fontSize: 17,
                            height: 1.55,
                            color: AdminColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
