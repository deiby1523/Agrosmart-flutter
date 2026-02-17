import 'package:agrosmart_flutter/data/services/jwt_service.dart';
import 'package:agrosmart_flutter/main.dart';
import 'package:agrosmart_flutter/presentation/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';

// =============================================================================
// API CLIENT - Cliente HTTP con Interceptores de Autenticación
// =============================================================================
// Singleton que configura Dio con:
// - AuthInterceptor: Inyecta Bearer token y maneja refresh automático
// - FarmIdInterceptor: Reemplaza {farmId} en URLs dinámicamente
// - LogInterceptor: Debugging de requests/responses

class ApiClient {
  // --- Singleton Pattern ---
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late Dio _dio;

  // --- Getter para acceso externo ---
  Dio get dio => _dio;

  // --- Inicialización del cliente ---
  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: 30000), // 30 segundos
        receiveTimeout: const Duration(milliseconds: 30000),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Orden de interceptores importa: Auth → FarmId → Logging
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(FarmIdInterceptor());
    _dio.interceptors.add(
      LogInterceptor(responseBody: true, requestBody: true),
    );
  }
}

// =============================================================================
// FARM ID INTERCEPTOR - Inyección Dinámica de FarmId
// =============================================================================
// Reemplaza {farmId} en las URLs con el ID de la granja activa
// Ejemplo: /farm/{farmId}/breeds → /farm/12345/breeds

class FarmIdInterceptor extends Interceptor {
  static const String _activeFarmKey = 'active_farm';

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Verificar si la URL contiene placeholder {farmId}
    if (options.path.contains('{farmId}')) {
      final prefs = await SharedPreferences.getInstance();
      final farmId = prefs.getInt(_activeFarmKey);

      if (farmId != null) {
        // Reemplazar placeholder con el ID real
        options.path = options.path.replaceAll('{farmId}', farmId.toString());
        handler.next(options);
      } else {
        // Rechazar request si no hay granja activa
        handler.reject(
          DioException(
            requestOptions: options,
            error: 'No hay una granja activa seleccionada',
            type: DioExceptionType.unknown,
          ),
        );
      }
    } else {
      // Endpoints sin {farmId} pasan sin modificación
      handler.next(options);
    }
  }
}

// =============================================================================
// AUTH INTERCEPTOR - Manejo de Autenticación y Refresh Token
// =============================================================================
// - Inyecta Bearer token en cada request
// - Detecta errores 401/403 (token expirado)
// - Intenta refresh automático
// - Redirige a login si el refresh falla

class AuthInterceptor extends Interceptor {
  // --- Request: Inyectar Bearer Token ---
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final secure = const FlutterSecureStorage();
    final token = await secure.read(key: 'auth_token');

    // Agregar header de autorización si existe token
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  // --- Error Handler: Auto-refresh en 401/403 ---
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Detectar token expirado (401) o prohibido (403)
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      final refreshed = await _refreshToken();

      if (refreshed) {
        // Token refrescado exitosamente → Reintentar request original
        final newToken = await const FlutterSecureStorage().read(
          key: 'auth_token',
        );

        // Crear Dio limpio (sin interceptores) para evitar recursión
        final retryDio = Dio();
        final opts = err.requestOptions;

        opts.headers['Authorization'] = 'Bearer $newToken';

        try {
          final response = await retryDio.fetch(opts);
          handler.resolve(response); // Resolver con respuesta exitosa
          return;
        } catch (e) {
          print("Error reintentando petición después del refresh: $e");
        }
      } else {
        // Refresh falló → Logout y redirigir a login
        await _handleAuthFailure();
      }
    }

    // Propagar error si no es 401/403
    handler.next(err);
  }

  // --- Private: Refrescar Access Token ---
  Future<bool> _refreshToken() async {
    try {
      final secure = const FlutterSecureStorage();
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = await secure.read(key: 'refresh_token');

      // Si no hay refresh token, no se puede refrescar
      if (refreshToken == null) return false;

      // Dio separado para evitar interceptores (prevenir loop infinito)
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // POST /auth/refresh con refresh token
      final response = await refreshDio.post(
        ApiConstants.refresh,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final newAccessToken = data['token'];
        final newRefreshToken = data['refreshToken'];

        // Validar que la respuesta contenga los tokens
        if (newAccessToken == null || newRefreshToken == null) {
          return false;
        }

        // Guardar nuevos tokens en secure storage
        await secure.write(key: 'auth_token', value: newAccessToken);
        await secure.write(key: 'refresh_token', value: newRefreshToken);

        // Procesar JWT para extraer info de la granja activa
        //TODO: Revisar esto despues() await jwtService.processJwtToken(newAccessToken);

        // Mantener email en SharedPreferences
        final email = prefs.getString('user_email');
        if (email != null) {
          await prefs.setString('user_email', email);
        }

        return true;
      }
    } catch (e) {
      print('Error refreshing token: $e');
      await _handleAuthFailure();
    }
    return false;
  }

  // --- Private: Limpiar sesión y redirigir a login ---
  Future<void> _handleAuthFailure() async {
    final prefs = await SharedPreferences.getInstance();
    final jwtService = JwtService(prefs);
    final secure = const FlutterSecureStorage();

    // Limpiar todos los datos de autenticación
    await secure.delete(key: 'auth_token');
    await secure.delete(key: 'refresh_token');
    await prefs.remove('user_email');
    await jwtService.clearFarmData();

    // Notificar logout al provider global (redirige a login)
    globalProviderContainer.read(authProvider.notifier).logout();
  }
}
