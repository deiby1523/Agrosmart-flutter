import 'package:agrosmart_flutter/domain/entities/lot.dart';

abstract class LotRepository {
  Future<List<Lot>> getLots();
  Future<Lot> getLotById(int id);
  Future<Lot> createLot(Lot lot);
  Future<Lot> updateLot(int id, Map<String, dynamic> updates);
  Future<void> deleteLot(int id);
}