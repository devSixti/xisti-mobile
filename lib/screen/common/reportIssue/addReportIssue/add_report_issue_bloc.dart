import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../../blocs/bloc.dart';
import '../../../../bottomSheet/common_bottom_sheet.dart';
import '../../../../commonView/image_selection.dart';
import '../../../../networking/base_dl.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/validator.dart';
import 'add_report_issue_dl.dart';
import 'add_report_issue_repo.dart';
import 'add_report_issue_screen.dart';

class AddReportIssueBloc extends Bloc {
  BuildContext context;
  String rideNo;
  int rideId, reportId;
  bool isFromIssueHistory, isFromDetail;

  AddReportIssueBloc(this.context, this.rideNo, this.rideId, this.isFromIssueHistory, this.reportId, this.isFromDetail) {
    if (isFromIssueHistory) {
      reportIssueDetailsApiCall();
    } else {
      orderNoTEC.text = "#$rideNo";
      draftApiCall();
      buttonHide();
    }
  }

  final AddReportIssueRepo _addReportIssueRepo = AddReportIssueRepo();

  List<ImageList> imageList = [];
  int ticketId = 0;

  TextEditingController orderNoTEC = TextEditingController();
  TextEditingController ticketIdTEC = TextEditingController();
  TextEditingController descriptionTEC = TextEditingController();

  final draftSubject = BehaviorSubject<ApiResponse<DraftPojo>>();
  final imageApiSubject = BehaviorSubject<ApiResponse<UploadImagesPojo>>();
  final reportDetailsSubject = BehaviorSubject<ApiResponse<ReportIssueDetailsPojo>>();
  final updateIssueReportSubject = BehaviorSubject<ApiResponse<BaseModel>>();
  final loadingImageSubject = BehaviorSubject<int>.seeded(-1);
  final isValidSubject = BehaviorSubject<bool>();
  final minIssueImageUploadSubject = BehaviorSubject<int>();
  final maxIssueImageUploadSubject = BehaviorSubject<int>();

  Future<void> openRemoveImageBottomSheet({required int imageIndex, required int imageId}) async {
    showModalBottomSheet(
      enableDrag: false,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return StreamBuilder<ApiResponse>(
          stream: imageApiSubject,
          builder: (context, snapshot) {
            return CommonBottomSheet(
              title: languages.deleteImage,
              message: languages.deleteImageMsg,
              positiveButtonTxt: languages.yes,
              negativeButtonTxt: languages.no,
              textAlign: TextAlign.start,
              isLoading: snapshot.data?.status == Status.loading,
              onPositivePress: () {
                Navigator.pop(context);

                removeImageApiCall(imageIndex: imageIndex, imageId: imageId);
              },
              onNegativePress: () {
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void buttonHide() {
    String description = validateEmptyField(descriptionTEC.text, languages.enterDescription);
    if ((imageApiSubject.valueOrNull?.data?.image.length ?? 0) < (minIssueImageUploadSubject.valueOrNull ?? 0) || description.isNotEmpty) {
      isValidSubject.add(true);
    } else {
      isValidSubject.add(false);
    }
  }

  void selectDocument() {
    int last = imageApiSubject.valueOrNull?.data?.image.length ?? 0;
    selectImgFromCameraOrGallery(
      context,
      (file) async {
        loadingImageSubject.sink.add(last);
        File compressFile = await compressImage(file);
        uploadImageApiCall(compressFile);
      },
      isSquare: true,
      aspectRatioCrop: const CropAspectRatio(ratioX: 100, ratioY: 100),
    );
  }

  //--------------------------------------Api Calling Start----------------------------
  Future<void> draftApiCall() async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => draftApiCall())) {
      draftSubject.sink.add(ApiResponse.loading());
      reportDetailsSubject.sink.add(ApiResponse.loading());
      try {
        var response = DraftPojo.fromJson(await _addReportIssueRepo.draftApi(rideId: rideId));

        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, true)) {
          ticketId = response.reportId;
          minIssueImageUploadSubject.sink.add(response.minReportIssueImageUpload);
          maxIssueImageUploadSubject.sink.add(response.maxReportIssueImageUpload);

          draftSubject.sink.add(ApiResponse.completed(response));
          reportDetailsSubject.sink.add(ApiResponse.completed());
        } else {
          draftSubject.sink.add(ApiResponse.error(response.message));
          reportDetailsSubject.sink.add(ApiResponse.error(response.message));
          if (response.status != 3) openSimpleSnackbar(context, response.message);
        }
      } catch (e) {
        draftSubject.sink.add(ApiResponse.error(e.toString()));
        reportDetailsSubject.sink.add(ApiResponse.error(e.toString()));
        if (context.mounted) openSimpleSnackbar(context, e.toString());
      }
    }
  }

  Future<void> uploadImageApiCall(File imageFile) async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => uploadImageApiCall(imageFile))) {
      try {
        UploadImagesPojo response = UploadImagesPojo.fromJson(await _addReportIssueRepo.uploadImageApi(reportId: ticketId, image: imageFile));
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, false)) {
          imageApiSubject.add(ApiResponse.completed(response));

          loadingImageSubject.sink.add(-1);
          buttonHide();

          if (response.isImageValid == 0) openSimpleSnackbar(context, response.message);
        } else {
          loadingImageSubject.sink.add(-1);
          imageApiSubject.add(ApiResponse.error(response.message));
          if (response.status != 3) openSimpleSnackbar(context, response.message);
        }
      } catch (e) {
        loadingImageSubject.sink.add(-1);
        imageApiSubject.add(ApiResponse.error(e.toString()));
        if (context.mounted) openSimpleSnackbar(context, e.toString());
      }
    }
  }

  Future<void> removeImageApiCall({required int imageIndex, required int imageId}) async {
    loadingImageSubject.sink.add(imageIndex);
    if (await isNetworkConnected(onRetryPressedCallApi: () => removeImageApiCall(imageIndex: imageIndex, imageId: imageId))) {
      try {
        UploadImagesPojo response = UploadImagesPojo.fromJson(await _addReportIssueRepo.removeImageApi(imgId: imageId, reportId: ticketId));
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, false)) {
          imageApiSubject.add(ApiResponse.completed(response));
          loadingImageSubject.sink.add(-1);
          buttonHide();
        } else {
          loadingImageSubject.sink.add(-1);
          imageApiSubject.add(ApiResponse.error(response.message));
          if (response.status != 3) openSimpleSnackbar(context, response.message);
        }
      } catch (e) {
        loadingImageSubject.sink.add(-1);
        imageApiSubject.add(ApiResponse.error(e.toString()));
        if (context.mounted) openSimpleSnackbar(context, e.toString());
      }
    }
  }

  Future<void> reportIssueApiCall() async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => reportIssueApiCall())) {
      updateIssueReportSubject.sink.add(ApiResponse.loading());
      try {
        var response = BaseModel.fromJson(
          await _addReportIssueRepo.updateReportIssueApi(reportId: ticketId, rideId: rideId, description: descriptionTEC.text.toString()),
        );

        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, false)) {
          updateIssueReportSubject.sink.add(ApiResponse.completed(response));
          if (isFromDetail) {
            openScreenWithReplacePrevious(context, AddReportIssueScreen(isFromIssueHistory: true, reportId: ticketId));
          } else {
            openScreenWithClearPrevious(context, AddReportIssueScreen(isFromIssueHistory: true, reportId: ticketId));
          }
        } else {
          updateIssueReportSubject.sink.add(ApiResponse.error(response.message));
          if (response.status != 3) openSimpleSnackbar(context, response.message);
        }
      } catch (e) {
        updateIssueReportSubject.sink.add(ApiResponse.error(e.toString()));
        if (context.mounted) openSimpleSnackbar(context, e.toString());
      }
    }
  }

  Future<void> reportIssueDetailsApiCall() async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => reportIssueDetailsApiCall())) {
      reportDetailsSubject.sink.add(ApiResponse.loading());
      try {
        var response = ReportIssueDetailsPojo.fromJson(await _addReportIssueRepo.reportIssueDetailsApi(reportId: reportId));
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, true)) {
          reportDetailsSubject.sink.add(ApiResponse.completed(response));
          orderNoTEC.text = "#${response.rideNo}";
          descriptionTEC.text = response.description;
          ticketIdTEC.text = "#${response.referenceNo}";
          minIssueImageUploadSubject.sink.add(response.minReportIssueImageUpload);
          maxIssueImageUploadSubject.sink.add(response.maxReportIssueImageUpload);
        } else {
          reportDetailsSubject.sink.add(ApiResponse.error(response.message));
          if (response.status != 3) openSimpleSnackbar(context, response.message);
        }
      } catch (e) {
        reportDetailsSubject.sink.add(ApiResponse.error(e.toString()));
        if (context.mounted) openSimpleSnackbar(context, e.toString());
      }
    }
  }

  //--------------------------------------Api Calling End----------------------------

  @override
  void dispose() {
    orderNoTEC.dispose();
    descriptionTEC.dispose();
    ticketIdTEC.dispose();
    draftSubject.close();
    updateIssueReportSubject.close();
    imageApiSubject.close();
    loadingImageSubject.close();
    isValidSubject.close();
    reportDetailsSubject.sink.close();
    minIssueImageUploadSubject.close();
    maxIssueImageUploadSubject.close();
  }
}
