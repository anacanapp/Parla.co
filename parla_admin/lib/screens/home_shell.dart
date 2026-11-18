import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../api/admin_api.dart';
import '../staff_session.dart';
import '../ui/texts.dart';
import '../ui/theme.dart';

/// One section of the panel's navigation.
class AdminSection {
  const AdminSection(this.path, this.label, this.icon, {this.roles});

  final String path;
  final String label;
  final IconData icon;

  /// Roles that see the section; `null` means every role.
  final Set<StaffRole>? roles;
}

const adminSections = [
  AdminSection('/overview', 'Ümumi', Icons.dashboard_outlined),
  AdminSection(
    '/content',
    'Məzmun',
    Icons.article_outlined,
    roles: {StaffRole.admin, StaffRole.editor, StaffRole.expert},
  ),
  AdminSection(
    '/users',
    'İstifadəçilər',
    Icons.people_outline,
    roles: {StaffRole.admin},
  ),
  AdminSection(
    '/stats',
    'Statistika',
    Icons.insights_outlined,
    roles: {StaffRole.admin, StaffRole.editor},
  ),
  AdminSection(
    '/messages',
    'Dəstək',
    Icons.support_agent_outlined,
    roles: {StaffRole.admin, StaffRole.support},
  ),
  AdminSection(
    '/staff',
    'İşçilər',
    Icons.badge_outlined,
    roles: {StaffRole.admin},
  ),
];

/// The panel frame: a side navigation and the current section.
class HomeShell extends StatelessWidget {
  const HomeShell({
    super.key,
    required this.state,
    required this.location,
    required this.child,
  });

  final StaffState state;
  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final sections = [
      for (final s in adminSections)
        if (s.roles == null || s.roles!.contains(state.me?.role)) s,
    ];
    final index = sections
        .indexWhere((s) => location.startsWith(s.path))
        .clamp(0, sections.length - 1);
    final me = state.me!;
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: AdminColors.white,
            extended: MediaQuery.sizeOf(context).width >= 1000,
            selectedIndex: index,
            onDestinationSelected: (i) => context.go(sections[i].path),
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'parla',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Chip(label: Text(roleLabel(me.role))),
                      IconButton(
                        key: const ValueKey('sign-out'),
                        tooltip: 'Çıxış',
                        onPressed: state.signOut,
                        icon: const Icon(Icons.logout),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            destinations: [
              for (final s in sections)
                NavigationRailDestination(
                  icon: Icon(s.icon),
                  label: Text(s.label),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
