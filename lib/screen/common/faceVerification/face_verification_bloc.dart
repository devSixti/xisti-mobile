import 'dart:io';

import 'package:app_xisti/appThemeManager/app_theme_colors.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../blocs/bloc.dart';
import '../../../commonView/common_view.dart';
import '../../../main.dart';
import '../../../services/faceDetection/face_detection_service.dart';

class FaceVerificationBloc extends Bloc {
  final BuildContext context;
  final Function(File image, int rotation) onVerified;
  final VoidCallback onCancel;
  final bool rotateImage;

  FaceVerificationBloc(this.context, {required this.onVerified, required this.onCancel, this.rotateImage = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeCamera());
  }

  final _faceDetectionService = FaceDetectionService();

  BuildContext? cameraPermissionBottomSheetContext;
  CameraController? cameraController;
  bool _isImageProcessing = false;
  bool _isWaitingForPermission = false;
  bool _isCameraInitializing = false;

  final faceVerificationStateSubject = BehaviorSubject<FaceVerificationState>.seeded(FaceVerificationState.searching(message: languages.loading));
  final isVerificationCompletedSubject = BehaviorSubject<bool>.seeded(false);

  bool get isVerificationCompleted => isVerificationCompletedSubject.valueOrNull ?? false;

  void _showPermissionBottomSheet() {
    if (cameraPermissionBottomSheetContext?.mounted ?? false) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        cameraPermissionBottomSheetContext = context;

        return CommonBottomSheet(
          title: languages.cameraPermissionRequired,
          message: languages.cameraPermissionMessage,
          positiveButtonTxt: languages.openSettings,
          onPositivePress: () {
            openAppSettings();
          },
          negativeButtonTxt: languages.cancel,
          onNegativePress: () {
            cancelVerification();
          },
        );
      },
    ).then((value) {
      _isWaitingForPermission = false;
      cameraPermissionBottomSheetContext = null;
      if (value is bool && value) {
        _initializeCamera();
      }
    });
  }

  Color getBorderColor(FaceVerificationState state) {
    switch (state.state) {
      case FaceVerificationStateEnum.searching:
        return getCurrentTheme(context).colorWhite.withValues(alpha: 0.5);

      case FaceVerificationStateEnum.faceDetected:
        return getCurrentTheme(context).colorPrimary;

      case FaceVerificationStateEnum.blinkDetected:
      case FaceVerificationStateEnum.success:
        return getCurrentTheme(context).colorGreen;

      case FaceVerificationStateEnum.failed:
        return getCurrentTheme(context).colorRed;
    }
  }

  void onAppLifecycleStateChanged(AppLifecycleState state) {
    if (_isWaitingForPermission) return;
    if (state == AppLifecycleState.inactive) {
      final controller = cameraController;
      cameraController = null;
      faceVerificationStateSubject.sink.add(FaceVerificationState.searching(message: languages.loading));
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    if (_isCameraInitializing) return;
    _isCameraInitializing = true;
    try {
      final permission = await Permission.camera.request();
      if (!permission.isGranted) {
        if (permission.isPermanentlyDenied) {
          _isWaitingForPermission = true;
          faceVerificationStateSubject.sink.add(FaceVerificationState.failed(message: languages.cameraPermissionMessage));
          _showPermissionBottomSheet();
        } else {
          faceVerificationStateSubject.sink.add(FaceVerificationState.failed(message: languages.cameraPermissionMessage));
        }
        return;
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        faceVerificationStateSubject.sink.add(FaceVerificationState.failed(message: languages.noCamerasFound));
        return;
      }

      final frontCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front, orElse: () => cameras.first);

      await cameraController?.dispose();
      cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
      );

      await cameraController?.initialize();

      if (cameraController == null || !(cameraController?.value.isInitialized ?? false)) {
        faceVerificationStateSubject.sink.add(FaceVerificationState.failed(message: languages.failedToCaptureImagePleaseTryAgain));
        return;
      }

      await cameraController?.setExposureMode(ExposureMode.auto);
      await cameraController?.setFocusMode(FocusMode.auto);
      await cameraController?.startImageStream(_processCameraFrame);

      faceVerificationStateSubject.sink.add(FaceVerificationState.searching());
    } catch (e) {
      debugPrint("-----> Camera Error: $e");

      if (e is CameraException && e.code == 'CameraAccessDenied') {
        _isWaitingForPermission = true;
        faceVerificationStateSubject.sink.add(FaceVerificationState.failed(message: languages.cameraPermissionMessage));
        _showPermissionBottomSheet();
        return;
      }
      faceVerificationStateSubject.sink.add(FaceVerificationState.failed(message: languages.failedToCaptureImagePleaseTryAgain));
    } finally {
      _isCameraInitializing = false;
    }
  }

  void _processCameraFrame(CameraImage image) async {
    if (_isImageProcessing || isVerificationCompleted) return;
    _isImageProcessing = true;

    try {
      final result = await _faceDetectionService.processCameraImage(
        image,
        cameraController?.description.sensorOrientation ?? 0,
        cameraController?.value.deviceOrientation ?? DeviceOrientation.portraitUp,
      );

      _handleDetectionResult(result);
    } catch (e) {
      debugPrint("-----> _processCameraFrame Error: $e");
    } finally {
      _isImageProcessing = false;
    }
  }

  void _handleDetectionResult(FaceDetectionResult result) {
    if (result.faces.isEmpty) {
      faceVerificationStateSubject.sink.add(FaceVerificationState.searching());
      _faceDetectionService.resetBlink();
    } else if (result.faces.length > 1) {
      faceVerificationStateSubject.sink.add(FaceVerificationState.failed(message: languages.onlyOneFaceAllowed));
    } else {
      final face = result.faces.first;

      if (faceVerificationStateSubject.valueOrNull?.state == FaceVerificationStateEnum.searching) {
        faceVerificationStateSubject.sink.add(FaceVerificationState.faceDetected());
      } else if (faceVerificationStateSubject.valueOrNull?.state == FaceVerificationStateEnum.faceDetected) {
        final blinkSucceeded = _faceDetectionService.detectBlink(face);

        if (blinkSucceeded) {
          faceVerificationStateSubject.sink.add(FaceVerificationState.success());
          _completeVerification();
        }
      } else {
        faceVerificationStateSubject.sink.add(FaceVerificationState.searching());
      }
    }
  }

  void _completeVerification() async {
    if (isVerificationCompleted) return;
    isVerificationCompletedSubject.add(true);

    try {
      if (cameraController != null && (cameraController?.value.isStreamingImages ?? false)) {
        await cameraController?.stopImageStream();
      }

      XFile file = await cameraController!.takePicture();
      File imageFile = File(file.path);

      if (context.mounted) {
        onVerified(imageFile, rotateImage ? _calculateRotation() : 0);
        if (Navigator.canPop(context)) Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint("-----> _completeVerification Error: $e");
      isVerificationCompletedSubject.add(false);
      faceVerificationStateSubject.sink.add(FaceVerificationState.failed(message: languages.failedToCaptureImagePleaseTryAgain));
    }
  }

  int _calculateRotation() {
    int sensorOrientation = cameraController?.description.sensorOrientation ?? 0;
    int deviceRotation = 0;

    final orientation = cameraController?.value.deviceOrientation ?? DeviceOrientation.portraitUp;
    switch (orientation) {
      case DeviceOrientation.portraitUp:
        deviceRotation = 0;
        break;
      case DeviceOrientation.landscapeLeft:
        deviceRotation = 90;
        break;
      case DeviceOrientation.portraitDown:
        deviceRotation = 180;
        break;
      case DeviceOrientation.landscapeRight:
        deviceRotation = 270;
        break;
    }

    // For newer camera plugin versions (0.11.0+), takePicture() already accounts
    // for sensorOrientation in the output JPEG. We only need to provide additional
    // rotation if the device was not in portraitUp.
    int rotation = deviceRotation;

    debugPrint("-----> _calculateRotation sensorOrientation: $sensorOrientation");
    debugPrint("-----> _calculateRotation orientation: $orientation");
    debugPrint("-----> _calculateRotation deviceRotation: $deviceRotation");
    debugPrint("-----> _calculateRotation rotation : $rotation");

    return rotation;
  }

  void cancelVerification() {
    onCancel.call();
    if (cameraPermissionBottomSheetContext != null && Navigator.canPop(cameraPermissionBottomSheetContext!)) {
      Navigator.pop(cameraPermissionBottomSheetContext!, false);
    }
    if (Navigator.canPop(context)) Navigator.pop(context, false);
  }

  @override
  void dispose() {
    _faceDetectionService.dispose();
    cameraController?.dispose();
    faceVerificationStateSubject.close();
    isVerificationCompletedSubject.close();
  }
}
