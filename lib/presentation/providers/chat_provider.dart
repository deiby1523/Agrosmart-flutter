import 'package:agrosmart_flutter/data/repositories/chat_repository_impl.dart';
import 'package:agrosmart_flutter/domain/repositories/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl();
});
