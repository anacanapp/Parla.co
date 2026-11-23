import 'package:go_router/go_router.dart';

import 'ui/night.dart';
import 'package:parla_shared/parla_shared.dart';

import 'check/shop_screen.dart';
import 'consent/consent_refresh.dart';
import 'check/shopping_list_screen.dart';
import 'discover/discover_screens.dart';
import 'journal/journal_screens.dart';
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

/// Which counted tool each screen belongs to (usage statistics).
const routeTools = {
  Routes.home: UsageTool.home,
  Routes.habits: UsageTool.habits,
  Routes.reminders: UsageTool.reminders,
  Routes.routineBuilder: UsageTool.routineBuilder,
  Routes.products: UsageTool.check,
  Routes.productDetail: UsageTool.productDetail,
  Routes.shoppingList: UsageTool.shoppingList,
  Routes.shop: UsageTool.shop,
  Routes.sport: UsageTool.sport,
  Routes.sportQuiz: UsageTool.sportQuiz,
  Routes.workout: UsageTool.workout,
  Routes.discover: UsageTool.discover,
  Routes.blog: UsageTool.blog,
  Routes.experts: UsageTool.experts,
  Routes.nutrition: UsageTool.nutrition,
  Routes.journal: UsageTool.journal,
  Routes.journalEntry: UsageTool.journal,
  Routes.messages: UsageTool.messages,
  Routes.privacy: UsageTool.privacy,
};

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
  static const shop = '/products/shop'; // Shop: partners' products
  static const shopProduct = '/products/shop/item'; // Slug as `extra`
  static const shopOrders = '/products/shop/orders'; // "My orders"
  static const sport = '/sport'; // Workout plan (redesign step 4)
  static const sportQuiz = '/sport/quiz'; // Sport questions
  static const workout = '/sport/workout'; // One workout, id as `extra`
  static const discover = '/discover'; // Blogs, experts, lists (step 5)
  static const blog = '/discover/blog';
  static const blogPost = '/discover/blog/post'; // Slug as `extra`
  static const experts = '/discover/experts';
  static const nutrition = '/discover/nutrition';
  static const recipe = '/discover/recipe'; // Slug as `extra`
  static const journal = '/discover/journal'; // Private, phone only
  static const journalEntry = '/discover/journal/entry'; // Id as `extra`
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
    _page(path: Routes.start, builder: (_, _) => const StartScreen()),
    _page(path: Routes.language, builder: (_, _) => const LanguageScreen()),
    _page(path: Routes.welcome, builder: (_, _) => const WelcomeScreen()),
    _page(path: Routes.age, builder: (_, _) => const AgeScreen()),
    _page(path: Routes.underage, builder: (_, _) => const UnderageScreen()),
    _page(path: Routes.signIn, builder: (_, _) => const SignInScreen()),
    _page(path: Routes.country, builder: (_, _) => const CountryScreen()),
    _page(path: Routes.consents, builder: (_, _) => const ConsentScreen()),
    _page(
      path: Routes.consentRefresh,
      builder: (_, _) => const ConsentRefreshScreen(),
    ),
    _page(path: Routes.quiz, builder: (_, _) => const QuizScreen()),
    _page(path: Routes.home, builder: (_, _) => const HomeScreen()),
    _page(path: Routes.habits, builder: (_, _) => const HabitsScreen()),
    _page(
      path: Routes.reminders,
      builder: (_, _) => const RemindersScreen(),
    ),
    _page(
      path: Routes.routineBuilder,
      // The routine id to edit travels as `extra`; without it a new
      // routine is made.
      builder: (_, state) => RoutineBuilderScreen(
        routineId: state.extra is String ? state.extra! as String : null,
      ),
    ),
    _page(
      path: Routes.products,
      builder: (_, _) => const ProductSearchScreen(),
    ),
    _page(
      path: Routes.productDetail,
      // The product travels in memory only; without it (e.g. a reload on
      // the web) the search opens again.
      redirect: (_, state) =>
          state.extra is ProductResult ? null : Routes.products,
      builder: (_, state) =>
          ProductDetailScreen(product: state.extra! as ProductResult),
    ),
    _page(
      path: Routes.shoppingList,
      builder: (_, _) => const ShoppingListScreen(),
    ),
    _page(path: Routes.shop, builder: (_, _) => const ShopScreen()),
    _page(
      path: Routes.shopOrders,
      builder: (_, _) => const ShopOrdersScreen(),
    ),
    _page(
      path: Routes.shopProduct,
      redirect: (_, state) => state.extra is String ? null : Routes.shop,
      builder: (_, state) => ShopProductScreen(slug: state.extra! as String),
    ),
    _page(path: Routes.sport, builder: (_, _) => const SportScreen()),
    _page(
      path: Routes.sportQuiz,
      builder: (_, _) => const SportQuizScreen(),
    ),
    _page(
      path: Routes.workout,
      // The workout id travels in memory; without it the plan opens.
      redirect: (_, state) => state.extra is String ? null : Routes.sport,
      builder: (_, state) => WorkoutScreen(workoutId: state.extra! as String),
    ),
    _page(path: Routes.discover, builder: (_, _) => const DiscoverScreen()),
    _page(
      path: Routes.blog,
      builder: (_, state) => BlogListScreen(
        tag: state.extra is String ? state.extra! as String : null,
      ),
    ),
    _page(
      path: Routes.blogPost,
      redirect: (_, state) => state.extra is String ? null : Routes.blog,
      builder: (_, state) => BlogPostScreen(slug: state.extra! as String),
    ),
    _page(path: Routes.experts, builder: (_, _) => const ExpertsScreen()),
    _page(
      path: Routes.nutrition,
      builder: (_, _) => const NutritionScreen(),
    ),
    _page(
      path: Routes.recipe,
      redirect: (_, state) => state.extra is String ? null : Routes.nutrition,
      builder: (_, state) => RecipeScreen(slug: state.extra! as String),
    ),
    _page(path: Routes.journal, builder: (_, _) => const JournalScreen()),
    _page(
      path: Routes.journalEntry,
      builder: (_, state) => JournalEntryScreen(id: state.extra as String?),
    ),
    _page(path: Routes.guest, builder: (_, _) => const GuestScreen()),
    _page(path: Routes.messages, builder: (_, _) => const MessagesScreen()),
    _page(path: Routes.privacy, builder: (_, _) => const PrivacyScreen()),
    _page(path: Routes.legal, builder: (_, _) => const LegalScreen()),
    _page(
      path: Routes.deleteAccount,
      builder: (_, _) => const DeleteAccountScreen(),
    ),
    _page(
      path: Routes.accountDeleted,
      builder: (_, _) => const AccountDeletedScreen(),
    ),
  ],
);

/// A route whose page carries the night backdrop, so every page is opaque
/// during its transition and scaffolds can stay transparent.
GoRoute _page({
  required String path,
  required GoRouterWidgetBuilder builder,
  GoRouterRedirect? redirect,
}) => GoRoute(
  path: path,
  redirect: redirect,
  builder: (context, state) => NightBackdrop(child: builder(context, state)),
);
