import 'package:go_router/go_router.dart';

import 'screens/age_screen.dart';
import 'screens/consent_screen.dart';
import 'screens/country_screen.dart';
import 'screens/guest_screen.dart';
import 'screens/habits_screen.dart';
import 'screens/home_screen.dart';
import 'screens/language_screen.dart';
import 'screens/privacy_screens.dart';
import 'screens/reminders_screen.dart';
import 'screens/quiz_screen.dart';
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
  static const quiz = '/quiz'; // M-09 to M-13
  static const home = '/home'; // M-14
  static const habits = '/habits'; // M-17, M-18
  static const reminders = '/habits/reminders'; // Part of M-26
  static const guest = '/guest'; // M-20 (placeholder)
  static const privacy = '/privacy'; // M-25, M-27, M-28
  static const legal = '/privacy/legal'; // M-34
  static const deleteAccount = '/privacy/delete'; // M-32
  static const accountDeleted = '/account-deleted'; // M-33
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
    GoRoute(path: Routes.quiz, builder: (_, _) => const QuizScreen()),
    GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen()),
    GoRoute(path: Routes.habits, builder: (_, _) => const HabitsScreen()),
    GoRoute(
      path: Routes.reminders,
      builder: (_, _) => const RemindersScreen(),
    ),
    GoRoute(path: Routes.guest, builder: (_, _) => const GuestScreen()),
    GoRoute(path: Routes.privacy, builder: (_, _) => const PrivacyScreen()),
    GoRoute(path: Routes.legal, builder: (_, _) => const LegalScreen()),
    GoRoute(
      path: Routes.deleteAccount,
      builder: (_, _) => const DeleteAccountScreen(),
    ),
    GoRoute(
      path: Routes.accountDeleted,
      builder: (_, _) => const AccountDeletedScreen(),
    ),
  ],
);
