import '../hive/hive_helper.dart';
import 'phone_util.dart';

/// Colombian QA phones (must stay in sync with XistiQaTestUserSeeder).
const Set<String> kQaReviewPhoneNumbers = {
  '3001234567',
  '3009876543',
  '3189274610',
  '3156748293',
  '3128495761',
  '3197584620',
  '3164839207',
  '3145928673',
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
