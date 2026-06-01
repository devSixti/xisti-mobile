import '../../../blocs/bloc.dart';
import '../../../hive/hive_helper.dart';

class RideEstimationRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future rideBookApi({
    required double offeredFare,
    required int estimatedTime,
    required double totalDistance,
    required String addressList,
    required String otherUserName,
    required String otherContactNumber,
  }) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointHailRideBooking,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramServiceId: getIntFromSettingBox(hiveServiceId),
        ApiParam.paramOfferedFare: offeredFare,
        ApiParam.paramEstimatedTime: estimatedTime,
        ApiParam.paramTotalDistance: totalDistance,
        ApiParam.paramAddressList: addressList,
        ApiParam.paramOtherUserName: otherUserName,
        ApiParam.paramOtherUserContactNumber: otherContactNumber,
      },
    );
    return response;
  }
}
