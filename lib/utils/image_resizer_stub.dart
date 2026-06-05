import 'dart:typed_data';
import 'dart:ui' as ui;

Future<Uint8List> resizeImage(
  String path,
  Uint8List bytes,
  int width,
  int height,
) async {
  try {
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: width,
      targetHeight: height,
    );
    final frame = await codec.getNextFrame();
    final image = frame.image;
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      return byteData.buffer.asUint8List();
    }
  } catch (e) {
    // fallback
  }
  return bytes;
}
