import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';
import 'language_and_currency_dl.dart';

class ItemLanguage extends StatefulWidget {
  final List<LanguageListItem> languageList;
  final int? defaultSelected;
  final Function(LanguageListItem) onSelectionChanged;

  const ItemLanguage({super.key, required this.languageList, required this.onSelectionChanged, this.defaultSelected});

  @override
  ItemLanguageState createState() => ItemLanguageState();
}

class ItemLanguageState extends State<ItemLanguage> {
  late LanguageListItem selectedChoice;

  @override
  void initState() {
    if (widget.languageList.isNotEmpty) {
      if (widget.defaultSelected != null && widget.defaultSelected != -1) {
        selectedChoice = widget.languageList[widget.defaultSelected!];
      } else {
        selectedChoice = widget.languageList[0];
      }
      widget.onSelectionChanged(selectedChoice);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 15.w,
      children:
          widget.languageList.map((s) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedChoice = s;
                  widget.onSelectionChanged(selectedChoice);
                });
              },
              child: Container(
                height: 45.h,
                margin: EdgeInsetsDirectional.only(top: 15.h,bottom: 1.h),
                padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w),
                decoration: BoxDecoration(
                  color: selectedChoice.languageCode == s.languageCode ? getCurrentTheme(context).colorPrimary : getCurrentTheme(context).colorPreferencesChoiceChipBg,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: selectedChoice.languageCode == s.languageCode ? getCurrentTheme(context).colorPrimary : getCurrentTheme(context).colorBorder,
                    width: 0.6.sp,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      s.languageName,
                      style: bodyText(context:context,
                        textColor:
                            selectedChoice.languageCode == s.languageCode ? getCurrentTheme(context).colorWhite : getCurrentTheme(context).colorTextCommon,
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
