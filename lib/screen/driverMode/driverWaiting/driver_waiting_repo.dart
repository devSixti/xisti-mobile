import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';

class DriverWaitingRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future getRideStatusApi({required int rideId}) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointWaiting,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramRideId: rideId,
      },
    );
    return response;
  }
}