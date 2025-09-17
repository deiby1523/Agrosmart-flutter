import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late Dio _dio;

  Dio get dio => _dio;

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
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
        final prefs = await SharedPreferences.getInstance();
        final newToken = prefs.getString('auth_token');

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
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');
      
      if (refreshToken == null) return false;

      // Crear un Dio separado para evitar interceptores
      final refreshDio = Dio(BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: {'Content-Type': 'application/json'},
      ));

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

        await prefs.setString('auth_token', newAccessToken);
        await prefs.setString('refresh_token', newRefreshToken);
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
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_email');
    
    // Aquí puedes redirigir al login o mostrar un mensaje
    // NavigationService.navigateToLogin();
  }
}
