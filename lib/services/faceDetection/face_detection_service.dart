import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'face_detection_dl.dart';

export 'face_detection_dl.dart';

/// Service for detecting faces in images and real-time camera streams.
///
/// This service utilizes the [google_mlkit_face_detection] package to process images
/// from both the file system (static images) and the device camera (live stream).
///
/// It handles platform-specific image format conversions:
/// - iOS: Typically uses BGRA8888 format.
/// - Android: Typically uses YUV420 format which needs conversion to NV21 for ML Kit.
class FaceDetectionService {
  FaceDetector? _faceDetector;

  // Blinking detection state
  bool _eyesClosed = false;
  int _blinkCount = 0;

  FaceDetectionService({FaceDetectorOptions? options}) {
    final detectorOptions =
        options ??
        FaceDetectorOptions(
          enableContours: false,
          enableLandmarks: false,
          enableClassification: true, // Required for blink detection
          enableTracking: true,
          performanceMode: FaceDetectorMode.fast,
          minFaceSize: 0.1,
        );
    _faceDetector = FaceDetector(options: detectorOptions);
  }

  /// Detects faces from a [File] object.
  Future<FaceDetectionResult> detectFaces(File imageFile) async {
    return detectFacesFromPath(imageFile.path);
  }

  /// Detects faces from a file path.
  Future<FaceDetectionResult> detectFacesFromPath(String imagePath) async {
    try {
      if (_faceDetector == null) {
        return FaceDetectionResult(faces: [], error: 'FaceDetector not initialized');
      }

      final file = File(imagePath);
      if (!await file.exists()) {
        return FaceDetectionResult(faces: [], error: 'Image file not found');
      }

      final inputImage = InputImage.fromFilePath(imagePath);
      final faces = await _faceDetector!.processImage(inputImage);

      return FaceDetectionResult(faces: faces);
    } catch (e) {
      debugPrint('Face detection error: $e');
      return FaceDetectionResult(faces: [], error: e.toString());
    }
  }

  /// Processes a frame from the Camera stream.
  Future<FaceDetectionResult> processCameraImage(CameraImage image, int sensorOrientation, DeviceOrientation deviceOrientation) async {
    try {
      if (_faceDetector == null) {
        debugPrint("-----> FaceDetector is null, returning empty result");
        return FaceDetectionResult(faces: []);
      }

      final inputImage = _buildInputImage(image, sensorOrientation);
      if (inputImage == null) {
        debugPrint("-----> InputImage is null, returning empty result");
        return FaceDetectionResult(faces: []);
      }

      debugPrint("-----> Processing image with ML Kit...");
      final faces = await _faceDetector!.processImage(inputImage);
      debugPrint("-----> ML Kit detection complete. Face count: ${faces.length}");

      return FaceDetectionResult(faces: faces);
    } catch (e, stack) {
      debugPrint("-----> Error processing camera image: $e");
      debugPrint("-----> StackTrace: $stack");
      return FaceDetectionResult(faces: [], error: e.toString());
    }
  }

  InputImage? _buildInputImage(CameraImage image, int sensorOrientation) {
    try {
      final InputImageRotation rotation = InputImageRotationValue.fromRawValue(sensorOrientation) ?? InputImageRotation.rotation270deg;

      final int width = image.width;
      final int height = image.height;

      debugPrint("-----> _buildInputImage: size=${width}x$height, format=${image.format.group}, raw=${image.format.raw}, sensor=$sensorOrientation");

      if (image.planes.isEmpty) {
        debugPrint("-----> _buildInputImage: No planes found!");
        return null;
      }

      // 1. Handle iOS BGRA8888
      // iOS camera images are typically in BGRA8888 format which has a single plane.
      if (image.format.group == ImageFormatGroup.bgra8888) {
        return _buildInputImageFromBGRA8888(image, rotation);
      }

      // 2. Handle Android YUV420 / NV21
      // Android camera images are typically in YUV420 format.
      // ML Kit requires NV21 format for Android, so we perform a conversion.
      return _buildInputImageFromYUV420(image, rotation);
    } catch (e) {
      debugPrint("-----> Error building input image: $e");
      return null;
    }
  }

  /// Handles BGRA8888 format (typically iOS).
  ///
  /// On iOS, the camera image is often returned in BGRA8888 format.
  /// This format places all color information in a single plane (plane[0]).
  /// We construct the [InputImage] directly from the bytes of this plane.
  InputImage _buildInputImageFromBGRA8888(CameraImage image, InputImageRotation rotation) {
    return InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: InputImageFormat.bgra8888,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  /// Handles YUV420 format (typically Android).
  /// Converts YUV420 to NV21.
  ///
  /// Android camera images typically come in YUV420 format (3 planes: Y, U, V).
  /// ML Kit anticipates NV21 format (Y plane followed by interleaved VU plane).
  /// This method manually constructs the NV21 byte buffer by:
  /// 1. Copying the Y plane (Luma).
  /// 2. Interleaving the V and U planes (Chroma) to match NV21 requirements.
  InputImage? _buildInputImageFromYUV420(CameraImage image, InputImageRotation rotation) {
    try {
      final int width = image.width;
      final int height = image.height;

      // Ensure we have 3 planes for YUV420
      if (image.planes.length != 3) {
        // If it's only 1 plane, it might already be raw NV21 format returned directly
        if (image.planes.length == 1) {
          debugPrint("-----> Detected single plane for YUV420/NV21, assuming pre-formatted bytes.");
          return InputImage.fromBytes(
            bytes: image.planes[0].bytes,
            metadata: InputImageMetadata(
              size: Size(width.toDouble(), height.toDouble()),
              rotation: rotation,
              format: InputImageFormat.nv21,
              bytesPerRow: image.planes[0].bytesPerRow,
            ),
          );
        }

        debugPrint("-----> Error: Expected 3 planes for YUV420, got ${image.planes.length}");
        return null;
      }

      final plane0 = image.planes[0]; // Y
      final plane1 = image.planes[1]; // U
      final plane2 = image.planes[2]; // V

      // Allocate buffer for NV21: Y (width * height) + VU (width * height / 2)
      final Uint8List bytes = Uint8List(width * height * 3 ~/ 2);

      // Copy Y plane
      int yOffset = 0;
      final int yStride = plane0.bytesPerRow;
      for (int row = 0; row < height; row++) {
        final start = row * yStride;
        final end = start + width;
        if (end <= plane0.bytes.length) {
          bytes.setRange(yOffset, yOffset + width, plane0.bytes.sublist(start, end));
        }
        yOffset += width;
      }

      // Interleave V and U planes
      final int uvHeight = height ~/ 2;
      final int uvWidth = width ~/ 2;
      final int uStride = plane1.bytesPerRow;
      final int vStride = plane2.bytesPerRow;
      final int uPixelStride = plane1.bytesPerPixel ?? 1;
      final int vPixelStride = plane2.bytesPerPixel ?? 1;

      int uvOffset = width * height;

      for (int row = 0; row < uvHeight; row++) {
        for (int col = 0; col < uvWidth; col++) {
          final int vIndex = (row * vStride) + (col * vPixelStride);
          final int uIndex = (row * uStride) + (col * uPixelStride);

          if (vIndex < plane2.bytes.length && uvOffset < bytes.length) {
            bytes[uvOffset++] = plane2.bytes[vIndex];
          } else {
            uvOffset++; // skip to keep alignment if out of bounds (shouldn't happen on well-formed images)
          }

          if (uIndex < plane1.bytes.length && uvOffset < bytes.length) {
            bytes[uvOffset++] = plane1.bytes[uIndex];
          } else {
            uvOffset++;
          }
        }
      }

      final InputImageFormat finalFormat = Platform.isAndroid
          ? InputImageFormat.nv21
          : (InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.bgra8888);

      return InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(size: Size(width.toDouble(), height.toDouble()), rotation: rotation, format: finalFormat, bytesPerRow: width),
      );
    } catch (e) {
      debugPrint("-----> Error converting YUV to NV21: $e");
      return null;
    }
  }

  /// Check for eye blink liveness.
  ///
  /// Returns `true` if a full blink (eyes closed then opened) is detected.
  ///
  /// Logic:
  /// 1. If eyes are closed (probability < 0.2), set [_eyesClosed] to true.
  /// 2. If eyes are subsequently opened (probability > 0.7) and previously closed,
  ///    count it as a blink and reset [_eyesClosed].
  bool detectBlink(Face face) {
    if (face.leftEyeOpenProbability == null || face.rightEyeOpenProbability == null) {
      return false;
    }

    final double leftOpen = face.leftEyeOpenProbability!;
    final double rightOpen = face.rightEyeOpenProbability!;

    if (!_eyesClosed && leftOpen < 0.2 && rightOpen < 0.2) {
      _eyesClosed = true;
      return false;
    }

    if (_eyesClosed && leftOpen > 0.7 && rightOpen > 0.7) {
      _eyesClosed = false;
      _blinkCount++;
      return true;
    }

    return false;
  }

  void resetBlink() {
    _eyesClosed = false;
    _blinkCount = 0;
  }

  int get blinkCount => _blinkCount;

  void dispose() {
    _faceDetector?.close();
    _faceDetector = null;
  }
}
