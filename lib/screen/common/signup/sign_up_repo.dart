import 'dart:io';

import 'package:dio/dio.dart';

import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';
import '../../../utils/utils.dart';

class SignUpRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<Map<String, dynamic>> changeContactNumber(String contactNumber, String countryCode) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointChangeNumber,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramContactNumber: contactNumber,
        ApiParam.paramSelectCountryCode: countryCode,
      },
    );
    return response;
  }

  Future signUp(String fullName, String email, String referralCode, MultipartFile? profileImage) async {
    final deviceToken = await resolveDeviceToken();
    final response = await _apiBaseHelper.postFormData(
      ApiConst.endPointRegister,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramFullName: fullName,
        ApiParam.paramEmail: email,
        ApiParam.paramContactNumber: getStringFromUserInfoBox(hiveContactNumber),
        ApiParam.paramReferCode: referralCode,
        ApiParam.paramDeviceToken: deviceToken,
        ApiParam.paramLoginDevice: Platform.isAndroid ? LoginDeviceType.android : LoginDeviceType.ios,
        ApiParam.paramSelectLanguage: getLanguageFromUserPrefBox(),
        ApiParam.paramSelectCountryCode: getStringFromUserInfoBox(hiveCountryCode),
        ApiParam.paramSelectCurrency: getStringFromSettingBox(hiveSelectedCurrency),
        ApiParam.paramProfileImage: profileImage,
      },
    );
    return response;
  }
}
