import 'package:dio/dio.dart';
import 'active_farm_service.dart';

class FarmIdInterceptor extends Interceptor {
  final ActiveFarmService _farmService;
  final RegExp _farmIdPattern = RegExp(r'/api/farm/\{farmId\}');

  FarmIdInterceptor(this._farmService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_farmIdPattern.hasMatch(options.path)) {
      try {
        final farmId = await _farmService.getActiveFarmIdOrThrow();
        options.path = options.path.replaceAll('{farmId}', farmId.toString());
        handler.next(options);
      } catch (e) {
        handler.reject(
          DioException(
            requestOptions: options,
            error: 'No hay una granja activa seleccionada',
          ),
        );
      }
    } else {
      handler.next(options);
    }
  }
}
