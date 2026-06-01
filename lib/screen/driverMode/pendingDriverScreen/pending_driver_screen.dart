import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/common_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../utils/utils.dart';
import '../../passengerMode/passengerHome/passenger_home.dart';
import '../driverDocumentScreen/require_document_screen.dart';

class PendingDriverScreen extends StatefulWidget {
  final String message, rejectMessage;
  final int driverStatus;

  const PendingDriverScreen({super.key, required this.driverStatus, required this.message, this.rejectMessage = ""});

  @override
  State createState() => _PendingDriverScreenState();
}

class _PendingDriverScreenState extends State<PendingDriverScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      resizeToAvoidBottomInset: false,
      appBar: CommonAppBar(
        centerTitle: true,
        titleTextStyle: toolbarStyle(context: context),
        title: Text(languages.verificationPending),
        leading: backButtonForAppBarCustom(
          context: context,
          onBackPress: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(setImagesBasedOnTheme(context, "verification_pending.png"), height: 250.h, fit: BoxFit.fitHeight),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30.h, vertical: 20.h),
                      child: Text(widget.message, textAlign: TextAlign.center, style: bodyText(context: context, fontSize: textSize14px)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (widget.rejectMessage.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsetsDirectional.all(10.sp),
              margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 1.h, bottom: 2.h),
              decoration: BoxDecoration(
                color: getCurrentTheme(context).colorSelectionPrimaryOpc,
                border: Border.all(color: getCurrentTheme(context).colorPrimary, width: 0.5.sp),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Text(widget.rejectMessage, style: bodyText(context: context, fontWeight: FontWeight.w500, fontSize: textSize14px)),
            ),
          Container(
            margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: getBottomMargin(), top: 20.h),
            child: Row(
              children: [
                if (widget.driverStatus == 3)
                  Expanded(
                    child: CustomRoundedButton(context, languages.document, () {
                      openScreen(context, const RequireDocumentScreen());
                    }, setBorder: true),
                  ),
                if (widget.driverStatus == 3) SizedBox(width: 20.w),
                Expanded(
                  child: CustomRoundedButton(context, languages.goToHome, () {
                    openScreenWithClearPrevious(context, const PassengerHome());
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
