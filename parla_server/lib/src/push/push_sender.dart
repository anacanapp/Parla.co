import 'dart:convert';

import 'package:googleapis_auth/auth_io.dart' as gauth;
import 'package:http/http.dart' as http;

/// One push notification. Titles and texts never hold personal data.
class PushMessage {
  const PushMessage({required this.title, required this.body, this.link});

  final String title;
  final String body;

  /// In-app link opened on tap (see `ContentRules.isBannerLink`).
  final String? link;
}

/// What happened to one token.
enum PushResult { sent, gone, failed }

/// Sends push notifications. FCM in staging and production; tests and
/// local development use [RecordingPushSender].
abstract class PushSender {
  Future<PushResult> send(String token, PushMessage message);
}

/// Keeps what would be sent (tests, local development).
class RecordingPushSender implements PushSender {
  final List<(String, PushMessage)> sent = [];

  /// Tokens FCM would report as no longer registered.
  final Set<String> gone = {};

  @override
  Future<PushResult> send(String token, PushMessage message) async {
    if (gone.contains(token)) return PushResult.gone;
    sent.add((token, message));
    return PushResult.sent;
  }
}

/// Firebase Cloud Messaging HTTP v1 with a service account kept in the
/// server secrets (`fcmServiceAccount`).
class FcmPushSender implements PushSender {
  FcmPushSender(this._serviceAccountJson);

  final String _serviceAccountJson;
  gauth.AutoRefreshingAuthClient? _client;
  String? _project;

  Future<gauth.AutoRefreshingAuthClient> _auth() async {
    final existing = _client;
    if (existing != null) return existing;
    final json = jsonDecode(_serviceAccountJson) as Map<String, Object?>;
    _project = json['project_id']! as String;
    return _client = await gauth.clientViaServiceAccount(
      gauth.ServiceAccountCredentials.fromJson(json),
      const ['https://www.googleapis.com/auth/firebase.messaging'],
    );
  }

  @override
  Future<PushResult> send(String token, PushMessage message) async {
    final client = await _auth();
    final http.Response res = await client.post(
      Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$_project/messages:send',
      ),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'message': {
          'token': token,
          'notification': {'title': message.title, 'body': message.body},
          if (message.link != null) 'data': {'link': message.link},
        },
      }),
    );
    if (res.statusCode == 200) return PushResult.sent;
    if (res.statusCode == 404 || res.body.contains('UNREGISTERED')) {
      return PushResult.gone;
    }
    return PushResult.failed;
  }
}

/// The server's sender, set at start-up; tests replace it.
class Push {
  static PushSender sender = RecordingPushSender();
}
