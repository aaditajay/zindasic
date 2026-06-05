// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:html' as html;
import 'dart:convert';
import 'package:flutter/foundation.dart';

Future<Uint8List> resizeImage(
  String path,
  Uint8List bytes,
  int width,
  int height,
) async {
  final completer = Completer<Uint8List>();
  debugPrint('ImageResizerWeb: Starting resize request for path: $path');

  try {
    final image = html.ImageElement();
    image.src = path;

    image.onLoad.listen((_) {
      debugPrint('ImageResizerWeb: Image loaded successfully inside ImageElement.');

      try {
        // Create canvas and scale
        final canvas = html.CanvasElement();
        canvas.width = width;
        canvas.height = height;

        final ctx = canvas.getContext('2d') as html.CanvasRenderingContext2D;
        ctx.drawImageScaled(image, 0, 0, width, height);
        debugPrint('ImageResizerWeb: Image drawn scaled onto Canvas ($width x $height).');

        // Synchronously convert canvas to Data URL (base64)
        final dataUrl = canvas.toDataUrl('image/png');
        debugPrint('ImageResizerWeb: Synchronously exported canvas to Data URL. Length: ${dataUrl.length}');
        
        final base64String = dataUrl.split(',').last;
        final resizedBytes = base64Decode(base64String);
        debugPrint('ImageResizerWeb: Decoded base64 to resized bytes. Size: ${resizedBytes.length} bytes.');
        completer.complete(resizedBytes);
      } catch (e) {
        debugPrint('ImageResizerWeb: Error during canvas toDataUrl or decode: $e');
        completer.complete(bytes); // fallback to original
      }
    });

    image.onError.listen((event) {
      debugPrint('ImageResizerWeb: ImageElement failed to load standard image stream.');
      completer.complete(bytes); // fallback to original
    });
  } catch (e) {
    debugPrint('ImageResizerWeb: Fatal exception in resize process: $e');
    completer.complete(bytes); // fallback to original
  }

  return completer.future;
}
