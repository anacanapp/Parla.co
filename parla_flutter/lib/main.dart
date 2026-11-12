import 'package:flutter/material.dart';

import 'app.dart';
import 'client.dart';
import 'services/serverpod_parla_api.dart';
import 'state/app_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  final settings = await AppSettings.load();
  runApp(ParlaApp(api: ServerpodParlaApi(client), settings: settings));
}
