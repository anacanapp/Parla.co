import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'l10n/app_localizations.dart';
import 'parla_scope.dart';
import 'routes.dart';
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
  });

  final ParlaApi api;
  final AppSettings settings;
  final DateTime Function() clock;
  final Future<void> Function(String json) shareExport;

  @override
  State<ParlaApp> createState() => _ParlaAppState();
}

class _ParlaAppState extends State<ParlaApp> {
  final GoRouter _router = buildRouter();
  final OnboardingState _onboarding = OnboardingState();

  @override
  void dispose() {
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
