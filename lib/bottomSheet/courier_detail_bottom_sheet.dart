import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../commonView/courier_detail_view.dart';
import '../commonView/custom_rounded_button.dart';
import '../commonView/scaffold_with_safe_area.dart';
import '../utils/utils.dart';

class CourierDetailBottomSheet extends StatefulWidget {
  final String itemDescription, recipientName, recipientContactNumber, estimatePrice;

  const CourierDetailBottomSheet({
    super.key,
    required this.itemDescription,
    required this.recipientName,
    required this.recipientContactNumber,
    required this.estimatePrice,
  });

  @override
  State<CourierDetailBottomSheet> createState() => _CourierDetailBottomSheetState();
}

class _CourierDetailBottomSheetState extends State<CourierDetailBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(child: Container()),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: getCurrentTheme(context).colorScaffoldBg, borderRadius: bottomSheetBorderRadius30r),
            padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(top: 25.h, bottom: 20.h),
                        child: Text(
                          languages.courierDetail,
                          textAlign: TextAlign.start,
                          style: bodyText(context: context, fontSize: textSize24px, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(CustomIcons.cancel, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
                    ),
                  ],
                ),
                CourierDetailView(
                  itemDesc: widget.itemDescription,
                  recipientName: widget.recipientName,
                  recipientNumber: widget.recipientContactNumber,
                  estimatedPrice: getDoubleFromDynamic(widget.estimatePrice),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: CustomRoundedButton(
                    context,
                    languages.okay,
                    () async {
                      Navigator.pop(context);
                    },
                    minWidth: double.maxFinite,
                    margin: EdgeInsetsDirectional.only(top: 20.h, bottom: getBottomMargin()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
