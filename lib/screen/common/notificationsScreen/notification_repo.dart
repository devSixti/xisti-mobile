import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';

class NotificationsRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future callNotificationsApi(int page, {int? perPage}) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointMassNotificationList,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramPage: page,
        ApiParam.paramPerPage: perPage ?? 10
      },
    );
    return response;
  }
}
