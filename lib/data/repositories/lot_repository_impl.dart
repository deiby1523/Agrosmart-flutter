import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/lot_model.dart';
import '../../domain/entities/lot.dart';
import '../../domain/repositories/lot_repository.dart';

class LotRepositoryImpl implements LotRepository {
  final ApiClient _apiClient = ApiClient();

  @override
  Future<List<Lot>> getLots() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.lots);
      
      final List<dynamic> data = response.data;
      return data.map((json) => LotModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Lot> getLotById(int id) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.lots}/$id');
      
      return LotModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Lot> createLot(Lot lot) async {
    try {
      final lotModel = LotModel.fromEntity(lot);
      final response = await _apiClient.dio.post(
        ApiConstants.lots,
        data: lotModel.toJson(),
      );
      
      return LotModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Lot> updateLot(int id, Map<String, dynamic> updates) async {
    try {
      final updateRequest = LotUpdateRequest(
        name: updates['name'],
        description: updates['description'],
      );
      
      final response = await _apiClient.dio.patch(
        '${ApiConstants.lots}/$id',
        data: updateRequest.toJson(),
      );
      
      return LotModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteLot(int id) async {
    try {
      await _apiClient.dio.delete('${ApiConstants.lots}/$id');
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
          return 'Lote no encontrado';
        case 409:
          return 'el lote ya existe';
        case 500:
          return 'Error del servidor';
        default:
          return 'Error de conexión';
      }
    }
    return 'Error desconocido';
  }
}