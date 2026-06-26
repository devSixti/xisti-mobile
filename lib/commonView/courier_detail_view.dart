import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'ride_detail_item.dart';

class CourierDetailView extends StatelessWidget {
  final String itemDesc, recipientName, recipientNumber;
  final double estimatedPrice;
  final String? packageWeightKg;
  final String? packageHeightCm;
  final String? packageWidthCm;
  final String? packageLengthCm;

  const CourierDetailView({
    super.key,
    required this.itemDesc,
    required this.recipientName,
    required this.recipientNumber,
    this.estimatedPrice = 0,
    this.packageWeightKg,
    this.packageHeightCm,
    this.packageWidthCm,
    this.packageLengthCm,
  });

  String _dimensionLine() {
    final parts = <String>[];
    if ((packageWeightKg ?? '').isNotEmpty) {
      parts.add('$packageWeightKg kg');
    }
    final h = packageHeightCm ?? '';
    final w = packageWidthCm ?? '';
    final l = packageLengthCm ?? '';
    if (h.isNotEmpty && w.isNotEmpty && l.isNotEmpty) {
      parts.add('$h × $w × $l cm');
    }
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = _dimensionLine();
    return Column(
      children: [
        RideDetailItem(iconData: CustomIcons.manageInformation, titleText: "${languages.itemDesc} :", mainText: itemDesc),
        if (dimensions.isNotEmpty)
          RideDetailItem(iconData: CustomIcons.manageInformation, titleText: "${languages.packageSizeLabel} :", mainText: dimensions),
        RideDetailItem(iconData: CustomIcons.name, titleText: "${languages.recipientName} :", mainText: recipientName),
        RideDetailItem(iconData: CustomIcons.call, titleText: "${languages.recipientNumber} :", mainText: recipientNumber),
        if (estimatedPrice > 0)
          RideDetailItem(
            iconData: CustomIcons.paymentMethod,
            titleText: "${languages.parcelEstimatedPrice} :",
            mainText: getAmountWithCurrency(estimatedPrice),
          ),
      ],
    );
  }
}
