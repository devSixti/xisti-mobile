import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/load_image_with_placeholder.dart';
import '../../../commonView/scaffold_with_safe_area.dart';
import '../../../hive/hive_helper.dart';
import '../../../utils/utils.dart';
import 'driver_waiting_bloc.dart';

class DriverWaitingScreen extends StatefulWidget {
  final String userProfile;
  final int rideId, serviceId, timeOut;

  const DriverWaitingScreen({super.key, required this.userProfile, required this.rideId, required this.serviceId, required this.timeOut});

  @override
  State<DriverWaitingScreen> createState() => _DriverWaitingScreenState();
}

class _DriverWaitingScreenState extends State<DriverWaitingScreen> {
  DriverWaitingBloc? _bloc;

  @override
  void initState() {
    isWaitingOpen = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bloc ??= DriverWaitingBloc(context, widget.rideId, widget.serviceId, widget.timeOut);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    isWaitingOpen = false;
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
      },
      child: ScaffoldWithSafeArea(
        backgroundColor: getCurrentTheme(context).colorBackGroundWaiting.withValues(alpha: 0.7),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 90.w),
                      child: Transform(
                        transform: Matrix4.rotationZ(0.3),
                        child: LoadImageWithPlaceHolder(
                          width: 70.sp,
                          height: 70.sp,
                          image: widget.userProfile,
                          defaultAssetImage: setImagesBasedOnTheme(context, "avatar.png"),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(end: 90.w, top: 23.h),
                      child: Transform(
                        transform: Matrix4.rotationZ(-0.3),
                        child: LoadImageWithPlaceHolder(
                          width: 70.sp,
                          height: 70.sp,
                          image: getStringFromUserInfoBox(hiveProfileImage),
                          defaultAssetImage: setImagesBasedOnTheme(context, "avatar.png"),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 26.h),
                child: Text(
                  languages.yourOfferIsBeingReviewedByCustomer,
                  textAlign: TextAlign.center,
                  style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize24px, textColor: getCurrentTheme(context).colorStaticWhite),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
