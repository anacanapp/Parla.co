import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Saves [bytes] as a download named [name]. The file is made in the
/// browser from a `blob:` URL; nothing is sent anywhere.
void saveFile(String name, Uint8List bytes, String mime) {
  final url = web.URL.createObjectURL(
    web.Blob([bytes.toJS].toJS, web.BlobPropertyBag(type: mime)),
  );
  final a = web.HTMLAnchorElement()
    ..href = url
    ..download = name
    ..style.display = 'none';
  web.document.body!.append(a);
  a.click();
  a.remove();
  // Give the browser a moment to start the download.
  Future<void>.delayed(
    const Duration(seconds: 5),
    () => web.URL.revokeObjectURL(url),
  );
}

/// Only used by tests outside the browser.
final savedFiles = <String, Uint8List>{};
