import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';

class OtpVerifyRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future callVerifyOtpApi(String otp) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointVerifyOtp,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramOtp: otp,
      },
      showServerErrorOnFailure: false,
    );
    return response;
  }

  Future callResendOtpApi({String channel = 'sms', bool forceResend = false}) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointResendOtp,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramChannel: channel,
        ApiParam.paramForceResend: forceResend ? 1 : 0,
      },
      showServerErrorOnFailure: false,
    );
    return response;
  }
}
