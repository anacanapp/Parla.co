import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Loads the bundled brand fonts so layout tests measure real text widths
/// instead of the wider default test font.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final file in files) {
      loader.addFont(rootBundle.load(file));
    }
    await loader.load();
  }

  await load('Commissioner', [
    'assets/fonts/Commissioner-Regular.ttf',
    'assets/fonts/Commissioner-SemiBold.ttf',
    'assets/fonts/Commissioner-Bold.ttf',
    'assets/fonts/Commissioner-ExtraBold.ttf',
  ]);
  await load('Fraunces', ['assets/fonts/Fraunces-Italic.ttf']);

  await testMain();
}
