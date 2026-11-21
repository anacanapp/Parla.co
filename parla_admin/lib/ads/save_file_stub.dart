import 'dart:typed_data';

/// Saves [bytes] as a download named [name]. Outside the browser (tests)
/// the files are kept in [savedFiles].
void saveFile(String name, Uint8List bytes, String mime) =>
    savedFiles[name] = bytes;

/// Files "downloaded" in tests.
final savedFiles = <String, Uint8List>{};
