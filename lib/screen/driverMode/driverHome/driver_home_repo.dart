import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';

class DriverHomeRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future driverHomeApi({required String currentLat, required String currentLng,required dynamic selectDistance, String appVersion = ""}) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointDriverHome,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramSearchDistance: selectDistance,
        ApiParam.paramAppVersion: appVersion,
        ApiParam.paramCurrentLat: currentLat,
        ApiParam.paramCurrentLng: currentLng,
      },
    );
    return response;
  }

  Future updateCurrentStatusApi({required int updateStatus}) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointUpdateCurrentStatus,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramUpdateStatus: updateStatus,
      },
    );
    return response;
  }

  Future updateCurrentLatLongApi({required double currentLat, required double currentLong}) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointUpdateCurrentLatLong,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramCurrentLat: currentLat,
        ApiParam.paramCurrentLng: currentLong,
      },
    );
    return response;
  }

  Future availableRideRequestApi({double? currentLat, double? currentLng}) async {
    final body = {
      ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
      ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
    };
    if (currentLat != null && currentLng != null) {
      body[ApiParam.paramCurrentLat] = currentLat.toString();
      body[ApiParam.paramCurrentLng] = currentLng.toString();
    }
    final response = await _apiBaseHelper.post(
      ApiConst.endPointAvailableRide,
      body: body,
    );
    return response;
  }

  Future updateDriverAvailabilityModesApi({
    required int acceptTransport,
    required int acceptDelivery,
  }) async {
    return _apiBaseHelper.post(
      ApiConst.endPointUpdateDriverAvailabilityModes,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramAcceptTransport: acceptTransport,
        ApiParam.paramAcceptDelivery: acceptDelivery,
      },
    );
  }
}
