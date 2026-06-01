import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

import '../../../../hive/hive_helper.dart';
import '../../../../networking/api_base_helper.dart';

class AddReportIssueRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future draftApi({required int rideId}) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointReportIssueDraft,
      body: {
        ApiParam.paramIssueProviderId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramIssueProviderType: getIntFromSettingBox(hiveAppMode),
        ApiParam.paramRideId: rideId,
      },
    );
    return response;
  }

  Future reportIssueDetailsApi({required int reportId}) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointReportIssueDetails,
      body: {
        ApiParam.paramIssueProviderId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramIssueProviderType: getIntFromSettingBox(hiveAppMode),
        ApiParam.paramIssueReportId: reportId,
      },
    );
    return response;
  }

  Future removeImageApi({required int imgId, required int reportId}) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointReportIssueRemoveImage,
      body: {
        ApiParam.paramIssueProviderId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramIssueProviderType: getIntFromSettingBox(hiveAppMode),
        ApiParam.paramIssueImageId: imgId,
      },
    );
    return response;
  }

  Future uploadImageApi({required int reportId, File? image}) async {
    final response = await _apiBaseHelper.postFormData(
      ApiConst.endPointReportIssueUploadImage,
      body: {
        ApiParam.paramIssueProviderId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramIssueProviderType: getIntFromSettingBox(hiveAppMode),
        ApiParam.paramIssueReportId: reportId,
        ApiParam.paramIssueImage: image != null ? await MultipartFile.fromFile(image.path, filename: path.basename(image.path)) : null,
      },
    );
    return response;
  }

  Future updateReportIssueApi({required int reportId, required int rideId, required String description}) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointReportIssueUpdate,
      body: {
        ApiParam.paramIssueProviderId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramIssueProviderType: getIntFromSettingBox(hiveAppMode),
        ApiParam.paramIssueReportId: reportId,
        ApiParam.paramRideId: rideId,
        ApiParam.paramDescription: description,
      },
    );
    return response;
  }
}
