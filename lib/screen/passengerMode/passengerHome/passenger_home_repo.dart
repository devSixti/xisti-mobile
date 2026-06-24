import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';

class PassengerHomeRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future home({required String currentLat, required String currentLng, String appVersion = ""}) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointHome,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramAppVersion: appVersion,
        ApiParam.paramCurrentLat: currentLat,
        ApiParam.paramCurrentLng: currentLng,
      },
    );
    return response;
  }

  Future bookRide({
    required int serviceId,
    required dynamic offeredFare,
    required dynamic estimatedTime,
    required dynamic totalDistance,
    required String addressList,
    required int paymentType,
    required dynamic minFareAmount,
    required dynamic maxFareAmount,
    required String additionalRemark,
    required String recipientName,
    required String recipientNumber,
    required String itemDecs,
    required dynamic estimatePrice,
    required String? pickupDateTime,
    required int autoAccept,
    required int rideForOther,
    required String otherName,
    required String otherNumber,
    required int childSeat,
    required int handicap,
    required String destinationPaymentMethod,
    required String packageWeightKg,
    required String packageHeightCm,
    required String packageWidthCm,
    required String packageLengthCm,
    int requestedVehicleServiceId = 0,
    String errandType = '',
    String deliveryVariant = '',
  }) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointTransportRideBooking,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramServiceId: serviceId,
        ApiParam.paramOfferedFare: offeredFare,
        ApiParam.paramEstimatedTime: estimatedTime,
        ApiParam.paramTotalDistance: totalDistance,
        ApiParam.paramPickUpDateTime: pickupDateTime,
        ApiParam.paramAddressList: addressList,
        ApiParam.paramAdditionalRemark: additionalRemark,
        ApiParam.paramPaymentType: paymentType,
        ApiParam.paramMinBargainAmt: minFareAmount,
        ApiParam.paramMaxBargainAmt: maxFareAmount,
        ApiParam.paramRecipientName: recipientName,
        ApiParam.paramRecipientNumber: recipientNumber,
        ApiParam.paramItemDesc: itemDecs,
        ApiParam.paramEstimatePrice: estimatePrice,
        ApiParam.paramIsAutoAccept: autoAccept,
        ApiParam.paramRideForOther: rideForOther,
        ApiParam.paramOtherUserName: otherName,
        ApiParam.paramOtherUserContactNumber: otherNumber,
        ApiParam.paramChildSeat: childSeat,
        ApiParam.paramHandicap: handicap,
        ApiParam.paramDestinationPaymentMethod: destinationPaymentMethod,
        ApiParam.paramPackageWeightKg: packageWeightKg,
        ApiParam.paramPackageHeightCm: packageHeightCm,
        ApiParam.paramPackageWidthCm: packageWidthCm,
        ApiParam.paramPackageLengthCm: packageLengthCm,
        if (requestedVehicleServiceId > 0) ApiParam.paramRequestedVehicleServiceId: requestedVehicleServiceId,
        if (errandType.isNotEmpty) ApiParam.paramErrandType: errandType,
        if (deliveryVariant.trim().isNotEmpty) ApiParam.paramDeliveryVariant: deliveryVariant.trim(),
      },
    );
    return response;
  }

  Future nearestDriverPositionApi(double currentLat, double currentLng) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointTransportGetNearestDriver,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramCurrentLat: currentLat,
        ApiParam.paramCurrentLng: currentLng,
      },
    );
    return response;
  }

  Future rideCalculation(int serviceCategoryId, double distance, int estimateTime) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointRideCalculation,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramServiceCategoryId: serviceCategoryId,
        ApiParam.paramDistance: distance,
        ApiParam.paramEstimateTime: estimateTime,
      },
    );
    return response;
  }
}
