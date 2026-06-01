import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';

class AddNewAddressRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future callAddAddressApi(String address, int addressType, LatLng latLng) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointAddAddress,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramAddress: address,
        ApiParam.paramType: addressType,
        ApiParam.paramLat: latLng.latitude,
        ApiParam.paramLong: latLng.longitude,
      },
    );
    return response;
  }

  Future callEditAddressApi(int addressId, String address, int addressType, LatLng latLng) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointEditAddress,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramAddressId: addressId,
        ApiParam.paramAddress: address,
        ApiParam.paramType: addressType,
        ApiParam.paramLat: latLng.latitude,
        ApiParam.paramLong: latLng.longitude,
      },
    );
    return response;
  }
}
