import 'package:flutter_test/flutter_test.dart';

import 'package:app_xisti/utils/invoice_util.dart';

void main() {
  test('driver invoice deduction matches 8% commission plus 19% VAT', () {
    final deduction = computeDriverInvoiceDeduction(
      10000,
      commissionRate: 0.08,
      vatRate: 0.19,
    );
    expect(deduction.commissionAmount, 800);
    expect(deduction.vatOnCommission, 152);
    expect(deduction.totalDeduction, 952);
    expect(deduction.netForDriver, 9048);
  });

  test('deductionFromApiFields uses server breakdown when provided', () {
    final deduction = deductionFromApiFields(
      rideFare: 10000,
      commissionAmount: 800,
      vatOnCommission: 152,
      totalDeduction: 952,
      netDriverPay: 9048,
    );
    expect(deduction, isNotNull);
    expect(deduction!.netForDriver, 9048);
  });
}
