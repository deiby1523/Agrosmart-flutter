import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/paddock_model.dart';
import '../../domain/entities/paddock.dart';
import '../../domain/repositories/paddock_repository.dart';

// =============================================================================
// PADDOCK REPOSITORY IMPL - Implementación del Repositorio de Corrales
// =============================================================================
// Coordina operaciones CRUD con la API de corrales (paddocks)
// - GET: Listar todos los corrales / Obtener por ID
// - POST: Crear nuevo corral
// - PATCH: Actualizar corral (parcial)
// - DELETE: Eliminar corral
// Endpoints: /farm/{farmId}/paddocks (farmId inyectado por interceptor)

class PaddockRepositoryImpl implements PaddockRepository {
  final ApiClient _apiClient = ApiClient();

  // --- GET: All Paddocks ---
  @override
  Future<List<Paddock>> getPaddocks() async {
    try {
      // GET /farm/{farmId}/paddocks
      final response = await _apiClient.dio.get(ApiConstants.paddocks);
      
      // Parsear array JSON a lista de entidades Paddock
      final List<dynamic> data = response.data;
      return data.map((json) => PaddockModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- GET: Single Paddock by ID ---
  @override
  Future<Paddock> getPaddockById(int id) async {
    try {
      // GET /farm/{farmId}/paddocks/{id}
      final response = await _apiClient.dio.get('${ApiConstants.paddocks}/$id');
      
      return PaddockModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- POST: Create Paddock ---
  @override
  Future<Paddock> createPaddock(Paddock paddock) async {
    try {
      // Convertir entity a model para serialización
      final paddockModel = PaddockModel.fromEntity(paddock);
      
      // POST /farm/{farmId}/paddocks
      final response = await _apiClient.dio.post(
        ApiConstants.paddocks,
        data: paddockModel.toJson(),
      );
      
      // Retornar corral creado (con ID asignado por el servidor)
      return PaddockModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- PATCH: Update Paddock (Partial) ---
  @override
  Future<Paddock> updatePaddock(int id, Map<String, dynamic> updates) async {
    try {
      // Construir request con solo campos modificados
      final updateRequest = PaddockUpdateRequest(
        name: updates['name'],
        location: updates['location'],
        surface: updates['surface'],
        description: updates['description'],
        grassType: updates['grassType'],
      );
      
      // PATCH /farm/{farmId}/paddocks/{id}
      final response = await _apiClient.dio.patch(
        '${ApiConstants.paddocks}/$id',
        data: updateRequest.toJson(),
      );
      
      // Retornar corral actualizado
      return PaddockModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- DELETE: Remove Paddock ---
  @override
  Future<void> deletePaddock(int id) async {
    try {
      // DELETE /farm/{farmId}/paddocks/{id}
      await _apiClient.dio.delete('${ApiConstants.paddocks}/$id');
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
          return 'Corral no encontrado';
        case 409:
          return 'El corral ya existe';
        case 500:
          return 'Error del servidor';
        default:
          return 'Error de conexión';
      }
    }
    return 'Error desconocido';
  }
}
