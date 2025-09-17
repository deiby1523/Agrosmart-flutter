import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/paddock_repository_impl.dart';
import '../../domain/entities/paddock.dart';

part 'paddock_provider.g.dart';

@riverpod
PaddockRepositoryImpl paddockRepository(PaddockRepositoryRef ref) {
  return PaddockRepositoryImpl();
}

@riverpod
class Paddocks extends _$Paddocks {
  @override
  FutureOr<List<Paddock>> build() async {
    return await ref.read(paddockRepositoryProvider).getPaddocks();
  }

  Future<void> createPaddock(String name,String location, double surface, String? description, String? grassType) async {
    state = const AsyncLoading();
    try {
      final paddock = Paddock(name: name, location: location, surface: surface, description: description, grassType: grassType);
      await ref.read(paddockRepositoryProvider).createPaddock(paddock);
      ref.invalidateSelf();
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> updatePaddock(int id, String name, String location, double surface, String? description, String? grassType) async {
    state = const AsyncLoading();
    try {
      final updates = {
        'name': name,
        'location' : location,
        'surface' : surface,
        'description': description,
        'grassType' : grassType,
      };
      await ref.read(paddockRepositoryProvider).updatePaddock(id, updates);
      ref.invalidateSelf();
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> deletePaddock(int id) async {
    state = const AsyncLoading();
    try {
      await ref.read(paddockRepositoryProvider).deletePaddock(id);
      ref.invalidateSelf();
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }
}
