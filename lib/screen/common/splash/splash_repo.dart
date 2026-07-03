import 'dart:io';

import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';
import '../../../utils/utils.dart';

class SplashRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper(
    connectTimeout: const Duration(seconds: 25),
    receiveTimeout: const Duration(seconds: 25),
  );

  Future getDriverRunningServiceApi() async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointGetDriverRunningService,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
      },
    );
    return response;
  }

  Future getPassengerRunningServiceApi() async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointGetCustomerRunningService,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
      },
    );
    return response;
  }

  Future validateSessionApi() async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointGetDetail,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
      },
    );
    return response;
  }

  Future appVersionCheckApi() async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointAppVersionCheck,
      body: {ApiParam.paramLoginDevice: Platform.isAndroid ? LoginDeviceType.android : LoginDeviceType.ios, ApiParam.paramAppType: 0},
    );
    return response;
  }
}
