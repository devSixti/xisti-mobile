import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/bloc.dart';
import '../../utils/utils.dart';
import '../raise_fare_sheet.dart';
import 'accept_request_bottom_sheet_dl.dart';

class ItemOfferRate extends StatefulWidget {
  final List<OfferRatePojo> offerList;
  final Function(dynamic) onSelectionChanged;

  const ItemOfferRate({super.key, required this.offerList, required this.onSelectionChanged});

  @override
  State<ItemOfferRate> createState() => _ItemOfferRateState();
}

class _ItemOfferRateState extends State<ItemOfferRate> {
  final selectedChoiceSubject = BehaviorSubject<dynamic>();
  final isCustomSelectedSubject = BehaviorSubject<bool>.seeded(false);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
      stream: selectedChoiceSubject,
      builder: (context, snapSelectedChoice) {
        dynamic selectedChoice = snapSelectedChoice.data ?? -1;
        return StreamBuilder<bool>(
          stream: isCustomSelectedSubject,
          builder: (context, snapIsCustomSelected) {
            bool isCustomSelected = snapIsCustomSelected.data ?? false;
            return SizedBox(
              height: 40.h,
              child: ListView.separated(
                padding: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  OfferRatePojo offerRateItem = widget.offerList[index];
                  return GestureDetector(
                    onTap: () {
                      if (offerRateItem.isCustom == 0) {
                        if (selectedChoice != offerRateItem.offerAmount) {
                          selectedChoiceSubject.sink.add(offerRateItem.offerAmount);
                          widget.onSelectionChanged(offerRateItem.offerAmount);
                        } else {
                          selectedChoiceSubject.sink.add(-1);
                          widget.onSelectionChanged(0);
                        }
                        isCustomSelectedSubject.sink.add(false);
                      } else {
                        if (isCustomSelected) {
                          selectedChoiceSubject.sink.add(-1);
                          isCustomSelectedSubject.sink.add(false);
                        } else {
                          openRaiseFareSheet();
                        }
                      }
                    },
                    child:
                        (offerRateItem.isCustom == 1 && !isCustomSelected)
                            ? Container(
                              padding: EdgeInsetsDirectional.all(10.sp),
                              height: 40.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                border: Border.all(color: getCurrentTheme(context).colorDarkBorder, width: 0.5.sp),
                              ),
                              child: Icon(CustomIcons.edit, size: 20.sp, color: getCurrentTheme(context).colorOfferEditIcon),
                            )
                            : Container(
                              padding: EdgeInsetsDirectional.symmetric(vertical: 10.h, horizontal: 15.w),
                              height: 40.h,
                              decoration: BoxDecoration(
                                color:
                                    (selectedChoice == offerRateItem.offerAmount)
                                        ? getCurrentTheme(context).colorPrimary
                                        : (isCustomSelected && offerRateItem.isCustom == 1)
                                        ? getCurrentTheme(context).colorPrimary
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(15.r),
                                border: Border.all(
                                  color:
                                      (selectedChoice == offerRateItem.offerAmount)
                                          ? Colors.transparent
                                          : (isCustomSelected && offerRateItem.isCustom == 1)
                                          ? Colors.transparent
                                          : getCurrentTheme(context).colorBorder,
                                  width: 0.5.sp,
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      (isCustomSelected && offerRateItem.isCustom == 1) ? languages.other : getAmountWithCurrency(offerRateItem.offerAmount),
                                      style: bodyText(
                                        context: context,
                                        fontWeight: FontWeight.w600,
                                        textColor:
                                            (selectedChoice == offerRateItem.offerAmount)
                                                ? getCurrentTheme(context).colorSuggestionAmountAndIcon
                                                : (isCustomSelected && offerRateItem.isCustom == 1)
                                                ? getCurrentTheme(context).colorSuggestionAmountAndIcon
                                                : getCurrentTheme(context).colorTextCommon,
                                      ).copyWith(height: 0),
                                    ),
                                    if (selectedChoice == offerRateItem.offerAmount || (isCustomSelected && offerRateItem.isCustom == 1))
                                      GestureDetector(
                                        onTap: () {
                                          selectedChoiceSubject.sink.add(-1);
                                          widget.onSelectionChanged(0);
                                        },
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.only(top: 2.h, start: 5.w),
                                          child: Icon(CustomIcons.filledRemove, size: 14.sp, color: getCurrentTheme(context).colorSuggestionAmountAndIcon),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(width: 11.w);
                },
                itemCount: widget.offerList.length,
              ),
            );
          },
        );
      },
    );
  }

  void openRaiseFareSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        return RaiseFareSheet(
          isFromDriver: true,
          onSubmit: (offerFare) {
            selectedChoiceSubject.sink.add(getDoubleFromDynamic(offerFare));
            isCustomSelectedSubject.sink.add(true);
            widget.onSelectionChanged(getDoubleFromDynamic(offerFare));
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
