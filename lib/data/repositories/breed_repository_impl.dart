import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/breed_model.dart';
import '../../domain/entities/breed.dart';
import '../../domain/repositories/breed_repository.dart';

class BreedRepositoryImpl implements BreedRepository {
  final ApiClient _apiClient = ApiClient();

  @override
  Future<List<Breed>> getBreeds() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.breeds);
      
      final List<dynamic> data = response.data;
      return data.map((json) => BreedModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Breed> getBreedById(int id) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.breeds}/$id');
      
      return BreedModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Breed> createBreed(Breed breed) async {
    try {
      final breedModel = BreedModel.fromEntity(breed);
      final response = await _apiClient.dio.post(
        ApiConstants.breeds,
        data: breedModel.toJson(),
      );
      
      return BreedModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Breed> updateBreed(int id, Map<String, dynamic> updates) async {
    try {
      final updateRequest = BreedUpdateRequest(
        name: updates['name'],
        description: updates['description'],
      );
      
      final response = await _apiClient.dio.patch(
        '${ApiConstants.breeds}/$id',
        data: updateRequest.toJson(),
      );
      
      return BreedModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteBreed(int id) async {
    try {
      await _apiClient.dio.delete('${ApiConstants.breeds}/$id');
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