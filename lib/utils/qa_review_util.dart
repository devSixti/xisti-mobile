import '../hive/hive_helper.dart';
import 'phone_util.dart';

/// Colombian QA phones used for store review and internal testing only.
const Set<String> kQaReviewPhoneNumbers = {
  '3009876543',
  '3001234567',
};

const String kQaReviewFixedOtp = '123456';

bool isQaReviewPhone() {
  final dialCode = getStringFromUserInfoBox(hiveCountryCode, defaultValue: '+57');
  if (!isColombiaDialCode(dialCode)) {
    return false;
  }
  final phone = normalizeLocalMobile(
    getStringFromUserInfoBox(hiveContactNumber),
    dialCode: dialCode,
  );
  return kQaReviewPhoneNumbers.contains(phone);
}
