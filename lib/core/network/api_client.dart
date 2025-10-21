import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';
import '../navigation/navigation_service.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late Dio _dio;

  Dio get dio => _dio;

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(
      LogInterceptor(responseBody: true, requestBody: true),
    );
  }
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final secure = const FlutterSecureStorage();
    final token = await secure.read(key: 'auth_token');

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Manejar tanto 401 como 403
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        final newToken = await const FlutterSecureStorage().read(
          key: 'auth_token',
        );

        // Reintentar la request original con un Dio limpio (sin interceptores)
        final retryDio = Dio();
        final opts = err.requestOptions;

        opts.headers['Authorization'] = 'Bearer $newToken';

        try {
          final response = await retryDio.fetch(opts);
          handler.resolve(response);
          return;
        } catch (e) {
          print("Error reintentando petición después del refresh: $e");
        }
      } else {
        // Si no se puede refrescar, redirigir al login
        await _handleAuthFailure();
      }
    }
    handler.next(err);
  }

  Future<bool> _refreshToken() async {
    try {
      final secure = const FlutterSecureStorage();
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = await secure.read(key: 'refresh_token');

      if (refreshToken == null) return false;

      // Crear un Dio separado para evitar interceptores
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final response = await refreshDio.post(
        ApiConstants.refresh,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final newAccessToken = data['token'];
        final newRefreshToken = data['refreshToken'];

        if (newAccessToken == null || newRefreshToken == null) {
          return false;
        }

        await secure.write(key: 'auth_token', value: newAccessToken);
        await secure.write(key: 'refresh_token', value: newRefreshToken);
        // mantener email en prefs
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

  Future<void> _handleAuthFailure() async {
    final prefs = await SharedPreferences.getInstance();
    final secure = const FlutterSecureStorage();
    await secure.delete(key: 'auth_token');
    await secure.delete(key: 'refresh_token');
    await prefs.remove('user_email');

    // Redirigir al login o mostrar un mensaje
    NavigationService.navigateToLogin();
  }
}
