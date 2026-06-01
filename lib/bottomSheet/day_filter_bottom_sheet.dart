import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../commonView/common_view.dart';
import '../commonView/custom_rounded_button.dart';
import '../networking/base_dl.dart';
import '../utils/utils.dart';

class DayFilterBottomSheet extends StatefulWidget {
  final int selectedFilter;
  final List<HistoryFilterModel> filterSort;
  final Function(HistoryFilterModel) applyFilter;

  const DayFilterBottomSheet({super.key, required this.applyFilter, required this.filterSort, required this.selectedFilter});

  @override
  State<DayFilterBottomSheet> createState() => _DayFilterBottomSheetState();
}

class _DayFilterBottomSheetState extends State<DayFilterBottomSheet> {
  HistoryFilterModel? selectedValue;
  int selectedIndex = -1;

  @override
  void initState() {
    if (widget.filterSort.isNotEmpty) {
      selectedValue = widget.filterSort.firstWhere((element) => element.filterType == widget.selectedFilter, orElse: () => widget.filterSort.first);
      selectedIndex = widget.filterSort.indexWhere((element) => element.filterType == widget.selectedFilter);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: AlignmentDirectional.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(color: getCurrentTheme(context).colorScaffoldBg, borderRadius: bottomSheetBorderRadius30r),
              padding: bottomSheetPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          languages.sortByDays,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: headerText(context: context, fontSize: textSize22px, fontWeight: FontWeight.w600),
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
                  SizedBox(height: 20.h),

                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: widget.filterSort.length,
                      separatorBuilder: (context, index) => SizedBox(height: 20.h),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedValue = widget.filterSort[index];
                              selectedIndex = index;
                            });
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.filterSort[index].filterName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: bodyText(context: context, fontSize: textSize16px, fontWeight: FontWeight.w500),
                                ),
                              ),
                              radioButton(context, selectedValue != null && selectedValue?.filterType == widget.filterSort[index].filterType),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 30.h),

                  CustomRoundedButton(
                    context,
                    languages.apply,
                    () {
                      if (selectedValue != null) {
                        widget.applyFilter(selectedValue!);
                      }
                      Navigator.pop(context, true);
                    },
                    minWidth: double.maxFinite,
                    textSize: textSize16px,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
