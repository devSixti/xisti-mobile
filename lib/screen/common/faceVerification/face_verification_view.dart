import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';

import '../../../commonView/common_circular_progress_indicator.dart';
import '../../../commonView/common_view.dart';
import '../../../services/faceDetection/face_detection_service.dart';
import '../../../utils/utils.dart';
import 'face_verification_bloc.dart';

class FaceVerificationView extends StatefulWidget {
  final Function(File image, int rotation) onVerified;
  final VoidCallback onCancel;
  final bool rotateImage;

  const FaceVerificationView({super.key, required this.onVerified, required this.onCancel, this.rotateImage = false});

  @override
  State<FaceVerificationView> createState() => _FaceVerificationViewState();
}

class _FaceVerificationViewState extends State<FaceVerificationView> with WidgetsBindingObserver {
  FaceVerificationBloc? _bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc ??= FaceVerificationBloc(context, onVerified: widget.onVerified, onCancel: widget.onCancel, rotateImage: widget.rotateImage);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _bloc?.onAppLifecycleStateChanged(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onForegroundGained: () async {
        if (_bloc?.cameraPermissionBottomSheetContext != null && (_bloc?.cameraPermissionBottomSheetContext?.mounted ?? false)) {
          Navigator.pop(_bloc!.cameraPermissionBottomSheetContext!, true);
        }
      },
      child: ScaffoldWithSafeArea(
        topPadding: true,
        backgroundColor: getCurrentTheme(context).colorPrimary,
        appBar: CommonAppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: getCurrentTheme(context).colorWhite,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
        ),
        body: StreamBuilder<FaceVerificationState>(
          stream: _bloc?.faceVerificationStateSubject,
          builder: (context, faceVerificationStateSnap) {
            final faceVerificationState = faceVerificationStateSnap.data ?? FaceVerificationState.searching();

            return _bloc?.cameraController == null || !(_bloc?.cameraController?.value.isInitialized ?? false)
                ? _buildFaceVerificationLoadingView(faceVerificationState: faceVerificationState)
                : _buildFaceVerificationView(faceVerificationState: faceVerificationState);
          },
        ),
      ),
    );
  }

  Widget _buildFaceVerificationLoadingView({required FaceVerificationState faceVerificationState}) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 8.h,
              children: [
                if (faceVerificationState.state != FaceVerificationStateEnum.failed)
                  CommonCircularProgressIndicator(color: getCurrentTheme(context).colorWhite, strokeWidth: cpiStrokeWidthRegular, size: cpiSizeSmall),
                Text(
                  faceVerificationState.message,
                  textAlign: TextAlign.center,
                  style: bodyText(context: context, textColor: getCurrentTheme(context).colorWhite, fontSize: textSize16px, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ),

        /// Close Button
        Align(
          alignment: AlignmentDirectional.topEnd,
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding, vertical: commonVerticalPadding),
            child: GestureDetector(
              onTap: () {
                _bloc?.cancelVerification();
              },
              child: Icon(Icons.close, color: getCurrentTheme(context).colorWhite, size: 20.sp),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFaceVerificationView({required FaceVerificationState faceVerificationState}) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        /// Camera Preview
        CameraPreview(_bloc!.cameraController!),

        /// Circular Mask Overlay — saveLayer + BlendMode.clear punches a clean hole
        CustomPaint(
          painter: _FaceOverlayPainter(overlayColor: getCurrentTheme(context).colorBlack.withValues(alpha: 0.6), horizontalMargin: commonHorizontalPadding),
          child: const SizedBox.expand(),
        ),

        /// Border for the circle
        Container(
          margin: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding),
          decoration: BoxDecoration(
            border: Border.all(color: _bloc?.getBorderColor(faceVerificationState) ?? Colors.transparent, width: 4.r),
            shape: BoxShape.circle,
          ),
        ),

        /// Instruction Text
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  faceVerificationState.message,
                  textAlign: TextAlign.center,
                  style: bodyText(context: context, textColor: getCurrentTheme(context).colorWhite, fontSize: textSize16px, fontWeight: FontWeight.w800),
                ),
                if (faceVerificationState.state == FaceVerificationStateEnum.faceDetected) ...[
                  SizedBox(height: 16.h),
                  Icon(Icons.remove_red_eye, color: getCurrentTheme(context).colorPrimary, size: 32.sp),
                ] else if (faceVerificationState.state == FaceVerificationStateEnum.success) ...[
                  SizedBox(height: 16.h),
                  Icon(Icons.check_circle, color: getCurrentTheme(context).colorGreen, size: 32.sp),
                ] else if (faceVerificationState.state == FaceVerificationStateEnum.failed) ...[
                  SizedBox(height: 16.h),
                  Icon(Icons.cancel, color: getCurrentTheme(context).colorRed, size: 32.sp),
                ],
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),

        /// Close Button
        Align(
          alignment: AlignmentDirectional.topEnd,
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding, vertical: commonVerticalPadding),
            child: GestureDetector(
              onTap: () {
                _bloc?.cancelVerification();
              },
              child: Icon(Icons.close, color: getCurrentTheme(context).colorWhite, size: 20.sp),
            ),
          ),
        ),
      ],
    );
  }
}

class _FaceOverlayPainter extends CustomPainter {
  final Color overlayColor;
  final double horizontalMargin;

  _FaceOverlayPainter({required this.overlayColor, required this.horizontalMargin});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = (size.width - horizontalMargin * 2) / 2;
    final center = Offset(size.width / 2, size.height / 2);

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(Offset.zero & size, Paint()..color = overlayColor);
    canvas.drawCircle(center, radius, Paint()..blendMode = BlendMode.clear);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FaceOverlayPainter oldDelegate) => oldDelegate.overlayColor != overlayColor || oldDelegate.horizontalMargin != horizontalMargin;
}
