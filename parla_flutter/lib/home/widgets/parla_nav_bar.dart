import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../routes.dart';
import '../../ui/brand.dart';
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

/// Bottom navigation: five tabs, each an icon with a text label.
///
/// Labels are 12 px before system text scaling and may shrink to fit
/// their fifth of the bar, so even the longest Russian label stays on one
/// line at large text sizes; the full label is always in the semantics.
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
        minimum: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            decoration: BoxDecoration(
              color: ParlaColors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F1F1A14),
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                for (final tab in ParlaTab.values)
                  Expanded(
                    child: _NavItem(
                      icon: tab.icon,
                      label: tab.label(l10n),
                      selected: tab == selected,
                      onTap: () {
                        if (tab != selected) context.go(tab.route);
                      },
                    ),
                  ),
              ],
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
    final color = selected ? ParlaColors.espresso : ParlaColors.muted;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44,
                  height: 28,
                  decoration: BoxDecoration(
                    color: selected ? ParlaColors.sun : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: ParlaIcon(icon, size: 20, color: color),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: kMinTextSize,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
