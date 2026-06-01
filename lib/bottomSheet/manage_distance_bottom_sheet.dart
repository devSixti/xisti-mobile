import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../blocs/bloc.dart';
import '../commonView/common_view.dart';
import '../commonView/custom_rounded_button.dart';
import '../screen/driverMode/driverHome/driver_home_dl.dart';
import '../utils/utils.dart';

class ManageDistanceBottomSheet extends StatefulWidget {
  final List<SearchRadius> searchRadiusList;
  final dynamic searchDistanceFilter;
  final Function(dynamic selectedDistance) onApply;
  final Function(dynamic selectedDistance) onReset;

  const ManageDistanceBottomSheet({
    super.key,
    required this.searchRadiusList,
    required this.searchDistanceFilter,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<ManageDistanceBottomSheet> createState() => _ManageDistanceBottomSheetState();
}

class _ManageDistanceBottomSheetState extends State<ManageDistanceBottomSheet> {
  final selectedDistanceSubject = BehaviorSubject<dynamic>();

  @override
  void didChangeDependencies() {
    selectedDistanceSubject.sink.add(widget.searchDistanceFilter);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: Container()),
          Container(
            decoration: BoxDecoration(borderRadius: bottomSheetBorderRadius30r, color: getCurrentTheme(context).colorScaffoldBg),
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: commonHorizontalPadding, end: commonHorizontalPadding, top: 30.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(bottom: 20.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          languages.manageDistance,
                          style: bodyText(context: context, fontWeight: FontWeight.w600, fontSize: textSize24px),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(CustomIcons.cancel, size: 25.sp, color: getCurrentTheme(context).colorIconCommon),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<dynamic>(
                    stream: selectedDistanceSubject,
                    builder: (context, snapshot) {
                      dynamic selectedDistance = snapshot.data ?? 0;
                      return Container(
                        constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight * 0.52),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            SearchRadius searchRadiusItem = widget.searchRadiusList[index];
                            return GestureDetector(
                              onTap: () {
                                if (selectedDistance == searchRadiusItem.radius) {
                                  selectedDistanceSubject.sink.add(0);
                                } else {
                                  selectedDistanceSubject.sink.add(searchRadiusItem.radius);
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${searchRadiusItem.radius} ${languages.km}",
                                    style: bodyText(context: context, fontWeight: FontWeight.w500),
                                  ),
                                  radioButton(context, selectedDistance == searchRadiusItem.radius),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 20.h);
                          },
                          itemCount: widget.searchRadiusList.length,
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(bottom: getBottomMargin(), top: 30.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomRoundedButton(context, languages.reset, setBorder: true, () {
                            selectedDistanceSubject.sink.add(0);
                            widget.onReset(0);
                            Navigator.pop(context);
                          }, margin: EdgeInsetsDirectional.only(top: 10.h)),
                        ),
                        SizedBox(width: 23.w),
                        Expanded(
                          child: CustomRoundedButton(context, languages.apply, () {
                            if ((selectedDistanceSubject.valueOrNull ?? 0) > 0) {
                              widget.onApply(selectedDistanceSubject.valueOrNull ?? 0);
                              Navigator.pop(context);
                            } else {
                              openSimpleSnackbar(context, languages.pleaseSelectADistance);
                            }
                          }, margin: EdgeInsetsDirectional.only(top: 10.h)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
