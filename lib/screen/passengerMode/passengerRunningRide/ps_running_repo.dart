import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';

class PassengerRunningRideRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future getRideDetail(int rideId) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointRideReceiptDetail,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramRideId: rideId,
      },
    );
    return response;
  }

  Future rideUserRating(int rideId, int driverId, dynamic rating, String comment) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointRideUserRating,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramRideId: rideId,
        ApiParam.paramDriverId: driverId,
        ApiParam.paramRating: rating,
        ApiParam.paramComment: comment,
      },
    );
    return response;
  }

  Future payToOnRide(int rideId, int paymentType) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointRidePayment,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramRideId: rideId,
        ApiParam.paramPaymentType: paymentType,
      },
    );
    return response;
  }
}
