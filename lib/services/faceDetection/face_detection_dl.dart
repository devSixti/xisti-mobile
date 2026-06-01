import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../../main.dart';

/// State of the face verification process.
enum FaceVerificationStateEnum { searching, faceDetected, blinkDetected, success, failed }

class FaceVerificationState {
  final FaceVerificationStateEnum? _state;
  final String? _message;

  /// No face detected
  FaceVerificationState.searching({String? message}) : _state = FaceVerificationStateEnum.searching, _message = message ?? languages.positionFaceInCircle;

  /// Face detected, waiting for blink
  FaceVerificationState.faceDetected() : _state = FaceVerificationStateEnum.faceDetected, _message = languages.blinkEyesNow;

  /// Blink detected
  FaceVerificationState.blinkDetected() : _state = FaceVerificationStateEnum.blinkDetected, _message = languages.processing;

  /// Verification complete
  FaceVerificationState.success() : _state = FaceVerificationStateEnum.success, _message = languages.verificationSuccessful;

  /// Verification failed (too many faces, etc.)
  FaceVerificationState.failed({String? message}) : _state = FaceVerificationStateEnum.failed, _message = message;

  FaceVerificationStateEnum get state => _state ?? FaceVerificationStateEnum.searching;
  String get message => _message ?? "";
}

/// Result of face detection containing detected faces and metadata.
class FaceDetectionResult {
  /// List of detected faces in the image.
  final List<Face> faces;

  /// Error message if detection failed, null otherwise.
  final String? error;

  FaceDetectionResult({required this.faces, this.error});

  /// Returns true if at least one face was detected.
  bool get hasFace => faces.isNotEmpty;

  /// Returns the number of faces detected.
  // int get faceCount => faces.length;

  /// Returns true if the detection was successful (no error).
  bool get isSuccess => error == null;

  /// Returns the first detected face, or null if none.
  Face? get firstFace => faces.isNotEmpty ? faces.first : null;
}
