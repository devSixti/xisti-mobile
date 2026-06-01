import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';
import 'language_and_currency_dl.dart';

class ItemAppTheme extends StatefulWidget {
  final int defaultSelected;
  final Function(AppThemeListItem) onSelectionChanged;

  const ItemAppTheme({super.key, required this.onSelectionChanged, this.defaultSelected = 0});

  @override
  ItemAppThemeState createState() => ItemAppThemeState();
}

class ItemAppThemeState extends State<ItemAppTheme> {
  AppThemeListItem selectedTheme = AppThemeListItem(languages.systemSelected, 0);

  List<AppThemeListItem> availableThemes = [
    AppThemeListItem(languages.systemSelected, 0),
    AppThemeListItem(languages.light, 1),
    AppThemeListItem(languages.dark, 2),
  ];

  @override
  void initState() {
    if (availableThemes.isNotEmpty) {
      if (widget.defaultSelected >= 0 && widget.defaultSelected <= 2) {
        selectedTheme = availableThemes[widget.defaultSelected];
      } else {
        selectedTheme = availableThemes[0];
      }
      widget.onSelectionChanged(selectedTheme);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 15.w,
      children: availableThemes.map<GestureDetector>(
        (AppThemeListItem appThemeListItem) {

          return  GestureDetector(
            onTap: () {
              setState(() {
                selectedTheme = appThemeListItem;
                widget.onSelectionChanged(selectedTheme);
              });
            },
            child: Container(
              height: 45.h,
              margin: EdgeInsetsDirectional.only(top: 15.h,bottom: 1.h),
              padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w),
              decoration: BoxDecoration(
                color: selectedTheme.appThemeCode == appThemeListItem.appThemeCode ? getCurrentTheme(context).colorPrimary : getCurrentTheme(context).colorPreferencesChoiceChipBg,
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: selectedTheme.appThemeCode ==appThemeListItem.appThemeCode ? getCurrentTheme(context).colorPrimary : getCurrentTheme(context).colorBorder,
                  width: 0.6.sp,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    appThemeListItem.appThemeName,
                    style: bodyText(context:context,
                      textColor:
                      selectedTheme.appThemeCode == appThemeListItem.appThemeCode ? getCurrentTheme(context).colorWhite : getCurrentTheme(context).colorTextCommon,
                      fontWeight: FontWeight.w500,
                    ).copyWith(height: 0),
                  ),
                ],
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
