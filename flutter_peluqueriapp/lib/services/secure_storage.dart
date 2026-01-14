import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static const _keyAccessToken = 'accessToken';
  static const _keyTokenType = 'tokenType';

  Future<void> saveToken(String token, String type) async {
    await _storage.write(key: _keyAccessToken, value: token);
    await _storage.write(key: _keyTokenType, value: type);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  Future<String?> getTokenType() async {
    return await _storage.read(key: _keyTokenType);
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
