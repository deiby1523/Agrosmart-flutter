import 'package:agrosmart_flutter/domain/entities/milking.dart';
import 'package:agrosmart_flutter/domain/entities/paginated_response.dart';

abstract class MilkingRepository {
  Future<PaginatedResponse<Milking>> getMilkings();
  Future<Milking> getMilkingById(int id);
  Future<Milking> createMilking(Milking milking);
  Future<Milking> updateMilking(int id, Map<String, dynamic> updates);
  Future<void> deleteMilking(int id);
}