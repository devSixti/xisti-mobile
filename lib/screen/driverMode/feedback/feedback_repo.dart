import '../../../blocs/bloc.dart';
import '../../../hive/hive_helper.dart';

class FeedbackRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future customerFeedback() async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointRideFeedback,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
      },
    );
    return response;
  }
}
