import 'package:flutter/widgets.dart';

import 'services/parla_api.dart';
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
    required super.child,
  });

  final ParlaApi api;
  final AppSettings settings;
  final OnboardingState onboarding;

  /// Current time. Replaced in tests.
  final DateTime Function() clock;

  static ParlaScope of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<ParlaScope>()!;

  @override
  bool updateShouldNotify(ParlaScope oldWidget) => false;
}
