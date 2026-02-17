import 'dart:developer';

import 'package:agrosmart_flutter/core/constants/api_constants.dart';
import 'package:agrosmart_flutter/core/network/api_client.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
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

    const endpoint = ApiConstants.productionReport;

    try {
      final response = await _apiClient.dio.download(
        endpoint,
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

  @override
  Future<void> downloadSupplyReport({
    required String? tipoInsumo,
    required DateTime? fechaInicio,
    required DateTime? fechaFin,
    required String savePath,
  }) async {
    final payload = {
      "tipoInsumo": tipoInsumo,
      "fechaInicio": fechaInicio?.toIso8601String(),
      "fechaFin": fechaFin?.toIso8601String(),
    };

    const endpoint = ApiConstants.supplyReport;

    try {
      final response = await _apiClient.dio.download(
        endpoint,
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

  @override
  Future<void> downloadAnimalReport({
    required Lot? lote,
    required String? sexo,
    required String? estado,
    required String? estadoSalud,
    required String savePath,
  }) async {
    final payload = {
      "loteId": lote?.id,
      "sexo": sexo,
      "estado": estado,
      "estadoSalud": estadoSalud,
    };

    const endpoint = ApiConstants.animalReport;

    try {
      final response = await _apiClient.dio.download(
        endpoint,
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

  @override
  Future<void> downloadFeedingReport({
    required Lot? lote,
    required DateTime? fechaInicio,
    required DateTime? fechaFin,
    required String savePath,
  }) async {
    final payload = {
      "loteId": lote?.id,
      "fechaInicio": fechaInicio?.toIso8601String(),
      "fechaFin": fechaFin?.toIso8601String(),
    };

    const endpoint = ApiConstants.feedingReport;

    try {
      final response = await _apiClient.dio.download(
        endpoint,
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

  @override
  Future<void> downloadPaddockReport({
    required String savePath,
  }) async {

    const endpoint = ApiConstants.paddockReport;

    try {
      final response = await _apiClient.dio.download(
        endpoint,
        savePath,
        options: Options(
          method: 'GET',
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );
      log("Peticion de reporte de potreros");
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> downloadLotReport({
    required String savePath,
  }) async {

    const endpoint = ApiConstants.lotReport;

    try {
      final response = await _apiClient.dio.download(
        endpoint,
        savePath,
        options: Options(
          method: 'GET',
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );
      log("Peticion de reporte de lotes");
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
