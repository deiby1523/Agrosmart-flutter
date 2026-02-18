import 'package:agrosmart_flutter/core/constants/api_constants.dart';
import 'package:agrosmart_flutter/core/network/api_client.dart';
import 'package:agrosmart_flutter/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ApiClient _apiClient = ApiClient();

  @override
  Future<String> sendMessage({
    required String user,
    required DateTime date,
    required String message,
  }) async {
    var endpoint = ApiConstants.chat;

    final response = await _apiClient.dio.post(
      endpoint,
      data: {"user": user, "date": date.toIso8601String(), "message": message},
    );

    return response.data as String;
  }
}
