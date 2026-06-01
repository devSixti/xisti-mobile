import 'dart:io';

import 'package:app_xisti/commonView/common_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/utils.dart';
import 'custom_rounded_button.dart';

class ImageSelection extends StatelessWidget {
  final Function onPressedCamera, onPressedGallery;

  const ImageSelection({super.key, required this.onPressedCamera, required this.onPressedGallery});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: AlignmentDirectional.bottomCenter,
        child: Container(
          padding: EdgeInsetsDirectional.only(top: 30.h, bottom: getBottomMargin(), start: commonHorizontalPadding, end: commonHorizontalPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r)),
            color: getCurrentTheme(context).colorScaffoldBg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomRoundedButton(
                      context,
                      languages.camera,
                      () {
                        onPressedCamera();
                      },
                      maxLine: 1,
                      textAlign: TextAlign.center,
                      textSize: textSize16px,
                      minWidth: 0.4,
                      icon: Icon(Icons.camera_alt, color: getCurrentTheme(context).colorStaticBlack),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    flex: 1,
                    child: CustomRoundedButton(
                      context,
                      languages.gallery,
                      () {
                        onPressedGallery();
                      },
                      maxLine: 1,
                      textAlign: TextAlign.center,
                      textSize: textSize16px,
                      icon: Icon(Icons.photo_library_rounded, color: getCurrentTheme(context).colorStaticBlack),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void selectImgFromCameraOrGallery(
  BuildContext context,
  Function(File file) fileCallback, {
  bool isSquare = false,
  bool allowPDF = false,
  CropAspectRatio? aspectRatioCrop,
}) {
  final BuildContext parentContext = context;
  showModalBottomSheet<void>(
    context: parentContext,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext bottomSheetContext) {
      return ImageSelection(
        onPressedCamera: () {
          Navigator.pop(bottomSheetContext);
          _getImage(parentContext, true, isSquare: isSquare, aspectRatioCrop: aspectRatioCrop).then((value) {
            if (value != null) {
              fileCallback(value);
            }
          });
        },
        onPressedGallery: () {
          Navigator.pop(bottomSheetContext);
          if (allowPDF) {
            _getFile(parentContext, isSquare: isSquare).then((value) {
              if (value != null) {
                fileCallback(value);
              }
            });
          } else {
            _getImage(parentContext, false, isSquare: isSquare, aspectRatioCrop: aspectRatioCrop).then((value) {
              if (value != null) {
                fileCallback(value);
              }
            });
          }
        },
      );
    },
  );
}

Future<File?> _getFile(BuildContext context, {bool isSquare = false}) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(allowedExtensions: ["jpg", "jpeg", "png", "pdf"], type: FileType.custom);

  if (result != null && (result.files.single.path ?? "").isNotEmpty) {
    File file = File(result.files.single.path!);
    String path = file.path.toLowerCase();
    if (path.endsWith(".jpg") || path.endsWith(".jpeg") || path.endsWith(".png")) {
      CroppedFile? croppedFile;
      if (!context.mounted) return null;
      croppedFile = (await ImageCropper().cropImage(
        sourcePath: file.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: languages.cropper,
            toolbarColor: getCurrentTheme(context).colorPrimary,
            toolbarWidgetColor: getCurrentTheme(context).colorStaticBlack,
            activeControlsWidgetColor: getCurrentTheme(context).colorPrimary,
            statusBarLight: false,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            aspectRatioPresets: isSquare
                ? [CropAspectRatioPreset.square]
                : [
                    CropAspectRatioPreset.square,
                    CropAspectRatioPreset.ratio3x2,
                    CropAspectRatioPreset.original,
                    CropAspectRatioPreset.ratio4x3,
                    CropAspectRatioPreset.ratio16x9,
                  ],
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
            aspectRatioPresets: isSquare
                ? [CropAspectRatioPreset.square]
                : [
                    CropAspectRatioPreset.square,
                    CropAspectRatioPreset.ratio3x2,
                    CropAspectRatioPreset.original,
                    CropAspectRatioPreset.ratio4x3,
                    CropAspectRatioPreset.ratio16x9,
                  ],
          ),
        ],
      ));

      return (croppedFile?.path ?? "").isNotEmpty ? File(croppedFile?.path ?? "") : null;
    }

    return file;
  } else {
    return null;
  }
}

Future<File?> _getImage(BuildContext context, bool isCamera, {bool isSquare = false, bool isFromVehicleImage = false, CropAspectRatio? aspectRatioCrop}) async {
  CroppedFile? croppedFile;
  var pickedFile = await ImagePicker().pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);

  if (pickedFile != null) {
    if (isCamera && Platform.isIOS) {
      // Let UIImagePickerController fully dismiss before presenting cropper.
      await Future<void>.delayed(const Duration(milliseconds: 900));
    }
    if (!context.mounted) return null;
    croppedFile = (await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: isFromVehicleImage ? const CropAspectRatio(ratioX: 670, ratioY: 300) : aspectRatioCrop,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: languages.cropper,
          toolbarColor: getCurrentTheme(context).colorPrimary,
          toolbarWidgetColor: getCurrentTheme(context).colorStaticBlack,
          activeControlsWidgetColor: getCurrentTheme(context).colorPrimary,
          statusBarLight: false,
          initAspectRatio: isSquare ? CropAspectRatioPreset.square : CropAspectRatioPreset.original,
          lockAspectRatio: isSquare || aspectRatioCrop != null,
          aspectRatioPresets: isSquare
              ? [CropAspectRatioPreset.square]
              : [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9,
                ],
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
          resetAspectRatioEnabled: !(isSquare || aspectRatioCrop != null),
          aspectRatioLockEnabled: isSquare || aspectRatioCrop != null,
          aspectRatioPresets: isSquare
              ? [CropAspectRatioPreset.square]
              : [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9,
                ],
        ),
      ],
    ));
  }
  return (croppedFile != null && croppedFile.path.trim().isNotEmpty) ? File(croppedFile.path) : null;
}
