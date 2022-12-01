import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static final _storage = FlutterSecureStorage();

  static const _keyAccessToken = 'access_token';

  static Future<void> setAccessToken(String accessToken) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
  }

  static Future<String?> getAccessToken() async =>
      await _storage.read(key: _keyAccessToken);

  static Future<void> deleteAccessToken() async {
    _storage.delete(key: _keyAccessToken);
  }
}
