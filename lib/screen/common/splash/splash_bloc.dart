import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../blocs/bloc.dart';
import '../../../bottomSheet/common_bottom_sheet.dart';
import '../../../bottomSheet/location_disclosure_sheet.dart';
import '../../../hive/hive_helper.dart';
import '../../../services/market_config_repo.dart';
import '../../../utils/app_mobile_settings.dart';
import '../../../utils/mobile_auth_bootstrap.dart';
import '../../../services/session_restore_service.dart';
import '../../../utils/utils.dart';
import '../../driverMode/driverHome/driver_home.dart';
import '../../driverMode/driverRunningRide/driver_running_ride.dart';
import '../../passengerMode/offerRide/offer_ride_screen.dart';
import '../../passengerMode/passengerHome/passenger_home.dart';
import '../../passengerMode/passengerRunningRide/passenger_running_ride.dart';
import '../languageCurrency/language_currency_screen.dart';
import 'splash_dl.dart';
import 'splash_repo.dart';

class SplashBloc extends Bloc {
  BuildContext context;
  String tag = 'SplashBloc';
  bool isBottomSheetOpen = false;
  final SplashRepo _splashRepo = SplashRepo();
  Timer? _timer;

  SplashBloc(this.context) {
    checkAppVersionApi();
  }

  final _subject = BehaviorSubject<ApiResponse<AppVersionCheckPojo>>();

  BehaviorSubject<ApiResponse<AppVersionCheckPojo>> get subject => _subject;

  Future<void> checkAppVersionApi() async {
    if (!await isNetworkConnected(
      onRetryPressedCallApi: () {
        checkAppVersionApi();
      },
    )) {
      debugPrint('$tag checkAppVersionApi: no connectivity, using defaults');
      _continueAfterBootstrapFailure();
      return;
    }
    _subject.sink.add(ApiResponse.loading());
    try {
      var response = AppVersionCheckPojo.fromJson(await _splashRepo.appVersionCheckApi());

      String message = getApiMsg(response.message);

      if (!context.mounted) return;
      if (isApiStatus(context, response.status, message, true)) {
        applyBuildTimeAppKeyIfConfigured();
        applyMobileAppKeyFromApi(response.appKey);
        if (kDebugMode && getStringFromSettingBox(hiveAuthKey).isEmpty) {
          debugPrint('$tag: XISTI_APP_KEY not configured — protected APIs will fail.');
        }
        applySocialLoginSettingsFromApi(response.toJson());
        applyAppMobileSettingsFromJson(response.toJson());
        unawaited(syncMarketConfig());
        _subject.sink.add(ApiResponse.completed(response));
        openForceFullyUpdateDialog(response.appVersion ?? "0", response.isForcefullyUpdate ?? 0);
      } else {
        _subject.sink.add(ApiResponse.error(message));
        _continueAfterBootstrapFailure();
      }
    } catch (e) {
      debugPrint('$tag checkAppVersionApi: $e');
      _subject.sink.add(ApiResponse.error(e.toString()));
      _continueAfterBootstrapFailure();
    }
  }

  void _continueAfterBootstrapFailure() {
    if (!context.mounted) return;
    applyBootstrapDefaultsWhenApiUnavailable();
    unawaited(ensureMobileAppAuthConfigured());
    openForceFullyUpdateDialog("0", 0);
  }

  Future<void> openForceFullyUpdateDialog(String versionName, int forcefullyUpdate) async {
    String currentVersion = "0", packageName = "";
    if (!kIsWeb) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      currentVersion = packageInfo.version;
      packageName = packageInfo.packageName;
    }
    if (currentVersion.compareTo(versionName) == -1 && forcefullyUpdate == 1) {
      if (!context.mounted) return;
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return CommonBottomSheet(
            title: languages.newUpdateAvailable,
            message: languages.newUpdateMsg,
            positiveButtonTxt: languages.update,
            cancelable: false,
            onPositivePress: () async {
              String url = "";
              if (Platform.isAndroid) {
                url = "https://play.google.com/store/apps/details?id=$packageName";
              } else {
                url = "https://apps.apple.com/app/id$appleId";
              }
              if (!isBottomSheetOpen) {
                isBottomSheetOpen = true;
                openUrl(url, launchMode: LaunchMode.externalApplication);
                await Future.delayed(const Duration(milliseconds: 1000));
                isBottomSheetOpen = false;
              }
            },
          );
        },
      ).then((value) {
        openForceFullyUpdateDialog(versionName, forcefullyUpdate);
      });
    } else {
      if (getStringFromSettingBox(hiveAuditConsentVersion) != currentAuditConsentVersion) {
        openDisclosureDialog();
      } else {
        splashAction();
      }
    }
  }

  void openDisclosureDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return LocationDisclosureSheet(
          onAgree: () {
            Navigator.pop(context, true);
            splashAction();
          },
        );
      },
    );
  }

  Future<bool> checkLocationPermission() async {
    LocationPermission permissionGranted = await Geolocator.checkPermission();
    if (permissionGranted == LocationPermission.denied) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> callDriverRunningServiceApi() async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callDriverRunningServiceApi();
      },
    )) {
      try {
        var response = GetRunningServicePojo.fromJson(await _splashRepo.getDriverRunningServiceApi());
        String message = getApiMsg(response.message);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, false, showMess: false)) {
          List<RunningRides> runningRidesList = response.runningRides ?? [];
          putDataInSettingBox(hiveIsAutoSettle, response.isAutoSettle == 1);
          if (runningRidesList.isEmpty) {
            _timer = Timer(const Duration(milliseconds: 5000), () {
              if (!context.mounted) return;
              openScreenWithClearPrevious(context, const DriverHome(isFromLogin: false));
            });
          } else {
            if (!context.mounted) return;
            openScreenWithClearPrevious(
              context,
              DriverRunningRide(rideId: response.runningRides?.first.rideId ?? 0, serviceId: response.runningRides?.first.rideServiceCatId ?? ServiceType.taxi),
            );
          }
        } else {
          if (response.status == 0 || response.status == 1 || isLoggedIn()) {
            _timer = Timer(const Duration(milliseconds: 5000), () {
              if (!context.mounted) return;
              openScreenWithClearPrevious(context, const DriverHome(isFromLogin: false));
            });
          }
        }
      } catch (e) {
        _timer = Timer(const Duration(milliseconds: 5000), () {
          if (!context.mounted) return;
          openScreenWithClearPrevious(context, const DriverHome(isFromLogin: false));
        });
        debugPrint(e.toString());
      }
    }
  }

  Future<void> callPassengerRunningServiceApi() async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callPassengerRunningServiceApi();
      },
    )) {
      try {
        var response = PassengerRunningPojo.fromJson(await _splashRepo.getPassengerRunningServiceApi());
        String message = getApiMsg(response.message);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, false, showMess: false)) {
          if ((response.rideId ?? 0) == 0) {
            if (!context.mounted) return;
            _timer = Timer(const Duration(milliseconds: 5000), () {
              openScreenWithClearPrevious(context, const PassengerHome());
            });
          } else {
            if (!context.mounted) return;
            Widget screen;
            if (response.rideStatus == 0 && (response.rideDetails ?? []).isNotEmpty) {
              RideDetails rideDetail = response.rideDetails!.first;
              screen = OfferRideScreen(
                rideId: rideDetail.rideId ?? 0,
                serviceType: rideDetail.serviceId ?? 0,
                addressList: rideDetail.addressList ?? [],
                fareAmount: "${rideDetail.offeredPrice ?? 0}",
                itemDesc: rideDetail.itemDescription ?? "",
                recipientName: rideDetail.recipientName ?? "",
                recipientNumber: rideDetail.recipientContactNumber ?? "",
                minFareAmount: rideDetail.minBargainAmt ?? 0,
                maxFareAmount: rideDetail.maxBargainAmt ?? 0,
                estimatedPrice: "${rideDetail.offeredPrice ?? 0}",
              );
            } else {
              screen = PassengerRunningRide(rideId: response.rideId ?? 0);
            }
            _timer = Timer(const Duration(milliseconds: 5000), () {
              if (!context.mounted) return;
              openScreenWithClearPrevious(context, screen);
            });
          }
        } else {
          if (response.status == 0 || response.status == 1 || isLoggedIn()) {
            _timer = Timer(const Duration(milliseconds: 5000), () {
              if (!context.mounted) return;
              openScreenWithClearPrevious(context, const PassengerHome());
            });
          }
        }
      } catch (e) {
        debugPrint('$tag callPassengerRunningServiceApi: $e');
        _timer = Timer(const Duration(milliseconds: 3000), () {
          if (!context.mounted) return;
          openScreenWithClearPrevious(context, const PassengerHome());
        });
      }
    }
  }

  Future<void> splashAction() async {
    SessionRestoreService.syncLoggedInFlagFromStoredCredentials();

    if (!isLoggedIn() && SessionRestoreService.canRestoreBiometricSession()) {
      final restored = await SessionRestoreService.tryRestoreSessionWithBiometrics(context);
      if (!context.mounted) {
        return;
      }
      if (restored) {
        SessionRestoreService.syncLoggedInFlagFromStoredCredentials();
      }
    }

    if (isLoggedIn()) {
      if (getIntFromSettingBox(hiveAppMode) == AppMode.driver) {
        callDriverRunningServiceApi();
      } else {
        callPassengerRunningServiceApi();
      }
    } else {
      _timer = Timer(const Duration(milliseconds: 3000), () {
        if (!context.mounted) return;
        openScreenWithClearPrevious(context, const LanguageAndCurrency(isFromHome: false));
      });
    }
  }

  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
    }
    _subject.close();
  }
}
