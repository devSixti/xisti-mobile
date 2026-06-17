import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';
import 'driver_home_dl.dart';

/// Stacked notification-style bars for incoming driver ride requests (top of map).
class DriverRideRequestOverlay extends StatelessWidget {
  const DriverRideRequestOverlay({
    super.key,
    required this.rideList,
    required this.selectedRide,
    required this.isSearching,
    required this.selectDistance,
    required this.onSelectRide,
  });

  final List<RideList> rideList;
  final RideList? selectedRide;
  final bool isSearching;
  final dynamic selectDistance;
  final ValueChanged<RideList> onSelectRide;

  static const int _maxVisibleBars = 4;

  @override
  Widget build(BuildContext context) {
    final hasRides = rideList.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isSearching && !hasRides) _searchingPill(context),
        if (hasRides) ...[
          if (isSearching) _searchingPill(context, compact: true),
          ...rideList.take(_maxVisibleBars).toList().asMap().entries.map((entry) {
            final index = entry.key;
            final ride = entry.value;
            final isSelected = selectedRide?.rideId == ride.rideId;
            return Padding(
              padding: EdgeInsetsDirectional.only(
                top: index == 0 && !isSearching ? 0 : 8.h,
                start: XistiUiTokens.overlayHorizontalPadding,
                end: XistiUiTokens.overlayHorizontalPadding,
              ),
              child: _notificationBar(context, ride: ride, isSelected: isSelected),
            );
          }),
          if (rideList.length > _maxVisibleBars)
            Padding(
              padding: EdgeInsetsDirectional.only(top: 8.h),
              child: Text(
                '+${rideList.length - _maxVisibleBars} ${languages.showMore.toLowerCase()}',
                textAlign: TextAlign.center,
                style: bodyText(
                  context: context,
                  fontSize: textSize12px,
                  fontWeight: FontWeight.w600,
                  textColor: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ),
        ],
      ],
    );
  }

  Widget _searchingPill(BuildContext context, {bool compact = false}) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: XistiUiTokens.overlayHorizontalPadding),
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w, vertical: compact ? 8.h : 12.h),
        decoration: BoxDecoration(
          color: XistiBrand.darkSurface.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: getCurrentTheme(context).colorBorder.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
          children: [
            SizedBox(
              width: 18.w,
              height: 18.w,
              child: CircularProgressIndicator(strokeWidth: 2.sp, color: getCurrentTheme(context).colorPrimary),
            ),
            SizedBox(width: 10.w),
            Flexible(
              child: RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize13px, textColor: Colors.white),
                  children: [
                    TextSpan(text: languages.searchingForRideRequests.trim()),
                    if (selectDistance > 0) TextSpan(text: ' ${languages.distanceKm(getDoubleFromDynamic(selectDistance).toString())}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationBar(BuildContext context, {required RideList ride, required bool isSelected}) {
    final theme = getCurrentTheme(context);
    final pickup = ride.addressList.isNotEmpty ? ride.addressList.first.address : ride.pickupAddress;
    final accent = isSelected ? theme.colorPrimary : XistiBrand.purple;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSelectRide(ride),
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.97),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: isSelected ? accent : Colors.black.withValues(alpha: 0.06), width: isSelected ? 2 : 1),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.22), blurRadius: 14, offset: const Offset(0, 4)),
            ],
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12.w, 10.h, 10.w, 10.h),
            child: Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(color: accent.withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: Icon(CustomIcons.pickupLocation, size: 18.sp, color: accent),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'XISTI',
                            style: bodyText(context: context, fontWeight: FontWeight.w800, fontSize: textSize12px, textColor: XistiBrand.dark),
                          ),
                          Text(
                            ' · ${languages.kmAway(ride.distance.toString())}',
                            style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize12px, textColor: XistiBrand.dark.withValues(alpha: 0.65)),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        pickup,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: bodyText(context: context, fontSize: textSize13px, fontWeight: FontWeight.w500, textColor: XistiBrand.dark.withValues(alpha: 0.82)),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      getAmountWithCurrency(ride.offeredPrice),
                      style: bodyText(context: context, fontWeight: FontWeight.w800, fontSize: textSize14px, textColor: theme.colorPrimary),
                    ),
                    SizedBox(height: 4.h),
                    Icon(
                      isSelected ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,
                      size: 20.sp,
                      color: XistiBrand.dark.withValues(alpha: 0.45),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
