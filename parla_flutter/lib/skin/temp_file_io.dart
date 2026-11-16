import 'dart:io';

/// Deletes the camera's temporary file so the photo leaves no copy.
Future<void> deleteTempFile(String path) async {
  try {
    final file = File(path);
    if (file.existsSync()) await file.delete();
  } on FileSystemException {
    // Already gone; the system also clears its temp folder.
  }
}
