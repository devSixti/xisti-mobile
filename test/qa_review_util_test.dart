import 'package:flutter_test/flutter_test.dart';

import 'package:app_xisti/utils/qa_review_util.dart';

void main() {
  test('QA review phone numbers are defined', () {
    expect(kQaReviewPhoneNumbers, contains('3009876543'));
    expect(kQaReviewPhoneNumbers, contains('3001234567'));
  });
}
