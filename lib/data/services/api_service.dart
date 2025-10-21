import 'package:dio/dio.dart';
import 'farm_id_interceptor.dart';
import 'active_farm_service.dart';

class ApiService {
  late final Dio _dio;
  final String baseUrl;

  ApiService({required this.baseUrl, required ActiveFarmService farmService}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Agregar el interceptor para manejar el farmId
    _dio.interceptors.add(FarmIdInterceptor(farmService));
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get(path, queryParameters: queryParameters, options: options);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // Agregar más métodos HTTP según sea necesario...
}
