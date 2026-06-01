import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';

class ReferralRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future getReferralList() async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointRefer,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
      },
    );
    return response;
  }
}
