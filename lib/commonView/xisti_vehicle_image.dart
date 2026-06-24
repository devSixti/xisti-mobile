import 'package:flutter/material.dart';

import 'load_image_with_placeholder.dart';

/// Vehicle icon without baked-in white box — uses transparent PNG assets.
class XistiVehicleImage extends StatelessWidget {
  final String? imagePath;
  final double size;
  final BoxFit fit;
  final bool isNetwork;

  const XistiVehicleImage({
    super.key,
    required this.imagePath,
    required this.size,
    this.fit = BoxFit.contain,
    this.isNetwork = false,
  });

  @override
  Widget build(BuildContext context) {
    final src = imagePath ?? '';
    if (src.isEmpty) {
      return SizedBox(width: size, height: size);
    }
    final network = isNetwork || !src.startsWith('assets/');
    return SizedBox(
      width: size,
      height: size,
      child: LoadImageWithPlaceHolder(
        width: size,
        height: size,
        imageFit: fit,
        isNetworkImage: network,
        image: src,
        defaultAssetImage: 'assets/images/app_icon.png',
        borderRadius: BorderRadius.zero,
      ),
    );
  }
}
