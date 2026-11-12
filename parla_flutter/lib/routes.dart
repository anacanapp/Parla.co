import 'package:go_router/go_router.dart';

import 'screens/age_screen.dart';
import 'screens/consent_screen.dart';
import 'screens/country_screen.dart';
import 'screens/guest_screen.dart';
import 'screens/home_screen.dart';
import 'screens/language_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/start_screen.dart';
import 'screens/underage_screen.dart';
import 'screens/welcome_screen.dart';

/// Route paths. Screen ids refer to the screen list document.
abstract final class Routes {
  static const start = '/';
  static const language = '/language'; // M-01
  static const welcome = '/welcome'; // M-02
  static const age = '/age'; // M-03
  static const underage = '/underage'; // M-04
  static const signIn = '/sign-in'; // M-05, M-06
  static const country = '/country'; // M-07
  static const consents = '/consents'; // M-08
  static const home = '/home'; // M-14 (placeholder)
  static const guest = '/guest'; // M-20 (placeholder)
}

GoRouter buildRouter() => GoRouter(
  initialLocation: Routes.start,
  routes: [
    GoRoute(path: Routes.start, builder: (_, _) => const StartScreen()),
    GoRoute(path: Routes.language, builder: (_, _) => const LanguageScreen()),
    GoRoute(path: Routes.welcome, builder: (_, _) => const WelcomeScreen()),
    GoRoute(path: Routes.age, builder: (_, _) => const AgeScreen()),
    GoRoute(path: Routes.underage, builder: (_, _) => const UnderageScreen()),
    GoRoute(path: Routes.signIn, builder: (_, _) => const SignInScreen()),
    GoRoute(path: Routes.country, builder: (_, _) => const CountryScreen()),
    GoRoute(path: Routes.consents, builder: (_, _) => const ConsentScreen()),
    GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen()),
    GoRoute(path: Routes.guest, builder: (_, _) => const GuestScreen()),
  ],
);
