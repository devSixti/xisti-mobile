import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageWidgetPlaceholder extends StatelessWidget {
  const ImageWidgetPlaceholder({
    super.key,
    required this.image,
    required this.placeholder,
    this.errorHolder,
    this.size,
    this.radius,
    this.isCircular,
    this.fit = BoxFit.cover,
  });

  final ImageProvider image;
  final Widget placeholder;
  final Widget? errorHolder;
  final double? size;
  final double? radius;
  final bool? isCircular;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final double defaultSize = isCircular ?? false ? radius ?? 80.sp : size ?? 80.sp;

    final double defaultRadius = isCircular ?? false ? (radius ?? defaultSize / 2) : radius ?? 0;
    return SizedBox(
      height: defaultSize,
      width: defaultSize,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(defaultRadius),
        child: Image(
          image: image,
          fit: fit,
          height: defaultSize,
          width: defaultSize,
          errorBuilder: (context, error, stackTrace) {
            return Center(child: errorHolder ?? const Icon(Icons.error));
          },
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            } else {
              return AnimatedSwitcher(duration: const Duration(milliseconds: 500), child: frame != null ? child : placeholder);
            }
          },
        ),
      ),
    );
  }
}
