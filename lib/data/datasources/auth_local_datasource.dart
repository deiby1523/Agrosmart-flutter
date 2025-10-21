import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  static const _tokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _emailKey = 'user_email';

  AuthLocalDataSource({required this.secureStorage});

  Future<void> saveTokens(
    String email,
    String token,
    String refreshToken,
  ) async {
    await secureStorage.write(key: _tokenKey, value: token);
    await secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  Future<Map<String, String?>> getTokensAndEmail() async {
    final token = await secureStorage.read(key: _tokenKey);
    final refreshToken = await secureStorage.read(key: _refreshTokenKey);
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_emailKey);
    return {'token': token, 'refreshToken': refreshToken, 'email': email};
  }

  Future<void> clear() async {
    await secureStorage.delete(key: _tokenKey);
    await secureStorage.delete(key: _refreshTokenKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
  }
}
