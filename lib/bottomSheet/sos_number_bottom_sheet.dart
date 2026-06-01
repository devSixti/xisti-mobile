import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../commonView/custom_rounded_button.dart';
import '../commonView/scaffold_with_safe_area.dart';
import '../hive/hive_helper.dart';
import '../networking/base_dl.dart';
import '../utils/phone_util.dart';
import '../utils/utils.dart';

class SosNumberBottomSheet extends StatefulWidget {
  final List<SosContactList> sosNumber;

  const SosNumberBottomSheet({super.key, required this.sosNumber});

  @override
  State<SosNumberBottomSheet> createState() => _SosNumberBottomSheetState();
}

class _SosNumberBottomSheetState extends State<SosNumberBottomSheet> {
  SosContactList? selectedValue;
  int selectedIndex = -1;
  bool isBottomSheetOpen = false;

  @override
  void initState() {
    super.initState();
  }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(top: 25.h, bottom: 20.h),
                        child: Text(
                          languages.emergencyContact,
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
                  constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight * 0.52),
                  child: GridView.builder(
                    padding: EdgeInsetsDirectional.only(bottom: 10.h),
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.sosNumber.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.w,
                      mainAxisSpacing: 20.h,
                      childAspectRatio: 2,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      var data = widget.sosNumber[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedValue = widget.sosNumber[index];
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: EdgeInsetsDirectional.only(start: 5.w, end: 5.w, top: 5.h, bottom: 5.h),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.sp,
                              color: selectedIndex == index ? getCurrentTheme(context).colorPrimary : getCurrentTheme(context).colorBorder,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data.name,
                                style: bodyText(
                                  context: context,
                                  fontSize: textSize14px,
                                  textColor: selectedIndex == index ? getCurrentTheme(context).colorTextCommon : getCurrentTheme(context).colorTextLight,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              AutoSizeText(
                                "${data.countryCode} ${data.contactNumber}",
                                maxLines: 2,
                                style: bodyText(context: context, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: CustomRoundedButton(
                    context,
                    languages.call,
                    selectedIndex == -1
                        ? null
                        : () async {
                          if (!isBottomSheetOpen) {
                            isBottomSheetOpen = true;
                            openUrl("tel:${selectedValue?.countryCode}${selectedValue?.contactNumber}");
                            await Future.delayed(const Duration(milliseconds: 1000));
                            isBottomSheetOpen = false;
                          }
                        },
                    minWidth: double.maxFinite,
                    margin: EdgeInsetsDirectional.only(top: 10.h, bottom: getBottomMargin()),
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

List<SosContactList> mergeUserEmergencyIntoSosList(List<SosContactList> sosContactList) {
  final emergencyNumber = getStringFromUserInfoBox(hiveEmergencyContact).trim();
  if (emergencyNumber.isEmpty) {
    return sosContactList;
  }

  final countryCode = normalizeDialCode(
    getStringFromUserInfoBox(hiveEmergencyCountryCode).trim().isNotEmpty
        ? getStringFromUserInfoBox(hiveEmergencyCountryCode)
        : getStringFromUserInfoBox(hiveCountryCode),
  );
  final emergencyKey = '${countryCode.replaceAll(RegExp(r'\D'), '')}${emergencyNumber.replaceAll(RegExp(r'\D'), '')}';

  final filtered = sosContactList.where((contact) {
    final key = '${contact.countryCode.replaceAll(RegExp(r'\D'), '')}${contact.contactNumber.replaceAll(RegExp(r'\D'), '')}';
    return key != emergencyKey;
  }).toList();

  final userName = getStringFromUserInfoBox(hiveUserName).trim();
  final displayName = userName.isNotEmpty ? userName : languages.emergencyContact;

  return [
    SosContactList(
      id: 0,
      name: displayName,
      countryCode: countryCode,
      contactNumber: emergencyNumber,
    ),
    ...filtered,
  ];
}

void openSosBottomSheet(BuildContext context, List<SosContactList> sosContactList) {
  final mergedContacts = mergeUserEmergencyIntoSosList(sosContactList);
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    enableDrag: false,
    isDismissible: false,
    isScrollControlled: true,
    builder: (context) {
      return AnimatedPadding(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: MediaQueryData.fromView(View.of(context)).padding.top + 10.h),
        child: SosNumberBottomSheet(sosNumber: mergedContacts),
      );
    },
  );
}
