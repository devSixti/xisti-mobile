import '../../../../hive/hive_helper.dart';
import '../../../../networking/api_base_helper.dart';

class ReportIssueHomeRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future faqListApi() async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointReportIssueFaqs,
      body: {
        ApiParam.paramIssueProviderId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramIssueProviderType: getIntFromSettingBox(hiveAppMode),
      },
    );
    return response;
  }
}
