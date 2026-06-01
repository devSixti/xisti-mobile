import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';

class ManageAccountRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future callLogoutApi() async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointLogout,
      body: {ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId), ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken)},
    );
    return response;
  }

  Future deleteAccountApi() async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointRemoveAccount,
      body: {ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId), ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken)},
    );
    return response;
  }
}
