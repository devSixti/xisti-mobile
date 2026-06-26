import '../networking/base_dl.dart';
import 'app_mobile_settings.dart';
import 'utils.dart';

/// Driver invoice breakdown (commission + VAT on commission).
class DriverInvoiceDeduction {
  final double tripValue;
  final double commissionAmount;
  final double vatOnCommission;
  final double totalDeduction;
  final double netForDriver;

  const DriverInvoiceDeduction({
    required this.tripValue,
    required this.commissionAmount,
    required this.vatOnCommission,
    required this.totalDeduction,
    required this.netForDriver,
  });
}

DriverInvoiceDeduction computeDriverInvoiceDeduction(
  dynamic tripValue, {
  double? commissionRate,
  double? vatRate,
}) {
  final v = double.tryParse(tripValue.toString()) ?? 0;
  final rate = commissionRate ?? (getAdminCommissionPercent() / 100);
  final vat = vatRate ?? (getVatRateOnCommissionPercent() / 100);
  final commission = v * rate;
  final vatOnCommission = commission * vat;
  final totalDeduction = commission + vatOnCommission;
  return DriverInvoiceDeduction(
    tripValue: v,
    commissionAmount: commission,
    vatOnCommission: vatOnCommission,
    totalDeduction: totalDeduction,
    netForDriver: v - totalDeduction,
  );
}

DriverInvoiceDeduction? deductionFromApiFields({
  required dynamic rideFare,
  dynamic commissionAmount,
  dynamic vatOnCommission,
  dynamic totalDeduction,
  dynamic netDriverPay,
}) {
  if (commissionAmount == null && vatOnCommission == null) {
    return null;
  }
  final trip = double.tryParse(rideFare.toString()) ?? 0;
  return DriverInvoiceDeduction(
    tripValue: trip,
    commissionAmount: double.tryParse(commissionAmount.toString()) ?? 0,
    vatOnCommission: double.tryParse(vatOnCommission.toString()) ?? 0,
    totalDeduction: double.tryParse(totalDeduction.toString()) ?? 0,
    netForDriver: double.tryParse(netDriverPay.toString()) ?? trip,
  );
}

void appendDriverInvoiceDeductionLines({
  required List<KeyValueModel> keyValuesList,
  required dynamic rideFare,
  dynamic commissionAmount,
  dynamic vatOnCommission,
  dynamic totalDeduction,
  dynamic netDriverPay,
  dynamic commissionPercent,
}) {
  final deduction = deductionFromApiFields(
        rideFare: rideFare,
        commissionAmount: commissionAmount,
        vatOnCommission: vatOnCommission,
        totalDeduction: totalDeduction,
        netDriverPay: netDriverPay,
      ) ??
      computeDriverInvoiceDeduction(rideFare);
  if (deduction.tripValue <= 0) {
    return;
  }
  final percentLabel = _resolveCommissionPercentLabel(
    deduction,
    commissionPercent,
  );
  setKeyValuePair(
    keyValuesList: keyValuesList,
    setDivider: false,
    setBold: false,
    setValueWithCurrency: true,
    key: '${languages.platformCommission} (${percentLabel.toStringAsFixed(0)}%)',
    value: "${deduction.commissionAmount}",
  );
  setKeyValuePair(
    keyValuesList: keyValuesList,
    setDivider: false,
    setBold: false,
    setValueWithCurrency: true,
    key: '${languages.vatOnCommission} (${getVatRateOnCommissionPercent().toStringAsFixed(0)}%)',
    value: "${deduction.vatOnCommission}",
  );
  setKeyValuePair(
    keyValuesList: keyValuesList,
    setDivider: false,
    setBold: false,
    setValueWithCurrency: true,
    key: languages.totalDeduction,
    value: "${deduction.totalDeduction}",
  );
  setKeyValuePair(
    keyValuesList: keyValuesList,
    setDivider: false,
    setBold: true,
    setValueWithCurrency: true,
    key: languages.netDriverEarnings,
    value: "${deduction.netForDriver}",
  );
}

double _resolveCommissionPercentLabel(
  DriverInvoiceDeduction deduction,
  dynamic commissionPercent,
) {
  final fromApi = double.tryParse(commissionPercent?.toString() ?? '');
  if (fromApi != null && fromApi > 0) {
    return fromApi;
  }
  if (deduction.tripValue > 0 && deduction.commissionAmount > 0) {
    return deduction.commissionAmount / deduction.tripValue * 100;
  }
  return getAdminCommissionPercent();
}
