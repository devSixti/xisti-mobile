import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../blocs/bloc.dart';
import '../../../../commonView/image_selection.dart';
import '../../../../hive/hive_helper.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../../utils/utils.dart';
import '../require_document_dl.dart';
import '../required_document_repo.dart';

class AddDocumentBloc extends Bloc {
  BuildContext context;
  DocumentList documentListItem;
  DateTime? expiryDateTime;
  Function(List<DocumentList> documentList) onUpload;
  final RequiredDocumentRepo _requiredDocumentRepo = RequiredDocumentRepo();

  final BehaviorSubject<File> documentImageFile = BehaviorSubject<File>();
  final subjectSingleDocUpload = BehaviorSubject<ApiResponse<UploadSingleDocPojo>>();
  var expiryDateTEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  AddDocumentBloc(this.context, this.documentListItem, this.onUpload) {
    if (documentListItem.containsExpiry == 1 && (documentListItem.documentExpireDate ?? "").trim().isNotEmpty) {
      expiryDateTime = DateTime.parse(documentListItem.documentExpireDate ?? "");
      debugPrint("expirydate is : ${expiryDateTime.toString()}");
      expiryDateTEC.text = getDateTime(documentListItem.documentExpireDate ?? "", format: "yyyy-MM-dd", showOnlyDate: true);
    }
  }

  void selectDocument() {
    selectImgFromCameraOrGallery(
      context,
      (file) async {
      String path = file.path.toLowerCase();
      File compressFile;
      if (path.endsWith("jpg") || path.endsWith("jpeg") || path.endsWith("png")) {
        compressFile = await compressImage(file);
      } else {
        compressFile = file;
      }
      documentImageFile.sink.add(compressFile);
      },
      allowPDF: true,
      aspectRatioCrop: const CropAspectRatio(ratioX: 85.6, ratioY: 54),
    );
  }

  void selectExpiryDate() {
    DateTime? initialDate;
    if (expiryDateTEC.text.trim().isNotEmpty) {
      initialDate = DateFormat(getConvertedDateAndTimeBasedOnFormat(true, false)).parse(expiryDateTEC.text);
      if (initialDate.isBefore(DateTime.now())) {
        initialDate = null;
      }
    }
    selectDocumentExpiryDate(context, initialDate: initialDate).then((date) {
      if (date != null) {
        DateTime now = DateTime.now();
        expiryDateTime = date.add(Duration(hours: now.hour, minutes: now.minute));
        expiryDateTEC.text = getDateTimeWithoutTimezoneFromObj(date, showOnlyDate: true);
      }
    });
  }

  void uploadDocument() {
    if (documentImageFile.valueOrNull == null && (documentListItem.documentFile ?? "").trim().isEmpty) {
      openSimpleSnackbar(context, languages.selectDocument);
    } else if (documentListItem.containsExpiry == 0 || formKey.currentState!.validate()) {
      callUploadSingleDocumentApi(
        documentListItem.documentId ?? 0,
        (documentListItem.documentFile ?? "").trim().isEmpty ? 0 : 1,
        documentImageFile.valueOrNull,
      );
    }
  }

  Future<void> callUploadSingleDocumentApi(int docId, int isUpdate, File? file) async {
    String expiryDate = documentListItem.documentExpireDate ?? "";
    if (expiryDateTime != null) {
      if (expiryDateTime!.isAfter(DateTime.now())) {
        expiryDate = convertTimeToServerTime(expiryDateTime!, onlyDate: true);
      } else {
        if (!context.mounted) return;
        openSimpleSnackbar(context, languages.expiryDateValidation);
        return;
      }
    }
    if (await isNetworkConnected(onRetryPressedCallApi: () => callUploadSingleDocumentApi(docId, isUpdate, file))) {
      try {
        subjectSingleDocUpload.sink.add(ApiResponse.loading());
        MultipartFile? multipartFile;
        if (file != null) {
          multipartFile = MultipartFile.fromFileSync(file.path, filename: file.path.split('/').last);
        }
        var response = UploadSingleDocPojo.fromJson(
          await _requiredDocumentRepo.uploadSingleDocumentApi(docId, expiryDate, isUpdate, multipartFile, (double progress) {
            subjectSingleDocUpload.sink.add(ApiResponse.loading(progress: progress));
          }),
        );

        if (!context.mounted) return;
        if (isApiStatus(context, response.status, response.message, true)) {
          subjectSingleDocUpload.sink.add(ApiResponse.completed(response));
          onUpload(response.requiredDocumentList);
          putDataInSettingBox(hiveDriverType, response.isDriverType);
          putDataInSettingBox(hiveDocumentStatus, response.driverDocStatus);
          Navigator.pop(context);
        } else {
          subjectSingleDocUpload.sink.add(ApiResponse.error(response.message));
          if (response.status != 3) openSimpleSnackbar(context, response.message);
        }
      } catch (e) {
        debugPrint(e.toString());
        subjectSingleDocUpload.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  @override
  void dispose() {
    documentImageFile.close();
    subjectSingleDocUpload.close();
    expiryDateTEC.dispose();
  }
}
