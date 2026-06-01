import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';

import '../appThemeManager/app_theme_colors.dart';
import '../constant/dimensions.dart';
import '../main.dart';
import '../utils/custom_icons.dart';
import '../utils/style_util.dart';
import 'custom_text_field.dart';

class CustomDropDownFieldWithTextFieldCustom<T> extends StatefulWidget {
  final List<T> selectionItemList;
  final BehaviorSubject<T?>? selectedItemStream;
  final String Function(T) getLabel;
  final bool Function(T a, T b)? isSelected;
  final IconData? commonPrefixIcon;
  final String? hintText;
  final double? maxHeight;
  final String Function(String)? validator;
  final TextEditingController selectedItemTEC;

  final bool setError;

  const CustomDropDownFieldWithTextFieldCustom({
    super.key,
    required this.selectionItemList,
    required this.selectedItemTEC,
    required this.selectedItemStream,
    required this.getLabel,
    this.isSelected,
    this.hintText,
    this.commonPrefixIcon,
    this.maxHeight,
    this.validator,
    this.setError = true,
  }) : assert(selectionItemList.length >= 1);

  @override
  State<CustomDropDownFieldWithTextFieldCustom<T>> createState() => _CustomDropDownFieldWithTextField<T>();
}

class _CustomDropDownFieldWithTextField<T> extends State<CustomDropDownFieldWithTextFieldCustom<T>> {
  final _showDropDownItems = BehaviorSubject.seeded(false);
  final _scrollController = ScrollController();

  @override
  void initState() {
    _changeSelectedItem(widget.selectedItemStream?.valueOrNull);
    super.initState();
  }

  @override
  void dispose() {
    _showDropDownItems.close();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedItem(T? selectedItem) {
    if (selectedItem == null) return;
    final index = widget.selectionItemList.indexWhere((item) => widget.isSelected?.call(item, selectedItem) ?? item == selectedItem);
    if (index != -1 && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(index * 43.h, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      });
    }
  }

  void _changeSelectedItem(T? item) {
    if (item != null) {
      widget.selectedItemTEC.text = widget.getLabel(item);
      widget.selectedItemStream?.sink.add(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T?>(
      stream: widget.selectedItemStream,
      builder: (context, selectedItemSnapshot) {
        final selectedItem = selectedItemSnapshot.data;
        return StreamBuilder<bool>(
          stream: _showDropDownItems,
          builder: (context, showDropDownItemSnapshot) {
            final showItem = showDropDownItemSnapshot.data ?? false;
            if (selectedItem != null && context.mounted && showItem) {
              _scrollToSelectedItem(selectedItem);
            }
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: getCurrentTheme(context).colorBorder, width: 1.sp),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormFieldCustom(
                    controller: widget.selectedItemTEC,
                    keyboardType: TextInputType.text,
                    readOnly: true,
                    backgroundColor: Colors.transparent,
                    onTap: () {
                      _showDropDownItems.sink.add(!showItem);
                    },
                    suffix: Padding(
                      padding: EdgeInsetsDirectional.only(end: 15.sp),
                      child: Icon(CustomIcons.arrowDown, size: 15.sp, color: getCurrentTheme(context).colorIconCommon),
                    ),
                    hint: widget.hintText ?? languages.selectItem,
                    commonPrefixIcon: widget.commonPrefixIcon,
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                    ),
                    setError: widget.setError,
                    validator: (value) {
                      return widget.validator?.call(value) ?? "";
                    },
                  ),
                  if (showItem)
                    Container(
                      margin: EdgeInsetsDirectional.only(top: 5.h),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
                      clipBehavior: Clip.antiAlias,
                      constraints: BoxConstraints(minHeight: 50.h, maxHeight: widget.maxHeight ?? 135.h),
                      child: ListView.separated(
                        controller: _scrollController,
                        shrinkWrap: true,
                        padding: EdgeInsetsDirectional.only(bottom: 10.h),
                        itemCount: widget.selectionItemList.length,
                        itemBuilder: (context, index) {
                          final item = widget.selectionItemList[index];
                          final isSelected = selectedItem != null && (widget.isSelected?.call(item, selectedItem) ?? item == selectedItem);

                          return GestureDetector(
                            onTap: () {
                              _changeSelectedItem(item);
                              _showDropDownItems.sink.add(false);
                            },
                            child: Container(
                              margin: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                              padding: EdgeInsetsDirectional.symmetric(vertical: 5.h, horizontal: 10.w),
                              decoration: BoxDecoration(
                                color: isSelected ? getCurrentTheme(context).colorPrimary.withValues(alpha: 0.2) : null,
                                borderRadius: BorderRadiusDirectional.all(Radius.circular(10.r)),
                              ),
                              child: Text(widget.getLabel(item), style: bodyText(context: context, fontSize: textSize14px, fontWeight: FontWeight.w500)),
                            ),
                          );
                        },
                        separatorBuilder: (_, _) {
                          return Padding(
                            padding: EdgeInsetsDirectional.symmetric(vertical: 7.h),
                            child: Divider(height: 0, thickness: 0.7.sp, color: getCurrentTheme(context).colorBlack),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
