import 'dart:developer';

import 'package:agrosmart_flutter/data/models/paginated_response_model.dart';
import 'package:agrosmart_flutter/domain/entities/paginated_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/milking_model.dart';
import '../../domain/entities/milking.dart';
import '../../domain/repositories/milking_repository.dart';

// =============================================================================
// MILKING REPOSITORY IMPL - Implementación del Repositorio de Ordeños
// =============================================================================
// Coordina operaciones CRUD con la API de registros de ordeño
// - GET: Listar todos los registros de ordeño / Obtener por ID
// - POST: Crear nuevo registro de ordeño
// - PATCH: Actualizar registro de ordeño (parcial)
// - DELETE: Eliminar registro de ordeño
// Endpoints: /farm/{farmId}/milkings (farmId inyectado por interceptor)

@riverpod
MilkingRepositoryImpl milkingRepository(Ref ref) {
  return MilkingRepositoryImpl();
}

class MilkingRepositoryImpl implements MilkingRepository {
  final ApiClient _apiClient = ApiClient();

  @override
  Future<PaginatedResponse<Milking>> getMilkings({
    int page = 1,
    int size = 10,
  }) async {
    try {
      // GET /farm/{farmId}/milkings?page=$page&size=$size
      final response = await _apiClient.dio.get(
        ApiConstants.milkings,
        queryParameters: {'page': page, 'size': size, 'sort': 'date,desc',},
      );

      log(response.toString());

      // Parsear la respuesta paginada
      final paginatedResponse = PaginatedResponseModel<MilkingModel>.fromJson(
        response.data,
        (json) => MilkingModel.fromJson(json),
      );

      // Convertir a entities
      return paginatedResponse.toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- GET: Single Milking by ID ---
  @override
  Future<Milking> getMilkingById(int id) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.milkings}/$id');
      return MilkingModel.fromJson(response.data).toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- POST: Create Milking ---
  @override
  Future<Milking> createMilking(Milking milking) async {
    log(milking.toString());

    try {
      final milkingModel = MilkingModel.fromEntity(milking);
      final response = await _apiClient.dio.post(
        ApiConstants.milkings,
        data: milkingModel.toJson(),
      );
      log(milkingModel.toJson().toString());
      log("Se hizo POST para registro de ordeño");
      log(response.data.toString());
      return MilkingModel.fromJson(response.data).toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- PATCH: Update Milking (Partial) ---
  @override
  Future<Milking> updateMilking(int id, Map<String, dynamic> updates) async {
    try {
      // Usar directamente el map de updates en lugar de MilkingUpdateRequest
      // para mayor flexibilidad
      final response = await _apiClient.dio.patch(
        '${ApiConstants.milkings}/$id',
        data: updates,
      );
      return MilkingModel.fromJson(response.data).toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- DELETE: Remove Milking ---
  @override
  Future<void> deleteMilking(int id) async {
    try {
      await _apiClient.dio.delete('${ApiConstants.milkings}/$id');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- GET: Milkings by Lot ---
  @override
  Future<List<Milking>> getMilkingsByLot(int lotId) async {
    try {
      // GET /farm/{farmId}/milkings?lotId={lotId}
      final response = await _apiClient.dio.get(
        ApiConstants.milkings,
        queryParameters: {'lotId': lotId},
      );
      
      // Parsear array de JSON a lista de Milking entities
      final List<dynamic> data = response.data['items'] ?? response.data;
      return data.map((json) => MilkingModel.fromJson(json).toEntity()).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- GET: Milkings by Date Range ---
  @override
  Future<List<Milking>> getMilkingsByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      // GET /farm/{farmId}/milkings?startDate={startDate}&endDate={endDate}
      final response = await _apiClient.dio.get(
        ApiConstants.milkings,
        queryParameters: {
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        },
      );
      
      // Parsear array de JSON a lista de Milking entities
      final List<dynamic> data = response.data['items'] ?? response.data;
      return data.map((json) => MilkingModel.fromJson(json).toEntity()).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.response?.statusCode) {
        case 400:
          return 'Datos inválidos del ordeño';
        case 404:
          return 'Registro de ordeño no encontrado';
        case 409:
          return 'El registro de ordeño ya existe';
        case 500:
          return 'Error del servidor';
        default:
          return 'Error de conexión: ${error.message}';
      }
    }
    log('$error, Error en milkingRepository');
    return 'Error desconocido';
  }
}