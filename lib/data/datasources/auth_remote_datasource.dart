import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/auth_models.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource({required this.apiClient});

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await apiClient.dio.post(
      ApiConstants.authenticate,
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data);
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await apiClient.dio.post(
      ApiConstants.register,
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data);
  }

  Future<AuthResponse> refresh(String refreshToken) async {
    final response = await apiClient.dio.post(
      ApiConstants.refresh,
      data: {'refreshToken': refreshToken},
    );
    return AuthResponse.fromJson(response.data);
  }
}
