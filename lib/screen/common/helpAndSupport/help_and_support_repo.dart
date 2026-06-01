import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';

class HelpAndSupportRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future getHelpAndSupport() async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointSupportPages,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
      },
    );
    return response;
  }
}
