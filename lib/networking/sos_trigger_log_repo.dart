import '../hive/hive_helper.dart';
import 'api_base_helper.dart';

/// Fire-and-forget audit log when the user places an SOS call (MVP Core).
class SosTriggerLogRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<void> logTrigger({
    required int? rideId,
    required String userRole,
    required String contactName,
    required String countryCode,
    required String contactNumber,
  }) async {
    try {
      await _apiBaseHelper.post(
        ApiConst.endPointLogSosTrigger,
        body: {
          ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
          ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
          if (rideId != null && rideId > 0) ApiParam.paramRideId: rideId,
          ApiParam.paramUserRole: userRole,
          ApiParam.paramContactName: contactName,
          ApiParam.paramCountryCode: countryCode,
          ApiParam.paramContactNumber: contactNumber,
        },
      );
    } catch (_) {
      // SOS call must not fail if logging fails.
    }
  }
}
