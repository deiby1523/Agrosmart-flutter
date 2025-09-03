import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/auth_models.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient = ApiClient();
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _emailKey = 'user_email';

  @override
  Future<User> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      
      final response = await _apiClient.dio.post(
        ApiConstants.authenticate,
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);
      
      // Guardar tokens en storage local
      await _saveUserData(email, authResponse.token, authResponse.refreshToken);
      
      return User(
        email: email,
        token: authResponse.token,
        refreshToken: authResponse.refreshToken,
      );
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<User> register(String email, String password, String dni, String name, String lastname) async {
    try {
      final request = RegisterRequest(email: email, password: password, dni: dni, name: name, lastName: lastname);
      
      final response = await _apiClient.dio.post(
        ApiConstants.register,
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);
      
      // Guardar tokens en storage local
      await _saveUserData(email, authResponse.token, authResponse.refreshToken);
      
      return User(
        email: email,
        token: authResponse.token,
        refreshToken: authResponse.refreshToken,
      );
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<User> refreshToken(String refreshToken) async {
    try {
      final request = RefreshTokenRequest(refreshToken: refreshToken);
      
      final response = await _apiClient.dio.post(
        ApiConstants.refresh,
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);
      
      // Obtener email guardado
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString(_emailKey) ?? '';
      
      // Actualizar tokens en storage local
      await _saveUserData(email, authResponse.token, authResponse.refreshToken);
      
      return User(
        email: email,
        token: authResponse.token,
        refreshToken: authResponse.refreshToken,
      );
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_emailKey);
  }

  @override
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final refreshToken = prefs.getString(_refreshTokenKey);
    final email = prefs.getString(_emailKey);

    if (token != null && refreshToken != null && email != null) {
      return User(
        email: email,
        token: token,
        refreshToken: refreshToken,
      );
    }
    return null;
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }

  Future<void> _saveUserData(String email, String token, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  String _handleAuthError(dynamic error) {
    if (error.toString().contains('400')) {
      return 'Credenciales inválidas';
    } else if (error.toString().contains('401')) {
      return 'No autorizado';
    } else if (error.toString().contains('404')) {
      return 'Usuario no encontrado';
    } else if (error.toString().contains('500')) {
      return 'Error del servidor';
    }
    return 'Error de conexión';
  }
}