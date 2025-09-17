import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/paddock_model.dart';
import '../../domain/entities/paddock.dart';
import '../../domain/repositories/paddock_repository.dart';

class PaddockRepositoryImpl implements PaddockRepository {
  final ApiClient _apiClient = ApiClient();

  @override
  Future<List<Paddock>> getPaddocks() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.paddocks);
      
      final List<dynamic> data = response.data;
      return data.map((json) => PaddockModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Paddock> getPaddockById(int id) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.paddocks}/$id');
      
      return PaddockModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Paddock> createPaddock(Paddock paddock) async {
    try {
      final paddockModel = PaddockModel.fromEntity(paddock);
      final response = await _apiClient.dio.post(
        ApiConstants.paddocks,
        data: paddockModel.toJson(),
      );
      
      return PaddockModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Paddock> updatePaddock(int id, Map<String, dynamic> updates) async {
    try {
      final updateRequest = PaddockUpdateRequest(
        name: updates['name'],
        location: updates['location'],
        surface: updates['surface'],
        description: updates['description'],
        grassType: updates['grassType']
      );
      
      final response = await _apiClient.dio.patch(
        '${ApiConstants.paddocks}/$id',
        data: updateRequest.toJson(),
      );
      
      return PaddockModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deletePaddock(int id) async {
    try {
      await _apiClient.dio.delete('${ApiConstants.paddocks}/$id');
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