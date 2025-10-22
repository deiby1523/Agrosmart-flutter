import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// =============================================================================
// AUTH LOCAL DATASOURCE - Almacenamiento Local de Autenticación
// =============================================================================
// Maneja persistencia de tokens y email del usuario
// - Tokens: FlutterSecureStorage (encriptado)
// - Email: SharedPreferences (plain text, para UI)

class AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  
  // --- Storage Keys ---
  static const _tokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _emailKey = 'user_email';

  // --- Constructor ---
  AuthLocalDataSource({required this.secureStorage});

  // --- Save: Tokens + Email ---
  /// Guarda los tokens de autenticación y el email del usuario
  /// - Tokens: Secure Storage (encriptado en el dispositivo)
  /// - Email: SharedPreferences (para mostrar en UI sin desencriptar)
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

  // --- Read: Tokens + Email ---
  /// Obtiene todos los datos de autenticación guardados
  /// Returns: Map con 'token', 'refreshToken' y 'email' (nullable)
  Future<Map<String, String?>> getTokensAndEmail() async {
    final token = await secureStorage.read(key: _tokenKey);
    final refreshToken = await secureStorage.read(key: _refreshTokenKey);
    
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_emailKey);
    
    return {
      'token': token,
      'refreshToken': refreshToken,
      'email': email,
    };
  }

  // --- Clear: Logout ---
  /// Elimina todos los datos de autenticación
  /// Usado al hacer logout o cuando los tokens expiran
  Future<void> clear() async {
    await secureStorage.delete(key: _tokenKey);
    await secureStorage.delete(key: _refreshTokenKey);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
  }
}