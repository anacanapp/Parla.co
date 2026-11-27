import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

/// Loads the bundled brand fonts so layout tests measure real text widths
/// instead of the wider default test font.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  // Tests that do not pass their own habit store get an empty secure store.
  FlutterSecureStorage.setMockInitialValues({});

  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final file in files) {
      loader.addFont(rootBundle.load(file));
    }
    await loader.load();
  }

  await load('PlusJakartaSans', [
    'assets/fonts/PlusJakartaSans-Regular.ttf',
    'assets/fonts/PlusJakartaSans-SemiBold.ttf',
    'assets/fonts/PlusJakartaSans-Bold.ttf',
    'assets/fonts/PlusJakartaSans-ExtraBold.ttf',
  ]);
  await load('Onest', [
    'assets/fonts/Onest-ExtraLight.ttf',
    'assets/fonts/Onest-Light.ttf',
    'assets/fonts/Onest-Regular.ttf',
    'assets/fonts/Onest-Medium.ttf',
    'assets/fonts/Onest-SemiBold.ttf',
    'assets/fonts/Onest-Bold.ttf',
    'assets/fonts/Onest-ExtraBold.ttf',
  ]);
  await load('NotoSansGeorgian', [
    'assets/fonts/NotoSansGeorgian-Light.ttf',
    'assets/fonts/NotoSansGeorgian-Regular.ttf',
    'assets/fonts/NotoSansGeorgian-Medium.ttf',
    'assets/fonts/NotoSansGeorgian-SemiBold.ttf',
    'assets/fonts/NotoSansGeorgian-Bold.ttf',
  ]);
  await load('PlayfairDisplay', [
    'assets/fonts/PlayfairDisplay-MediumItalic.ttf',
  ]);

  await testMain();
}
