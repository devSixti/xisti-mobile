import 'package:dio/dio.dart';

import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';

class ChatRepo {
  final ApiBaseHelper apiBaseHelper = ApiBaseHelper(baseUrl: BaseUrl.baseUrlCustomer + ApiConst.endPointReportIssue);

  Future sendImageCall(String reportChatNo, MultipartFile? multipartFile) async {
    final response = await apiBaseHelper.postFormData(
      ApiConst.endPointChatPhotos,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramReportChatNo: reportChatNo,
        ApiParam.paramChatImage: multipartFile,
      },
    );

    return response;
  }
}
