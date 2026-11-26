import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../routes.dart';
import '../../ui/parla_icons.dart';
import '../../ui/parla_mark.dart';
import '../../ui/warm.dart';

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

/// Bottom navigation (light design, owner 2026-11-26): a dark capsule
/// that floats over the page. Tabs are round icons; the open one sits on
/// a lighter disc. The middle tab (product check) is a white disc with the
/// Parla mark. Every tab's name is in the semantics.
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
        minimum: const EdgeInsets.only(bottom: 16),
        child: Center(
          heightFactor: 1,
          child: DecoratedBox(
            key: const ValueKey('parla-nav'),
            decoration: const ShapeDecoration(
              color: Warm.ink,
              shape: StadiumBorder(),
              shadows: [
                BoxShadow(
                  color: Color(0x59000000),
                  blurRadius: 30,
                  offset: Offset(0, 14),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final tab in ParlaTab.values)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: _NavItem(
                        tab: tab,
                        label: tab.label(l10n),
                        selected: tab == selected,
                        onTap: tab == selected
                            ? () {}
                            : () => context.go(tab.route),
                      ),
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
    required this.tab,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final ParlaTab tab;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final middle = tab == ParlaTab.check;
    final size = middle ? 52.0 : 48.0;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: middle
                  ? Colors.white
                  : selected
                  ? const Color(0xFF3A3530)
                  : Colors.transparent,
              border: middle && selected
                  ? Border.all(color: Warm.banana, width: 3)
                  : null,
            ),
            child: middle
                ? const ParlaMark(size: 30)
                : ParlaIcon(
                    tab.icon,
                    size: 21,
                    color: selected ? Warm.onDark : const Color(0xFFBDB5AA),
                  ),
          ),
        ),
      ),
    );
  }
}
