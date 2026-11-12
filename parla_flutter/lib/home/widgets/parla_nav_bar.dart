import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../ui/brand.dart';
import '../../ui/parla_icons.dart';

/// Bottom navigation: four tabs, always icon plus text label at 18 px.
///
/// Four, not five: at 18 px the longest Russian label needs about 80 px,
/// more than a fifth of a 390 px screen. The routine lives on the home tab.
class ParlaNavBar extends StatelessWidget {
  const ParlaNavBar({super.key, required this.selected, required this.onTap});

  final int selected;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      (ParlaIconName.home, l10n.navToday),
      (ParlaIconName.scan, l10n.navScan),
      (ParlaIconName.sparkle, l10n.navHabits),
      (ParlaIconName.profile, l10n.navProfile),
    ];
    return Semantics(
      container: true,
      label: l10n.navMenuLabel,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            decoration: BoxDecoration(
              color: ParlaColors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A1F1A14),
                  blurRadius: 30,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: _NavItem(
                      icon: items[i].$1,
                      label: items[i].$2,
                      selected: i == selected,
                      onTap: () => onTap(i),
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
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: selected ? ParlaColors.sun : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: ParlaIcon(icon, color: color),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
