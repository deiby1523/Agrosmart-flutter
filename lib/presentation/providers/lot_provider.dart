import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/lot_repository_impl.dart';
import '../../domain/entities/lot.dart';

part 'lot_provider.g.dart';

@riverpod
LotRepositoryImpl lotRepository(LotRepositoryRef ref) {
  return LotRepositoryImpl();
}

@riverpod
class Lots extends _$Lots {
  @override
  FutureOr<List<Lot>> build() async {
    return await ref.read(lotRepositoryProvider).getLots();
  }

  Future<void> createLot(String name, String? description) async {
    state = const AsyncLoading();
    try {
      final lot = Lot(name: name, description: description);
      await ref.read(lotRepositoryProvider).createLot(lot);
      ref.invalidateSelf();
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> updateLot(int id, String name, String? description) async {
    state = const AsyncLoading();
    try {
      final updates = {
        'name': name,
        'description': description,
      };
      await ref.read(lotRepositoryProvider).updateLot(id, updates);
      ref.invalidateSelf();
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> deleteLot(int id) async {
    state = const AsyncLoading();
    try {
      await ref.read(lotRepositoryProvider).deleteLot(id);
      ref.invalidateSelf();
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }
}
