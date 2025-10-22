// =============================================================================
// AUTH REPOSITORY - Contrato de Autenticación
// =============================================================================
// Define las operaciones esenciales para la autenticación de usuarios en el
// sistema AgroSmart. Esta interfaz abstrae la fuente de datos, permitiendo
// diferentes implementaciones (por ejemplo, HTTP, local o mock).
//
// Funciones clave:
// - Inicio y cierre de sesión
// - Registro de nuevos usuarios
// - Renovación de tokens
// - Validación del estado de sesión
//
// Implementación esperada: `AuthRepositoryImpl`

import '../entities/auth_session.dart';
import '../entities/farm.dart';

abstract class AuthRepository {
  /// Inicia sesión con las credenciales proporcionadas y retorna una [AuthSession]
  Future<AuthSession> login(String email, String password);

  /// Registra un nuevo usuario y retorna su [AuthSession]
  Future<AuthSession> register(
    String email,
    String password,
    String dni,
    String name,
    String lastname,
    Farm farm,
  );

  /// Renueva el token de acceso utilizando un [refreshToken] válido
  Future<AuthSession> refreshToken(String refreshToken);

  /// Cierra la sesión activa del usuario
  Future<void> logout();

  /// Retorna la sesión actual almacenada (si existe)
  Future<AuthSession?> getCurrentSession();

  /// Verifica si hay un usuario autenticado actualmente
  Future<bool> isUserLoggedIn();
}
