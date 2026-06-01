import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../blocs/bloc.dart';
import '../commonView/custom_rounded_button.dart';
import '../commonView/custom_text_field.dart';
import '../commonView/scaffold_with_safe_area.dart';
import '../utils/utils.dart';

class RatingBottomSheet extends StatefulWidget {
  final String title, message;
  final Function(double rating, String comment) onSubmit;

  const RatingBottomSheet({super.key, required this.title, required this.onSubmit, this.message = ""});

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  final _ratingController = BehaviorSubject<double>.seeded(0);
  final reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: AlignmentGeometry.bottomCenter,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight * 0.85),
          decoration: BoxDecoration(color: getCurrentTheme(context).colorScaffoldBg, borderRadius: bottomSheetBorderRadius30r),
          padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
          child: SingleChildScrollView(
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              if (widget.message.trim().isNotEmpty) ...[
                Text(
                  widget.message,
                  style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize18px),
                ),
                SizedBox(height: 20.h),
              ],
              RatingBar.builder(
                initialRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                glow: false,
                itemCount: 5,
                itemSize: 48.sp,
                unratedColor: getCurrentTheme(context).colorDisableRating,
                itemBuilder: (context, _) => Icon(CustomIcons.rating, color: getCurrentTheme(context).colorRating, size: 48.sp),
                onRatingUpdate: (rating) {
                  _ratingController.sink.add(rating);
                },
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: getCurrentTheme(context).colorTextFieldBorder, width: 1.sp),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                margin: EdgeInsetsDirectional.only(top: 20.h),
                padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w, top: 10.h, bottom: 10.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(CustomIcons.description, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
                    Expanded(
                      child: TextFormFieldCustom(
                        controller: reviewController,
                        maxLine: 5,
                        minLine: 3,
                        keyboardType: TextInputType.multiline,
                        backgroundColor: Colors.transparent,
                        hint: languages.writeYourFeedBack,
                        contentPadding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w),
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CustomRoundedButton(
                context,
                languages.submit,
                () {
                  double rating = _ratingController.valueOrNull ?? 0;
                  String comment = reviewController.text.trim();
                  if (rating > 0) {
                    widget.onSubmit(rating, comment);
                    Navigator.pop(context, true);
                  } else {
                    openSimpleSnackbar(context, languages.giveFeedbackErrorMsg);
                  }
                },
                minWidth: double.maxFinite,
                margin: EdgeInsetsDirectional.only(top: 20.h, bottom: getBottomMargin()),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}
