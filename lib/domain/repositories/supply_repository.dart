import 'package:agrosmart_flutter/domain/entities/paginated_response.dart';
import 'package:agrosmart_flutter/domain/entities/supply.dart';

abstract class SupplyRepository {
  Future<PaginatedResponse<Supply>> getSupplies();
  Future<Supply> getSupplyById(int id);
  Future<Supply> createSupply(Supply supply);
  Future<Supply> updateSupply(int id, Map<String, dynamic> updates);
  Future<void> deleteSupply(int id);
}