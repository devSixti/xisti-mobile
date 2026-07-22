import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../blocs/bloc.dart';
import '../../../bottomSheet/driver_register_bottom_sheet.dart';
import '../../../commonView/common_view.dart';
import '../../../hive/hive_helper.dart';
import '../../../utils/biometrics_login_utils.dart';
import '../../../utils/utils.dart';
import '../../driverMode/bankDetails/bank_details_screen.dart';
import '../../driverMode/driverHome/driver_home.dart';
import '../../driverMode/driverRideHistory/driver_ride_history.dart';
import '../../driverMode/feedback/feedback_screen.dart';
import '../../driverMode/heatMap/heat_map_screen.dart';
import '../../driverMode/pendingDriverScreen/pending_driver_screen.dart';
import '../../passengerMode/passengerHome/passenger_home.dart';
import '../../passengerMode/passengerRideHistory/passenger_ride_history.dart';
import '../emergencyContact/emergency_contact.dart';
import '../helpAndSupport/help_and_support.dart';
import '../inviteFriends/invite_friends.dart';
import '../languageCurrency/language_currency_screen.dart';
import '../manageAccount/manage_account_screen.dart';
import '../manageAdress/manage_address_screen.dart';
import '../manageInformation/manage_information_screen.dart';
import '../notificationsScreen/notification_screen.dart';
import '../referralScreen/referral_screen.dart';
import '../reportIssue/reportIssueHome/report_issue_home.dart';
import '../wallet/walletHome/wallet_home.dart';
import 'account_dl.dart';
import 'account_repo.dart';

class AccountBloc extends Bloc {
  final BuildContext context;
  final AccountRepo _accountRepo = AccountRepo();

  AccountBloc(this.context) {
    if (getIntFromSettingBox(hiveIsFingerAllow) == 1) {
      biometricsLoginUtils.isAuthenticationAvailable().then((isBiometricAvailable) {
        isBiometricAuthAvailableController.sink.add(isBiometricAvailable && getStringFromSettingBox(hiveUniqueId).trim().isNotEmpty);
      });
    }
    getDrawerData();
  }

  final BiometricsLoginUtils biometricsLoginUtils = BiometricsLoginUtils();

  final accountItemController = BehaviorSubject<List<AccountItem>>();
  final loginWithBiometricController = BehaviorSubject<bool>.seeded(getBoolFromSettingBox(hiveIsLoginWithBiometrics));
  final isBiometricAuthAvailableController = BehaviorSubject<bool>();
  final subjectMode = BehaviorSubject<ApiResponse<ActiveModePojo>>();
  final subjectStatus = BehaviorSubject<ApiResponse<DriverServiceStatusPojo>>();

  Future<void> callChangeAppModeApi() async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callChangeAppModeApi();
      },
    )) {
      subjectMode.sink.add(ApiResponse.loading());
      try {
        var response = ActiveModePojo.fromJson(await _accountRepo.changeAppModeApi());
        if (!context.mounted) return;
        String message = getApiMsg(response.message);
        if (isApiStatus(context, response.status, message, true)) {
          subjectMode.sink.add(ApiResponse.completed(response));
          putDataInSettingBox(hiveAppMode, response.activeMode ?? AppMode.passenger);
          if (response.activeMode == AppMode.passenger) {
            putDataInSettingBox(hiveDriverCurrentStatus, 0);
            putDataInSettingBox(hivePaymentTypeCash, response.cashPayment == 1);
            putDataInSettingBox(hivePaymentTypeOnline, response.onlinePayment == 1);
            putDataInSettingBox(hivePaymentTypeWallet, response.walletPayment == 1);
            backgroundLocationService.onStop();
          }
          changeSubscribeTopic();
          if (getIntFromSettingBox(hiveAppMode) == AppMode.driver) {
            openScreenWithClearPrevious(context, const DriverHome(isFromLogin: true));
          } else {
            openScreenWithClearPrevious(context, const PassengerHome(isFromLogin: true));
          }
        } else {
          subjectMode.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        debugPrint(e.toString());
        subjectMode.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> callServiceStatusApi() async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callServiceStatusApi();
      },
    )) {
      subjectStatus.sink.add(ApiResponse.loading());
      try {
        var response = DriverServiceStatusPojo.fromJson(await _accountRepo.serviceStatusApi());

        if (!context.mounted) return;
        String message = getApiMsg(response.message);
        if (isApiStatus(context, response.status, message, true)) {
          subjectStatus.sink.add(ApiResponse.completed(response));
          putDataInSettingBox(hiveVehicleStatus, response.driverVehicleStatus ?? 0);
          putDataInSettingBox(hiveDocumentStatus, response.driverDocStatus ?? 0);
          putDataInSettingBox(hiveDriverType, response.isDriverType ?? 0);
          putDataInSettingBox(hiveDriverStatus, response.isDriverStatus ?? 0);
          if (response.driverVehicleStatus != 1 || response.driverDocStatus != 1) {
            openDriverRegisterBottomSheet();
          } else {
            //0==pending
            //1==approved
            //2==block
            //3==rejected
            switch (response.isDriverStatus) {
              case 0:
                openScreen(context, PendingDriverScreen(driverStatus: response.isDriverStatus ?? 0, message: languages.pendingMessage));
                break;
              case 1:
                callChangeAppModeApi();
                break;
              case 2:
                openScreen(
                  context,
                  PendingDriverScreen(driverStatus: response.isDriverStatus ?? 0, message: languages.driverBlock, rejectMessage: response.rejectReason ?? ""),
                );
                break;
              case 3:
                openScreen(
                  context,
                  PendingDriverScreen(
                    driverStatus: response.isDriverStatus ?? 0,
                    message: languages.driverRejectedByAdmin,
                    rejectMessage: response.rejectReason ?? "",
                  ),
                );
                break;
            }
          }
        } else {
          subjectStatus.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        debugPrint(e.toString());
        subjectStatus.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  void getDrawerData() {
    List<AccountItem> accountItemsList = [
      AccountItem(AccountEnum.rideHistory, CustomIcons.rideHistory, languages.rideHistory, isEmailAndNumberCheck: true),
      AccountItem(AccountEnum.notification, CustomIcons.notification, languages.notification, isEmailAndNumberCheck: true),
      if (getBoolFromSettingBox(hivePaymentTypeWallet))
        AccountItem(AccountEnum.wallet, CustomIcons.myWallet, languages.myWallet, isEmailAndNumberCheck: true),
      if (getIntFromSettingBox(hiveAppMode) == AppMode.driver)
        AccountItem(AccountEnum.manageInformation, CustomIcons.manageInformation, languages.manageInformation, isEmailAndNumberCheck: true),

      if (getIntFromSettingBox(hiveAppMode) == AppMode.driver)
        AccountItem(AccountEnum.bankDetails, CustomIcons.bankDetails, languages.bankDetails, isEmailAndNumberCheck: true),

      AccountItem(AccountEnum.referHistory, CustomIcons.referHistory, languages.referHistory, isEmailAndNumberCheck: true),
      AccountItem(AccountEnum.myPreference, CustomIcons.myPreferences, languages.myPreference),
      if (getIntFromSettingBox(hiveAppMode) == AppMode.passenger)
        AccountItem(AccountEnum.manageAddress, CustomIcons.manageAddress, languages.manageAddress, isEmailAndNumberCheck: true),

      if (getIntFromSettingBox(hiveAppMode) == AppMode.driver)
        AccountItem(AccountEnum.rating, CustomIcons.ratingMenu, languages.rating, isEmailAndNumberCheck: true),

      AccountItem(AccountEnum.emergencyContact, CustomIcons.emergencyContact, languages.emergencyContact, isEmailAndNumberCheck: true),
      AccountItem(AccountEnum.inviteFriend, CustomIcons.inviteFriend, languages.inviteFriend),
      AccountItem(AccountEnum.reportIssue, CustomIcons.reportIssue, languages.reportIssue),
      if (getIntFromSettingBox(hiveAppMode) == AppMode.driver) AccountItem(AccountEnum.heatMap, CustomIcons.heatMap, languages.heatMap, isEmailAndNumberCheck: true),
      AccountItem(AccountEnum.help, CustomIcons.help, languages.help),
      AccountItem(AccountEnum.manageAccount, CustomIcons.manageAccount, languages.manageAccount),
    ];
    accountItemController.sink.add(accountItemsList);
  }

  void changeAppMode() {
    if (getIntFromSettingBox(hiveAppMode) == AppMode.driver) {
      callChangeAppModeApi();
    } else {
      callServiceStatusApi();
    }
  }

  void openDriverRegisterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: MediaQueryData.fromView(View.of(context)).padding.top + 10.h),
          child: DriverRegisterBottomSheet(
            onProceed: () {
              Navigator.pop(context);
              openScreen(context, ManageInformationScreen());
            },
          ),
        );
      },
    );
  }

  void openAccountSelectedScreen(AccountItem accountItem) {
    Widget? screen;

    switch (accountItem.accountEnum) {
      case AccountEnum.notification:
        screen = NotificationScreen();
        break;
      case AccountEnum.rideHistory:
        screen = (getIntFromSettingBox(hiveAppMode) == AppMode.driver) ? const DriverRideHistory() : const PassengerRideHistory();
        break;
      case AccountEnum.wallet:
        screen = WalletHome();
        break;
      case AccountEnum.manageInformation:
        screen = ManageInformationScreen();
        break;
      case AccountEnum.referHistory:
        screen = ReferralScreen();
        break;
      case AccountEnum.myPreference:
        screen = LanguageAndCurrency(isFromHome: true);
        break;
      case AccountEnum.manageAddress:
        screen = ManageAddressScreen();
        break;
      case AccountEnum.emergencyContact:
        screen = EmergencyContact();
        break;
      case AccountEnum.inviteFriend:
        screen = InviteFriend();
        break;
      case AccountEnum.reportIssue:
        screen = ReportIssueHome();
        break;
      case AccountEnum.rating:
        screen = FeedbackScreen();
        break;
      case AccountEnum.help:
        screen = HelpAndSupport();
        break;
      case AccountEnum.heatMap:
        screen = HeatMapScreen();
        break;
      case AccountEnum.bankDetails:
        screen = BankDetailsScreen();
        break;
      case AccountEnum.manageAccount:
        screen = ManageAccountScreen();
        break;
    }
    if (accountItem.isEmailAndNumberCheck) {
      openRequiredInfoBottomSheet(context, () {
        openScreen(context, screen!);
      });
    } else {
      openScreen(context, screen);
    }
  }

  @override
  void dispose() {
    accountItemController.close();
    loginWithBiometricController.close();
    isBiometricAuthAvailableController.close();
  }
}
