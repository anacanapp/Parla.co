import 'dart:convert';

import 'package:share_plus/share_plus.dart';

/// Opens the system share sheet with the export as `parla-data.json`, so the
/// user can save it where they want. The file is never stored by Parla.
Future<void> shareExportFile(String json) async {
  await SharePlus.instance.share(
    ShareParams(
      files: [
        XFile.fromData(utf8.encode(json), mimeType: 'application/json'),
      ],
      fileNameOverrides: const ['parla-data.json'],
    ),
  );
}
