import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../parla_scope.dart';
import '../routes.dart';

/// Decides where the app opens: language choice on first launch, the home
/// screen for a finished profile, otherwise the welcome screen.
class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _route());
  }

  Future<void> _route() async {
    final scope = ParlaScope.of(context);
    String target;
    if (scope.settings.language == null) {
      target = Routes.language;
    } else if (!scope.api.isSignedIn) {
      target = Routes.welcome;
    } else {
      try {
        final profile = await scope.api.myProfile();
        target = profile == null ? Routes.age : Routes.home;
      } on Object {
        target = Routes.welcome;
      }
    }
    if (mounted) context.go(target);
  }

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}
