import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

// Modelo para Login Request
@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

// Modelo para Register Request
@JsonSerializable()
class RegisterRequest {
  final String email;
  final String password;
  final String dni;
  final String name;
  final String lastName;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.dni,
    required this.name,
    required this.lastName,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

// Modelo para Refresh Token Request
@JsonSerializable()
class RefreshTokenRequest {
  final String refreshToken;

  const RefreshTokenRequest({required this.refreshToken});

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);
}

// Modelo para Auth Response
@JsonSerializable()
class AuthResponse {
  final String token;
  final String refreshToken;

  const AuthResponse({required this.token, required this.refreshToken});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
