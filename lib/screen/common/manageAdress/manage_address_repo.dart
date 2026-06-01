import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';

class ManageAddressRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future callAddressListApi() async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointAddressList,
      body: {ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId), ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken)},
    );
    return response;
  }

  Future callDeleteAddressApi(int addressId) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointDeleteAddress,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramAddressId: addressId,
      },
    );
    return response;
  }
}
