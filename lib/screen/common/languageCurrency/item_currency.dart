import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/currency_display_util.dart';
import '../../../utils/utils.dart';
import 'language_and_currency_dl.dart';

class ItemCurrency extends StatefulWidget {
  final List<CurrencyListItem> currencyList;
  final int defaultSelected;
  final Function(CurrencyListItem) onSelectionChanged;

  const ItemCurrency({super.key, required this.currencyList, required this.onSelectionChanged, this.defaultSelected = 0});

  @override
  ItemCurrencyState createState() => ItemCurrencyState();
}

class ItemCurrencyState extends State<ItemCurrency> {
  int selectedChoice = 0;


  @override
  void initState() {
    int index = 0;
    if (widget.currencyList.isNotEmpty) {
      if (widget.defaultSelected != 0) {
        selectedChoice = widget.defaultSelected;
        index = widget.currencyList.indexWhere((element) => element.currencyId == selectedChoice);
      } else {
        selectedChoice = widget.currencyList[0].currencyId;
      }
      widget.onSelectionChanged(widget.currencyList[index >= 0 ? index : 0]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 15.w,
      children:
          widget.currencyList.map((s) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedChoice = s.currencyId;
                  widget.onSelectionChanged(s);
                });
              },
              child: Container(
                height: 45.h,
                margin: EdgeInsetsDirectional.only(top: 15.h,bottom: 1.h),
                padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w),
                decoration: BoxDecoration(
                  color: selectedChoice == s.currencyId ? getCurrentTheme(context).colorPrimary : getCurrentTheme(context).colorPreferencesChoiceChipBg,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: selectedChoice == s.currencyId ? getCurrentTheme(context).colorPrimary : getCurrentTheme(context).colorBorder,
                    width: 0.6.sp,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      CurrencyDisplayUtil.chipLabel(s),
                      style: bodyText(context:context,
                        textColor: selectedChoice == s.currencyId ? getCurrentTheme(context).colorWhite : getCurrentTheme(context).colorTextCommon,
                        fontWeight: FontWeight.w500,
                      ).copyWith(height: 0),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
