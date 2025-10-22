// =============================================================================
// USER - Entidad de Usuario
// =============================================================================
// Representa un usuario dentro del sistema AgroSmart, con sus datos personales,
// credenciales y la granja a la que pertenece. Puede incluir información
// adicional de sesión como tokens de autenticación.
//
// Usos comunes:
// - Autenticación y gestión de sesión
// - Asociación del usuario con una granja determinada
// - Control de permisos y roles dentro de una granja

import 'package:agrosmart_flutter/domain/entities/farm.dart';

class User {
  /// Correo electrónico del usuario (utilizado para autenticación)
  final String email;

  /// Documento nacional de identidad o número de identificación
  final String dni;

  /// Nombre del usuario
  final String name;

  /// Apellido del usuario
  final String lastName;

  /// Granja asociada al usuario
  final Farm farm;

  /// Token de acceso (opcional, se usa para mantener la sesión activa)
  final String? token;

  /// Token de actualización (opcional, permite renovar la sesión)
  final String? refreshToken;

  /// Constructor constante de la entidad [User]
  const User({
    required this.email,
    required this.dni,
    required this.name,
    required this.lastName,
    required this.farm,
    this.token,
    this.refreshToken,
  });

  // --- COPY WITH ---
  /// Retorna una nueva instancia de [User] con los valores modificados.
  /// Los campos no proporcionados conservarán sus valores originales.
  User copyWith({
    String? email,
    String? dni,
    String? name,
    String? lastName,
    Farm? farm,
    String? token,
    String? refreshToken,
  }) {
    return User(
      email: email ?? this.email,
      dni: dni ?? this.dni,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      farm: farm ?? this.farm,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
