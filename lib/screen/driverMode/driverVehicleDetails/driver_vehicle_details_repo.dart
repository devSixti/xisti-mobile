import 'package:dio/dio.dart';

import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';

class DriverVehicleDetailsRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future vehicleServiceListApi() async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointVehicleList,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
      },
    );
    return response;
  }

  Future getVehicleDetailApi() async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointGetVehicleDetails,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
      },
    );
    return response;
  }

  Future callServiceRegisterApi({
    required int vehicleTypeId,
    required int serviceTypeId,
    required String manufactureName,
    required String modelName,
    required String modelYear,
    required String vehiclePlatNo,
    required String vehicleColor,
    required int childSeat,
    required int handyCapAccess,
    int isTaxi = 0,
    int acceptDelivery = 1,
    String? deliveryVariant,
    int alsoTransportPassengers = 0,
    double? currentLat,
    double? currentLong,
    MultipartFile? vehicleImageFront,
    MultipartFile? vehicleImageSide,
    MultipartFile? vehicleImageRear,
    String? technicalInspectionExpiry,
    progress,
  }) async {
    final body = <String, dynamic>{
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramVehicleTypeId: vehicleTypeId,
        ApiParam.paramServiceTypeId: serviceTypeId,
        ApiParam.paramManufactureName: manufactureName,
        ApiParam.paramModelName: modelName,
        ApiParam.paramModelYear: modelYear,
        ApiParam.paramVehiclePlatNo: vehiclePlatNo,
        ApiParam.paramVehicleColor: vehicleColor,
        ApiParam.paramChildSafetySeat: childSeat,
        ApiParam.paramHandyCapSeat: handyCapAccess,
        ApiParam.paramIsTaxi: isTaxi,
        ApiParam.paramAcceptDelivery: acceptDelivery,
        ApiParam.paramAlsoTransportPassengers: alsoTransportPassengers,
    };
    if (deliveryVariant != null && deliveryVariant.trim().isNotEmpty) {
      body[ApiParam.paramDeliveryVariant] = deliveryVariant.trim();
    }
    body[ApiParam.paramCurrentLat] = currentLat;
    body[ApiParam.paramCurrentLng] = currentLong;
    body[ApiParam.paramVehicleImageFront] = vehicleImageFront;
    body[ApiParam.paramVehicleImageSide] = vehicleImageSide;
    body[ApiParam.paramVehicleImageRear] = vehicleImageRear;
    if (technicalInspectionExpiry != null && technicalInspectionExpiry.trim().isNotEmpty) {
      body[ApiParam.paramTechnicalInspectionExpiry] = technicalInspectionExpiry.trim();
    }
    final response = await _apiBaseHelper.postFormData(
      ApiConst.endPointServiceRegister,
      body: body,
      onProgress: progress,
    );
    return response;
  }
}
