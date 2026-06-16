import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/utils.dart';
import '../utils/xisti_ui_tokens.dart';

/// Branded bottom sheet header + handle shared across offer/booking flows.
class XistiBottomSheetShell extends StatelessWidget {
  final String title;
  final VoidCallback? onClose;
  final List<Widget> children;
  final bool scrollable;
  final EdgeInsetsGeometry? padding;

  const XistiBottomSheetShell({
    super.key,
    required this.title,
    this.onClose,
    required this.children,
    this.scrollable = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            margin: EdgeInsetsDirectional.only(top: 10.h, bottom: 12.h),
            width: 48.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: theme.colorIndicatorOff,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        Row(
          children: [
            Text(
              'XISTI',
              style: bodyText(
                context: context,
                fontSize: textSize12px,
                fontWeight: FontWeight.w800,
                textColor: XistiBrand.green,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: bodyText(context: context, fontSize: textSize18px, fontWeight: FontWeight.w600),
              ),
            ),
            if (onClose != null)
              GestureDetector(
                onTap: onClose,
                child: Icon(CustomIcons.cancel, size: 24.sp, color: theme.colorIconCommon),
              ),
          ],
        ),
        SizedBox(height: 12.h),
        ...children,
      ],
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScaffoldBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(XistiUiTokens.sheetRadius)),
        boxShadow: XistiUiTokens.floatingShadow(context, theme.colorBorder),
      ),
      padding: padding ??
          EdgeInsetsDirectional.only(
            start: commonHorizontalPadding,
            end: commonHorizontalPadding,
            bottom: getBottomMargin(),
            top: 8.h,
          ),
      child: scrollable
          ? SingleChildScrollView(child: content)
          : content,
    );
  }
}
