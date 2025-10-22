import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/breed_model.dart';
import '../../domain/entities/breed.dart';
import '../../domain/repositories/breed_repository.dart';

// =============================================================================
// BREED REPOSITORY IMPL - Implementación del Repositorio de Razas
// =============================================================================
// Coordina operaciones CRUD con la API de razas
// - GET: Listar todas las razas / Obtener por ID
// - POST: Crear nueva raza
// - PATCH: Actualizar raza (parcial)
// - DELETE: Eliminar raza
// Endpoints: /farm/{farmId}/breeds (farmId inyectado por interceptor)

class BreedRepositoryImpl implements BreedRepository {
  final ApiClient _apiClient = ApiClient();

  // --- GET: All Breeds ---
  @override
  Future<List<Breed>> getBreeds() async {
    try {
      // GET /farm/{farmId}/breeds
      final response = await _apiClient.dio.get(ApiConstants.breeds);
      
      // Parsear array de JSON a lista de Breed entities
      final List<dynamic> data = response.data;
      return data.map((json) => BreedModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- GET: Single Breed by ID ---
  @override
  Future<Breed> getBreedById(int id) async {
    try {
      // GET /farm/{farmId}/breeds/{id}
      final response = await _apiClient.dio.get('${ApiConstants.breeds}/$id');
      
      return BreedModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- POST: Create Breed ---
  @override
  Future<Breed> createBreed(Breed breed) async {
    try {
      // Convertir entity a model para serialización
      final breedModel = BreedModel.fromEntity(breed);
      
      // POST /farm/{farmId}/breeds
      final response = await _apiClient.dio.post(
        ApiConstants.breeds,
        data: breedModel.toJson(),
      );
      
      // Retornar raza creada (con ID asignado por el servidor)
      return BreedModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- PATCH: Update Breed (Partial) ---
  @override
  Future<Breed> updateBreed(int id, Map<String, dynamic> updates) async {
    try {
      // Construir request con solo campos modificados
      final updateRequest = BreedUpdateRequest(
        name: updates['name'],
        description: updates['description'],
      );
      
      // PATCH /farm/{farmId}/breeds/{id}
      final response = await _apiClient.dio.patch(
        '${ApiConstants.breeds}/$id',
        data: updateRequest.toJson(),
      );
      
      // Retornar raza actualizada
      return BreedModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- DELETE: Remove Breed ---
  @override
  Future<void> deleteBreed(int id) async {
    try {
      // DELETE /farm/{farmId}/breeds/{id}
      await _apiClient.dio.delete('${ApiConstants.breeds}/$id');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- Private: Error Handler ---
  /// Convierte errores HTTP en mensajes amigables para el usuario
  String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.response?.statusCode) {
        case 400:
          return 'Datos inválidos';
        case 404:
          return 'Raza no encontrada';
        case 409:
          return 'La raza ya existe';
        case 500:
          return 'Error del servidor';
        default:
          return 'Error de conexión';
      }
    }
    return 'Error desconocido';
  }
}