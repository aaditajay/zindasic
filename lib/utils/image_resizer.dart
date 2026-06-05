import 'dart:typed_data';
import 'image_resizer_stub.dart'
    if (dart.library.html) 'image_resizer_web.dart' as impl;

/// Resizes the image at the provided path and bytes to 200x200 PNG bytes.
/// Strips EXIF metadata and outputs standard, clean PNG bytes.
Future<Uint8List> resizeImageFile(
  String path,
  Uint8List bytes,
  int width,
  int height,
) async {
  return impl.resizeImage(path, bytes, width, height);
}
