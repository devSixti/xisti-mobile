import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/common_view.dart';
import '../../../commonView/custom_rounded_button.dart';
import '../../../hive/hive_helper.dart';
import '../../../utils/utils.dart';
import '../profile/profile.dart';

class EmergencyContact extends StatefulWidget {
  const EmergencyContact({super.key});

  @override
  State<EmergencyContact> createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<EmergencyContact> {
  bool isBottomSheetOpen = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      appBar: CommonAppBar(
        centerTitle: true,
        leading: backButtonForAppBarCustom(
          context: context,
          onBackPress: () {
            Navigator.pop(context);
          },
        ),
        title: Text(languages.emergencyContact, style: toolbarStyle(context: context)),
      ),
      body: _buildEmergencyContact(),
    );
  }

  Widget _buildEmergencyContact() {
    String emergencyNumber = getStringFromUserInfoBox(hiveEmergencyContact);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(setImagesBasedOnTheme(context, "emergency_contact.png"), width: double.infinity, height: 250.h, fit: BoxFit.fitHeight),
                if (emergencyNumber.trim().isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsetsDirectional.only(top: 20.h),
                    child: Text(
                      "${getStringFromUserInfoBox(hiveEmergencyCountryCode)} $emergencyNumber",
                      style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize18px),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(top: 15.h),
                    child: Text(languages.emergencyContactMsg, style: bodyText(context: context, fontSize: textSize14px), textAlign: TextAlign.center),
                  ),
                ] else ...[
                  SizedBox(height: 20.h),
                  Text(
                    languages.emergencyContactAddMsg,
                    textAlign: TextAlign.center,
                    style: bodyText(context: context, textColor: getCurrentTheme(context).colorTextCommon, fontWeight: FontWeight.w600, fontSize: textSize18px),
                  ),
                ],
              ],
            ),
          ),
        ),
        CustomRoundedButton(
          context,
          emergencyNumber.trim().isNotEmpty ? languages.emergencyCall : languages.addEmergencyContact,
          () async {
            if (emergencyNumber.trim().isNotEmpty) {
              if (!isBottomSheetOpen) {
                isBottomSheetOpen = true;
                await openUrl("tel:${getStringFromUserInfoBox(hiveEmergencyCountryCode)} $emergencyNumber");
                await Future.delayed(const Duration(milliseconds: 1000));
                isBottomSheetOpen = false;
              }
            } else {
              openScreenWithResult(context, const ProfileScreen()).then((val) {
                setState(() {});
              });
            }
          },
          minWidth: double.infinity,
          margin: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, bottom: getBottomMargin()),
        ),
      ],
    );
  }
}
