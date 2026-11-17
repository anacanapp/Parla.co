import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parla_client/parla_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

import 'api/server_url.dart';
import 'api/serverpod_admin_api.dart';
import 'app.dart';

/// Served by the server at `/admin/`, the panel talks to its own origin.
/// For local development, build with `--dart-define=SERVER_URL=https://…/`;
/// otherwise it uses the local server.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final client =
      Client(
          sameOriginServerUrl(
                Uri.base,
                define: const String.fromEnvironment('SERVER_URL'),
              ) ??
              await getServerUrl(),
        )
        ..connectivityMonitor = FlutterConnectivityMonitor()
        ..authSessionManager = FlutterAuthSessionManager();
  await client.auth.initialize();
  runApp(AdminApp(api: ServerpodAdminApi(client)));
}
