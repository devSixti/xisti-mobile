import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'destination_payment_util.dart';
import 'utils.dart';

Widget buildOfferPaymentIcon(
  BuildContext context, {
  required int paymentType,
  required String destinationPaymentCode,
  double? size,
}) {
  final iconSize = size ?? 25.sp;
  final color = getCurrentTheme(context).colorIconCommon;

  if (paymentType == PaymentType.wallet) {
    return Icon(CustomIcons.wallet, size: iconSize, color: color);
  }

  switch (destinationPaymentCode) {
    case DestinationPaymentUtil.cash:
      return Icon(CustomIcons.cash, size: iconSize, color: color);
    case DestinationPaymentUtil.bancolombia:
      return _brandIcon('assets/images/payment_methods/bancolombia.png', iconSize);
    case DestinationPaymentUtil.nequi:
      return _brandIcon('assets/images/payment_methods/nequi.png', iconSize);
    case DestinationPaymentUtil.daviplata:
      return _brandIcon('assets/images/payment_methods/daviplata.png', iconSize);
    default:
      return Icon(CustomIcons.cash, size: iconSize, color: color);
  }
}

Widget _brandIcon(String asset, double size) {
  return Image.asset(
    asset,
    width: size,
    height: size,
    fit: BoxFit.contain,
    filterQuality: FilterQuality.high,
  );
}
