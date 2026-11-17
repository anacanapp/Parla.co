import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The phone side of push notifications.
abstract class PushClient {
  /// `android` or `ios`.
  String get platform;

  /// Asks the system for permission; `true` when granted.
  Future<bool> requestPermission();

  /// This phone's push token, or `null`.
  Future<String?> token();

  /// In-app links of notifications the user tapped.
  Stream<String> get openedLinks;
}

/// Firebase Cloud Messaging. Configured only through build settings
/// (`--dart-define=FIREBASE_*`, from Codemagic); without them push is off
/// and nothing is initialised.
class FirebasePushClient implements PushClient {
  FirebasePushClient._();

  static const _apiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const _projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const _senderId = String.fromEnvironment('FIREBASE_SENDER_ID');
  static const _androidAppId = String.fromEnvironment(
    'FIREBASE_ANDROID_APP_ID',
  );
  static const _iosAppId = String.fromEnvironment('FIREBASE_IOS_APP_ID');

  static bool get configured =>
      _apiKey.isNotEmpty &&
      _projectId.isNotEmpty &&
      _senderId.isNotEmpty &&
      (_androidAppId.isNotEmpty || _iosAppId.isNotEmpty);

  /// The client, or `null` when push is not configured for this build.
  static PushClient? create() =>
      configured && !kIsWeb ? FirebasePushClient._() : null;

  Future<FirebaseMessaging>? _ready;

  Future<FirebaseMessaging> _init() => _ready ??= () async {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: _apiKey,
        appId: defaultTargetPlatform == TargetPlatform.iOS
            ? _iosAppId
            : _androidAppId,
        messagingSenderId: _senderId,
        projectId: _projectId,
      ),
    );
    return FirebaseMessaging.instance;
  }();

  @override
  String get platform =>
      defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';

  @override
  Future<bool> requestPermission() async {
    final settings = await (await _init()).requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  // The registration token works with the FCM HTTP v1 `token` target the
  // server uses. The newer register()/onRegistered API returns an
  // installation id instead; switch both sides together once FCM's
  // server-side support for it is confirmed.
  // ignore: deprecated_member_use
  Future<String?> token() async => (await _init()).getToken();

  @override
  Stream<String> get openedLinks async* {
    final messaging = await _init();
    final first = await messaging.getInitialMessage();
    final link = first?.data['link'];
    if (link is String) yield link;
    yield* FirebaseMessaging.onMessageOpenedApp
        .map((m) => m.data['link'])
        .where((l) => l is String)
        .cast<String>();
  }
}

/// The app's push client; `null` when this build has no push. Tests set a
/// fake.
abstract final class PushService {
  static PushClient? client = FirebasePushClient.create();
}

/// Whether this phone has notifications on, and its token (kept on the
/// phone to turn them off again or on sign-out).
class PushPrefs {
  static const _key = 'push.token';

  static Future<String?> token() async =>
      (await SharedPreferences.getInstance()).getString(_key);

  static Future<void> setToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token == null) {
      await prefs.remove(_key);
    } else {
      await prefs.setString(_key, token);
    }
  }
}
