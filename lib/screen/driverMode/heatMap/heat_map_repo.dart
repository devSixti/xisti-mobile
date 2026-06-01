import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';

class HeatMapRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future callHeatMapApi(int selectedServiceCategoryId) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointHeatMap,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
      },
    );
    return response;
  }
}
