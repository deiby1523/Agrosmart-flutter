// =============================================================================
// AUTH REMOTE DATASOURCE - Comunicación con API de Autenticación
// =============================================================================
// Maneja todas las peticiones HTTP relacionadas con autenticación
// - POST /auth/authenticate: Login
// - POST /auth/register: Registro de usuario
// - POST /auth/refresh: Renovar access token

import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/auth_models.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  // --- Constructor ---
  AuthRemoteDataSource({required this.apiClient});

  // --- POST: Login ---
  /// Autentica usuario con email y contraseña
  /// Returns: AuthResponse con tokens (access + refresh)
  Future<AuthResponse> login(LoginRequest request) async {
    final response = await apiClient.dio.post(
      ApiConstants.authenticate,
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data);
  }

  // --- POST: Register ---
  /// Registra un nuevo usuario en el sistema
  /// Returns: AuthResponse con tokens del usuario creado
  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await apiClient.dio.post(
      ApiConstants.register,
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data);
  }

  // --- POST: Refresh Token ---
  /// Renueva el access token usando el refresh token
  /// Returns: AuthResponse con nuevos tokens
  Future<AuthResponse> refresh(String refreshToken) async {
    final response = await apiClient.dio.post(
      ApiConstants.refresh,
      data: {'refreshToken': refreshToken},
    );
    return AuthResponse.fromJson(response.data);
  }
}