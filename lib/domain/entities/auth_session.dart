// =============================================================================
// AUTH SESSION - Modelo de Sesión de Autenticación
// =============================================================================
// Representa la sesión autenticada del usuario dentro del sistema.
// Contiene los tokens de acceso, el token de actualización (refresh) y
// la información del usuario autenticado.

import 'user.dart';

class AuthSession {
  /// Token de acceso utilizado para autenticar solicitudes a la API
  final String token;

  /// Token de actualización usado para obtener un nuevo token de acceso
  final String refreshToken;

  /// Información del usuario autenticado
  final User user;

  /// Crea una nueva instancia de sesión de autenticación
  const AuthSession({
    required this.token,
    required this.refreshToken,
    required this.user,
  });
}
