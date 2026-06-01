import '../../../constant/constant.dart';
import '../../../hive/hive_helper.dart';
import '../../../main.dart';
import '../../../networking/api_base_helper.dart';

class DriverRideHistoryRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future getDriverRideHistoryApi({required int filterType, required String orderStatus, required int page, int perPage = perPageRecord}) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointDriverRideHistory,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramFilterType: filterType,
        ApiParam.paramOrderStatus: orderStatus,
        ApiParam.paramTimeZone: localTimeZone,
        ApiParam.paramPage: page,
        ApiParam.paramPerPage: perPage,
      },
    );
    return response;
  }
}
