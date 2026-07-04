import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/delivery_request_badge.dart';
import '../../../commonView/load_image_with_placeholder.dart';
import '../../../commonView/ride_request_type_chip.dart';
import '../../../hive/hive_helper.dart';
import '../../../utils/destination_payment_util.dart';
import '../../../utils/offer_payment_icon.dart';
import '../../../utils/service_mode_util.dart';
import '../../../utils/utils.dart';
import 'driver_home_dl.dart';

/// Full ride breakdown for driver incoming requests (passenger, payment, route, extras).
class DriverRideRequestDetailPanel extends StatelessWidget {
  const DriverRideRequestDetailPanel({
    super.key,
    required this.ride,
    required this.onClearSelection,
    required this.onAcceptRide,
  });

  final RideList ride;
  final VoidCallback onClearSelection;
  final ValueChanged<RideList> onAcceptRide;

  static const double panelHeightFactor = 0.54;
  /// Space reserved bottom-right for the hail FAB (person with suitcase).
  static double hailFabReserve(BuildContext context) => 56.w + commonHorizontalPadding;

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);
    final isSpanish = getLanguageFromUserPrefBox().startsWith('es');
    final paymentLabel = _paymentLabel(isSpanish);
    final isDelivery = ServiceModeKind.isDeliveryRideRequest(
      serviceId: ride.serviceId,
      isDelivery: ride.isDelivery,
      itemDescription: ride.itemDescription,
      recipientName: ride.recipientName,
    );

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * panelHeightFactor),
      decoration: BoxDecoration(
        color: theme.colorScaffoldBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.45), blurRadius: 20, offset: const Offset(0, -6)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: onClearSelection,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsetsDirectional.only(top: 10.h, bottom: 6.h),
              child: Column(
                children: [
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(99.r)),
                  ),
                  SizedBox(height: 4.h),
                  Icon(Icons.keyboard_arrow_down_rounded, size: 20.sp, color: Colors.white.withValues(alpha: 0.35)),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(commonHorizontalPadding, 0, commonHorizontalPadding, 10.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    languages.rideDetail,
                    style: bodyText(context: context, fontWeight: FontWeight.w800, fontSize: textSize18px, textColor: Colors.white),
                  ),
                ),
                RideRequestTypeChip(
                  serviceId: ride.serviceId,
                  serviceMode: ride.serviceMode,
                  isDelivery: ride.isDelivery,
                  isEncomienda: ride.isEncomienda,
                  serviceName: ride.serviceName,
                  vehicleVariant: ride.vehicleVariant,
                  isTaxi: ride.isTaxi,
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.fromSTEB(commonHorizontalPadding, 0, commonHorizontalPadding, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _passengerCard(context),
                  SizedBox(height: 14.h),
                  _metricsRow(context),
                  SizedBox(height: 14.h),
                  _farePaymentCard(context, paymentLabel),
                  if (ride.scheduleDate.isNotEmpty && ride.rideType == 1) ...[
                    SizedBox(height: 12.h),
                    _infoTile(
                      context,
                      icon: CustomIcons.scheduleRide,
                      label: languages.schedule,
                      value: getDateTime(ride.scheduleDate, returnFormat: 'dd MMM, yyyy hh:mm aa'),
                    ),
                  ],
                  SizedBox(height: 14.h),
                  _sectionTitle(context, languages.pickUpLocation),
                  ..._addressSections(context),
                  if (isDelivery && (ride.itemDescription.isNotEmpty || ride.recipientName.isNotEmpty)) ...[
                    SizedBox(height: 14.h),
                    _sectionTitle(context, languages.itemDesc),
                    if (ride.itemDescription.isNotEmpty)
                      _infoTile(context, icon: CustomIcons.manageInformation, label: languages.itemDesc, value: ride.itemDescription),
                    if (ride.recipientName.isNotEmpty)
                      _infoTile(context, icon: CustomIcons.name, label: languages.recipientName, value: ride.recipientName),
                    if (ride.recipientContactNumber.isNotEmpty)
                      _infoTile(context, icon: CustomIcons.call, label: languages.recipientNumber, value: ride.recipientContactNumber),
                    if (_packageSizeLine().isNotEmpty)
                      _infoTile(context, icon: CustomIcons.manageInformation, label: languages.packageLabel, value: _packageSizeLine()),
                    if (getDoubleFromDynamic(ride.estimatePrice) > 0)
                      _infoTile(
                        context,
                        icon: CustomIcons.paymentMethod,
                        label: languages.parcelEstimatedPrice,
                        value: getAmountWithCurrency(ride.estimatePrice),
                      ),
                  ],
                  if (ride.otherUserName.isNotEmpty) ...[
                    SizedBox(height: 14.h),
                    _sectionTitle(context, languages.bookForOther),
                    _infoTile(context, icon: CustomIcons.name, label: languages.passengerName, value: ride.otherUserName),
                    if (ride.otherUserContactNumber.isNotEmpty)
                      _infoTile(context, icon: CustomIcons.call, label: languages.contactNumber, value: ride.otherUserContactNumber),
                  ],
                  if (ride.additionalRemarks.isNotEmpty) ...[
                    SizedBox(height: 14.h),
                    _sectionTitle(context, languages.noteFromCustomer),
                    _infoTile(context, icon: CustomIcons.manageInformation, label: languages.noteFromCustomer, value: ride.additionalRemarks),
                  ],
                  if (ride.childSeat == 1 || ride.handicap == 1) ...[
                    SizedBox(height: 12.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        if (ride.childSeat == 1) _requirementChip(context, languages.childSeatSafety, Icons.child_friendly_outlined),
                        if (ride.handicap == 1) _requirementChip(context, languages.handicapAccess, Icons.accessible_outlined),
                      ],
                    ),
                  ],
                  if (ride.isAutoAccept == 1) ...[
                    SizedBox(height: 12.h),
                    _infoBanner(context, languages.autoAcceptDriverRide, XistiBrand.green),
                  ],
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                commonHorizontalPadding,
                0,
                commonHorizontalPadding + hailFabReserve(context),
                12.h,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => onAcceptRide(ride),
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorPrimary,
                    foregroundColor: theme.colorHailIcon,
                    padding: EdgeInsetsDirectional.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                  ),
                  child: Text(
                    languages.accept,
                    style: bodyText(context: context, fontWeight: FontWeight.w700, fontSize: textSize16px, textColor: theme.colorHailIcon),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _paymentLabel(bool isSpanish) {
    if (ride.destinationPaymentLabel.isNotEmpty) return ride.destinationPaymentLabel;
    if (ride.destinationPaymentMethod.isNotEmpty) {
      return DestinationPaymentUtil.labelForCode(ride.destinationPaymentMethod, isSpanish: isSpanish);
    }
    return DestinationPaymentUtil.labelForCode(DestinationPaymentUtil.cash, isSpanish: isSpanish);
  }

  String _packageSizeLine() {
    final parts = <String>[];
    if (ride.packageWeightKg.isNotEmpty) parts.add('${ride.packageWeightKg} kg');
    if (ride.packageHeightCm.isNotEmpty && ride.packageWidthCm.isNotEmpty && ride.packageLengthCm.isNotEmpty) {
      parts.add('${ride.packageHeightCm} × ${ride.packageWidthCm} × ${ride.packageLengthCm} cm');
    }
    return parts.join(' · ');
  }

  Widget _passengerCard(BuildContext context) {
    final theme = getCurrentTheme(context);
    return Container(
      padding: EdgeInsetsDirectional.all(12.w),
      decoration: BoxDecoration(
        color: XistiBrand.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadImageWithPlaceHolder(
            width: 64.w,
            height: 64.w,
            image: ride.profileImage,
            borderRadius: BorderRadius.circular(14.r),
            defaultAssetImage: setImagesBasedOnTheme(context, 'avatar.png'),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ride.userName.isNotEmpty ? ride.userName : languages.passengerMode,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: bodyText(context: context, fontWeight: FontWeight.w800, fontSize: textSize16px, textColor: Colors.white),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(CustomIcons.rating, size: 16.sp, color: theme.colorRating),
                    SizedBox(width: 4.w),
                    Text(
                      ride.rating > 0 ? '${ride.rating} (${ride.totalRatings})' : '--',
                      style: bodyText(context: context, fontSize: textSize13px, textColor: Colors.white.withValues(alpha: 0.75)),
                    ),
                  ],
                ),
                if (ride.orderTime.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    ride.orderTime,
                    style: bodyText(context: context, fontSize: textSize12px, textColor: Colors.white.withValues(alpha: 0.5)),
                  ),
                ],
                if (ride.rideNo > 0) ...[
                  SizedBox(height: 2.h),
                  Text(
                    '#${ride.rideNo}',
                    style: bodyText(context: context, fontSize: textSize12px, fontWeight: FontWeight.w600, textColor: Colors.white.withValues(alpha: 0.45)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _metricChip(context, icon: CustomIcons.locationRadius, label: languages.kmAway(ride.distance.toString()))),
        SizedBox(width: 8.w),
        Expanded(
          child: _metricChip(
            context,
            icon: CustomIcons.dropLocation,
            label: '${ride.time} ${languages.min}',
          ),
        ),
      ],
    );
  }

  Widget _metricChip(BuildContext context, {required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border.all(color: XistiBrand.purple.withValues(alpha: 0.45)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: Colors.white),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize12px, textColor: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _farePaymentCard(BuildContext context, String paymentLabel) {
    final theme = getCurrentTheme(context);
    final estimate = getDoubleFromDynamic(ride.estimatePrice);
    final offered = getDoubleFromDynamic(ride.offeredPrice);

    return Container(
      padding: EdgeInsetsDirectional.all(14.w),
      decoration: BoxDecoration(
        color: XistiBrand.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: theme.colorPrimary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languages.totalPay,
                      style: bodyText(context: context, fontSize: textSize12px, textColor: Colors.white.withValues(alpha: 0.55)),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      getAmountWithCurrency(ride.offeredPrice),
                      style: bodyText(context: context, fontWeight: FontWeight.w800, fontSize: textSize24px, textColor: theme.colorPrimary),
                    ),
                  ],
                ),
              ),
              if (estimate > 0 && estimate != offered)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      languages.offerFare,
                      style: bodyText(context: context, fontSize: textSize12px, textColor: Colors.white.withValues(alpha: 0.5)),
                    ),
                    Text(
                      getAmountWithCurrency(estimate),
                      style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize14px, textColor: Colors.white.withValues(alpha: 0.75)),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.1)),
          SizedBox(height: 10.h),
          Row(
            children: [
              buildOfferPaymentIcon(
                context,
                paymentType: ride.destinationPaymentMethod == 'wallet' ? PaymentType.wallet : PaymentType.cash,
                destinationPaymentCode: ride.destinationPaymentMethod.isNotEmpty ? ride.destinationPaymentMethod : DestinationPaymentUtil.cash,
                size: 22.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languages.paymentMethod,
                      style: bodyText(context: context, fontSize: textSize12px, textColor: Colors.white.withValues(alpha: 0.55)),
                    ),
                    Text(
                      paymentLabel,
                      style: bodyText(context: context, fontWeight: FontWeight.w700, fontSize: textSize14px, textColor: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _addressSections(BuildContext context) {
    final addresses = ride.addressList;
    if (addresses.isEmpty) {
      return [
        _infoTile(context, icon: CustomIcons.pickupLocation, label: languages.pickUpLocation, value: ride.pickupAddress),
        SizedBox(height: 8.h),
        _infoTile(context, icon: CustomIcons.dropLocation, label: languages.dropLocation, value: ride.destinationAddress),
      ];
    }
    return List.generate(addresses.length, (index) {
      final isFirst = index == 0;
      final isLast = index == addresses.length - 1;
      final label = isFirst
          ? languages.pickUpLocation
          : isLast
          ? languages.dropLocation
          : languages.stopPoint;
      final icon = isFirst
          ? CustomIcons.pickupLocation
          : isLast
          ? CustomIcons.dropLocation
          : CustomIcons.stopPoint;
      return Padding(
        padding: EdgeInsetsDirectional.only(bottom: 8.h),
        child: _infoTile(context, icon: icon, label: label, value: addresses[index].address),
      );
    });
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 8.h),
      child: Text(
        title,
        style: bodyText(context: context, fontWeight: FontWeight.w700, fontSize: textSize14px, textColor: Colors.white.withValues(alpha: 0.85)),
      ),
    );
  }

  Widget _infoTile(BuildContext context, {required IconData icon, required String label, required String value}) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(top: 2.h),
            child: Icon(icon, size: 18.sp, color: Colors.white.withValues(alpha: 0.85)),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: bodyText(context: context, fontSize: textSize12px, fontWeight: FontWeight.w600, textColor: Colors.white.withValues(alpha: 0.5)),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: bodyText(context: context, fontSize: textSize14px, fontWeight: FontWeight.w600, textColor: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _requirementChip(BuildContext context, String label, IconData icon) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: XistiBrand.purple.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: XistiBrand.purple.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: Colors.white),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              label,
              style: bodyText(context: context, fontSize: textSize12px, fontWeight: FontWeight.w600, textColor: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBanner(BuildContext context, String text, Color accent) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Text(
        text,
        style: bodyText(context: context, fontSize: textSize12px, fontWeight: FontWeight.w600, textColor: accent),
      ),
    );
  }
}
