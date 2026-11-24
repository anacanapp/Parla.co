import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../routes.dart';
import '../../ui/parla_icons.dart';

/// The five main tabs (owner's order, 2026-11-20). Sport opens from
/// Discover; the profile and privacy centre is the last tab.
enum ParlaTab {
  today(ParlaIconName.home, Routes.home),
  routine(ParlaIconName.sparkle, Routes.habits),
  check(ParlaIconName.scan, Routes.products),
  discover(ParlaIconName.compass, Routes.discover),
  profile(ParlaIconName.profile, Routes.privacy);

  const ParlaTab(this.icon, this.route);

  final ParlaIconName icon;
  final String route;

  String label(AppLocalizations l10n) => switch (this) {
    ParlaTab.today => l10n.navToday,
    ParlaTab.routine => l10n.navRoutine,
    ParlaTab.check => l10n.navCheck,
    ParlaTab.discover => l10n.navDiscover,
    ParlaTab.profile => l10n.navProfile,
  };
}

/// Bottom navigation (night design 3.0): a floating glass capsule with
/// five tabs. The open tab is a light capsule with its icon and name; the
/// others show their icon, and every tab's name is in the semantics.
///
/// The bar is the prototype's 66 px glass capsule, 16 px from the sides
/// and 18 px from the bottom. The open tab's label is 13 px before system
/// text scaling and may shrink to fit, so even the longest Russian label stays on one line at
/// large text sizes.
class ParlaNavBar extends StatelessWidget {
  const ParlaNavBar({super.key, required this.selected});

  final ParlaTab selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      container: true,
      label: l10n.navMenuLabel,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          // Warm day design: a black capsule; the open tab is white.
          child: Container(
            key: const ValueKey('parla-nav'),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: const ShapeDecoration(
              color: Color(0xE00F0F12),
              shape: StadiumBorder(),
              shadows: [
                BoxShadow(
                  color: Color(0x33281409),
                  blurRadius: 30,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: SizedBox(
              height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final tab in ParlaTab.values)
                    if (tab == selected)
                      Flexible(
                        child: _NavItem(
                          icon: tab.icon,
                          label: tab.label(l10n),
                          selected: true,
                          onTap: () {},
                        ),
                      )
                    else
                      _NavItem(
                        icon: tab.icon,
                        label: tab.label(l10n),
                        selected: false,
                        onTap: () => context.go(tab.route),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final ParlaIconName icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // The open tab: a light capsule with dark ink; the others are light
    // icons at 75 % on the glass.
    final color = selected ? _ink : const Color(0xD9FFFFFF);
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 50,
          constraints: const BoxConstraints(minWidth: 50),
          padding: EdgeInsets.symmetric(horizontal: selected ? 16 : 0),
          decoration: ShapeDecoration(
            color: selected ? Colors.white : Colors.transparent,
            shape: const StadiumBorder(),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ParlaIcon(icon, size: selected ? 18 : 22, color: color),
              if (selected) ...[
                const SizedBox(width: 6),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Dark ink on the light capsule.
const _ink = Color(0xFF1A0B2A);
