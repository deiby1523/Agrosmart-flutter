import '../entities/paddock.dart';

abstract class PaddockRepository {
  Future<List<Paddock>> getPaddocks();
  Future<Paddock> getPaddockById(int id);
  Future<Paddock> createPaddock(Paddock paddock);
  Future<Paddock> updatePaddock(int id, Map<String, dynamic> updates);
  Future<void> deletePaddock(int id);
}