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
import 'routes.dart';
import 'check/care_list.dart';
import 'routines/custom_routines.dart';
import 'discover/content_library.dart';
import 'discover/nutrition_book.dart';
import 'sport/sport_book.dart';
import 'services/export_share.dart';
import 'services/parla_api.dart';
import 'state/app_settings.dart';
import 'state/onboarding_state.dart';
import 'ui/brand.dart';

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

  /// Defaults to local notifications on the device.
  final ReminderScheduler? reminderScheduler;

  /// Defaults to the CosIng data shipped in `parla_shared`.
  final IngredientDataset? ingredientDataset;

  @override
  State<ParlaApp> createState() => _ParlaAppState();
}

class _ParlaAppState extends State<ParlaApp> {
  final GoRouter _router = buildRouter();
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

  late final ContentLibrary _content = ContentLibrary(widget.api);

  late final SportBook _sport = SportBook(
    store: widget.sportStore,
    api: widget.api,
    clock: widget.clock,
  );

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
    language: () => widget.settings.language ?? defaultLanguage,
  );
  String? _language;

  @override
  void initState() {
    super.initState();
    _language = widget.settings.language;
    widget.settings.addListener(_onSettings);
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
    _sport.dispose();
    _nutrition.dispose();
    _content.dispose();
    _habits.dispose();
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
      content: _content,
      ingredients: widget.ingredientDataset ?? euIngredientDataset,
      child: ListenableBuilder(
        listenable: widget.settings,
        builder: (context, _) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          // Light only for now: the brand's dark ("cocoa") theme is not
          // designed yet.
          theme: parlaTheme(),
          locale: widget.settings.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: _router,
        ),
      ),
    );
  }
}
