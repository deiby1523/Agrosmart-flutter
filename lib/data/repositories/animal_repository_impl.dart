import 'dart:developer';

import 'package:agrosmart_flutter/data/models/paginated_response_model.dart';
import 'package:agrosmart_flutter/domain/entities/paginated_response.dart';
import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/animal_model.dart';
import '../../domain/entities/animal.dart';
import '../../domain/repositories/animal_repository.dart';

// =============================================================================
// ANIMAL REPOSITORY IMPL - Implementación del Repositorio de Animales
// =============================================================================
// Coordina operaciones CRUD con la API de razas
// - GET: Listar todas los animales / Obtener por ID
// - POST: Crear nuevo animal
// - PATCH: Actualizar animal (parcial)
// - DELETE: Eliminar animal
// Endpoints: /farm/{farmId}/animals (farmId inyectado por interceptor)

class AnimalRepositoryImpl implements AnimalRepository {
  final ApiClient _apiClient = ApiClient();

  @override
  Future<PaginatedResponse<Animal>> getAnimals({
    int page = 1,
    int size = 10,
  }) async {
    try {
      // GET /farm/{farmId}/animals?page=$page&size=$size
      final response = await _apiClient.dio.get(
        ApiConstants.animals,
        queryParameters: {'page': page, 'size': size},
      );

      // log(response.toString());

      // Parsear la respuesta paginada
      final paginatedResponse = PaginatedResponseModel<AnimalModel>.fromJson(
        response.data,
        (json) => AnimalModel.fromJson(json),
      );

      // Convertir a entities
      return paginatedResponse.toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- GET: Single Animal by ID ---
  @override
  Future<Animal> getAnimalById(int id) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.animals}/$id');
      return AnimalModel.fromJson(response.data).toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- POST: Create Animal ---
  @override
  Future<Animal> createAnimal(Animal animal) async {
    // log(animal.toString());

    try {
      final animalModel = AnimalModel.fromEntity(animal);
      final response = await _apiClient.dio.post(
        ApiConstants.animals,
        data: animalModel.toJson(),
      );
      log(animalModel.toJson().toString());
      // log("Se hizo POST");
      // log(response.data.toString());
      return AnimalModel.fromJson(response.data).toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- PATCH: Update Animal (Partial) ---
  @override
  Future<Animal> updateAnimal(int id, Map<String, dynamic> updates) async {
    try {
      // Usar directamente el map de updates en lugar de AnimalUpdateRequest
      // para mayor flexibilidad
      final response = await _apiClient.dio.patch(
        '${ApiConstants.animals}/$id',
        data: updates,
      );
      return AnimalModel.fromJson(response.data).toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- DELETE: Remove Animal ---
  @override
  Future<void> deleteAnimal(int id) async {
    try {
      await _apiClient.dio.delete('${ApiConstants.animals}/$id');
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
