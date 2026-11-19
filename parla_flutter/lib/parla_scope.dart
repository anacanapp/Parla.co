import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:parla_shared/parla_shared.dart';

import 'habits/habit_tracker.dart';
import 'reminders/reminder_controller.dart';
import 'check/care_list.dart';
import 'routines/custom_routines.dart';
import 'discover/content_library.dart';
import 'discover/nutrition_book.dart';
import 'sport/sport_book.dart';
import 'services/parla_api.dart';
import 'services/usage_meter.dart';
import 'state/app_settings.dart';
import 'state/onboarding_state.dart';

/// Makes app-wide services available to every screen.
class ParlaScope extends InheritedWidget {
  const ParlaScope({
    super.key,
    required this.api,
    required this.settings,
    required this.onboarding,
    required this.clock,
    required this.shareExport,
    required this.habits,
    required this.reminders,
    required this.routines,
    required this.careList,
    required this.sport,
    required this.nutrition,
    required this.content,
    required this.usage,
    required this.ingredients,
    required super.child,
  });

  final ParlaApi api;
  final AppSettings settings;
  final OnboardingState onboarding;

  /// Current time. Replaced in tests.
  final DateTime Function() clock;

  /// Hands the exported JSON to the system share sheet. Replaced in tests.
  final Future<void> Function(String json) shareExport;

  /// Habit history of the signed-in account, kept on this device only.
  final HabitTracker habits;

  /// Reminder settings of the signed-in account (local notifications).
  final ReminderController reminders;

  /// The user's own routines (server with the health consent, else phone).
  final CustomRoutineBook routines;

  /// Product preferences, checked products and the shopping list.
  final CareListBook careList;

  /// Sport answers, plan and finished workouts.
  final SportBook sport;

  /// The daily plate of the nutrition tool.
  final NutritionBook nutrition;

  /// Published articles, recipes and expert profiles.
  final ContentLibrary content;

  /// Anonymous usage counts (only with the analytics consent).
  final UsageMeter usage;

  /// EU ingredient statuses shipped with the app (CosIng export).
  final IngredientDataset ingredients;

  /// Loads the signed-in account's on-device data: habits and reminders.
  Future<void> attachAccount() async {
    final id = api.accountId;
    await Future.wait([
      habits.attach(id),
      reminders.attach(id),
      routines.attach(id),
      careList.attach(id),
      sport.attach(id),
      nutrition.attach(id),
    ]);
    // Own-routine ticks moved from the habit log to the routines.
    if (id != null && api.accountId == id) {
      await routines.adoptTicks(habits.takeOwnRoutineTicks());
      final now = clock();
      // Once a day per app run; failures are ignored (it is only a count).
      unawaited(usage.start('${now.year}-${now.month}-${now.day}'));
    }
  }

  /// Sign-out: forgets the account's on-device data in memory and cancels
  /// its reminders. The stored data stays for the next sign-in.
  /// Syncs the health-consent documents again (after a consent change).
  Future<void> resyncDocuments() => Future.wait([
    routines.resync(),
    careList.resync(),
    sport.resync(),
    nutrition.resync(),
  ]);

  Future<void> detachAccount() async {
    usage.reset();
    habits.detach();
    routines.detach();
    careList.detach();
    sport.detach();
    nutrition.detach();
    await reminders.detach();
  }

  /// Account deletion: deletes the account's on-device data.
  Future<void> eraseAccountData() async {
    await habits.erase();
    habits.detach();
    await routines.erase();
    routines.detach();
    await careList.erase();
    careList.detach();
    await sport.erase();
    sport.detach();
    await nutrition.erase();
    nutrition.detach();
    await reminders.erase();
  }

  static ParlaScope of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<ParlaScope>()!;

  @override
  bool updateShouldNotify(ParlaScope oldWidget) => false;
}
