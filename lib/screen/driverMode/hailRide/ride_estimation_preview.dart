import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../blocs/bloc.dart';
import '../../../commonView/child_size_notifier.dart';
import '../../../commonView/common_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/dash_line_view.dart';
import '../../../commonView/ride_detail_item.dart';
import '../../../utils/utils.dart';
import '../../passengerMode/passengerHome/passenger_home_dl.dart';
import 'hail_ride_dl.dart';
import 'ride_estimation_bloc.dart';

class RideEstimationPreview extends StatefulWidget {
  final List<SearchedLocation> addressList;
  final double offerPrice, distance;
  final int time;
  final String customerName, customerNumber;

  const RideEstimationPreview({
    super.key,
    required this.addressList,
    required this.offerPrice,
    required this.distance,
    required this.time,
    required this.customerName,
    required this.customerNumber,
  });

  @override
  State<RideEstimationPreview> createState() => _RideEstimationPreviewState();
}

class _RideEstimationPreviewState extends State<RideEstimationPreview> {
  RideEstimationBloc? _bloc;

  @override
  void didChangeDependencies() {
    _bloc ??= RideEstimationBloc(
      context,
      addressList: widget.addressList,
      offerPrice: widget.offerPrice,
      distance: widget.distance,
      time: widget.time,
      customerName: widget.customerName,
      customerNumber: widget.customerNumber,
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      appBar: CommonAppBar(
        leading: backButtonForAppBarCustom(
          context: context,
          onBackPress: () {
            Navigator.pop(context);
          },
        ),
        title: Text(languages.rideEstimation, style: toolbarStyle(context: context)),
        centerTitle: true,
      ),
      body: _buildRideEstimationPreview(),
    );
  }

  Widget _buildRideEstimationPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: 20.h, top: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [distanceTimeAndPrice(), SizedBox(height: 15.h), _picUpDropLocationView(), _buildRideDetailsView()],
            ),
          ),
        ),
        _actionButtons(),
      ],
    );
  }

  Widget distanceTimeAndPrice() {
    return Row(
      children: [
        Container(
          padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, top: 8.h, bottom: 8.h),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(17.5.r), border: Border.all(color: getCurrentTheme(context).colorBorder, width: 0.5.w)),
          child: Row(
            children: [
              Icon(CustomIcons.locationTime, size: 20.sp, color: getCurrentTheme(context).colorIconCommon),
              SizedBox(width: 5.w),
              Text(
                "${widget.time} ${languages.min}, ${widget.distance} ${languages.km}",
                style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize14px),
              ),
            ],
          ),
        ),
        Expanded(child: Container()),
        Text(
          getAmountWithCurrency(widget.offerPrice),
          style: bodyText(context: context, fontSize: textSize18px, fontWeight: FontWeight.w600, textColor: getCurrentTheme(context).colorPrimary),
        ),
      ],
    );
  }

  Widget _picUpDropLocationView() {
    return ChildSizeNotifier(
      builder: (context, size, child) {
        return Container(
          padding: EdgeInsetsDirectional.only(bottom: 20.h),
          child: Stack(
            children: [
              Container(
                alignment: AlignmentDirectional.topStart,
                margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 11.w),
                child: DashLineView(
                  dashColor: getCurrentTheme(context).colorBorder,
                  totalHeight: size.height / 3,
                  dashHeight: 5.h,
                  dashWidth: 1.5.w,
                  emptyHeight: 4.h,
                ),
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.addressList.length,
                padding: EdgeInsetsDirectional.zero,
                separatorBuilder: (context, index) {
                  return Container(height: 15.h);
                },
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Container(
                        color: getCurrentTheme(context).colorScaffoldBg,
                        padding: EdgeInsetsDirectional.all(2.sp),
                        margin: EdgeInsetsDirectional.only(end: 10.w),
                        child: Icon(
                          index == 0
                              ? CustomIcons.pickupLocation
                              : index == widget.addressList.length - 1
                              ? CustomIcons.dropLocation
                              : CustomIcons.stopPoint,
                          size: 20.sp,
                          color: getCurrentTheme(context).colorIconCommon,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.addressList[index].name ?? "-",
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: bodyText(context: context).copyWith(height: 0),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRideDetailsView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsetsDirectional.only(bottom: 15.h),
          child: Text(languages.rideDetail, textAlign: TextAlign.start, maxLines: 1, overflow: TextOverflow.ellipsis, style: toolbarStyle(context: context)),
        ),

        RideDetailItem(
          iconData: CustomIcons.rideDatetime,
          titleText: languages.rideDateTime,
          mainText: getDateTimeWithoutTimezoneFromObj(DateTime.now(), returnFormat: "dd MMM, yyyy hh:mm aa"),
        ),
        RideDetailItem(iconData: CustomIcons.name, titleText: "${languages.customerName} :", mainText: widget.customerName),
        RideDetailItem(iconData: CustomIcons.call, titleText: "${languages.customerNumber} :", mainText: widget.customerNumber),
        RideDetailItem(iconData: CustomIcons.paymentMethod, titleText: languages.paymentMethod, mainText: getPaymentType(paymentType: PaymentType.cash)),
        RideDetailItem(iconData: CustomIcons.paymentStatus, titleText: languages.paymentStatus, mainText: languages.pending),
      ],
    );
  }

  Widget _actionButtons() {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: getBottomMargin()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: CustomRoundedButton(context, languages.cancel, () {
              Navigator.pop(context);
            }, setBorder: true),
          ),
          SizedBox(width: 25.w),
          Expanded(
            child: StreamBuilder<ApiResponse<HailRideBookingPojo>>(
              stream: _bloc?.subject,
              builder: (context, snapLoad) {
                bool isLoading = snapLoad.data?.status == Status.loading;
                return CustomRoundedButton(
                  context,
                  languages.confirm,
                  isLoading
                      ? null
                      : () {
                        _bloc?.rideBookApiCall();
                      },
                  setProgress: isLoading,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
