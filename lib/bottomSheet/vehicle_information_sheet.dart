import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_xisti/commonView/common_view.dart';

import '../commonView/custom_rounded_button.dart';
import '../commonView/load_image_with_placeholder.dart';
import '../utils/utils.dart';

class VehicleInformationSheet extends StatefulWidget {
  final String serviceName, serviceIcon, serviceDescription;

  const VehicleInformationSheet({super.key, required this.serviceName, required this.serviceIcon, required this.serviceDescription});

  @override
  State<VehicleInformationSheet> createState() => _VehicleInformationSheetState();
}

class _VehicleInformationSheetState extends State<VehicleInformationSheet> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: AlignmentDirectional.bottomCenter,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: getCurrentTheme(context).colorScaffoldBg, borderRadius: bottomSheetBorderRadius30r),
          padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
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
                        widget.serviceName,
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
              LoadImageWithPlaceHolder(width: 75.sp, height: 75.sp, image: widget.serviceIcon, imageFit: BoxFit.contain),
              if (widget.serviceDescription.isNotEmpty)
                Container(
                  constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight * 0.5),
                  child: SingleChildScrollView(
                    child: Text(
                      widget.serviceDescription,
                      style: bodyText(context: context, fontSize: textSize16px, fontWeight: FontWeight.w500),
                    ),
                  ),
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
      ),
    );
  }
}
