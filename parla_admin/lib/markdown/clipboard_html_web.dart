import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// The HTML on the clipboard (as Google Docs copies it), or `null` when the
/// browser does not give it or the user declined.
Future<String?> readClipboardHtml() async {
  try {
    final items = await web.window.navigator.clipboard.read().toDart;
    for (final item in items.toDart) {
      if (item.types.toDart.map((t) => t.toDart).contains('text/html')) {
        final blob = await item.getType('text/html').toDart;
        return (await blob.text().toDart).toDart;
      }
    }
  } on Object {
    return null;
  }
  return null;
}
