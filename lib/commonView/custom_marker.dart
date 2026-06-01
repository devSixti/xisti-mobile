import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerIcon {
  static Future<BitmapDescriptor> downloadResizePictureCircle(
    String imageUrl, {
    int size = 150,
    bool addBorder = false,
    Color borderColor = Colors.white,
    double borderSize = 10,
  }) async {
    final File imageFile = await DefaultCacheManager().getSingleFile(imageUrl);

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..isAntiAlias = true;

    final double radius = size / 2;

    // Make a real circular mask for profile avatars on map markers.
    final Path clipPath = Path()..addOval(Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()));
    canvas.clipPath(clipPath);

    //paintImage
    final Uint8List imageUint8List = await imageFile.readAsBytes();
    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec.getNextFrame();
    paintImage(
        fit: BoxFit.cover, alignment: Alignment.center, canvas: canvas, rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()), image: imageFI.image);

    if (addBorder) {
      //draw Border
      paint.color = borderColor;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = borderSize;
      canvas.drawCircle(Offset(radius, radius), radius, paint);
    }

    //convert canvas as PNG bytes
    final image = await pictureRecorder.endRecording().toImage(size, size);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    final view = ui.PlatformDispatcher.instance.views.first;
    //convert PNG bytes as BitmapDescriptor
    return BitmapDescriptor.bytes(data!.buffer.asUint8List(), imagePixelRatio: view.devicePixelRatio);
  }
}
