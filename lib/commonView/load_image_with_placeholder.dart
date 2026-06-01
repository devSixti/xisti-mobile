import 'package:flutter/material.dart';

import '../appThemeManager/app_theme_colors.dart';
import '../constant/dimensions.dart';
import '../main.dart';
import 'common_circular_progress_indicator.dart';

class LoadImageWithPlaceHolder extends StatelessWidget {
  final double height;
  final double width;
  final Color? color;
  final Color? defaultAssetColor;
  final String image;
  final String? defaultAssetImage;
  final bool isNetworkImage;
  final Widget? placeholder;
  final Widget? errorHolder;
  final BorderRadius? borderRadius;
  final BoxFit? imageFit;
  final BoxFit? placeholderFit;

  const LoadImageWithPlaceHolder({
    super.key,
    required this.width,
    required this.height,
    required this.image,
    this.defaultAssetImage = "assets/images/app_icon.png",
    this.defaultAssetColor,
    this.imageFit,
    this.placeholderFit,
    this.isNetworkImage = true,
    this.color,
    this.placeholder,
    this.errorHolder,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image(
          image: getImageProvider(),
          color: getColor(),
          fit: getBoxFit(),
          height: height,
          width: width,
          errorBuilder: (context, error, stackTrace) {
            return getErrorHolder();
          },
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return getFrameBuilder(child, frame, wasSynchronouslyLoaded);
          },
        ),
      ),
    );
  }

  ImageProvider getImageProvider() {
    return isNetworkImage ? (image.isNotEmpty ? NetworkImage(image) : AssetImage(defaultAssetImage ?? "")) : AssetImage(image);
  }

  Color? getColor() {
    return isNetworkImage
        ? (image.isNotEmpty ? (color) : ((defaultAssetImage == null) ? getCurrentTheme(navigatorKey.currentContext!).colorShimmerBg : (defaultAssetColor)))
        : (defaultAssetColor);
  }

  BoxFit getBoxFit() {
    return imageFit ?? (isNetworkImage ? (image.isNotEmpty ? BoxFit.cover : BoxFit.scaleDown) : BoxFit.cover);
  }

  Center getErrorHolder() {
    return Center(child: errorHolder ?? /*getPlaceHolderImage()*/ Container(color: getCurrentTheme(navigatorKey.currentContext!).colorShimmerBg));
  }

  Widget getFrameBuilder(Widget child, int? frame, bool wasSynchronouslyLoaded) {
    if (wasSynchronouslyLoaded) {
      return child;
    } else {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(opacity: animation, child: child),
        child:
            frame != null
                ? child
                : placeholder ??
                    /*Shimmer.fromColors(
                  baseColor: colorShimmerBg,
                  highlightColor: Colors.grey[100],
                  period: const Duration(milliseconds: 800),
                  child: getPlaceHolderImage(),
                )*/
                    Container(color: getCurrentTheme(navigatorKey.currentContext!).colorShimmerBg),
      );
    }
  }

  /*getPlaceHolderImage() {
    return Image.asset(
      "assets/images/login_image.png",
      fit: placeholderFit ?? BoxFit.scaleDown,
      height: double.infinity,
      width: double.infinity,
      color: colorPrimary,
    );
  }*/
}

class LoadImageSimple extends StatelessWidget {
  final String? image;
  final String? defaultAssetImage;
  final BoxFit? imageFit;
  final double? height;
  final double? width;
  final bool isFromSlider;
  final bool isChatImage;

  const LoadImageSimple({
    super.key,
    required this.image,
    this.defaultAssetImage,
    this.imageFit,
    this.height,
    this.width,
    this.isFromSlider = false,
    this.isChatImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Image(
      image: getImageProvider(),
      height: height,
      width: width,
      fit: imageFit,
      errorBuilder: (context, error, stackTrace) {
        if (isChatImage) {
          return Center(
            child: CommonCircularProgressIndicator(color: getCurrentTheme(context).colorPrimary, strokeWidth: cpiStrokeWidthRegular, size: cpiSizeRegular),
          );
        } else {
          return Container(color: getCurrentTheme(context).colorShimmerBg);
        }
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        return getFrameBuilder(context, child, frame, wasSynchronouslyLoaded);
      },
    );
  }

  Widget getFrameBuilder(BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
    if (wasSynchronouslyLoaded) {
      return child;
    } else {
      return AnimatedSwitcher(
        duration: Duration(milliseconds: isFromSlider ? 0 : 200),
        transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(opacity: animation, child: child),
        child:
            frame != null
                ? child
                : isChatImage
                ? Center(
                  child: CommonCircularProgressIndicator(
                    color: getCurrentTheme(context).colorPrimary,
                    strokeWidth: cpiStrokeWidthRegular,
                    size: cpiSizeRegular,
                  ),
                )
                : Container(color: getCurrentTheme(context).colorShimmerBg),
      );
    }
  }

  bool checkImageUrl() {
    bool checkedStatus = Uri.parse(image ?? "").isAbsolute;
    return checkedStatus;
  }

  ImageProvider getImageProvider() {
    return checkImageUrl() ? NetworkImage(image ?? "") : AssetImage(image ?? (defaultAssetImage ?? "assets/images/app_icon.png"));
  }
}
