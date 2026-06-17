import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart' as p_handler;
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../blocs/bloc.dart';
import '../../../bottomSheet/acceptRequestBottomSheet/accept_request_bottom_sheet.dart';
import '../../../bottomSheet/common_bottom_sheet.dart';
import '../../../bottomSheet/manage_distance_bottom_sheet.dart';
import '../../../bottomSheet/overlay_permission_bottom_sheet.dart';
import '../../../bottomSheet/region_confirm_sheet.dart';
import '../../../hive/hive_helper.dart';
import '../../../networking/base_dl.dart';
import '../../../services/dispatch_trigger_service.dart';
import '../../../services/push_notification_service.dart';
import '../../../utils/service_mode_util.dart';
import '../../../utils/alert_feedback_util.dart';
import '../../../utils/utils.dart';
import 'driver_availability_modes.dart';
import '../../common/splash/splash_dl.dart';
import '../../common/splash/splash_repo.dart';
import '../../common/wallet/walletHome/wallet_home.dart';
import '../driverDocumentScreen/require_document_screen.dart';
import '../driverRunningRide/driver_running_ride.dart';
import 'driver_home_dl.dart';
import 'driver_home_repo.dart';

class DriverHomeBloc extends Bloc {
  BuildContext context;

  DriverHomeBloc(this.context, this.iFromLogin) {
    firebaseAuth().then((value) {
      setFCMToken();
    });
    manageNotification();
    getCurrentLocation().then((value) async {
      if (Platform.isAndroid && await Permission.systemAlertWindow.status.isDenied && (int.parse(await getAndroidVersion()) < androidVersion15)) {
        openOverlayPermissionBottomSheet();
      }
    });
  }

  DateTime? lastResumeStateDateTime;
  bool iFromLogin;
  String versionName = "";
  final SplashRepo _splashRepo = SplashRepo();
  List<RideList> rideList = [];
  List<AddressListItem> addressList = [];

  final DriverHomeRepo _repo = DriverHomeRepo();

  BuildContext? manageDistanceContext;
  BuildContext? overlayPermissionContext;
  BuildContext? acceptRequestContext;
  BuildContext? walletBottomSheet;

  Timer? _availableApiTimer;
  LatLng? currentLaLng;
  List<int> rideIdList = [];
  dynamic nearestDistance;
  bool isBottomSheetOpen = false;
  StreamSubscription<RemoteMessage>? firebaseOnMessageStream;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  final selectedDriverRideSubject = BehaviorSubject<RideList?>();

  final availableRideSubject = BehaviorSubject<ApiResponse<AvailableRidePojo>>();
  final driverHomeSubject = BehaviorSubject<ApiResponse<DriverHomePojo>>();
  final selectDistanceSubject = BehaviorSubject<dynamic>.seeded(0);
  final currentStatusSubject = BehaviorSubject<ApiResponse<UpdateCurrentStatusPojo>>();
  final statusSwitchSubject = BehaviorSubject<bool>.seeded(getIntFromSettingBox(hiveDriverCurrentStatus) == 1);
  final rideListItemSubject = BehaviorSubject<RideList?>();
  final showHailRideSubject = BehaviorSubject<bool>();
  final driverPriceSuggestionSubject = BehaviorSubject<double>();
  final mapStyleSubject = BehaviorSubject<String>.seeded('');
  final currentLocationSubject = BehaviorSubject<LatLng?>();
  GoogleMapController? googleMapController;
  List<RideList> _filterRidesByAvailability(List<RideList>? rides) {
    if (rides == null) return [];
    return rides.where((ride) {
      final mode = (ride.serviceMode?.isNotEmpty ?? false)
          ? ride.serviceMode!
          : ServiceModeKind.modeForServiceId(ride.serviceId);
      return driverAcceptsRideServiceMode(
        mode,
        isEncomienda: ride.isEncomienda,
        isDelivery: ride.isDelivery,
      );
    }).toList();
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
        if (isApiStatus(context, response.status, message, true, showMess: false)) {
          List<RunningRides> runningRidesList = response.runningRides ?? [];
          putDataInSettingBox(hiveIsAutoSettle, response.isAutoSettle == 1);
          if (runningRidesList.isNotEmpty) {
            openScreenWithClearPrevious(
              context,
              DriverRunningRide(rideId: response.runningRides?.first.rideId ?? 0, serviceId: response.runningRides?.first.rideServiceCatId ?? ServiceType.taxi),
            );
          } else {
            callDriverHomeApi();
          }
        } else {
          callDriverHomeApi();
        }
      } catch (e) {
        callDriverHomeApi();
        debugPrint(e.toString());
      }
    }
  }

  Future<void> callDriverHomeApi() async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callDriverHomeApi();
      },
    )) {
      driverHomeSubject.add(ApiResponse.loading());
      try {
        if (versionName.trim().isEmpty) {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          versionName = packageInfo.version;
        }
        var response = DriverHomePojo.fromJson(
          await _repo.driverHomeApi(
            currentLat: (currentLaLng?.latitude ?? 0).toString(),
            currentLng: (currentLaLng?.longitude ?? 0).toString(),
            selectDistance: selectDistanceSubject.valueOrNull ?? 0,
            appVersion: versionName,
          ),
        );
        String message = getApiMsg(response.message);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, true)) {
          driverHomeSubject.add(ApiResponse.completed(response));
          selectDistanceSubject.sink.add(response.searchDistanceFilter);
          statusSwitchSubject.sink.add(response.driverCurrentStatus == 1 ? true : false);
          showHailRideSubject.sink.add(response.isHailRide == 1 ? true : false);
          putDataInSettingBox(hiveDriverCurrentStatus, response.driverCurrentStatus);
          putDataInSettingBox(hivePaymentTypeCash, response.cashPayment == 1);
          putDataInSettingBox(hivePaymentTypeWallet, response.walletPayment == 1);
          putDataInSettingBox(hivePaymentTypeOnline, response.onlinePayment == 1);
          putDataInSettingBox(hiveServiceId, response.serviceId);
          persistDriverAvailabilityModes(
            response.acceptTransport == 1,
            response.acceptDelivery == 1,
          );
          changeDriverStatus(response.driverCurrentStatus == 1);
        } else {
          driverHomeSubject.add(ApiResponse.error(message));
        }
      } catch (e) {
        driverHomeSubject.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> callAvailableRideApi({bool isLoading = true}) async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callAvailableRideApi();
      },
    )) {
      if (isLoading) {
        availableRideSubject.add(ApiResponse.loading());
      }
      try {
        var response = AvailableRidePojo.fromJson(
          await _repo.availableRideRequestApi(
            currentLat: currentLaLng?.latitude,
            currentLng: currentLaLng?.longitude,
          ),
        );
        String message = getApiMsg(response.message);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, true)) {
          availableRideSubject.add(ApiResponse.completed(response));
          nearestDistance = response.nearestRidePopup;
          driverPriceSuggestionSubject.sink.add(getDoubleFromDynamic(response.driverPriceSuggestion));
          rideList = [];
          rideList.addAll(_filterRidesByAvailability(response.rideList));
          final selected = selectedDriverRideSubject.valueOrNull;
          if (selected != null) {
            final idx = rideList.indexWhere((e) => e.rideId == selected.rideId);
            selectedDriverRideSubject.sink.add(idx >= 0 ? rideList[idx] : null);
          }
          if (rideList.isNotEmpty) {
            RideList? rideListItem = rideListItemSubject.valueOrNull;
            if (rideListItem != null) {
              int index = rideList.indexWhere((element) => element.rideId == rideListItem.rideId);
              if (index >= 0) {
                rideListItemSubject.sink.add(rideList[index]);
              }
            }
          }
          checkBottomSheetOpenAvailable();
          startTimer();
        } else {
          stopTimer();
          availableRideSubject.add(ApiResponse.error(message));
        }
      } catch (e) {
        stopTimer();
        availableRideSubject.add(ApiResponse.error(e.toString()));
      }
    } else {
      stopTimer();
    }
  }

  Future<void> callUpdateCurrentStatusApi({required int updateStatus}) async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callUpdateCurrentStatusApi(updateStatus: updateStatus);
      },
    )) {
      currentStatusSubject.sink.add(ApiResponse.loading());
      try {
        var response = UpdateCurrentStatusPojo.fromJson(await _repo.updateCurrentStatusApi(updateStatus: updateStatus));
        String message = getApiMsg(response.message);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status, message, false, messageCode: response.messageCode, hideMessOnCodeList: [339, 370, 342])) {
          currentStatusSubject.sink.add(ApiResponse.completed(response));
          putDataInSettingBox(hiveDriverCurrentStatus, response.driverCurrentStatus);
          changeDriverStatus(response.driverCurrentStatus != 0);
        } else {
          if (response.messageCode == minAmountMessageCode) {
            openWalletBottomSheet(message: response.message);
          }
          putDataInSettingBox(hiveDriverCurrentStatus, 0);
          changeDriverStatus(false);
          if (response.isDocumentPending == 1 || response.isDocumentExpired == 1) {
            openBottomSheetUploadDocuments(message: response.message);
          }
          currentStatusSubject.sink.add(ApiResponse.error(message));
        }
        putDataInSettingBox(hiveBgLocationData, "");
        putDataInSettingBox(hiveBgLocationTime, "");
      } catch (e) {
        currentStatusSubject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> _syncDriverLocationToServer(double lat, double lng) async {
    currentLaLng = LatLng(lat, lng);
    currentLocationSubject.add(currentLaLng);
    try {
      await _repo.updateCurrentLatLongApi(currentLat: lat, currentLong: lng);
    } catch (e) {
      debugPrint('syncDriverLocationToServer: $e');
    }
  }

  Future<void> changeDriverStatus(bool currentStatus) async {
    debugPrint("changeDriverStatus 1: $currentStatus");
    if (isEmailOrNumNull() && currentStatus) {
      callUpdateCurrentStatusApi(updateStatus: 0);
    } else {
      debugPrint("changeDriverStatus 2: $currentStatus");
      statusSwitchSubject.sink.add(currentStatus);
      if (currentStatus) {
        final loc = currentLaLng;
        if (loc != null) {
          await _syncDriverLocationToServer(loc.latitude, loc.longitude);
        }
        backgroundLocationService.onStart();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          callAvailableRideApi(isLoading: true);
        });
        startTimer();
        if (!(await WakelockPlus.enabled)) {
          WakelockPlus.enable();
        }
      } else {
        backgroundLocationService.onStop();
        stopTimer();
        if (await WakelockPlus.enabled) {
          WakelockPlus.disable();
        }
      }
    }
  }

  bool _regionPromptInFlight = false;

  Future<void> _maybePromptRegionChange(double lat, double lng) async {
    if (_regionPromptInFlight || !context.mounted) return;
    _regionPromptInFlight = true;
    await handleRegionPromptIfNeeded(
      context,
      lat,
      lng,
      onRegionApplied: (_) {},
    );
    _regionPromptInFlight = false;
  }

  Future<void> getCurrentLocation() async {
    mapStyleSubject.add(getCurrentTheme(context).mapStyle);
    getLocationUtils.getLocationUtils(
      (locationData) async {
        await _maybePromptRegionChange(locationData.latitude, locationData.longitude);
        await _syncDriverLocationToServer(locationData.latitude, locationData.longitude);
        if (googleMapController != null) {
          googleMapController!.animateCamera(
            CameraUpdate.newLatLngZoom(currentLaLng!, 15),
          );
        }
        if (iFromLogin) {
          callDriverRunningServiceApi();
        } else {
          callDriverHomeApi();
        }
      },
      (locationData, address) {},
      onPermissionReq: () {
        backgroundLocationService.checkAllLocationPermission();
      },
      getForceFully: true,
      isGetAddress: true,
    );
  }

  void checkBottomSheetOpenAvailable() {
    if (rideList.isNotEmpty && rideIdList.isNotEmpty) {
      if (!isBottomSheetOpen) {
        RideList? rideListItem;
        for (var myRideListItem in rideList) {
          if (rideListItem == null) {
            if (getDoubleFromDynamic(myRideListItem.distance ?? 0) <= getDoubleFromDynamic(nearestDistance) && rideIdList.contains(myRideListItem.rideId)) {
              rideListItem = myRideListItem;
            }
          }
        }
        if (rideListItem != null && (getDoubleFromDynamic(rideListItem.distance ?? 0) <= getDoubleFromDynamic(nearestDistance)) && !isWaitingOpen) {
          if (acceptRequestContext != null) {
            Navigator.pop(acceptRequestContext!);
            isBottomSheetOpen = false;
            acceptRequestContext = null;
          }
          if (rideIdList.contains(rideListItem.rideId)) {
            rideIdList.remove(rideListItem.rideId);
          }
          rideListItemSubject.sink.add(rideListItem);
          openAcceptRequestBottomSheet(rideListItem: rideListItem, isNearestRide: true);
        }
      }
    }
  }

  void openManageDistanceBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        manageDistanceContext = context;
        return ManageDistanceBottomSheet(
          searchRadiusList: (driverHomeSubject.valueOrNull?.data?.searchRadius ?? []),
          searchDistanceFilter: driverHomeSubject.valueOrNull?.data?.searchDistanceFilter ?? 0,
          onApply: (selectedDistance) {
            selectDistanceSubject.sink.add(selectedDistance);
            callDriverHomeApi();
          },
          onReset: (selectedDistance) {
            selectDistanceSubject.sink.add(selectedDistance);
            callDriverHomeApi();
          },
        );
      },
    );
  }

  void openAcceptRequestBottomSheet({required RideList rideListItem, bool isNearestRide = false}) {
    if (!isBottomSheetOpen && acceptRequestContext == null) {
      unawaited(triggerRideAlertFeedback());
      isBottomSheetOpen = true;
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (context) {
          acceptRequestContext = context;
          return StreamBuilder<RideList?>(
            stream: rideListItemSubject,
            builder: (context, snapRideListItem) {
              if (snapRideListItem.data != null) {
                debugPrint("snap ride: ${snapRideListItem.data?.offeredPrice ?? 0}");
                return AcceptRequestBottomSheet(
                  rideListItem: snapRideListItem.data!,
                  isNearestRide: isNearestRide,
                  rideIdList: rideIdList,
                  offerRateAmount: driverPriceSuggestionSubject.valueOrNull ?? 0,
                );
              }
              return Container();
            },
          );
        },
      ).then((value) {
        isBottomSheetOpen = false;
        acceptRequestContext = null;
        rideListItemSubject.sink.add(null);
        checkBottomSheetOpenAvailable();
      });
    }
  }

  Future<void> openOverlayPermissionBottomSheet() async {
    Future.delayed(const Duration(seconds: 1), () {
      if (!context.mounted) return;
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        builder: (BuildContext context) {
          overlayPermissionContext = context;
          return const OverlayPermissionBottomSheet();
        },
      );
    });
  }

  Future openWalletBottomSheet({required String message}) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        walletBottomSheet = context;
        return CommonBottomSheet(
          title: message,
          positiveButtonTxt: languages.ok,
          onPositivePress: () {
            if (!context.mounted) return;
            Navigator.pop(context);
            openScreen(context, const WalletHome());
          },
        );
      },
    );
  }

  void openBottomSheetUploadDocuments({required String message}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return CommonBottomSheet(
          title: languages.uploadDocument,
          message: message,
          positiveButtonTxt: languages.uploadDocument,
          onPositivePress: () {
            Navigator.pop(context);
            openScreen(context, const RequireDocumentScreen(isFromHomeScreen: true));
          },
        );
      },
    );
  }

  void startTimer() {
    if (_availableApiTimer?.isActive ?? false) return;
    _availableApiTimer = Timer.periodic(DispatchTriggerService.fastPollInterval, (timer) {
      if (DispatchTriggerService.shouldSkipScheduledPoll('refresh_available_rides')) {
        return;
      }
      callAvailableRideApi(isLoading: false);
    });
  }

  void stopTimer() {
    if (_availableApiTimer != null && _availableApiTimer!.isActive) {
      _availableApiTimer!.cancel();
      _availableApiTimer = null;
    }
  }

  void manageNotification() {
    firebaseOnMessageStream ??= FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      Map<String, dynamic> notificationData = message.data;
      DispatchTriggerService.recordFromNotificationData(notificationData);
      int notificationType = int.parse((notificationData[NotificationConstant.notificationType] ?? 0).toString());
      int orderId = int.parse((notificationData[NotificationConstant.rideId] ?? 0).toString());
      if (notificationType == 7) {
        rideIdList.add(orderId);
        unawaited(triggerRideAlertFeedback());
        DispatchTriggerService.recordManualRefresh('refresh_available_rides');
        callAvailableRideApi(isLoading: false);
        pushNotificationService.dismissRideNotification(orderId);
      } else if (notificationType == 9 && !isWaitingOpen) {
        pushNotificationService.dismissRideNotification(orderId);
        DispatchTriggerService.recordManualRefresh('refresh_available_rides');
        callAvailableRideApi(isLoading: false);
        String name = (notificationData[NotificationConstant.customerName] ?? "").toString();
        if (context.mounted) {
          openSimpleSnackbar(context, languages.changeRideFare(name));
        }
      }
    });
  }

  void onDriverMapCreated(GoogleMapController controller) {
    googleMapController = controller;
    final loc = currentLaLng;
    if (loc != null) {
      controller.animateCamera(CameraUpdate.newLatLngZoom(loc, 15));
    }
  }

  @override
  void dispose() {
    googleMapController?.dispose();
    stopTimer();
    selectedDriverRideSubject.close();
    availableRideSubject.close();
    driverHomeSubject.close();
    selectDistanceSubject.close();
    currentStatusSubject.close();
    statusSwitchSubject.close();
    rideListItemSubject.close();
    showHailRideSubject.close();
    driverPriceSuggestionSubject.close();
    mapStyleSubject.close();
    currentLocationSubject.close();
  }
}
