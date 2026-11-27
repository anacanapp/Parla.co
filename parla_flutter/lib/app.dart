import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import 'habits/habit_store.dart';
import 'habits/habit_tracker.dart';
import 'l10n/app_localizations.dart';
import 'reminders/reminder_controller.dart';
import 'reminders/reminder_scheduler.dart';
import 'parla_scope.dart';
import 'services/usage_meter.dart';
import 'routes.dart';
import 'check/care_list.dart';
import 'routines/custom_routines.dart';
import 'discover/saved_recipes.dart';
import 'discover/banner_strip.dart';
import 'discover/content_library.dart';
import 'push/push_client.dart';
import 'discover/nutrition_book.dart';
import 'journal/journal_book.dart';
import 'sport/sport_book.dart';
import 'services/export_share.dart';
import 'services/parla_api.dart';
import 'state/app_settings.dart';
import 'state/onboarding_state.dart';
import 'ui/brand.dart';
import 'ui/tone_scope.dart';
import 'ui/system_texts.dart';
import 'screens/language_screen.dart' show choosableLanguages;

/// The Parla user app.
class ParlaApp extends StatefulWidget {
  const ParlaApp({
    super.key,
    required this.api,
    required this.settings,
    this.clock = DateTime.now,
    this.shareExport = shareExportFile,
    this.habitStore = const SecureHabitStore(),
    this.routineStore = const SecureHabitStore.routines(),
    this.careListStore = const SecureHabitStore.careList(),
    this.sportStore = const SecureHabitStore.sport(),
    this.nutritionStore = const SecureHabitStore.nutrition(),
    this.journalStore = const SecureHabitStore.journal(),
    this.reminderScheduler,
    this.ingredientDataset,
  });

  final ParlaApi api;
  final AppSettings settings;
  final DateTime Function() clock;
  final Future<void> Function(String json) shareExport;
  final HabitStore habitStore;

  /// Where the user's own routines are kept (on the device).
  final HabitStore routineStore;

  /// Where the phone copy of the "Yoxla" data is kept.
  final HabitStore careListStore;

  /// Where the phone copy of the sport answers and workouts is kept.
  final HabitStore sportStore;

  /// Where the phone copy of the daily plate is kept.
  final HabitStore nutritionStore;
  final HabitStore journalStore;

  /// Defaults to local notifications on the device.
  final ReminderScheduler? reminderScheduler;

  /// Defaults to the CosIng data shipped in `parla_shared`.
  final IngredientDataset? ingredientDataset;

  @override
  State<ParlaApp> createState() => _ParlaAppState();
}

class _ParlaAppState extends State<ParlaApp> {
  final GoRouter _router = buildRouter();
  StreamSubscription<String>? _pushLinks;
  final OnboardingState _onboarding = OnboardingState();
  late final HabitTracker _habits = HabitTracker(
    store: widget.habitStore,
    clock: widget.clock,
  );

  late final NutritionBook _nutrition = NutritionBook(
    store: widget.nutritionStore,
    api: widget.api,
    clock: widget.clock,
  );

  late final JournalBook _journal = JournalBook(
    store: widget.journalStore,
    clock: widget.clock,
  );

  late final ContentLibrary _content = ContentLibrary(widget.api);

  late final UsageMeter _usage = UsageMeter(
    hasConsent: () async {
      try {
        final states = await widget.api.consentStates();
        return states[ConsentKind.analytics] ?? false;
      } on Object {
        return null;
      }
    },
    send: widget.api.reportUsage,
  );
  late final AppLifecycleListener _lifecycle = AppLifecycleListener(
    onHide: _usage.flush,
  );

  late final SportBook _sport = SportBook(
    store: widget.sportStore,
    api: widget.api,
    clock: widget.clock,
  );

  final SavedRecipes _savedRecipes = SavedRecipes();

  late final CareListBook _careList = CareListBook(
    store: widget.careListStore,
    api: widget.api,
    clock: widget.clock,
  );

  late final CustomRoutineBook _routines = CustomRoutineBook(
    store: widget.routineStore,
    api: widget.api,
    clock: widget.clock,
  );

  late final ReminderController _reminders = ReminderController(
    scheduler: widget.reminderScheduler ?? LocalReminderScheduler(),
    language: () => widget.settings.contentLanguage,
  );
  String? _language;

  @override
  void initState() {
    super.initState();
    // Team texts and hidden flags for preferences, exercises and steps.
    _content.loadCatalogue();
    // A tapped push notification opens its in-app link.
    _pushLinks = PushService.client?.openedLinks.listen((link) {
      final route = linkRoute(link);
      if (route != null) _router.go(route.$1, extra: route.$2);
    });
    _language = widget.settings.language;
    widget.settings.addListener(_onSettings);
    _router.routerDelegate.addListener(_onRoute);
    _lifecycle;
  }

  /// Counts which tool, article or recipe was opened (only with the
  /// analytics consent; see [UsageMeter]).
  void _onRoute() {
    final match = _router.routerDelegate.currentConfiguration;
    if (match.isEmpty) return;
    final path = match.uri.path;
    final extra = match.extra;
    if (path == Routes.blogPost && extra is String) {
      _usage.count(UsageEvent.article, extra);
    } else if (path == Routes.recipe && extra is String) {
      _usage.count(UsageEvent.recipe, extra);
    } else if (path == Routes.shopProduct && extra is String) {
      _usage.count(UsageEvent.product, extra);
    }
    final tool = routeTools[path];
    if (tool != null) _usage.tool(tool);
  }

  /// Reminder texts follow the interface language.
  void _onSettings() {
    if (widget.settings.language == _language) return;
    _language = widget.settings.language;
    _reminders.refreshTexts();
  }

  @override
  void dispose() {
    widget.settings.removeListener(_onSettings);
    _reminders.dispose();
    _routines.dispose();
    _careList.dispose();
    _savedRecipes.dispose();
    _sport.dispose();
    _nutrition.dispose();
    _journal.dispose();
    _content.dispose();
    _habits.dispose();
    _pushLinks?.cancel();
    _router.routerDelegate.removeListener(_onRoute);
    _lifecycle.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ParlaScope(
      api: widget.api,
      settings: widget.settings,
      onboarding: _onboarding,
      clock: widget.clock,
      shareExport: widget.shareExport,
      habits: _habits,
      reminders: _reminders,
      routines: _routines,
      careList: _careList,
      sport: _sport,
      nutrition: _nutrition,
      journal: _journal,
      content: _content,
      savedRecipes: _savedRecipes,
      usage: _usage,
      ingredients: widget.ingredientDataset ?? euIngredientDataset,
      child: ListenableBuilder(
        listenable: widget.settings,
        builder: (context, _) => ToneScope(
          dark: switch (widget.settings.appearance) {
            Appearance.light => false,
            Appearance.dark => true,
            Appearance.system =>
              MediaQuery.platformBrightnessOf(context) == Brightness.dark,
          },
          // A fresh theme for the tone just set (the tokens read it).
          builder: (context) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
            // Day "İşıq" or night "Espresso" (owner, 2026-11-26).
            theme: parlaTheme(),
            locale: widget.settings.locale,
            // Only the languages people can choose: a phone set to a
            // language still being checked gets the default one.
            supportedLocales: [
              for (final code in choosableLanguages) Locale(code),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              SystemTextsDelegate(GlobalMaterialLocalizations.delegate),
              SystemTextsDelegate(GlobalWidgetsLocalizations.delegate),
              SystemTextsDelegate(GlobalCupertinoLocalizations.delegate),
            ],
            routerConfig: _router,
          ),
        ),
      ),
    );
  }
}
