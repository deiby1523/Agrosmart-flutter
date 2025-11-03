// lib/domain/services/animal_relations_service.dart
import 'package:agrosmart_flutter/data/repositories/breed_repository_impl.dart';
import 'package:agrosmart_flutter/data/repositories/lot_repository_impl.dart';
import 'package:agrosmart_flutter/data/repositories/paddock_repository_impl.dart';
import 'package:agrosmart_flutter/data/repositories/animal_repository_impl.dart';
import 'package:agrosmart_flutter/domain/entities/animal.dart';
import 'package:agrosmart_flutter/domain/entities/breed.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/domain/entities/paddock.dart';
import 'package:flutter/material.dart';
import 'package:agrosmart_flutter/domain/entities/milking.dart';

class AnimalRelationsService {
  final BreedRepositoryImpl _breedRepository;
  final LotRepositoryImpl _lotRepository;
  final PaddockRepositoryImpl _paddockRepository;
  final AnimalRepositoryImpl _animalRepository;

  AnimalRelationsService({
    required BreedRepositoryImpl breedRepository,
    required LotRepositoryImpl lotRepository,
    required PaddockRepositoryImpl paddockRepository,
    required AnimalRepositoryImpl animalRepository,
  }) : _breedRepository = breedRepository,
       _lotRepository = lotRepository,
       _paddockRepository = paddockRepository,
       _animalRepository = animalRepository;

  // Cache en memoria para la sesión actual
  final Map<int, Breed> _breedCache = {};
  final Map<int, Lot> _lotCache = {};
  final Map<int, Paddock> _paddockCache = {};
  final Map<int, Animal> _animalCache = {};

  /// Optimización: Obtener todas las relaciones en lotes
  Future<List<Animal>> populateAnimalsWithRelations(
    List<Animal> animals,
  ) async {
    if (animals.isEmpty) return animals;

    // Paso 1: Extraer todos los IDs únicos necesarios
    final relations = _extractAllRelationIds(animals);

    // Paso 2: Cargar todas las relaciones en paralelo
    await _loadAllRelations(relations);

    // Paso 3: Combinar animales con relaciones usando cache
    return _mergeAnimalsWithRelations(animals);
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

  RelationIds _extractAllRelationIds(List<Animal> animals) {
    final breedIds = <int>{};
    final lotIds = <int>{};
    final paddockIds = <int>{};
    final animalIds = <int>{};

    for (final animal in animals) {
      // Relaciones básicas
      if (animal.breed.id != null) breedIds.add(animal.breed.id!);
      if (animal.lot.id != null) lotIds.add(animal.lot.id!);
      if (animal.paddockCurrent.id != null)
        paddockIds.add(animal.paddockCurrent.id!);

      // Relaciones padre/madre
      if (animal.father?.id != null) animalIds.add(animal.father!.id!);
      if (animal.mother?.id != null) animalIds.add(animal.mother!.id!);
    }

    return RelationIds(
      breedIds: breedIds,
      lotIds: lotIds,
      paddockIds: paddockIds,
      animalIds: animalIds,
    );
  }

  Future<void> _loadAllRelations(RelationIds relations) async {
    final futures = <Future>[];

    // Cargar razas (si hay IDs nuevos)
    final newBreedIds = relations.breedIds.where(
      (id) => !_breedCache.containsKey(id),
    );
    if (newBreedIds.isNotEmpty) {
      futures.add(_loadBreeds(newBreedIds));
    }

    // Cargar lotes (si hay IDs nuevos)
    final newLotIds = relations.lotIds.where(
      (id) => !_lotCache.containsKey(id),
    );
    if (newLotIds.isNotEmpty) {
      futures.add(_loadLots(newLotIds));
    }

    // Cargar potreros (si hay IDs nuevos)
    final newPaddockIds = relations.paddockIds.where(
      (id) => !_paddockCache.containsKey(id),
    );
    if (newPaddockIds.isNotEmpty) {
      futures.add(_loadPaddocks(newPaddockIds));
    }

    // Cargar animales padre/madre (si hay IDs nuevos)
    final newAnimalIds = relations.animalIds.where(
      (id) => !_animalCache.containsKey(id),
    );
    if (newAnimalIds.isNotEmpty) {
      futures.add(_loadAnimals(newAnimalIds));
    }

    // Ejecutar todas las cargas en paralelo
    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
  }

  Future<void> _loadBreeds(Iterable<int> breedIds) async {
    try {
      // ASUNTO: ¿Tu repository tiene método para obtener múltiples breeds?
      // Si no, necesitamos implementarlo
      for (final id in breedIds) {
        final breed = await _breedRepository.getBreedById(id);
        _breedCache[id] = breed;
      }
    } catch (e) {
      debugPrint('Error loading breeds: $e');
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

  Future<void> _loadPaddocks(Iterable<int> paddockIds) async {
    try {
      for (final id in paddockIds) {
        final paddock = await _paddockRepository.getPaddockById(id);
        _paddockCache[id] = paddock;
      }
    } catch (e) {
      debugPrint('Error loading paddocks: $e');
    }
  }

  Future<void> _loadAnimals(Iterable<int> animalIds) async {
    try {
      for (final id in animalIds) {
        final animal = await _animalRepository.getAnimalById(id);
        _animalCache[id] = animal;
      }
    } catch (e) {
      debugPrint('Error loading animals: $e');
    }
  }

  List<Animal> _mergeAnimalsWithRelations(List<Animal> animals) {
    return animals.map((animal) {
      // Aplicar relaciones básicas
      var updatedAnimal = animal.copyWith(
        breed: _breedCache[animal.breed.id] ?? animal.breed,
        lot: _lotCache[animal.lot.id] ?? animal.lot,
        paddockCurrent:
            _paddockCache[animal.paddockCurrent.id] ?? animal.paddockCurrent,
      );

      // Aplicar relaciones padre/madre si existen
      if (animal.father?.id != null) {
        final father = _animalCache[animal.father!.id];
        if (father != null) {
          updatedAnimal = updatedAnimal.copyWith(father: father);
        }
      }

      if (animal.mother?.id != null) {
        final mother = _animalCache[animal.mother!.id];
        if (mother != null) {
          updatedAnimal = updatedAnimal.copyWith(mother: mother);
        }
      }

      return updatedAnimal;
    }).toList();
  }

  // Limpiar cache cuando sea necesario
  void clearCache() {
    _breedCache.clear();
    _lotCache.clear();
    _paddockCache.clear();
    _animalCache.clear();
  }
}

class RelationIds {
  final Set<int> breedIds;
  final Set<int> lotIds;
  final Set<int> paddockIds;
  final Set<int> animalIds;

  RelationIds({
    required this.breedIds,
    required this.lotIds,
    required this.paddockIds,
    required this.animalIds,
  });
}
