import '../../../../hive/hive_helper.dart';
import '../../../../networking/api_base_helper.dart';

class WalletHomeRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future getWalletBalanceApi() async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointGetWalletBalance,
      body: {ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId), ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken)},
    );
    return response;
  }

  Future addWalletBalanceApi(double amount, int cardId) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointWalletBalance,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramAmount: amount,
        ApiParam.paramCardId: cardId,
        ApiParam.paramPaymentMethodType: 1,
      },
    );
    return response;
  }

  Future cashOutApi(double amount) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointRequestCashOut,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramAmount: amount,
      },
    );
    return response;
  }
}
