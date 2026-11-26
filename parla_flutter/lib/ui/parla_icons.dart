import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Brand icons (guidelines section 05): 24 px grid, 2 px rounded stroke,
/// a small smile detail where it fits. Drawn as SVG so they match the
/// design file exactly.
enum ParlaIconName {
  home(
    '<path d="M4 10.5 12 4l8 6.5V20a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1z"/>'
    '<path d="M9.5 15.5q2.5 2 5 0"/>',
  ),
  routine(
    '<path d="M10 6h10M10 12h10M10 18h10"/>'
    '<path d="M3.5 6l1.3 1.3L7 5M3.5 12l1.3 1.3L7 11M3.5 18l1.3 1.3L7 17"/>',
  ),
  scan(
    '<path d="M4 8V5a1 1 0 0 1 1-1h3M16 4h3a1 1 0 0 1 1 1v3M20 16v3a1 1 0 0 '
    '1-1 1h-3M8 20H5a1 1 0 0 1-1-1v-3"/><path d="M9 13.5q3 2.4 6 0"/>',
  ),
  sparkle(
    '<path d="M11 3l1.8 4.7L17.5 9.5l-4.7 1.8L11 16l-1.8-4.7L4.5 9.5l4.7-1.8z"/>'
    '<path d="M18 15v5M15.5 17.5h5"/>',
  ),
  profile('<circle cx="12" cy="8" r="4"/><path d="M4 21a8 8 0 0 1 16 0"/>'),
  sun(
    '<circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4'
    'M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"/>',
  ),
  moon('<path d="M20 14.5A8 8 0 1 1 9.5 4a6.5 6.5 0 0 0 10.5 10.5z"/>'),
  drop(
    '<path d="M12 3.5s-6 6.6-6 10.5a6 6 0 0 0 12 0c0-3.9-6-10.5-6-10.5z"/>'
    '<path d="M9.5 15q2.5 2 5 0"/>',
  ),
  move('<path d="M3 12h4l3-7 4 14 3-7h4"/>'),
  check('<path d="M5 12.5l4.5 4.5L19 7.5"/>'),
  plus('<path d="M12 5v14M5 12h14"/>'),
  minus('<path d="M5 12h14"/>'),
  arrowRight('<path d="M5 12h14M13 6l6 6-6 6"/>'),
  arrowLeft('<path d="M15 5l-7 7 7 7"/>'),
  dumbbell('<path d="M6 7v10M18 7v10M3 10v4M21 10v4M6 12h12"/>'),
  compass(
    '<circle cx="12" cy="12" r="9"/><path d="M15.5 8.5l-2 5-5 2 2-5z"/>',
  ),
  book(
    '<path d="M5 4h11a3 3 0 0 1 3 3v13H8a3 3 0 0 1-3-3z"/>'
    '<path d="M5 17a3 3 0 0 1 3-3h11"/>',
  ),
  bowl('<path d="M3 11h18a9 9 0 0 1-18 0z"/><path d="M12 7c0-2 1-3 3-4"/>'),
  bag('<path d="M5 8h14l-1 12H6z"/><path d="M9 8a3 3 0 0 1 6 0"/>'),
  lock(
    '<rect x="5" y="11" width="14" height="9" rx="2"/>'
    '<path d="M8 11V8a4 4 0 0 1 8 0v3"/>',
  ),
  bell(
    '<path d="M6 16V11a6 6 0 0 1 12 0v5l1.5 2h-15z"/><path d="M10 20a2 2 0 0 0 4 0"/>',
  ),
  pen('<path d="M4 20h4L19 9l-4-4L4 16z"/><path d="M13 7l4 4"/>');

  const ParlaIconName(this.paths);

  final String paths;
}

/// An outlined brand icon. Decorative by default: pair it with visible text.
/// Without [color] it takes the surrounding icon colour (dark ink on the
/// light "İşıq" pages, white inside a dark button).
class ParlaIcon extends StatelessWidget {
  const ParlaIcon(
    this.name, {
    super.key,
    this.size = 24,
    this.color,
    this.strokeWidth = 2,
  });

  final ParlaIconName name;
  final double size;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final svg =
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" '
        'fill="none" stroke="#000" stroke-width="$strokeWidth" '
        'stroke-linecap="round" stroke-linejoin="round">${name.paths}</svg>';
    return ExcludeSemantics(
      child: SvgPicture.string(
        svg,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(
          color ?? IconTheme.of(context).color ?? const Color(0xFF16130F),
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
