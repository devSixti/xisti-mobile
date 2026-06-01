import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../blocs/bloc.dart';
import '../../../bottomSheet/cancel_ride_bottom_sheet.dart';
import '../../../bottomSheet/invoice_detail_bottom_sheet.dart';
import '../../../networking/base_dl.dart';
import '../../../utils/map_curved_lines.dart';
import '../../../utils/invoice_util.dart';
import '../../../utils/utils.dart';
import '../driverRunningRide/driver_running_ride.dart';
import '../driverRunningRide/driver_running_ride_dl.dart';
import '../driverRunningRide/driver_running_ride_repo.dart';

class DriverRideDetailBloc extends Bloc {
  GoogleMapController? googleMapController;
  BuildContext context;
  List<AddressListItem> addressList = [];
  final DriverRunningRideRepo _runningRideRepo = DriverRunningRideRepo();
  int rideId;

  DriverRideDetailBloc(this.context, this.rideId) {
    subjectRideDetail.sink.add(ApiResponse.loading());
  }

  final mapStyle = BehaviorSubject<String>.seeded("");
  final subjectRideDetail = BehaviorSubject<ApiResponse<DriverRunningRidePojo>>();
  final markersListController = BehaviorSubject<List<Marker>>();
  final polyLineController = BehaviorSubject<Map<PolylineId, Polyline>>();
  final subjectCancelOrder = BehaviorSubject<ApiResponse<BaseModel>>();
  final subjectStartRide = BehaviorSubject<ApiResponse<BaseModel>>();

  Future<void> getRideDetailApi() async {
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        getRideDetailApi();
      },
    )) {
      subjectRideDetail.sink.add(ApiResponse.loading());
      try {
        var response = DriverRunningRidePojo.fromJson(await _runningRideRepo.getRideDetails(rideId));

        String message = getApiMsg(response.message);
        if (!context.mounted) return;
        if (isApiStatus(context, response.status ?? 0, message, true)) {
          subjectRideDetail.sink.add(ApiResponse.completed(response));
          addressList = response.rideDetails?.addressList ?? [];
          setMarkers();
        } else {
          subjectRideDetail.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        subjectRideDetail.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> callStartRideApi() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        callStartRideApi();
      },
    )) {
      subjectStartRide.sink.add(ApiResponse.loading());
      try {
        var response = BaseModel.fromJson(await _runningRideRepo.scheduleStartRideApi(rideId: rideId));

        if (!context.mounted) return;
        String message = getApiMsg(response.message);
        if (isApiStatus(context, response.status, message, true)) {
          subjectStartRide.sink.add(ApiResponse.completed(response));
          openScreenWithClearPrevious(
            context,
            DriverRunningRide(rideId: rideId, serviceId: subjectRideDetail.valueOrNull?.data?.rideDetails?.serviceId ?? ServiceType.taxi),
          );
        } else {
          subjectStartRide.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        debugPrint(e.toString());
        subjectStartRide.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> cancelOrderApi(String reason) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (await isNetworkConnected(
      onRetryPressedCallApi: () {
        cancelOrderApi(reason);
      },
    )) {
      subjectCancelOrder.sink.add(ApiResponse.loading());
      try {
        var response = BaseModel.fromJson(
          await _runningRideRepo.updateRideStatus(rideId: rideId, rideStatus: 4, cancelReason: reason, rating: 0, comment: "", otp: "", wayPointStatus: 0),
        );

        if (!context.mounted) return;
        String message = getApiMsg(response.message);
        if (isApiStatus(context, response.status, message, true)) {
          subjectCancelOrder.sink.add(ApiResponse.completed(response));
          getRideDetailApi();
        } else {
          subjectCancelOrder.sink.add(ApiResponse.error(message));
        }
      } catch (e) {
        debugPrint(e.toString());
        subjectCancelOrder.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  Future<void> onMapCreated(GoogleMapController googleMapController) async {
    this.googleMapController = googleMapController;
    getRideDetailApi();
  }

  Future<void> setMarkers() async {
    List<Marker> markerList = [];
    if ((addressList).isNotEmpty) {
      LatLng pickUpLatLng = LatLng(getDoubleFromDynamic(addressList.first.addressLat), getDoubleFromDynamic(addressList.first.addressLong));
      LatLng destinationLatLng = LatLng(getDoubleFromDynamic(addressList.last.addressLat), getDoubleFromDynamic(addressList.last.addressLong));

      BitmapDescriptor pickUpMarkerIcon = await getBitmapDescriptorFromAssetBytes(path: setImagesBasedOnTheme(context, 'ic_pin_pickup_location.png'));
      if (!context.mounted) return;
      BitmapDescriptor destinationMarkerIcon = await getBitmapDescriptorFromAssetBytes(path: setImagesBasedOnTheme(context, 'ic_pin_destination_location.png'));
      markerList.add(Marker(markerId: const MarkerId("PickUpMarker"), position: pickUpLatLng, icon: pickUpMarkerIcon, infoWindow: const InfoWindow(title: "")));
      markerList.add(
        Marker(
          markerId: const MarkerId("DestinationMarker"),
          position: destinationLatLng,
          icon: destinationMarkerIcon,
          infoWindow: const InfoWindow(title: ""),
        ),
      );
      markersListController.sink.add(markerList);
      Map<PolylineId, Polyline> polyLines = {};
      PolylineId id = const PolylineId("poly");
      if (!context.mounted) return;
      Polyline polyline = Polyline(
        polylineId: id,
        color: getCurrentTheme(context).colorBlack,
        points: MapsCurvedLines.getPointsOnCurve(pickUpLatLng, destinationLatLng),
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        width: 2.w.toInt(),
      );
      polyLines[id] = polyline;
      polyLineController.sink.add(polyLines);

      var lngs = markerList.map<double>((m) => m.position.longitude).toList();
      var lats = markerList.map<double>((m) => m.position.latitude).toList();

      setMapFitToTourUsingLatLng(latList: lats, longList: lngs, controller: googleMapController!, padding: 30.sp);
    }
  }

  void openInvoiceBottomSheet() {
    RideDetails? rideDetail = subjectRideDetail.valueOrNull?.data?.rideDetails;
    List<KeyValueModel> keyValuesList = [];
    setKeyValuePair(
      keyValuesList: keyValuesList,
      setDivider: false,
      setBold: false,
      setValueWithCurrency: true,
      key: languages.rideFare,
      value: "${rideDetail?.rideFare ?? "0"}",
    );
    appendDriverInvoiceDeductionLines(
      keyValuesList: keyValuesList,
      rideFare: rideDetail?.rideFare ?? "0",
      commissionAmount: rideDetail?.commissionAmount,
      vatOnCommission: rideDetail?.vatOnCommission,
      totalDeduction: rideDetail?.totalDeduction,
      netDriverPay: rideDetail?.netDriverPay,
    );
    setKeyValuePair(
      keyValuesList: keyValuesList,
      setDivider: false,
      setBold: false,
      setValueWithCurrency: true,
      key: languages.tollAmount,
      value: "${rideDetail?.tollCharge ?? "0"}",
    );
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
          child: InvoiceDetailBottomSheet(invoiceList: keyValuesList),
        );
      },
    );
  }

  void openCancelRideSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        return CancelRideBottomSheet(
          onSubmit: (cancelReason) {
            cancelOrderApi(cancelReason);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    mapStyle.close();
    subjectRideDetail.close();
    markersListController.close();
    polyLineController.close();
    subjectCancelOrder.close();
  }
}
