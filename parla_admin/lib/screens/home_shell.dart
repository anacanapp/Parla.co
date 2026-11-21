import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../api/admin_api.dart';
import '../staff_session.dart';
import '../ui/texts.dart';
import '../ui/theme.dart';

/// The two groups of the side navigation.
enum SectionGroup { work, manage }

/// One section of the panel's navigation.
class AdminSection {
  const AdminSection(
    this.path,
    this.label,
    this.icon, {
    this.roles,
    this.group = SectionGroup.work,
  });

  final String path;
  final String label;
  final IconData icon;
  final SectionGroup group;

  /// Roles that see the section; `null` means every role.
  final Set<StaffRole>? roles;
}

const adminSections = [
  AdminSection('/overview', 'Ümumi', Icons.space_dashboard_outlined),
  AdminSection(
    '/content',
    'Məzmun',
    Icons.article_outlined,
    roles: {StaffRole.admin, StaffRole.editor, StaffRole.expert},
  ),
  AdminSection(
    '/messages',
    'Dəstək',
    Icons.chat_bubble_outline,
    roles: {StaffRole.admin, StaffRole.support},
  ),
  AdminSection(
    '/orders',
    'Sifarişlər',
    Icons.receipt_long_outlined,
    roles: {StaffRole.admin},
    group: SectionGroup.manage,
  ),
  AdminSection(
    '/ads',
    'Reklam',
    Icons.campaign_outlined,
    roles: {StaffRole.admin},
    group: SectionGroup.manage,
  ),
  AdminSection(
    '/users',
    'İstifadəçilər',
    Icons.people_outline,
    roles: {StaffRole.admin},
    group: SectionGroup.manage,
  ),
  AdminSection(
    '/dashboard',
    'Dashboard',
    Icons.bar_chart_rounded,
    roles: {StaffRole.admin},
    group: SectionGroup.manage,
  ),
  AdminSection(
    '/staff',
    'İşçilər',
    Icons.badge_outlined,
    roles: {StaffRole.admin},
    group: SectionGroup.manage,
  ),
];

/// The panel frame: a side navigation and the current section. On narrow
/// screens the navigation moves into a drawer.
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
    final current = sections
        .where((s) => location.startsWith(s.path))
        .firstOrNull;
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final nav = _SideNav(
      state: state,
      sections: sections,
      current: current,
      inDrawer: !wide,
    );
    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            SizedBox(width: 264, child: nav),
            Expanded(child: child),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AdminColors.white,
        surfaceTintColor: Colors.transparent,
        shape: const Border(bottom: BorderSide(color: AdminColors.line)),
        titleSpacing: 0,
        title: Row(
          children: [
            const ParlaMark(size: 28),
            const SizedBox(width: 10),
            Text(
              current?.label ?? 'parla',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: AdminColors.white,
        shape: const RoundedRectangleBorder(),
        child: nav,
      ),
      body: child,
    );
  }
}

class _SideNav extends StatelessWidget {
  const _SideNav({
    required this.state,
    required this.sections,
    required this.current,
    required this.inDrawer,
  });

  final StaffState state;
  final List<AdminSection> sections;
  final AdminSection? current;
  final bool inDrawer;

  @override
  Widget build(BuildContext context) {
    final role = state.me!.role;
    Widget group(String title, SectionGroup g) {
      final items = sections.where((s) => s.group == g).toList();
      if (items.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
                color: AdminColors.subtle,
              ),
            ),
          ),
          for (final s in items)
            _NavItem(
              section: s,
              selected: identical(s, current),
              onTap: () {
                if (inDrawer) Navigator.of(context).pop();
                context.go(s.path);
              },
            ),
          const SizedBox(height: 24),
        ],
      );
    }

    return Container(
      key: const ValueKey('admin-nav'),
      decoration: const BoxDecoration(
        color: AdminColors.white,
        border: Border(right: BorderSide(color: AdminColors.line)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 28),
              child: Row(
                children: [
                  ParlaMark(),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'parla',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'İdarə paneli',
                        style: TextStyle(
                          fontSize: 12,
                          color: AdminColors.subtle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  group('İş', SectionGroup.work),
                  group('İdarəetmə', SectionGroup.manage),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.fromLTRB(8, 14, 0, 16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AdminColors.line)),
              ),
              child: Row(
                children: [
                  ExcludeSemantics(
                    child: Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AdminColors.espresso,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        roleLabel(role).characters.first,
                        style: const TextStyle(
                          color: AdminColors.sun,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          roleLabel(role),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Sessiya ${_hhmm(state.me!.signInExpiresAt)}-dək',
                          key: const ValueKey('nav-session'),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AdminColors.subtle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    key: const ValueKey('sign-out'),
                    tooltip: 'Çıxış',
                    onPressed: state.signOut,
                    icon: const Icon(Icons.logout_rounded, size: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.section,
    required this.selected,
    required this.onTap,
  });

  final AdminSection section;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? AdminColors.sunSoft : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          key: ValueKey('nav-${section.path.substring(1)}'),
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          hoverColor: AdminColors.hover,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                Icon(
                  section.icon,
                  size: 20,
                  color: selected ? AdminColors.espresso : AdminColors.ink,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    section.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? AdminColors.espresso : AdminColors.ink,
                    ),
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

/// A section that arrives in a later phase.
class ComingSection extends StatelessWidget {
  const ComingSection({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(32),
    children: [
      Semantics(
        header: true,
        child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
      ),
      const SizedBox(height: 12),
      Text(body, style: Theme.of(context).textTheme.bodyLarge),
    ],
  );
}

String _hhmm(DateTime t) {
  final l = t.toLocal();
  return '${l.hour.toString().padLeft(2, '0')}:'
      '${l.minute.toString().padLeft(2, '0')}';
}
