import 'dart:developer';

import 'package:agrosmart_flutter/core/constants/api_constants.dart';
import 'package:agrosmart_flutter/core/network/api_client.dart';
import 'package:agrosmart_flutter/domain/repositories/report_repository.dart';
import 'package:dio/dio.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ApiClient _apiClient = ApiClient();

  @override
  Future<void> downloadProductionReport({
    required List<int> loteIds,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String savePath,
  }) async {
    final payload = {
      "loteIds": loteIds,
      "fechaInicio": fechaInicio.toIso8601String(),
      "fechaFin": fechaFin.toIso8601String(),
    };

    // Apuntamos al endpoint correcto (ajusta la URL según tu API)
    const endpoint = ApiConstants.productionReport;

    try {
      final response = await _apiClient.dio.download(
        ApiConstants.productionReport,
        savePath,
        options: Options(
          method: 'POST',
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
        data: payload,
      );
      log("Peticion de reporte: $payload");
    } catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.response?.statusCode) {
        case 400:
          return 'Datos inválidos';
        case 404:
          return 'Animal no encontrado';
        case 409:
          return 'El animal ya existe';
        case 500:
          return 'Error del servidor';
        default:
          return 'Error de conexión';
      }
    }
    log('$error, Error en animalRepository');
    return 'Error desconocido';
  }
}
