// =============================================================================
// FARM ID INTERCEPTOR - Interceptor de Inyección de ID de Granja
// =============================================================================
// Interceptor personalizado para inyectar automáticamente el ID de la granja activa
// en las solicitudes HTTP cuyo endpoint contenga la ruta /api/farm/{farmId}.
//
// Funcionalidad principal:
// - Detecta si la URL contiene el patrón /api/farm/{farmId}.
// - Sustituye {farmId} por el ID real obtenido desde ActiveFarmService.
// - Rechaza la solicitud si no existe una granja activa.
//
// Ejemplo:
//   /api/farm/{farmId}/lots → /api/farm/12/lots
//
// Dependencias:
// - ActiveFarmService: Servicio encargado de obtener la granja activa desde cache.

import 'package:dio/dio.dart';
import 'active_farm_service.dart';

class FarmIdInterceptor extends Interceptor {
  final ActiveFarmService _farmService;
  final RegExp _farmIdPattern = RegExp(r'/api/farm/\{farmId\}');

  FarmIdInterceptor(this._farmService);

  // --- REQUEST INTERCEPTION ---
  /// Intercepta las solicitudes salientes y reemplaza el marcador `{farmId}`
  /// por el ID real de la granja activa. Si no hay una granja seleccionada,
  /// la solicitud se rechaza con un error de tipo [DioException].
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Verifica si la ruta contiene el patrón /api/farm/{farmId}
    if (_farmIdPattern.hasMatch(options.path)) {
      try {
        // Obtiene el ID de la granja activa y reemplaza el marcador en la URL
        final farmId = await _farmService.getActiveFarmIdOrThrow();
        options.path = options.path.replaceAll('{farmId}', farmId.toString());
        handler.next(options);
      } catch (e) {
        // Si no hay granja activa, rechaza la solicitud con un mensaje claro
        handler.reject(
          DioException(
            requestOptions: options,
            error: 'No hay una granja activa seleccionada',
          ),
        );
      }
    } else {
      // Si la ruta no requiere ID de granja, continúa normalmente
      handler.next(options);
    }
  }
}
