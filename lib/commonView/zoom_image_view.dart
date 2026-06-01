import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';

import '../appThemeManager/app_theme_colors.dart';
import '../constant/dimensions.dart';
import 'scaffold_with_safe_area.dart';

class ZoomImageView extends StatelessWidget {
  final String image;

  const ZoomImageView({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithSafeArea(
      backgroundColor: Colors.black54,
      body: Builder(
        builder:
            (context) => Stack(
              children: [
                Hero(
                  createRectTween: (Rect? begin, Rect? end) {
                    return MaterialRectCenterArcTween(begin: begin, end: end);
                  },
                  tag: image,
                  child: PhotoView(
                    imageProvider: NetworkImage(image),
                    backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                    minScale: PhotoViewComputedScale.contained,
                  ),
                ),
                SafeArea(
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: Container(
                            width: 35.sp,
                            height: 35.sp,
                            padding: EdgeInsets.all(5.sp),
                            margin: EdgeInsetsDirectional.only(top: 20.h, end: commonHorizontalPadding),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: getCurrentTheme(context).colorBlack),
                            child: Icon(Icons.cancel_rounded, size: 20.sp, color: getCurrentTheme(context).colorWhite),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
