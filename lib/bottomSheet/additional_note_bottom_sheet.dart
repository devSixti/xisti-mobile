import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../commonView/custom_rounded_button.dart';
import '../commonView/scaffold_with_safe_area.dart';
import '../utils/utils.dart';

class AdditionalNoteBottomSheet extends StatefulWidget {
  final String title, additionalNote;

  const AdditionalNoteBottomSheet({super.key, required this.title, required this.additionalNote});

  @override
  State<AdditionalNoteBottomSheet> createState() => _AdditionalNoteBottomSheetState();
}

class _AdditionalNoteBottomSheetState extends State<AdditionalNoteBottomSheet> {
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
                          widget.title,
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
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    border: Border.all(color: getCurrentTheme(context).colorDarkBorder, width: 1.sp),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w, top: 13.h, bottom: 13.h),
                  child: Text(widget.additionalNote, style: bodyText(context: context, fontWeight: FontWeight.w500)),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: CustomRoundedButton(
                    context,
                    languages.continueTxt,
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
