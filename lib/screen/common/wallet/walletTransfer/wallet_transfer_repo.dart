import '../../../../hive/hive_helper.dart';
import '../../../../networking/api_base_helper.dart';

class WalletTransferRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future findUser(String search) async {
    // provider_id => numeric
    // access_token => numeric
    // search  => numeric
    final response = await _apiBaseHelper.post(
      ApiConst.endPointSearchUser,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramSearch: search,
      },
    );
    return response;
  }

  Future transferWalletBalance(double amount, int transferId, int walletProviderType) async {
    // user_id => numeric
    // access_token => numeric
    // amount => numeric
    // transfer_id => numeric
    // wallet_provider_type => 0-user,1-store,2-driver,3-provider:

    final response = await _apiBaseHelper.post(
      ApiConst.endPointWalletTransfer,
      body: {
        ApiParam.paramUserId: getIntFromUserInfoBox(hiveUserId),
        ApiParam.paramAccessToken: getStringFromSettingBox(hiveAccessToken),
        ApiParam.paramAmount: amount,
        ApiParam.paramTransferId: transferId,
        ApiParam.paramWalletProviderType: walletProviderType,
      },
    );
    return response;
  }
}
