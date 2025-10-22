import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/lot_model.dart';
import '../../domain/entities/lot.dart';
import '../../domain/repositories/lot_repository.dart';

// =============================================================================
// LOT REPOSITORY IMPL - Implementación del Repositorio de Lotes
// =============================================================================
// Coordina operaciones CRUD con la API de lotes de ganado
// - GET: Listar todos los lotes / Obtener por ID
// - POST: Crear nuevo lote
// - PATCH: Actualizar lote (parcial)
// - DELETE: Eliminar lote
// Endpoints: /farm/{farmId}/lots (farmId inyectado por interceptor)

class LotRepositoryImpl implements LotRepository {
  final ApiClient _apiClient = ApiClient();

  // --- GET: All Lots ---
  @override
  Future<List<Lot>> getLots() async {
    try {
      // GET /farm/{farmId}/lots
      final response = await _apiClient.dio.get(ApiConstants.lots);
      
      // Parsear array de JSON a lista de Lot entities
      final List<dynamic> data = response.data;
      return data.map((json) => LotModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- GET: Single Lot by ID ---
  @override
  Future<Lot> getLotById(int id) async {
    try {
      // GET /farm/{farmId}/lots/{id}
      final response = await _apiClient.dio.get('${ApiConstants.lots}/$id');
      
      return LotModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- POST: Create Lot ---
  @override
  Future<Lot> createLot(Lot lot) async {
    try {
      // Convertir entity a model para serialización
      final lotModel = LotModel.fromEntity(lot);
      
      // POST /farm/{farmId}/lots
      final response = await _apiClient.dio.post(
        ApiConstants.lots,
        data: lotModel.toJson(),
      );
      
      // Retornar lote creado (con ID asignado por el servidor)
      return LotModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- PATCH: Update Lot (Partial) ---
  @override
  Future<Lot> updateLot(int id, Map<String, dynamic> updates) async {
    try {
      // Construir request con solo campos modificados
      final updateRequest = LotUpdateRequest(
        name: updates['name'],
        description: updates['description'],
      );
      
      // PATCH /farm/{farmId}/lots/{id}
      final response = await _apiClient.dio.patch(
        '${ApiConstants.lots}/$id',
        data: updateRequest.toJson(),
      );
      
      // Retornar lote actualizado
      return LotModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- DELETE: Remove Lot ---
  @override
  Future<void> deleteLot(int id) async {
    try {
      // DELETE /farm/{farmId}/lots/{id}
      await _apiClient.dio.delete('${ApiConstants.lots}/$id');
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
          return 'Lote no encontrado';
        case 409:
          return 'El lote ya existe';
        case 500:
          return 'Error del servidor';
        default:
          return 'Error de conexión';
      }
    }
    return 'Error desconocido';
  }
}