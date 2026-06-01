import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';
import '../../../utils/utils.dart';

class AccountRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();


  Future changeAppModeApi() async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointChangeMode,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramActiveMode: getIntFromSettingBox(hiveAppMode) == AppMode.passenger ? AppMode.driver : AppMode.passenger,
      },
    );
    return response;
  }

  Future serviceStatusApi() async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointDriverStatus,
      body: {ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId), ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken)},
    );
    return response;
  }
}
