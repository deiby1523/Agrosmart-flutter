// lib/domain/services/feeding_relations_service.dart
import 'package:agrosmart_flutter/data/repositories/supply_repository_impl.dart';
import 'package:agrosmart_flutter/data/repositories/lot_repository_impl.dart';
import 'package:agrosmart_flutter/domain/entities/feeding.dart';
import 'package:agrosmart_flutter/domain/entities/supply.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:flutter/material.dart';
import 'package:agrosmart_flutter/domain/entities/milking.dart';

class FeedingRelationsService {
  final SupplyRepositoryImpl _supplyRepository;
  final LotRepositoryImpl _lotRepository;

  FeedingRelationsService({
    required SupplyRepositoryImpl supplyRepository,
    required LotRepositoryImpl lotRepository,
  }) : _supplyRepository = supplyRepository,
       _lotRepository = lotRepository;

  // Cache en memoria para la sesión actual
  final Map<int, Supply> _supplyCache = {};
  final Map<int, Lot> _lotCache = {};

  /// Optimización: Obtener todas las relaciones en lotes
  Future<List<Feeding>> populateFeedingsWithRelations(
    List<Feeding> feedings,
  ) async {
    if (feedings.isEmpty) return feedings;

    // Paso 1: Extraer todos los IDs únicos necesarios
    final relations = _extractAllRelationIds(feedings);

    // Paso 2: Cargar todas las relaciones en paralelo
    await _loadAllRelations(relations);

    // Paso 3: Combinar feedinges con relaciones usando cache
    return _mergeFeedingsWithRelations(feedings);
  }

  /// Popula la relación de Lot para una lista de registros de ordeño (Milking).
  /// Reutiliza la cache de lotes y el loader existente para evitar requests duplicados.
  Future<List<Milking>> populateMilkingsWithRelations(
    List<Milking> milkings,
  ) async {
    if (milkings.isEmpty) return milkings;

    // Extraer IDs únicos de lot
    final lotIds = milkings
        .map((m) => m.lot.id)
        .where((id) => id != null)
        .cast<int>()
        .toSet();

    // Cargar solo los lotes faltantes en cache
    final newLotIds = lotIds.where((id) => !_lotCache.containsKey(id));
    if (newLotIds.isNotEmpty) {
      await _loadLots(newLotIds);
    }

    // Mapear lotes cargados a cada registro de ordeño
    return milkings.map((m) {
      final resolvedLot = (m.lot.id != null)
          ? (_lotCache[m.lot.id] ?? m.lot)
          : m.lot;
      return m.copyWith(lot: resolvedLot);
    }).toList();
  }

  RelationIds _extractAllRelationIds(List<Feeding> feedings) {
    final supplyIds = <int>{};
    final lotIds = <int>{};

    for (final feeding in feedings) {
      // Relaciones básicas
      if (feeding.supply.id != null) supplyIds.add(feeding.supply.id!);
      if (feeding.lot.id != null) lotIds.add(feeding.lot.id!);
    }

    return RelationIds(
      supplyIds: supplyIds,
      lotIds: lotIds,
    );
  }

  Future<void> _loadAllRelations(RelationIds relations) async {
    final futures = <Future>[];

    // Cargar razas (si hay IDs nuevos)
    final newSupplyIds = relations.supplyIds.where(
      (id) => !_supplyCache.containsKey(id),
    );
    if (newSupplyIds.isNotEmpty) {
      futures.add(_loadSupplys(newSupplyIds));
    }

    // Cargar lotes (si hay IDs nuevos)
    final newLotIds = relations.lotIds.where(
      (id) => !_lotCache.containsKey(id),
    );
    if (newLotIds.isNotEmpty) {
      futures.add(_loadLots(newLotIds));
    }

    // Ejecutar todas las cargas en paralelo
    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
  }

  Future<void> _loadSupplys(Iterable<int> supplyIds) async {
    try {
      // Si no, necesitamos implementarlo
      for (final id in supplyIds) {
        final supply = await _supplyRepository.getSupplyById(id);
        _supplyCache[id] = supply;
      }
    } catch (e) {
      debugPrint('Error loading supplys: $e');
    }
  }

  Future<void> _loadLots(Iterable<int> lotIds) async {
    try {
      for (final id in lotIds) {
        final lot = await _lotRepository.getLotById(id);
        _lotCache[id] = lot;
      }
    } catch (e) {
      debugPrint('Error loading lots: $e');
    }
  }

  List<Feeding> _mergeFeedingsWithRelations(List<Feeding> feedings) {
    return feedings.map((feeding) {
      // Aplicar relaciones básicas
      var updatedFeeding = feeding.copyWith(
        supply: _supplyCache[feeding.supply.id] ?? feeding.supply,
        lot: _lotCache[feeding.lot.id] ?? feeding.lot,
      );

      return updatedFeeding;
    }).toList();
  }

  // Limpiar cache cuando sea necesario
  void clearCache() {
    _supplyCache.clear();
    _lotCache.clear();
  }
}

class RelationIds {
  final Set<int> supplyIds;
  final Set<int> lotIds;

  RelationIds({
    required this.supplyIds,
    required this.lotIds,
  });
}
