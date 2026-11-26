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

/// Bottom navigation ("İşıq" design): a dark floating capsule with five
/// round tabs. The open tab is a lighter dark circle with a white icon,
/// the others are soft grey icons; the middle tab (Check) is a white
/// circle with the Parla mark. Every tab's name is in the semantics.
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
        child: Center(
          heightFactor: 1,
          child: DecoratedBox(
            key: const ValueKey('parla-nav'),
            decoration: const ShapeDecoration(
              color: Warm.black,
              shape: StadiumBorder(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final tab in ParlaTab.values)
                    _NavItem(
                      icon: tab.icon,
                      label: tab.label(l10n),
                      selected: tab == selected,
                      middle: tab == ParlaTab.check,
                      onTap: tab == selected
                          ? () {}
                          : () => context.go(tab.route),
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
    required this.middle,
    required this.onTap,
  });

  final ParlaIconName icon;
  final String label;
  final bool selected;
  final bool middle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = middle ? 52.0 : 48.0;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: size,
            height: size,
            decoration: ShapeDecoration(
              color: middle
                  ? Colors.white
                  : selected
                  ? const Color(0xFF2E2A24)
                  : Colors.transparent,
              shape: CircleBorder(
                side: middle && selected
                    ? const BorderSide(color: Warm.banana, width: 2.5)
                    : BorderSide.none,
              ),
            ),
            alignment: Alignment.center,
            child: middle
                ? const ParlaMark(size: 30)
                : ParlaIcon(
                    icon,
                    size: 21,
                    color: selected ? Colors.white : const Color(0xFFBDB5AA),
                  ),
          ),
        ),
      ),
    );
  }
}
