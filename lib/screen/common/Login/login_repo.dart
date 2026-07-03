import 'dart:io';

import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';
import '../../../utils/utils.dart';

class LoginRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future login({required String loginType, required String phoneNum, String? name, String? loginId, String? profileImage, String? countryCode}) async {
    final deviceToken = await resolveDeviceToken();
    final response = await _apiBaseHelper.post(
      ApiConst.endPointLogin,
      body: {
        ApiParam.paramLoginType: loginType,
        ApiParam.paramDeviceToken: deviceToken,
        ApiParam.paramContactNumber: phoneNum,
        ApiParam.paramFullName: name,
        ApiParam.paramLoginId: loginId,
        ApiParam.paramLoginDevice: Platform.isAndroid ? LoginDeviceType.android : LoginDeviceType.ios,
        ApiParam.paramProfileImage: profileImage,
        ApiParam.paramSelectLanguage: getLanguageFromUserPrefBox(),
        ApiParam.paramSelectCountryCode: countryCode,
        ApiParam.paramSelectCurrency: getStringFromSettingBox(hiveSelectedCurrency),
      },
      showServerErrorOnFailure: false,
    );
    return response;
  }

  Future biometricLogin() async {
    final deviceToken = await resolveDeviceToken();
    final response = await _apiBaseHelper.post(
      ApiConst.endPointFingerLogin,
      body: {
        ApiParam.paramLoginType: LoginType.biometric,
        ApiParam.paramDeviceToken: deviceToken,
        ApiParam.paramLoginId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramUniqueId: getStringFromSettingBox(hiveUniqueId),
        ApiParam.paramLoginDevice: Platform.isAndroid ? LoginDeviceType.android : LoginDeviceType.ios,
        ApiParam.paramSelectLanguage: getLanguageFromUserPrefBox(),
        ApiParam.paramSelectCurrency: getStringFromSettingBox(hiveSelectedCurrency)
      },
    );
    return response;
  }

  Future facebookGraphRequest(String url) async {
    final response = await _apiBaseHelper.get(url);
    return response;
  }
}
