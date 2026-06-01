import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';

class DriverNewRequestRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future driverBidApi({required int rideId, required dynamic offerAmount}) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointBidRide,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramRideId: rideId,
        ApiParam.paramOfferedPrice: offerAmount,
      },
    );
    return response;
  }

  Future getRideApi({required int rideId}) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointGetRide,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramRideId: rideId,
      },
    );
    return response;
  }

  Future rideAcceptApi(int rideId) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointDriverAcceptRide,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramRideId: rideId,
      },
    );
    return response;
  }
}
