import '../../../../../constant/constant.dart';
import '../../../../../hive/hive_helper.dart';
import '../../../../../networking/api_base_helper.dart';

class WalletTransactionRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future getWalletTransactionsListApi({required int orderBy, required int dateFilter, int perPage = perPageRecord, required int page}) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointWalletTransactions,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramOrderBy: orderBy,
        ApiParam.paramDateFilter: dateFilter,
        ApiParam.paramPerPage: perPage,
        ApiParam.paramPage: page,
      },
    );
    return response;
  }
}
