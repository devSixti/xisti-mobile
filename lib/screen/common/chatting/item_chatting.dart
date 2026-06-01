import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/load_image_with_placeholder.dart';
import '../../../commonView/zoom_image_view.dart';
import '../../../utils/utils.dart';
import 'chatting_dl.dart';

class ItemChatting extends StatelessWidget {
  final ModelChatting modelChatting;
  final String userId;

  const ItemChatting({super.key, required this.userId, required this.modelChatting});

  @override
  Widget build(BuildContext context) {
    return userId.trim() == modelChatting.senderId
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsetsDirectional.only(top: 25.h, start: 80.sp, end: 20.w),
              decoration: BoxDecoration(
                color: getCurrentTheme(context).colorPrimary,
                borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(12.r), topStart: Radius.circular(12.r), bottomStart: Radius.circular(12.r)),
              ),
              child:
                  modelChatting.isImage == "1"
                      ? GestureDetector(
                        onTap: () {
                          openImageScreen(context, modelChatting.message);
                        },
                        child: Container(
                          height: 100.sp,
                          width: 100.sp,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.only(
                              topEnd: Radius.circular(12.r),
                              topStart: Radius.circular(12.r),
                              bottomStart: Radius.circular(12.r),
                            ),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: LoadImageSimple(isChatImage: true, image: modelChatting.message, width: 100.sp, height: 100.sp, imageFit: BoxFit.cover),
                        ),
                      )
                      : Container(
                        margin: EdgeInsetsDirectional.all(10.sp),
                        child: Text(
                          modelChatting.message,
                          textAlign: TextAlign.end,
                          style: bodyText(context: context, textColor: getCurrentTheme(context).colorWhite, fontWeight: FontWeight.w500),
                        ),
                      ),
            ),
            Container(
              margin: EdgeInsetsDirectional.only(top: 5.h, end: 20.w),
              child: Text(
                getTimeStampConvertDateTime(timeStamp: int.parse(modelChatting.date), returnFormat: "dd MMM yyyy, HH:mm aa"),
                textAlign: TextAlign.end,
                style: bodyText(context: context, fontSize: textSize12px, textColor: getCurrentTheme(context).colorTextLight),
              ),
            ),
          ],
        )
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsetsDirectional.only(top: 20.h, start: 20.w, end: 80.w),
              decoration: BoxDecoration(
                color: getCurrentTheme(context).colorOtherChatBg,
                borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(10.r), topStart: Radius.circular(10.r), bottomEnd: Radius.circular(10.r)),
              ),
              child:
                  modelChatting.isImage == "1"
                      ? GestureDetector(
                        onTap: () {
                          openImageScreen(context, modelChatting.message);
                        },
                        child: Container(
                          height: 100.sp,
                          width: 100.sp,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.only(
                              topEnd: Radius.circular(10.r),
                              topStart: Radius.circular(10.r),
                              bottomEnd: Radius.circular(10.r),
                            ),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: LoadImageSimple(isChatImage: true, image: modelChatting.message, width: 100.sp, height: 100.sp, imageFit: BoxFit.cover),
                        ),
                      )
                      : Container(
                        margin: EdgeInsetsDirectional.all(10.sp),
                        child: Text(modelChatting.message, textAlign: TextAlign.start, style: bodyText(context: context, fontWeight: FontWeight.w500)),
                      ),
            ),
            Container(
              margin: EdgeInsetsDirectional.only(top: 10.h, start: 20.w),
              child: Text(
                getTimeStampConvertDateTime(timeStamp: int.parse(modelChatting.date), returnFormat: "dd MMM yyyy, HH:mm aa"),
                textAlign: TextAlign.start,
                style: bodyText(context: context, fontSize: textSize12px, textColor: getCurrentTheme(context).colorTextLight),
              ),
            ),
          ],
        );
  }

  Future<void> openImageScreen(BuildContext context, String image) {
    return Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Opacity(opacity: const Interval(0.0, 1.0, curve: Curves.linear).transform(animation.value), child: ZoomImageView(image: image));
            },
          );
        },
      ),
    );
  }
}
