import 'package:flutter/material.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'api/admin_api.dart';
import 'screens/auth_screens.dart';
import 'screens/content_screens.dart';
import 'screens/stats_screen.dart';
import 'screens/support_screen.dart';
import 'screens/users_screen.dart';
import 'screens/home_shell.dart';
import 'screens/staff_screen.dart';
import 'staff_session.dart';
import 'ui/theme.dart';

/// The Parla admin panel.
class AdminApp extends StatefulWidget {
  const AdminApp({super.key, required this.api});

  final AdminApi api;

  @override
  State<AdminApp> createState() => _AdminAppState();
}

class _AdminAppState extends State<AdminApp> {
  late final StaffState _state = StaffState(widget.api)..refresh();
  late final GoRouter _router = _buildRouter(_state);

  @override
  void dispose() {
    _router.dispose();
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Parla Admin',
    debugShowCheckedModeBanner: false,
    theme: adminTheme(),
    locale: const Locale('az'),
    supportedLocales: const [Locale('az'), Locale('en')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    routerConfig: _router,
  );
}

const _stagePaths = {
  AdminStage.signedOut: '/sign-in',
  AdminStage.notStaff: '/join',
  AdminStage.setupTotp: '/2fa-setup',
  AdminStage.verifyTotp: '/2fa',
};

GoRouter _buildRouter(StaffState state) => GoRouter(
  initialLocation: '/overview',
  refreshListenable: state,
  redirect: (context, route) {
    if (!state.loaded) return '/loading';
    final stage = state.stage;
    final path = route.matchedLocation;
    if (stage != AdminStage.ready) {
      final target = _stagePaths[stage]!;
      return path == target ? null : target;
    }
    final gatePaths = {..._stagePaths.values, '/loading'};
    if (gatePaths.contains(path)) return '/overview';
    final section = adminSections.where((s) => path.startsWith(s.path));
    final roles = section.isEmpty ? null : section.first.roles;
    if (roles != null && !roles.contains(state.me?.role)) {
      return '/overview';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/loading',
      builder: (_, _) =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    ),
    GoRoute(
      path: '/sign-in',
      builder: (_, _) => SignInScreen(state: state),
    ),
    GoRoute(
      path: '/join',
      builder: (_, _) => JoinScreen(state: state),
    ),
    GoRoute(
      path: '/2fa-setup',
      builder: (_, _) => TotpSetupScreen(state: state),
    ),
    GoRoute(
      path: '/2fa',
      builder: (_, _) => TotpScreen(state: state),
    ),
    ShellRoute(
      builder: (context, route, child) => HomeShell(
        state: state,
        location: route.matchedLocation,
        child: child,
      ),
      routes: [
        GoRoute(
          path: '/overview',
          builder: (_, _) => const ComingSection(
            title: 'Ümumi',
            body:
                'Xoş gəldiniz. Məzmun bölməsində bloqlar, reseptlər və '
                'mütəxəssislər idarə olunur. İstifadəçilər və statistika C '
                'mərhələsində, bannerlər, mesajlar və push bildirişlər D '
                'mərhələsində əlavə olunur.',
          ),
        ),
        GoRoute(path: '/content', redirect: (_, _) => '/content/article'),
        GoRoute(
          path: '/content/:kind',
          redirect: (_, route) =>
              ContentKind.values.any(
                (k) => k.name == route.pathParameters['kind'],
              )
              ? null
              : '/content/article',
          builder: (_, route) =>
              ContentScreen(state: state, kind: route.pathParameters['kind']!),
        ),
        GoRoute(
          path: '/content/:kind/:id',
          builder: (_, route) => ContentEditorScreen(
            state: state,
            kind: route.pathParameters['kind']!,
            id: int.tryParse(route.pathParameters['id']!) ?? -1,
          ),
        ),
        GoRoute(
          path: '/users',
          redirect: (_, _) => state.isAdmin ? null : '/overview',
          builder: (_, _) => UsersScreen(state: state),
        ),
        GoRoute(
          path: '/stats',
          redirect: (_, _) =>
              state.me?.role == StaffRole.expert ? '/overview' : null,
          builder: (_, _) => StatsScreen(state: state),
        ),
        GoRoute(
          path: '/messages',
          redirect: (_, _) =>
              const {
                StaffRole.admin,
                StaffRole.support,
              }.contains(state.me?.role)
              ? null
              : '/overview',
          builder: (_, _) => SupportScreen(state: state),
        ),
        GoRoute(
          path: '/staff',
          builder: (_, _) => StaffScreen(state: state),
        ),
      ],
    ),
  ],
);
