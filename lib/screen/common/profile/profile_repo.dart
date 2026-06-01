import 'package:dio/dio.dart';

import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';

class ProfileRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future getUserDetailApi() async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointGetDetail,
      body: {ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId), ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken)},
    );
    return response;
  }

  Future editProfileApi(
    String firstName,
    String selectedCountryCode,
    String contactNum,
    String email,
    String emergencyContact,
    String emergencyContactName,
    String emergencyCountryCode,
    MultipartFile? multipartFile,
    progress,
  ) async {
    final response = await _apiBaseHelper.postFormData(
      ApiConst.endPointEditProfile,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramFullName: firstName,
        ApiParam.paramSelectCountryCode: selectedCountryCode,
        ApiParam.paramContactNumber: contactNum,
        ApiParam.paramEmail: email,
        ApiParam.paramEmergencyContact: emergencyContact,
        ApiParam.paramEmergencyContactName: emergencyContactName,
        ApiParam.paramEmergencyCountryCode: emergencyCountryCode,
        ApiParam.paramDescription: "",
        ApiParam.paramProfileImage: multipartFile,
      },
      onProgress: progress,
    );
    return response;
  }
}
