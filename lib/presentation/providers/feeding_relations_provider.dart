// lib/providers/feeding_relations_provider.dart
import 'package:agrosmart_flutter/data/services/feeding_relations_service.dart';
import 'package:agrosmart_flutter/domain/entities/feeding.dart';
import 'package:agrosmart_flutter/domain/entities/milking.dart';
import 'package:agrosmart_flutter/presentation/providers/supply_provider.dart';
import 'package:agrosmart_flutter/presentation/providers/lot_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedingRelationsServiceProvider = Provider<FeedingRelationsService>((ref) {
  return FeedingRelationsService(
    supplyRepository: ref.read(supplyRepositoryProvider),
    lotRepository: ref.read(lotRepositoryProvider),
  );
});

final feedingsWithRelationsProvider = FutureProvider.family<List<Feeding>, List<Feeding>>((ref, feedings) async {
  final service = ref.read(feedingRelationsServiceProvider);
  return await service.populateFeedingsWithRelations(feedings);
});

final milkingsWithRelationsProvider = FutureProvider.family<List<Milking>, List<Milking>>((ref, milkings) async {
  final service = ref.read(feedingRelationsServiceProvider);
  return await service.populateMilkingsWithRelations(milkings);
});
