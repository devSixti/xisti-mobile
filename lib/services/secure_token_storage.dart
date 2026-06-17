import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../hive/hive_constant.dart';
import '../main.dart' show settingsBox;

/// Encrypted storage for session access_token (migrated from plain Hive).
class SecureTokenStorage {
  SecureTokenStorage._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _key = 'xisti_access_token';
  static String _cachedAccessToken = '';

  static Future<void> init() async {
    _cachedAccessToken = (await _storage.read(key: _key)) ?? '';
    final legacy = settingsBox.get(hiveAccessToken);
    if (legacy != null) {
      final legacyToken = legacy.toString().trim();
      if (legacyToken.isNotEmpty && _cachedAccessToken.isEmpty) {
        await writeAccessToken(legacyToken);
      }
      await settingsBox.delete(hiveAccessToken);
    }
  }

  static String readAccessToken() => _cachedAccessToken;

  static Future<void> writeAccessToken(String token) async {
    _cachedAccessToken = token;
    if (token.trim().isEmpty) {
      await _storage.delete(key: _key);
      return;
    }
    await _storage.write(key: _key, value: token);
  }

  static Future<void> clearAccessToken() async {
    _cachedAccessToken = '';
    await _storage.delete(key: _key);
  }
}
