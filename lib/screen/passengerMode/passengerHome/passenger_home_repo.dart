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
    String deliveryDirection = '',
    String senderName = '',
    String senderNumber = '',
    String acarreoVehicleVariant = '',
    String estimatedServiceDate = '',
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
        if (deliveryDirection.isNotEmpty) ApiParam.paramDeliveryDirection: deliveryDirection,
        if (senderName.isNotEmpty) ApiParam.paramSenderName: senderName,
        if (senderNumber.isNotEmpty) ApiParam.paramSenderNumber: senderNumber,
        if (acarreoVehicleVariant.isNotEmpty) ApiParam.paramAcarreoVehicleVariant: acarreoVehicleVariant,
        if (estimatedServiceDate.isNotEmpty) ApiParam.paramEstimatedServiceDate: estimatedServiceDate,
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

  Future<Map<String, dynamic>> sharedRideSearch({
    required String tripKind,
    required String originTown,
    required String destinationTown,
    required String tripDate,
  }) async {
    return Map<String, dynamic>.from(
      await _apiBaseHelper.post(
        ApiConst.endPointSharedRideSearch,
        body: {
          ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
          ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
          ApiParam.paramTripKind: tripKind,
          ApiParam.paramOriginTown: originTown,
          ApiParam.paramDestinationTown: destinationTown,
          ApiParam.paramTripDate: tripDate,
        },
      ),
    );
  }

  Future<Map<String, dynamic>> sharedRideJoin({required int offerId, int? searchId}) async {
    final body = <String, dynamic>{
      ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
      ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
      ApiParam.paramOfferId: offerId,
    };
    if (searchId != null && searchId > 0) {
      body[ApiParam.paramSearchId] = searchId;
    }
    return Map<String, dynamic>.from(
      await _apiBaseHelper.post(ApiConst.endPointSharedRideJoin, body: body),
    );
  }

  Future<Map<String, dynamic>> sharedRideCreateOffer({
    required String tripKind,
    required String originTown,
    required String destinationTown,
    required String tripDate,
    required int seatsTotal,
    required double farePerPerson,
  }) async {
    return Map<String, dynamic>.from(
      await _apiBaseHelper.post(
        ApiConst.endPointSharedRideCreateOffer,
        body: {
          ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
          ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
          ApiParam.paramTripKind: tripKind,
          ApiParam.paramOriginTown: originTown,
          ApiParam.paramDestinationTown: destinationTown,
          ApiParam.paramTripDate: tripDate,
          ApiParam.paramSeatsTotal: seatsTotal,
          ApiParam.paramFarePerPerson: farePerPerson,
        },
      ),
    );
  }
}
