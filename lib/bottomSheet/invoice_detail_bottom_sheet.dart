import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../commonView/custom_rounded_button.dart';
import '../commonView/item_key_value.dart';
import '../commonView/scaffold_with_safe_area.dart';
import '../networking/base_dl.dart';
import '../utils/utils.dart';

class InvoiceDetailBottomSheet extends StatefulWidget {
  final List<KeyValueModel> invoiceList;

  const InvoiceDetailBottomSheet({super.key, required this.invoiceList});

  @override
  State<InvoiceDetailBottomSheet> createState() => _InvoiceDetailBottomSheetState();
}

class _InvoiceDetailBottomSheetState extends State<InvoiceDetailBottomSheet> {
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(top: 25.h, bottom: 20.h),
                        child: Text(
                          languages.invoiceDetail,
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.invoiceList.length,
                    itemBuilder: (context, position) {
                      return ItemKeyValue(keyValueModel: widget.invoiceList[position]);
                    },
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: CustomRoundedButton(
                    context,
                    languages.okay,
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
        ],
      ),
    );
  }
}
