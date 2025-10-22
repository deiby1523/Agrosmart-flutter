import 'dart:developer';
import 'package:agrosmart_flutter/data/models/farm_model.dart';
import 'package:agrosmart_flutter/domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/auth_models.dart';
import '../services/jwt_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/farm.dart';
import '../mappers/auth_mapper.dart';

/// =============================================================================
/// # AUTH REPOSITORY IMPLEMENTATION
/// Implementación del repositorio de autenticación según los principios
/// de *Clean Architecture*.
/// 
/// Coordina las fuentes de datos (`AuthRemoteDataSource`, `AuthLocalDataSource`)
/// y servicios (`JwtService`) para manejar:
/// 
/// - **Login:** Autenticación y persistencia local de tokens.
/// - **Register:** Registro de nuevos usuarios con su primera granja.
/// - **Refresh:** Renovación automática de tokens.
/// - **Logout:** Limpieza completa de la sesión.
/// - **Session Management:** Recuperación de la sesión actual.
/// =============================================================================
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final JwtService jwtService;

  /// Constructor principal que inyecta las dependencias requeridas.
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.jwtService,
  });

  /// ---------------------------------------------------------------------------
  /// ## Login: Autenticación de Usuario
  /// 
  /// 1. Envía las credenciales del usuario al servidor.
  /// 2. Decodifica el JWT para obtener las granjas asociadas.
  /// 3. Guarda la primera granja como activa por defecto.
  /// 4. Persiste los tokens y el email localmente.
  /// 5. Retorna la sesión activa (`AuthSession`).
  /// ---------------------------------------------------------------------------
  @override
  Future<AuthSession> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final authResponse = await remoteDataSource.login(request);

      final claims = jwtService.decodeToken(authResponse.token);
      if (claims != null && claims.farms.isNotEmpty) {
        await jwtService.saveActiveFarm(claims.farms.first);
        log("Granja activa establecida con ID: ${claims.farms.first.id}");
      }

      await localDataSource.saveTokens(
        email,
        authResponse.token,
        authResponse.refreshToken,
      );

      return authSessionFromResponse(authResponse, email: email);
    } catch (e) {
      throw Exception(_handleAuthError(e));
    }
  }

  /// ---------------------------------------------------------------------------
  /// ## Register: Registro de Nuevo Usuario
  /// 
  /// Crea un nuevo usuario y su primera granja asociada.
  /// 
  /// Flujo:
  /// 1. Convierte la entidad `Farm` en `FarmModel`.
  /// 2. Envía el `RegisterRequest` a la API.
  /// 3. Decodifica el JWT para obtener y guardar la granja activa.
  /// 4. Persiste los tokens localmente.
  /// 5. Retorna la sesión del nuevo usuario.
  /// ---------------------------------------------------------------------------
  @override
  Future<AuthSession> register(
    String email,
    String password,
    String dni,
    String name,
    String lastName,
    Farm farm,
  ) async {
    try {
      final farmModel = FarmModel.fromEntity(farm);
      final request = RegisterRequest(
        email: email,
        password: password,
        dni: dni,
        name: name,
        lastName: lastName,
        farm: farmModel,
      );

      final authResponse = await remoteDataSource.register(request);

      final claims = jwtService.decodeToken(authResponse.token);
      if (claims != null && claims.farms.isNotEmpty) {
        await jwtService.saveActiveFarm(claims.farms.first);
      }

      await localDataSource.saveTokens(
        email,
        authResponse.token,
        authResponse.refreshToken,
      );

      return authSessionFromResponse(authResponse, email: email);
    } catch (e) {
      throw Exception(_handleAuthError(e));
    }
  }

  /// ---------------------------------------------------------------------------
  /// ## Refresh Token: Renovar Access Token
  /// 
  /// 1. Solicita nuevos tokens a la API usando el refresh token actual.
  /// 2. Recupera el email almacenado localmente.
  /// 3. Decodifica el nuevo JWT y actualiza la granja activa.
  /// 4. Guarda los nuevos tokens localmente.
  /// 5. Retorna la sesión actualizada.
  /// ---------------------------------------------------------------------------
  @override
  Future<AuthSession> refreshToken(String refreshToken) async {
    try {
      final authResponse = await remoteDataSource.refresh(refreshToken);

      final stored = await localDataSource.getTokensAndEmail();
      final email = stored['email'] ?? '';

      final claims = jwtService.decodeToken(authResponse.token);
      if (claims != null && claims.farms.isNotEmpty) {
        await jwtService.saveActiveFarm(claims.farms.first);
        log("Token renovado. Nueva granja activa ID: ${claims.farms.first.id}");
      }

      await localDataSource.saveTokens(
        email,
        authResponse.token,
        authResponse.refreshToken,
      );

      return authSessionFromResponse(authResponse, email: email);
    } catch (e) {
      throw Exception(_handleAuthError(e));
    }
  }

  /// ---------------------------------------------------------------------------
  /// ## Logout: Cerrar Sesión
  /// 
  /// Elimina los tokens locales y la información de granja activa.
  /// ---------------------------------------------------------------------------
  @override
  Future<void> logout() async {
    await localDataSource.clear();
    await jwtService.clearFarmData();
  }

  /// ---------------------------------------------------------------------------
  /// ## Get Current Session: Recuperar Sesión Activa
  /// 
  /// 1. Obtiene tokens y email desde almacenamiento local.
  /// 2. Valida la existencia de datos de sesión.
  /// 3. Recupera la granja activa.
  /// 4. Construye la entidad `User`.
  /// 5. Retorna una instancia de `AuthSession` si hay sesión válida.
  /// ---------------------------------------------------------------------------
  @override
  Future<AuthSession?> getCurrentSession() async {
    final stored = await localDataSource.getTokensAndEmail();
    final token = stored['token'];
    final refreshToken = stored['refreshToken'];
    final email = stored['email'];

    if (token != null && refreshToken != null && email != null) {
      final activeFarm = await jwtService.getActiveFarm();

      final user = User(
        email: email,
        dni: '', // TODO: Considerar extraer estos datos del JWT si están presentes.
        name: '',
        lastName: '',
        farm: Farm(
          id: activeFarm?.id ?? 0,
          name: activeFarm?.name ?? '',
          description: '',
          location: '',
        ),
        token: token,
        refreshToken: refreshToken,
      );

      return AuthSession(token: token, refreshToken: refreshToken, user: user);
    }

    return null;
  }

  /// ---------------------------------------------------------------------------
  /// ## isUserLoggedIn
  /// 
  /// Retorna `true` si existe una sesión válida, `false` en caso contrario.
  /// ---------------------------------------------------------------------------
  @override
  Future<bool> isUserLoggedIn() async {
    final session = await getCurrentSession();
    return session != null;
  }

  /// ---------------------------------------------------------------------------
  /// ## _handleAuthError (Privado)
  /// 
  /// Traduce errores HTTP comunes en mensajes legibles para el usuario.
  /// ---------------------------------------------------------------------------
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
