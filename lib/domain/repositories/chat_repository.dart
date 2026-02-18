abstract class ChatRepository {
  Future<String> sendMessage({
    required String user,
    required DateTime date,
    required String message,
  });
}
