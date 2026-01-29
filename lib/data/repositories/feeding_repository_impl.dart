import 'dart:developer';

import 'package:agrosmart_flutter/data/models/paginated_response_model.dart';
import 'package:agrosmart_flutter/data/repositories/breed_repository_impl.dart';
import 'package:agrosmart_flutter/domain/entities/paginated_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/feeding_model.dart';
import '../../domain/entities/feeding.dart';
import '../../domain/repositories/feeding_repository.dart';

// =============================================================================
// FEEDING REPOSITORY IMPL - Implementación del Repositorio de Alimentaciones
// =============================================================================
// Coordina operaciones CRUD con la API de razas
// - GET: Listar todas los feedings / Obtener por ID
// - POST: Crear nuevo feeding
// - PATCH: Actualizar feeding (parcial)
// - DELETE: Eliminar feeding
// Endpoints: /farm/{farmId}/feedings (farmId inyectado por interceptor)

@riverpod
BreedRepositoryImpl breedRepository(Ref ref) {
  return BreedRepositoryImpl();
}

class FeedingRepositoryImpl implements FeedingRepository {
  final ApiClient _apiClient = ApiClient();

  @override
  Future<PaginatedResponse<Feeding>> getFeedings({
    int page = 1,
    int size = 10,
  }) async {
    try {
      // GET /farm/{farmId}/feedings?page=$page&size=$size
      final response = await _apiClient.dio.get(
        ApiConstants.feedings,
        queryParameters: {'page': page, 'size': size},
      );

      // Parsear la respuesta paginada
      final paginatedResponse = PaginatedResponseModel<FeedingModel>.fromJson(
        response.data,
        (json) => FeedingModel.fromJson(json),
      );

      // Convertir a entities
      return paginatedResponse.toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- GET: Single Feeding by ID ---
  @override
  Future<Feeding> getFeedingById(int id) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.feedings}/$id');
      return FeedingModel.fromJson(response.data).toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- POST: Create Feeding ---
  @override
  Future<Feeding> createFeeding(Feeding feeding) async {
    try {
      final feedingModel = FeedingModel.fromEntity(feeding);
      // log(feedingModel.supplyId.toString());
      final response = await _apiClient.dio.post(
        ApiConstants.feedings,
        data: feedingModel.toJson(),
      );
      log(feedingModel.toJson().toString());
      // log("Se hizo POST");
      // log(response.data.toString());
      return FeedingModel.fromJson(response.data).toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- PATCH: Update Feeding (Partial) ---
  @override
  Future<Feeding> updateFeeding(int id, Map<String, dynamic> updates) async {
    try {
      // Usar directamente el map de updates en lugar de FeedingUpdateRequest
      // para mayor flexibilidad
      final response = await _apiClient.dio.patch(
        '${ApiConstants.feedings}/$id',
        data: updates,
      );
      return FeedingModel.fromJson(response.data).toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- DELETE: Remove Feeding ---
  @override
  Future<void> deleteFeeding(int id) async {
    try {
      await _apiClient.dio.delete('${ApiConstants.feedings}/$id');
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
          return 'Registro de alimentación no encontrado';
        case 409:
          return 'El registro de alimentación ya existe';
        case 500:
          return 'Error del servidor';
        default:
          return 'Error de conexión';
      }
    }
    log('$error, Error en feedingRepository');
    return 'Error desconocido';
  }
}
