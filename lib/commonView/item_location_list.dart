import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/utils.dart';

class ItemLocationList extends StatelessWidget {
  final Function()? onTap;
  final IconData? leadingIcon;
  final bool showSuffixIcon;
  final bool isLoadingCurrentLocation;
  final String? title;
  final String address;
  final TextStyle? addressTextStyle;

  const ItemLocationList({
    super.key,
    this.onTap,
    this.leadingIcon,
    this.showSuffixIcon = true,
    required this.address,
    this.title,
    this.addressTextStyle,
    this.isLoadingCurrentLocation = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsetsDirectional.symmetric(vertical: 10.h),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leadingIcon != null)
              Flexible(
                flex: 0,
                child: Container(
                  margin: EdgeInsetsDirectional.only(end: 10.w),
                  child: Icon(leadingIcon, color: getCurrentTheme(context).colorIconCommon, size: 25.sp),
                ),
              ),
            Expanded(
              child: Text(
                address,
                maxLines: 2,
                textAlign: TextAlign.start,
                style: addressTextStyle ?? bodyText(context:context,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
