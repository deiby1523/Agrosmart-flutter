import 'dart:developer';

import 'package:agrosmart_flutter/data/models/paginated_response_model.dart';
import 'package:agrosmart_flutter/domain/entities/paginated_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/supply_model.dart';
import '../../domain/entities/supply.dart';
import '../../domain/repositories/supply_repository.dart';

// =============================================================================
// SUPPLY REPOSITORY IMPL - Implementación del Repositorio de Insumos
// =============================================================================
// Coordina operaciones CRUD con la API de registros de insumo
// - GET: Listar todos los registros de insumo / Obtener por ID
// - POST: Crear nuevo registro de insumo
// - PATCH: Actualizar registro de insumo (parcial)
// - DELETE: Eliminar registro de insumo
// Endpoints: /farm/{farmId}/supplies (farmId inyectado por interceptor)

@riverpod
SupplyRepositoryImpl supplyRepository(Ref ref) {
  return SupplyRepositoryImpl();
}

class SupplyRepositoryImpl implements SupplyRepository {
  final ApiClient _apiClient = ApiClient();

  @override
  Future<PaginatedResponse<Supply>> getSupplies({
    int page = 1,
    int size = 10,
  }) async {
    try {
      // GET /farm/{farmId}/supplies?page=$page&size=$size
      final response = await _apiClient.dio.get(
        ApiConstants.supplies,
        queryParameters: {'page': page, 'size': size},
      );

      log(response.toString());

      // Parsear la respuesta paginada
      final paginatedResponse = PaginatedResponseModel<SupplyModel>.fromJson(
        response.data,
        (json) => SupplyModel.fromJson(json),
      );

      // Convertir a entities
      return paginatedResponse.toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- GET: Single Supply by ID ---
  @override
  Future<Supply> getSupplyById(int id) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.supplies}/$id');
      return SupplyModel.fromJson(response.data).toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- POST: Create Supply ---
  @override
  Future<Supply> createSupply(Supply supply) async {
    log(supply.toString());

    try {
      final supplyModel = SupplyModel.fromEntity(supply);
      final response = await _apiClient.dio.post(
        ApiConstants.supplies,
        data: supplyModel.toJson(),
      );
      log(supplyModel.toJson().toString());
      log("Se hizo POST para registro de insumo");
      log(response.data.toString());
      return SupplyModel.fromJson(response.data).toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- PATCH: Update Supply (Partial) ---
  @override
  Future<Supply> updateSupply(int id, Map<String, dynamic> updates) async {
    try {
      // Usar directamente el map de updates en lugar de SupplyUpdateRequest
      // para mayor flexibilidad
      final response = await _apiClient.dio.patch(
        '${ApiConstants.supplies}/$id',
        data: updates,
      );
      return SupplyModel.fromJson(response.data).toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- DELETE: Remove Supply ---
  @override
  Future<void> deleteSupply(int id) async {
    try {
      await _apiClient.dio.delete('${ApiConstants.supplies}/$id');
    } catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.response?.statusCode) {
        case 400:
          return 'Datos del insumo inválidos';
        case 404:
          return 'Insumo no encontrado';
        case 409:
          return 'El registro de insumo ya existe';
        case 500:
          return 'Error del servidor';
        default:
          return 'Error de conexión: ${error.message}';
      }
    }
    log('$error, Error en supplyRepository');
    return 'Error desconocido';
  }
}