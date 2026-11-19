import 'package:flutter/foundation.dart';
import 'package:parla_shared/parla_shared.dart';

/// The app version from the build (`--build-name`), for the version counts.
const appBuildName = String.fromEnvironment(
  'FLUTTER_BUILD_NAME',
  defaultValue: '0.0.0',
);

/// The platform name the usage statistics use.
UsagePlatform get currentUsagePlatform => switch (defaultTargetPlatform) {
  TargetPlatform.iOS => UsagePlatform.ios,
  TargetPlatform.android => UsagePlatform.android,
  _ => UsagePlatform.other,
};

/// Counts tool openings, opened articles and recipes, and banner views and
/// taps for the anonymous usage statistics (see `UsageRules`).
///
/// Nothing is counted or sent without the analytics consent: [start] asks
/// the server for the consent state first, and until it is known the counts
/// only wait in memory. Counts never leave the phone with anything but the
/// platform; the server adds them to the day's totals.
class UsageMeter {
  UsageMeter({
    required this.hasConsent,
    required this.send,
    UsagePlatform? platform,
    this.appVersion = appBuildName,
  }) : platform = platform ?? currentUsagePlatform;

  /// The analytics consent state; `null` when it could not be read.
  final Future<bool?> Function() hasConsent;

  /// Sends counts; returns whether the server counted them.
  final Future<bool> Function(String platform, Map<String, int> counts) send;
  final UsagePlatform platform;
  final String appVersion;

  /// Whether counting is on; `null` until the consent state is known.
  bool? _enabled;
  final _pending = <String, int>{};
  final _shownBanners = <int>{};
  String? _startedDay;
  bool _sending = false;

  bool? get enabled => _enabled;

  /// Counts waiting to be sent (for tests).
  Map<String, int> get pending => Map.unmodifiable(_pending);

  /// Counts one [event] with [target]. Ignored without the consent.
  void count(UsageEvent event, String target) {
    if (_enabled == false) return;
    if (!UsageRules.validTarget(event, target)) return;
    final key = UsageRules.key(event, target);
    _pending[key] = (_pending[key] ?? 0) + 1;
    if (_pending.length >= 30) flush();
  }

  void tool(UsageTool tool) => count(UsageEvent.tool, tool.name);

  /// A banner was shown: counted once per app run.
  void bannerShown(int id) {
    if (_shownBanners.add(id)) count(UsageEvent.bannerView, '$id');
  }

  void bannerTapped(int id) => count(UsageEvent.bannerTap, '$id');

  /// After sign-in, once a day per app run: reads the consent and, with
  /// it, reports the app opening (the server then counts the account as
  /// active today) together with what is pending.
  Future<void> start(String day) async {
    if (_startedDay == day) return;
    _startedDay = day;
    try {
      final granted = await hasConsent();
      if (granted == null) {
        _startedDay = null; // Try again next time.
        return;
      }
      setEnabled(granted);
      if (granted) {
        count(UsageEvent.appOpen, appVersion);
        await flush();
      }
    } on Object {
      _startedDay = null;
    }
  }

  /// After the analytics consent changed in the app.
  void setEnabled(bool granted) {
    _enabled = granted;
    if (!granted) _pending.clear();
  }

  /// Sends what is pending (when the app goes to the background, and when
  /// many counts wait). Failures keep the counts for the next try.
  Future<void> flush() async {
    if (_enabled != true || _pending.isEmpty || _sending) return;
    _sending = true;
    final batch = Map.of(_pending);
    _pending.clear();
    try {
      final counted = await send(platform.name, batch);
      if (!counted) setEnabled(false);
    } on Object {
      for (final e in batch.entries) {
        _pending[e.key] = (_pending[e.key] ?? 0) + e.value;
      }
    } finally {
      _sending = false;
    }
  }

  /// Sign-out: forgets everything about the session.
  void reset() {
    _enabled = null;
    _pending.clear();
    _shownBanners.clear();
    _startedDay = null;
  }
}
