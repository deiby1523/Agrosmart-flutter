// lib/providers/animal_relations_provider.dart
import 'package:agrosmart_flutter/data/services/animal_relations_service.dart';
import 'package:agrosmart_flutter/domain/entities/animal.dart';
import 'package:agrosmart_flutter/presentation/providers/animal_provider.dart';
import 'package:agrosmart_flutter/presentation/providers/breed_provider.dart';
import 'package:agrosmart_flutter/presentation/providers/lot_provider.dart';
import 'package:agrosmart_flutter/presentation/providers/paddock_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final animalRelationsServiceProvider = Provider<AnimalRelationsService>((ref) {
  return AnimalRelationsService(
    breedRepository: ref.read(breedRepositoryProvider),
    lotRepository: ref.read(lotRepositoryProvider),
    paddockRepository: ref.read(paddockRepositoryProvider),
    animalRepository: ref.read(animalRepositoryProvider),
  );
});

final animalsWithRelationsProvider = FutureProvider.family<List<Animal>, List<Animal>>((ref, animals) async {
  final service = ref.read(animalRelationsServiceProvider);
  return await service.populateAnimalsWithRelations(animals);
});