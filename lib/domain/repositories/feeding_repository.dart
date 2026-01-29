import 'package:agrosmart_flutter/domain/entities/paginated_response.dart';

import '../entities/feeding.dart';

abstract class FeedingRepository {
  Future<PaginatedResponse<Feeding>> getFeedings({int page, int size});
  Future<Feeding> getFeedingById(int id);
  Future<Feeding> createFeeding(Feeding feeding);
  Future<Feeding> updateFeeding(int id, Map<String, dynamic> updates);
  Future<void> deleteFeeding(int id);
}
