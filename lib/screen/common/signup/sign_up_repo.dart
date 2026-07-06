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

  Future signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String referralCode,
    MultipartFile? profileImage,
    String? contactNumber,
    String? countryCode,
    String? emergencyContactName,
    String? emergencyContact,
    String? emergencyCountryCode,
  }) async {
    final deviceToken = await resolveDeviceToken();
    final body = <String, dynamic>{
      ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
      ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
      ApiParam.paramFirstName: firstName,
      ApiParam.paramLastName: lastName,
      ApiParam.paramEmail: email,
      ApiParam.paramContactNumber: contactNumber ?? getStringFromUserInfoBox(hiveContactNumber),
      ApiParam.paramReferCode: referralCode,
      ApiParam.paramDeviceToken: deviceToken,
      ApiParam.paramLoginDevice: Platform.isAndroid ? LoginDeviceType.android : LoginDeviceType.ios,
      ApiParam.paramSelectLanguage: getLanguageFromUserPrefBox(),
      ApiParam.paramSelectCountryCode: countryCode ?? getStringFromUserInfoBox(hiveCountryCode),
      ApiParam.paramSelectCurrency: getStringFromSettingBox(hiveSelectedCurrency),
      ApiParam.paramProfileImage: profileImage,
    };
    if ((emergencyContactName ?? '').trim().isNotEmpty) {
      body[ApiParam.paramEmergencyContactName] = emergencyContactName!.trim();
    }
    if ((emergencyContact ?? '').trim().isNotEmpty) {
      body[ApiParam.paramEmergencyContact] = emergencyContact!.trim();
      body[ApiParam.paramEmergencyCountryCode] = emergencyCountryCode ?? countryCode ?? getStringFromUserInfoBox(hiveCountryCode);
    }
    final response = await _apiBaseHelper.postFormData(
      ApiConst.endPointRegister,
      body: body,
    );
    return response;
  }
}
