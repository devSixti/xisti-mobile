import '../../../../constant/constant.dart';
import '../../../../hive/hive_helper.dart';
import '../../../../networking/api_base_helper.dart';

class ReportedIssueHistoryRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future getIssueHistoryApi(int filterType, int page, String timeZone, String status, int generalIssueFilter, {int perPage = perPageRecord}) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointReportIssueTransportHistory,
      body: {
        ApiParam.paramIssueProviderId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramIssueProviderType: getIntFromSettingBox(hiveAppMode),
        ApiParam.paramFilterType: filterType,
        ApiParam.paramPage: page,
        ApiParam.paramPerPage: perPage,
        ApiParam.paramTimeZone: timeZone, //Asia/Kolkata
        ApiParam.paramIssueStatus: status, // 1 = un-resolved, 2 = resolved
        ApiParam.paramIssueGeneralIssueFilter: generalIssueFilter, // 0 = all, 1 = general issue
      },
    );
    return response;
  }
}
