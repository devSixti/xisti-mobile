import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';
import '../../../utils/utils.dart';

class DriverRunningRideRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future getRideDetails(int rideId) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointRideDetail,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramRideId: rideId
      },
    );
    return response;
  }

  Future scheduleStartRideApi({required int rideId}) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointStartRequest,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramRideId: rideId
      },
    );
    return response;
  }

  Future updateRideStatus({
    required int rideId,
    required int rideStatus,
    String? cancelReason,
    dynamic rating,
    String? comment,
    String otp = "",
    dynamic tollCount = 0,
    dynamic tollCharge = 0,
    int wayPointStatus = 0
  }) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointUpdateRideStatus,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramRideId: rideId,
        ApiParam.paramRideStatus: rideStatus,
        ApiParam.paramCancelReason: cancelReason,
        ApiParam.paramRating: rating,
        ApiParam.paramComment: comment,
        ApiParam.paramOtp: otp,
        ApiParam.paramTollCharge: getDoubleFromDynamic(tollCharge),
        ApiParam.paramNoOfToll: int.parse(tollCount.toString()),
        ApiParam.paramWayPointStatus: wayPointStatus,
      },
    );
    return response;
  }
}
