import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';

class OfferRideRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future cancelRideBookingApi(int rideId, String cancelReason) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointCancelRide,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramRideId: rideId,
        ApiParam.paramCancelReason: cancelReason
      },
    );
    return response;
  }

  Future findDriverApi(int rideId) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointFindDriver,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramRideId: rideId,
      },
    );
    return response;
  }

  Future updatePriceApi(int rideId, dynamic amount) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointUpdatePrice,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramRideId: rideId,
        ApiParam.paramOfferedPrice: amount,
      },
    );
    return response;
  }

  Future acceptDriverApi(int rideId, int driverId) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointAcceptRide,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramRideId: rideId,
        ApiParam.paramDriverId: driverId,
      },
    );
    return response;
  }

  Future rejectDriverApi(int rideId, int driverId) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointDeclineRequest,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramRideId: rideId,
        ApiParam.paramDriverId: driverId,
      },
    );
    return response;
  }
}
