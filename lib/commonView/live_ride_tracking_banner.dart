import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/utils.dart';
import 'statusView/passenger_ride_status_view.dart';

/// Modern live-trip header: pulsing badge, status copy, and ETA when available.
class LiveRideTrackingBanner extends StatelessWidget {
  final int rideStatus;
  final Stream<dynamic>? etaStream;
  final String? etaFallback;

  const LiveRideTrackingBanner({
    super.key,
    required this.rideStatus,
    this.etaStream,
    this.etaFallback,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);
    final showEta = rideStatus > passengerArrive && rideStatus < passengerDrop;

    return Container(
      margin: EdgeInsetsDirectional.only(top: 10.h, bottom: 10.h),
      padding: EdgeInsetsDirectional.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: theme.colorDarkBorder, width: 1.w),
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            theme.colorScaffoldBg,
            XistiBrand.green.withValues(alpha: 0.06),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _LivePulseBadge(label: languages.liveTrackingBadge),
              const Spacer(),
              if (showEta)
                StreamBuilder<dynamic>(
                  stream: etaStream,
                  initialData: etaFallback,
                  builder: (context, snap) {
                    final eta = (snap.data ?? etaFallback ?? '--').toString();
                    if (eta == '--' || eta == '0') {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: XistiBrand.green.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        eta,
                        style: bodyText(
                          context: context,
                          fontSize: textSize12px,
                          fontWeight: FontWeight.w700,
                          textColor: XistiBrand.green,
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(color: _iconBorderColor(context), shape: BoxShape.circle),
                margin: EdgeInsetsDirectional.only(end: 8.w),
                padding: EdgeInsets.all(2.5.sp),
                child: Container(
                  width: 28.sp,
                  height: 28.sp,
                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(
                    color: _iconBgColor(context),
                    shape: BoxShape.circle,
                    border: Border.all(color: _iconBorderColor(context), width: 2.w),
                  ),
                  child: Icon(_iconForStatus(), size: 18.sp, color: theme.colorPsRunningIcon),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _statusMessage(),
                      style: bodyText(context: context, fontSize: textSize14px, fontWeight: FontWeight.w600),
                    ),
                    if (showEta) ...[
                      SizedBox(height: 4.h),
                      Text(
                        languages.estimatedArrival,
                        style: bodyText(context: context, fontSize: textSize12px, textColor: theme.colorTextLight),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusMessage() {
    if (rideStatus < passengerArrive) {
      return languages.yourDriverIsOnWay;
    }
    if (rideStatus <= passengerArrive) {
      return languages.driverIsAtPickup;
    }
    if (rideStatus < passengerDrop) {
      return languages.driverHeadingDestination;
    }
    return languages.reachYourDestination;
  }

  IconData _iconForStatus() {
    if (rideStatus < passengerArrive) {
      return CustomIcons.driverOnWay;
    }
    if (rideStatus <= passengerArrive) {
      return CustomIcons.driverPickup;
    }
    if (rideStatus < passengerDrop) {
      return CustomIcons.driverOnWay;
    }
    return CustomIcons.reachedDestination;
  }

  Color _iconBgColor(BuildContext context) {
    if (rideStatus < passengerDrop) {
      return getCurrentTheme(context).colorPsRunningIconBg;
    }
    return getCurrentTheme(context).colorPsCompletedIconBg;
  }

  Color _iconBorderColor(BuildContext context) {
    if (rideStatus < passengerDrop) {
      return getCurrentTheme(context).colorPsRunningIconBg.withValues(alpha: 0.5);
    }
    return getCurrentTheme(context).colorPsCompletedIconBg.withValues(alpha: 0.5);
  }
}

class _LivePulseBadge extends StatefulWidget {
  final String label;

  const _LivePulseBadge({required this.label});

  @override
  State<_LivePulseBadge> createState() => _LivePulseBadgeState();
}

class _LivePulseBadgeState extends State<_LivePulseBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final scale = 0.85 + (_controller.value * 0.3);
            return Transform.scale(
              scale: scale,
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: XistiBrand.green,
                  boxShadow: [
                    BoxShadow(
                      color: XistiBrand.green.withValues(alpha: 0.45),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(width: 6.w),
        Text(
          widget.label,
          style: bodyText(
            context: context,
            fontSize: textSize12px,
            fontWeight: FontWeight.w700,
            textColor: XistiBrand.green,
          ),
        ),
      ],
    );
  }
}
