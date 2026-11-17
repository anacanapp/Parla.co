import 'package:go_router/go_router.dart';

import 'check/shop_screen.dart';
import 'consent/consent_refresh.dart';
import 'check/shopping_list_screen.dart';
import 'discover/discover_screens.dart';
import 'messages/messages_screen.dart';
import 'routines/routine_builder_screen.dart';
import 'sport/sport_quiz_screen.dart';
import 'sport/sport_screen.dart';
import 'sport/workout_screen.dart';
import 'screens/age_screen.dart';
import 'screens/consent_screen.dart';
import 'screens/coming_soon_screens.dart';
import 'screens/country_screen.dart';
import 'screens/guest_screen.dart';
import 'screens/habits_screen.dart';
import 'screens/home_screen.dart';
import 'services/parla_api.dart';
import 'screens/language_screen.dart';
import 'screens/privacy_screens.dart';
import 'screens/products_screen.dart';
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
  static const consentRefresh = '/consents/refresh'; // CON-3
  static const quiz = '/quiz'; // M-09 to M-13
  static const home = '/home'; // M-14
  static const habits = '/habits'; // M-17, M-18
  static const reminders = '/habits/reminders'; // Part of M-26
  static const routineBuilder = '/habits/builder'; // Own routine (step 2)
  static const products = '/products'; // M-20, M-22
  static const productDetail = '/products/detail'; // M-21, M-23
  static const shoppingList = '/products/list'; // Shopping list (step 3)
  static const shop = '/products/shop'; // Shop "coming soon" (step 3)
  static const sport = '/sport'; // Workout plan (redesign step 4)
  static const sportQuiz = '/sport/quiz'; // Sport questions
  static const workout = '/sport/workout'; // One workout, id as `extra`
  static const discover = '/discover'; // Blogs, experts, lists (step 5)
  static const blog = '/discover/blog';
  static const blogPost = '/discover/blog/post'; // Slug as `extra`
  static const experts = '/discover/experts';
  static const nutrition = '/discover/nutrition';
  static const recipe = '/discover/recipe'; // Slug as `extra`
  static const guest = '/guest'; // Guest placeholder
  static const messages = '/messages'; // Announcements and support (D2)
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
    GoRoute(
      path: Routes.consentRefresh,
      builder: (_, _) => const ConsentRefreshScreen(),
    ),
    GoRoute(path: Routes.quiz, builder: (_, _) => const QuizScreen()),
    GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen()),
    GoRoute(path: Routes.habits, builder: (_, _) => const HabitsScreen()),
    GoRoute(
      path: Routes.reminders,
      builder: (_, _) => const RemindersScreen(),
    ),
    GoRoute(
      path: Routes.routineBuilder,
      // The routine id to edit travels as `extra`; without it a new
      // routine is made.
      builder: (_, state) => RoutineBuilderScreen(
        routineId: state.extra is String ? state.extra! as String : null,
      ),
    ),
    GoRoute(
      path: Routes.products,
      builder: (_, _) => const ProductSearchScreen(),
    ),
    GoRoute(
      path: Routes.productDetail,
      // The product travels in memory only; without it (e.g. a reload on
      // the web) the search opens again.
      redirect: (_, state) =>
          state.extra is ProductResult ? null : Routes.products,
      builder: (_, state) =>
          ProductDetailScreen(product: state.extra! as ProductResult),
    ),
    GoRoute(
      path: Routes.shoppingList,
      builder: (_, _) => const ShoppingListScreen(),
    ),
    GoRoute(path: Routes.shop, builder: (_, _) => const ShopScreen()),
    GoRoute(path: Routes.sport, builder: (_, _) => const SportScreen()),
    GoRoute(
      path: Routes.sportQuiz,
      builder: (_, _) => const SportQuizScreen(),
    ),
    GoRoute(
      path: Routes.workout,
      // The workout id travels in memory; without it the plan opens.
      redirect: (_, state) => state.extra is String ? null : Routes.sport,
      builder: (_, state) => WorkoutScreen(workoutId: state.extra! as String),
    ),
    GoRoute(path: Routes.discover, builder: (_, _) => const DiscoverScreen()),
    GoRoute(path: Routes.blog, builder: (_, _) => const BlogListScreen()),
    GoRoute(
      path: Routes.blogPost,
      redirect: (_, state) => state.extra is String ? null : Routes.blog,
      builder: (_, state) => BlogPostScreen(slug: state.extra! as String),
    ),
    GoRoute(path: Routes.experts, builder: (_, _) => const ExpertsScreen()),
    GoRoute(
      path: Routes.nutrition,
      builder: (_, _) => const NutritionScreen(),
    ),
    GoRoute(
      path: Routes.recipe,
      redirect: (_, state) => state.extra is String ? null : Routes.nutrition,
      builder: (_, state) => RecipeScreen(slug: state.extra! as String),
    ),
    GoRoute(path: Routes.guest, builder: (_, _) => const GuestScreen()),
    GoRoute(path: Routes.messages, builder: (_, _) => const MessagesScreen()),
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
