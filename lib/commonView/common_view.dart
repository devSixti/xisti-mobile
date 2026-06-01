import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../bottomSheet/additional_note_bottom_sheet.dart';
import '../bottomSheet/common_bottom_sheet.dart';
import '../hive/hive_helper.dart';
import '../screen/common/profile/profile.dart';
import '../utils/utils.dart';
import 'common_circular_progress_indicator.dart';

export '../bottomSheet/common_bottom_sheet.dart';
export 'scaffold_with_safe_area.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? elevation, scrollUnderElevation;
  final Color? backgroundColor;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;
  final bool? centerTitle;
  final double? titleSpacing;
  final double? toolbarHeight;
  final double? leadingWidth;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool automaticallyImplyLeading;

  const CommonAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.scrollUnderElevation,
    this.backgroundColor,
    this.shadowColor,
    this.shape,
    this.foregroundColor,
    this.iconTheme,
    this.centerTitle,
    this.titleSpacing,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: title,
      actions: actions,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      elevation: elevation ?? 0,
      scrolledUnderElevation: scrollUnderElevation ?? 0,
      backgroundColor: backgroundColor ?? getCurrentTheme(context).colorAppBarDefault,
      surfaceTintColor: backgroundColor ?? getCurrentTheme(context).colorAppBarDefault,
      shadowColor: shadowColor ?? Colors.transparent,
      shape: shape,
      foregroundColor: foregroundColor,
      iconTheme: iconTheme,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,
      toolbarTextStyle: toolbarTextStyle,
      titleTextStyle: titleTextStyle,
      systemOverlayStyle: systemOverlayStyle ?? getCurrentTheme(context).systemUiOverlayStyle,
    );
  }

  @override
  Size get preferredSize {
    return _PreferredAppBarSize(toolbarHeight ?? AppBar().preferredSize.height, bottom?.preferredSize.height ?? 0);
  }
}

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight) : super.fromHeight((toolbarHeight) + (bottomHeight));

  final double toolbarHeight;
  final double bottomHeight;
}

Widget indicator(bool isActive) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 150),
    margin: EdgeInsets.symmetric(horizontal: 5.w),
    height: isActive ? 5.sp : 5.sp,
    width: isActive ? 30.w : 5.sp,
    decoration: BoxDecoration(
      borderRadius: isActive ? BorderRadiusDirectional.circular(15.r) : BorderRadiusDirectional.circular(1.r),
      color: isActive ? getCurrentTheme(navigatorKey.currentContext!).colorPrimary : getCurrentTheme(navigatorKey.currentContext!).colorIndicatorOff,
    ),
  );
}

Widget backButtonCustom({required BuildContext context, required Function() onBackPress}) {
  return GestureDetector(
    onTap: () {
      onBackPress.call();
    },
    child: Container(
      width: 30.sp,
      height: 30.sp,
      decoration: BoxDecoration(
        border: Border.all(color: getCurrentTheme(context).colorIndicatorOff, width: 1.sp),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Transform(
        alignment: AlignmentDirectional.center,
        transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
        child: Icon(CustomIcons.backButton, color: getCurrentTheme(context).colorIconCommon, size: 24.sp),
      ),
    ),
  );
}

Widget backButtonForAppBarCustom({required BuildContext context, required Function() onBackPress}) {
  return GestureDetector(
    onTap: () {
      onBackPress.call();
    },
    child: Container(
      width: 30.sp,
      height: 30.sp,
      padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, top: 10.h, bottom: 10.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: getCurrentTheme(context).colorBorder, width: 1.sp),
        ),
        child: Transform(
          alignment: AlignmentDirectional.center,
          transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
          child: Icon(CustomIcons.backButton, color: getCurrentTheme(context).colorIconCommon, size: 20.sp),
        ),
      ),
    ),
  );
}

Widget appVersionName({Color? textColor}) {
  if (!kIsWeb) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
        return Text(
          (snapshot.data != null && snapshot.data?.version != null) ? "V${snapshot.data!.version}" : "",
          textAlign: TextAlign.center,
          maxLines: 1,
          style: bodyText(context: context, textColor: textColor ?? getCurrentTheme(context).colorTextCommon, fontSize: textSize14px, fontWeight: FontWeight.w600),
        );
      },
    );
  } else {
    return Container();
  }
}

class AppErrorWidget extends StatelessWidget {
  final String? errorMessage;

  final Function()? onRetryPressed;

  const AppErrorWidget({super.key, this.errorMessage, this.onRetryPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (errorMessage != null)
            Text(
              errorMessage ?? "",
              textAlign: TextAlign.center,
              style: bodyText(context: context, textColor: Colors.red),
            ),
          if (errorMessage != null) const SizedBox(height: 8),
          IconButton(
            onPressed: onRetryPressed,
            icon: const Icon(Icons.refresh, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

Widget buildChatAndCallButton(BuildContext context, IconData icon, Function() onTap) {
  return GestureDetector(
    onTap: () {
      onTap.call();
    },
    child: Container(
      padding: EdgeInsetsDirectional.all(5.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.all(Radius.circular(8.r)),
        border: Border.all(color: getCurrentTheme(context).colorIconCommon),
      ),
      child: Icon(icon, color: getCurrentTheme(context).colorIconCommon, size: 14.sp),
    ),
  );
}

Widget radioButton(BuildContext context, bool isSelected) {
  return Container(
    height: 20.sp,
    width: 20.sp,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: isSelected ? getCurrentTheme(context).colorPrimary : getCurrentTheme(context).colorBorder, width: isSelected ? 5.sp : 1.sp),
    ),
  );
}

void openRequiredInfoBottomSheet(BuildContext context, Function onPositivePress) {
  if (isEmailOrNumNull()) {
    String mess = "";
    if (getStringFromUserInfoBox(hiveEmail).trim().isEmpty) {
      mess = "- ${languages.emailAddress}\n";
    }
    if (getStringFromUserInfoBox(hiveContactNumber).trim().isEmpty) {
      mess = "$mess- ${languages.contactNumber}";
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CommonBottomSheet(
          title: languages.requiredMess,
          message: mess,
          positiveButtonTxt: languages.ok,
          negativeButtonTxt: languages.cancel,
          onPositivePress: () {
            Navigator.pop(context, true);
            openScreenWithResult(context, ProfileScreen()).then((value) {
              if (value != null && value) {
                onPositivePress();
              }
            });
          },
          onNegativePress: () {
            Navigator.pop(context);
          },
        );
      },
    );
  } else {
    onPositivePress();
  }
}

class FullScreenProgress extends StatelessWidget {
  final String message;

  const FullScreenProgress({super.key, this.message = ""});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: getCurrentTheme(context).colorBlack.withValues(alpha: 0.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonCircularProgressIndicator(strokeWidth: 2.4.sp, size: 21.sp, color: getCurrentTheme(context).colorWhite),
            Container(
              margin: EdgeInsetsDirectional.only(top: 10.h),
              child: Text(
                message,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: bodyText(context: context, textColor: getCurrentTheme(context).colorWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget dayFilterTabItemView(BuildContext context, {required String text}) {
  return Container(
    padding: EdgeInsetsDirectional.symmetric(vertical: 10.h, horizontal: 15.w),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.r), color: getCurrentTheme(context).colorPrimary),
    child: Row(
      children: [
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: bodyText(context: context, fontSize: textSize14px, fontWeight: FontWeight.w600, textColor: getCurrentTheme(context).colorWhite),
        ),
        Padding(
          padding: EdgeInsetsDirectional.only(start: 10.w),
          child: Icon(CustomIcons.arrowDown, color: getCurrentTheme(context).colorWhite, size: 15.sp),
        ),
      ],
    ),
  );
}

Widget filterTabItemView(BuildContext context, {required bool isSelected, required String text}) {
  return Container(
    margin: EdgeInsetsDirectional.symmetric(vertical: 1.h),
    padding: EdgeInsetsDirectional.symmetric(vertical: 10.h, horizontal: 15.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15.r),
      color: isSelected ? getCurrentTheme(context).colorPrimary : Colors.transparent,
      border: Border.all(color: isSelected ? Colors.transparent : getCurrentTheme(context).colorTextFieldBorder, width: 0.5.sp),
    ),
    child: Row(
      children: [
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: bodyText(
            context: context,
            fontSize: textSize14px,
            fontWeight: FontWeight.w600,
            textColor: isSelected ? getCurrentTheme(context).colorWhite : getCurrentTheme(context).colorTextCommon,
          ),
        ),
        if (isSelected) ...[SizedBox(width: 10.w), Icon(CustomIcons.removeFilled, color: getCurrentTheme(context).colorWhite, size: 15.sp)],
      ],
    ),
  );
}

class AdditionalNoteView extends StatelessWidget {
  final String title, additionalNote;
  final EdgeInsetsDirectional? sideMargin;

  const AdditionalNoteView({super.key, required this.title, required this.additionalNote, this.sideMargin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          enableDrag: false,
          isDismissible: false,
          isScrollControlled: true,
          builder: (context) {
            return AdditionalNoteBottomSheet(title: title, additionalNote: additionalNote);
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: getCurrentTheme(context).colorSelectionPrimaryOpc,
          border: Border.all(color: getCurrentTheme(context).colorPrimary, width: 0.5.w),
          borderRadius: BorderRadius.circular(15.r),
        ),
        margin: sideMargin,
        padding: EdgeInsetsDirectional.all(15.sp),
        child: Row(
          children: [
            Icon(CustomIcons.edit, color: getCurrentTheme(context).colorStaticBlack, size: 20.sp),
            Expanded(
              child: Container(
                margin: EdgeInsetsDirectional.only(start: 10.w),
                child: Text(
                  title,
                  style: bodyText(context: context, fontWeight: FontWeight.w500, fontSize: textSize14px),
                ),
              ),
            ),
            Transform(
              alignment: AlignmentDirectional.center,
              transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
              child: Icon(CustomIcons.arrowForward, color: getCurrentTheme(context).colorStaticBlack, size: 20.sp),
            ),
          ],
        ),
      ),
    );
  }
}
