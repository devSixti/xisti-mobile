import 'package:dio/dio.dart';

import '../../../hive/hive_helper.dart';
import '../../../networking/api_base_helper.dart';

class RequiredDocumentRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future manageDocumentListApi() async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointManageDocumentList,
      body: {ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId), ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken)},
    );
    return response;
  }

  Future uploadSingleDocumentApi(int documentId, String expiryDate, int isUpdate, MultipartFile? multipartFile, progress) async {
    final response = await _apiBaseHelper.postFormData(
      ApiConst.endPointUploadSingleDocument,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramDocumentId: documentId,
        ApiParam.paramExpiryDate: expiryDate,
        ApiParam.paramIsUpdate: isUpdate,
        ApiParam.paramDocumentFile: multipartFile,
      },
      onProgress: progress,
    );
    return response;
  }
}
