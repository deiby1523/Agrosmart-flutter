// =============================================================================
// AUTH MODELS - DTOs para Autenticación (Request/Response)
// =============================================================================
// Modelos serializables para comunicación con la API de autenticación
// - LoginRequest: Credenciales de login
// - RegisterRequest: Datos de registro de usuario + granja
// - AuthResponse: Tokens devueltos por el servidor

import 'package:json_annotation/json_annotation.dart';
import 'farm_model.dart';

part 'auth_models.g.dart';

// =============================================================================
// LOGIN REQUEST
// =============================================================================
// POST /auth/authenticate
// Body: { "email": "user@example.com", "password": "********" }

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  // --- JSON Serialization (Auto-generated) ---
  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

// =============================================================================
// REGISTER REQUEST
// =============================================================================
// POST /auth/register
// Body: { "email", "password", "dni", "name", "lastName", "farm": {...} }

@JsonSerializable()
class RegisterRequest {
  // --- User Info ---
  final String email;
  final String password;
  final String dni;
  final String name;
  final String lastName;

  // --- Farm Info (nested object) ---
  final FarmModel farm;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.dni,
    required this.name,
    required this.lastName,
    required this.farm,
  });

  // --- JSON Serialization (Auto-generated) ---
  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

// =============================================================================
// AUTH RESPONSE
// =============================================================================
// Response de /auth/authenticate y /auth/register
// { "token": "eyJhbG...", "refreshToken": "eyJhbG..." }

@JsonSerializable()
class AuthResponse {
  final String token;         // Access token (JWT, corta duración)
  final String refreshToken;  // Refresh token (larga duración)

  const AuthResponse({
    required this.token,
    required this.refreshToken,
  });

  // --- JSON Serialization (Auto-generated) ---
  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}