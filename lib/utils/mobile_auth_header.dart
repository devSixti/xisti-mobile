import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

import '../hive/hive_helper.dart';

void setAuthKey(String text) {
  final authKey = base64.encode(utf8.encode(text));
  final md5String = md5.convert(utf8.encode(authKey)).toString();
  const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final rnd = Random();
  String rand(int n) => String.fromCharCodes(
        Iterable.generate(n, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
      );
  putDataInSettingBox(hiveAuthKey, '${rand(57)}$md5String${rand(43)}');
}
