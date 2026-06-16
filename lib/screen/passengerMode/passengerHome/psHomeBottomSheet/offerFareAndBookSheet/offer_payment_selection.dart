import '../../../../../constant/constant.dart';

class OfferPaymentSelection {
  final String label;
  final int paymentType;
  final String destinationPaymentCode;

  const OfferPaymentSelection({
    required this.label,
    required this.paymentType,
    required this.destinationPaymentCode,
  });

  bool get isWallet => paymentType == PaymentType.wallet;
}
