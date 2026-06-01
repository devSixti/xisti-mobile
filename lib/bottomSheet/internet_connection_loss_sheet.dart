// internet_connection_loss

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../commonView/custom_rounded_button.dart';
import '../commonView/scaffold_with_safe_area.dart';
import '../utils/utils.dart';

bool isInternetConnectionLostSheetOpen = false;

class InternetConnectionLoss extends StatefulWidget {
  final Function? onPositivePress;

  const InternetConnectionLoss({super.key, required this.onPositivePress});

  @override
  State<InternetConnectionLoss> createState() => _InternetConnectionLossState();
}

class _InternetConnectionLossState extends State<InternetConnectionLoss> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(child: Container()),
          Container(
            width: double.infinity,
            padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: getBottomMargin(), top: 20.h),
            decoration: BoxDecoration(color: getCurrentTheme(context).colorScaffoldBg, borderRadius: bottomSheetBorderRadius30r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(bottom: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(languages.connectionLost, style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize22px)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(CustomIcons.cancel, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(top: 20.h, bottom: 20.h),
                  child: SvgPicture.asset(
                    "assets/svgs/no_internet_connection.svg",
                    fit: BoxFit.contain,
                    height: 100.h,
                    colorFilter: ColorFilter.mode(getCurrentTheme(navigatorKey.currentContext!).colorPrimary, BlendMode.srcIn),
                  ),
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(top: 10.h),
                  child: Text(languages.internetConnLostMessage, textAlign: TextAlign.center, style: bodyText(context: context, fontWeight: FontWeight.w500)),
                ),
                CustomRoundedButton(context, languages.retry, () async {
                  if (await isNetworkConnected()) {
                    widget.onPositivePress!();
                  }
                }, margin: EdgeInsetsDirectional.only(top: 20.h)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showInternetConnectivityLossSheet(BuildContext context, {Function()? onRetryPressed}) {
  if (!isInternetConnectionLostSheetOpen) {
    isInternetConnectionLostSheetOpen = true;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return InternetConnectionLoss(
          onPositivePress: () async {
            Navigator.pop(context);
            onRetryPressed?.call();
          },
        );
      },
    ).then((value) => isInternetConnectionLostSheetOpen = false);
  } else {
    return;
  }
}
