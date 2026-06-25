import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../blocs/bloc.dart';
import '../../../commonView/image_selection.dart';
import '../../../hive/hive_helper.dart';
import '../../../utils/utils.dart';
import '../../../utils/xisti_vehicle_catalog.dart';
import '../driverDocumentScreen/require_document_screen.dart';
import 'driver_vehicle_details_dl.dart';
import 'driver_vehicle_details_repo.dart';

class DriverVehicleDetailsBloc extends Bloc {
  BuildContext context;
  LatLng? currentLatLng;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<ServiceList> serviceList = [];
  VehicleDetailsPojo? oldVehicleDetailsPojo;

  final DriverVehicleDetailsRepo _repo = DriverVehicleDetailsRepo();

  DriverVehicleDetailsBloc(this.context) {
    callVehicleServiceListApi();
    getCurrentLocation();
  }

  final driverVehicleListSubject = BehaviorSubject<ApiResponse<DriverVehicleListPojo>>();
  final subjectGetVehicleDetails = BehaviorSubject<ApiResponse<VehicleDetailsPojo>>();
  final subjectUploadVehicleDetails = BehaviorSubject<ApiResponse<UploadVehiclePojo>>();

  final serviceTypeSelection = BehaviorSubject<ServiceList>();
  final vehicleTypeSelection = BehaviorSubject<VehicleTypeList?>();
  final vehicleYearSelection = BehaviorSubject<String?>();

  final childSafetyController = BehaviorSubject<bool>.seeded(false);
  final isTaxiController = BehaviorSubject<bool>.seeded(false);
  final handyCapAccessibilityController = BehaviorSubject<bool>.seeded(false);
  final alsoTransportPassengersController = BehaviorSubject<bool>.seeded(false);

  final vehicleImageFrontFile = BehaviorSubject<File?>();
  final vehicleImageSideFile = BehaviorSubject<File?>();
  final vehicleImageRearFile = BehaviorSubject<File?>();
  final vehicleImageFrontUrl = BehaviorSubject<String>();
  final vehicleImageSideUrl = BehaviorSubject<String>();
  final vehicleImageRearUrl = BehaviorSubject<String>();

  final manufactureNameTEC = TextEditingController();
  final modelNameTEC = TextEditingController();
  final vehiclePlateNumberTEC = TextEditingController();
  final vehicleColorTEC = TextEditingController();
  final vehicleYearTEC = TextEditingController();
  final vehicleTypeTEC = TextEditingController();
  final technicalInspectionExpiryTEC = TextEditingController();
  DateTime? technicalInspectionExpiryDate;

  Future<void> addVehiclePhoto(BehaviorSubject<File?> target) async {
    selectImgFromCameraOrGallery(context, (file) async {
      if (file.path.isNotEmpty) {
        target.sink.add(await compressImage(file));
      }
    });
  }

  bool _hasVehiclePhoto(BehaviorSubject<File?> file, BehaviorSubject<String> url) {
    return (file.valueOrNull?.path ?? '').isNotEmpty || (url.valueOrNull ?? '').isNotEmpty;
  }

  Future<void> callVehicleServiceListApi() async {
    if (await isNetworkConnected(onRetryPressedCallApi: () => callVehicleServiceListApi())) {
      driverVehicleListSubject.sink.add(ApiResponse.loading());
      subjectGetVehicleDetails.sink.add(ApiResponse.loading());
      try {
        var response = DriverVehicleListPojo.fromJson(await _repo.vehicleServiceListApi());

        if (!context.mounted) return;
        String message = getApiMsg(response.message);
        if (isApiStatus(context, response.status, message, true)) {
          serviceList = XistiVehicleCatalog.mergeDriverTransportRegistrationApi(response.serviceList);
          if (serviceList.isNotEmpty) {
            serviceTypeSelection.sink.add(serviceList.first);
          }
          getVehicleDetailApi();
          driverVehicleListSubject.sink.add(ApiResponse.completed(response));
        } else {
          subjectGetVehicleDetails.sink.add(ApiResponse.error());
          driverVehicleListSubject.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        debugPrint(e.toString());
        subjectGetVehicleDetails.sink.add(ApiResponse.error());
        driverVehicleListSubject.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> getVehicleDetailApi() async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        getVehicleDetailApi();
      },
    )) {
      subjectGetVehicleDetails.sink.add(ApiResponse.loading());
      try {
        var response = VehicleDetailsPojo.fromJson(await _repo.getVehicleDetailApi());

        if (!context.mounted) return;
        String message = getApiMsg(response.message);
        if (isApiStatus(context, response.status, message, true, messageCode: response.messageCode, hideMessOnCodeList: [15])) {
          oldVehicleDetailsPojo = response;
          setVehicleDetails(response);
          subjectGetVehicleDetails.sink.add(ApiResponse.completed(response));
        } else {
          subjectGetVehicleDetails.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        debugPrint(e.toString());
        subjectGetVehicleDetails.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> uploadVehicleData() async {
    if ((vehicleTypeSelection.valueOrNull?.vehicleTypeId ?? 0) == 0) {
      openSimpleSnackbar(context, languages.selectVehicle);
      return;
    }
    if ((vehicleYearSelection.valueOrNull ?? "").isEmpty) {
      openSimpleSnackbar(context, languages.selectVehicleYear);
      return;
    }
    if (!_hasVehiclePhoto(vehicleImageFrontFile, vehicleImageFrontUrl) ||
        !_hasVehiclePhoto(vehicleImageSideFile, vehicleImageSideUrl) ||
        !_hasVehiclePhoto(vehicleImageRearFile, vehicleImageRearUrl)) {
      openSimpleSnackbar(context, 'Sube las fotos frontal, lateral y trasera del vehículo.');
      return;
    }
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        uploadVehicleData();
      },
    )) {
      MultipartFile? multipartFront;
      MultipartFile? multipartSide;
      MultipartFile? multipartRear;
      final frontFile = vehicleImageFrontFile.valueOrNull;
      final sideFile = vehicleImageSideFile.valueOrNull;
      final rearFile = vehicleImageRearFile.valueOrNull;
      if (frontFile != null) {
        multipartFront = MultipartFile.fromFileSync(frontFile.path, filename: frontFile.path.split('/').last);
      }
      if (sideFile != null) {
        multipartSide = MultipartFile.fromFileSync(sideFile.path, filename: sideFile.path.split('/').last);
      }
      if (rearFile != null) {
        multipartRear = MultipartFile.fromFileSync(rearFile.path, filename: rearFile.path.split('/').last);
      }
      subjectUploadVehicleDetails.sink.add(ApiResponse.loading());
      try {
        var response = UploadVehiclePojo.fromJson(
          await _repo.callServiceRegisterApi(
            manufactureName: manufactureNameTEC.text,
            modelName: modelNameTEC.text,
            modelYear: vehicleYearSelection.valueOrNull ?? yearPickerList().last,
            vehicleColor: vehicleColorTEC.text.trim(),
            vehiclePlatNo: vehiclePlateNumberTEC.text,
            vehicleTypeId: vehicleTypeSelection.valueOrNull == null ? 0 : vehicleTypeSelection.valueOrNull?.vehicleTypeId ?? 0,
            serviceTypeId: serviceTypeSelection.valueOrNull == null ? 0 : serviceTypeSelection.valueOrNull?.serviceId ?? 0,
            childSeat: _carTransportExtrasEnabled()
                ? ((childSafetyController.valueOrNull ?? false) ? 1 : 0)
                : 0,
            handyCapAccess: _carTransportExtrasEnabled()
                ? ((handyCapAccessibilityController.valueOrNull ?? false) ? 1 : 0)
                : 0,
            isTaxi: XistiVehicleCatalog.showTaxiOptionForVariant(serviceTypeSelection.valueOrNull?.deliveryVariant) &&
                    (isTaxiController.valueOrNull ?? false)
                ? 1
                : 0,
            acceptDelivery: serviceTypeSelection.valueOrNull?.isDeliveryOnlyService == true ? 1 : 1,
            deliveryVariant: _deliveryVariantForApi(serviceTypeSelection.valueOrNull),
            alsoTransportPassengers: (alsoTransportPassengersController.valueOrNull ?? false) ? 1 : 0,
            currentLat: currentLatLng?.latitude,
            currentLong: currentLatLng?.longitude,
            vehicleImageFront: multipartFront,
            vehicleImageSide: multipartSide,
            vehicleImageRear: multipartRear,
            technicalInspectionExpiry: _requiresTechnicalInspection() && technicalInspectionExpiryTEC.text.trim().isNotEmpty
                ? convertTimeToServerTime(technicalInspectionExpiryDate ?? DateTime.now(), onlyDate: true)
                : null,
            progress: (double progress) {
              subjectUploadVehicleDetails.sink.add(ApiResponse.loading(progress: progress));
            },
          ),
        );

        if (!context.mounted) return;
        final message = getApiMsg(response.message, response.messageCode);
        if (isApiStatus(context, response.status, message, true, messageCode: response.messageCode ?? 0)) {
          putDataInSettingBox(hiveDriverType, response.isDriverType ?? 0);
          putDataInSettingBox(hiveVehicleStatus, response.driverVehicleStatus ?? 0);
          putDataInSettingBox(hiveDocumentStatus, response.driverDocStatus ?? 0);
          subjectUploadVehicleDetails.sink.add(ApiResponse.completed(response));
          openSimpleSnackbar(context, languages.vehicleDetailsUploadedSuccessfully);
          if ((response.driverDocStatus ?? 0) != 1) {
            openScreen(context, const RequireDocumentScreen());
          } else {
            getVehicleDetailApi();
          }
        } else {
          subjectUploadVehicleDetails.sink.add(ApiResponse.error(message));
          if (response.status != 3) openSimpleSnackbar(context, message);
        }
      } catch (e) {
        subjectUploadVehicleDetails.sink.add(ApiResponse.error('Ocurrió un error. Inténtalo de nuevo.'));
      }
    }
  }

  bool _passengerExtrasEnabled() {
    final service = serviceTypeSelection.valueOrNull;
    return (service?.supportsPassengerTransportToggle ?? false) &&
        (alsoTransportPassengersController.valueOrNull ?? false);
  }

  bool _carTransportExtrasEnabled() {
    final service = serviceTypeSelection.valueOrNull;
    if (service == null) {
      return false;
    }
    if (service.serviceId == ServiceType.taxi) {
      return true;
    }
    return _passengerExtrasEnabled();
  }

  String? _deliveryVariantForApi(ServiceList? service) {
    if (service == null) {
      return null;
    }
    final variant = service.deliveryVariant.trim();
    if (variant.isEmpty) {
      return null;
    }
    return variant;
  }

  void setVehicleDetails(VehicleDetailsPojo vehicleDetailsPojo) {
    if (serviceList.isNotEmpty) {
      ServiceList serviceListItem = serviceList.firstWhere(
        (service) => service.serviceId == vehicleDetailsPojo.serviceId && !service.isDeliveryOnlyService,
        orElse: () => serviceList.firstWhere(
          (service) => service.serviceId == vehicleDetailsPojo.serviceId,
          orElse: () => serviceList.first,
        ),
      );
      serviceTypeSelection.sink.add(serviceListItem);
      List<VehicleTypeList> vehicleList = serviceListItem.vehicleTypeList;
      VehicleTypeList? vehicleTypeList;
      if (vehicleList.isNotEmpty) {
        vehicleTypeList = vehicleList.firstWhere(
          (vehicle) {
            return vehicle.vehicleTypeId == vehicleDetailsPojo.vehicleTypeId;
          },
          orElse: () {
            return vehicleList.first;
          },
        );
      }
      setSelectedVehicleType(vehicleTypeList);
    }

    manufactureNameTEC.text = vehicleDetailsPojo.manufactureName;
    modelNameTEC.text = vehicleDetailsPojo.modelName;

    String year = DateTime.now().year.toString();
    yearPickerList().forEach((e) {
      if (int.parse(e) == vehicleDetailsPojo.modelYear) {
        year = vehicleDetailsPojo.modelYear.toString();
      }
    });
    setSelectedVehicleYear(year);
    vehiclePlateNumberTEC.text = vehicleDetailsPojo.vehiclePlatNo;
    vehicleColorTEC.text = vehicleDetailsPojo.vehicleColor;
    if (vehicleDetailsPojo.technicalInspectionExpiry.trim().isNotEmpty) {
      technicalInspectionExpiryTEC.text = getDateTime(vehicleDetailsPojo.technicalInspectionExpiry, format: 'yyyy-MM-dd', showOnlyDate: true);
      try {
        technicalInspectionExpiryDate = DateTime.parse(vehicleDetailsPojo.technicalInspectionExpiry);
      } catch (_) {}
    }
    vehicleImageFrontUrl.sink.add(vehicleDetailsPojo.vehicleImageFront);
    vehicleImageSideUrl.sink.add(vehicleDetailsPojo.vehicleImageSide);
    vehicleImageRearUrl.sink.add(vehicleDetailsPojo.vehicleImageRear);
    vehicleImageFrontFile.sink.add(null);
    vehicleImageSideFile.sink.add(null);
    vehicleImageRearFile.sink.add(null);

    childSafetyController.sink.add(vehicleDetailsPojo.childSafetySeat == 1);
    handyCapAccessibilityController.sink.add(vehicleDetailsPojo.handyCapSeat == 1);
  }

  void setSelectedVehicleType(VehicleTypeList? vehicleTypeList) {
    vehicleTypeSelection.sink.add(vehicleTypeList);
    vehicleTypeTEC.text = vehicleTypeList?.vehicleTypeName ?? "";
  }

  void setSelectedVehicleYear(String? year) {
    vehicleYearSelection.sink.add(year);
    vehicleYearTEC.text = year ?? "";
  }

  bool _requiresTechnicalInspection() {
    final service = serviceTypeSelection.valueOrNull;
    return service?.requiresTechnicalInspection == true || service?.serviceId == ServiceType.taxi;
  }

  Future<void> selectTechnicalInspectionExpiry() async {
    selectDocumentExpiryDate(context, initialDate: technicalInspectionExpiryDate).then((date) {
      if (date != null) {
        technicalInspectionExpiryDate = date;
        technicalInspectionExpiryTEC.text = getDateTimeWithoutTimezoneFromObj(date, showOnlyDate: true);
      }
    });
  }

  void serviceSelect(int position, {bool isResetData = false}) {
    final selected = serviceList[position];
    if (oldVehicleDetailsPojo != null &&
        oldVehicleDetailsPojo?.serviceId == selected.serviceId &&
        !selected.isDeliveryOnlyService) {
      setVehicleDetails(oldVehicleDetailsPojo!);
    } else if (isResetData) {
      resetData();
    }
  }

  void resetData() {
    setSelectedVehicleType(null);
    manufactureNameTEC.text = "";
    modelNameTEC.text = "";
    setSelectedVehicleYear(null);
    vehiclePlateNumberTEC.text = "";
    vehicleColorTEC.text = "";
    technicalInspectionExpiryTEC.text = "";
    technicalInspectionExpiryDate = null;
    modelNameTEC.text = "";
    vehicleImageFrontUrl.sink.add('');
    vehicleImageSideUrl.sink.add('');
    vehicleImageRearUrl.sink.add('');
    vehicleImageFrontFile.sink.add(null);
    vehicleImageSideFile.sink.add(null);
    vehicleImageRearFile.sink.add(null);
    childSafetyController.sink.add(false);
    handyCapAccessibilityController.sink.add(false);
    alsoTransportPassengersController.sink.add(false);
    isTaxiController.sink.add(false);
    formKey = GlobalKey<FormState>();
  }

  Future<void> getCurrentLocation() async {
    getLocationUtils.getLocationUtils((locationData) {
      currentLatLng = LatLng(locationData.latitude, locationData.longitude);
    }, (l, address) {}, getForceFully: false, isGetAddress: false);
  }

  @override
  void dispose() {
    driverVehicleListSubject.close();
    subjectGetVehicleDetails.close();
    serviceTypeSelection.close();
    vehicleTypeSelection.close();
    vehicleYearSelection.close();
    childSafetyController.close();
    isTaxiController.close();
    handyCapAccessibilityController.close();
    alsoTransportPassengersController.close();
    vehicleImageFrontFile.close();
    vehicleImageSideFile.close();
    vehicleImageRearFile.close();
    vehicleImageFrontUrl.close();
    vehicleImageSideUrl.close();
    vehicleImageRearUrl.close();
    manufactureNameTEC.dispose();
    modelNameTEC.dispose();
    vehiclePlateNumberTEC.dispose();
    vehicleColorTEC.dispose();
    vehicleYearTEC.dispose();
    technicalInspectionExpiryTEC.dispose();
    vehicleTypeTEC.dispose();
  }
}
