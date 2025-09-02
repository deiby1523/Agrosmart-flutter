import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/breed_repository_impl.dart';
import '../../domain/entities/breed.dart';

part 'breed_provider.g.dart';

@riverpod
BreedRepositoryImpl breedRepository(BreedRepositoryRef ref) {
  return BreedRepositoryImpl();
}

@riverpod
class Breeds extends _$Breeds {
  @override
  FutureOr<List<Breed>> build() async {
    return await ref.read(breedRepositoryProvider).getBreeds();
  }

  Future<void> createBreed(String name, String? description) async {
    state = const AsyncLoading();
    try {
      final breed = Breed(name: name, description: description);
      await ref.read(breedRepositoryProvider).createBreed(breed);
      ref.invalidateSelf();
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> updateBreed(int id, String name, String? description) async {
    state = const AsyncLoading();
    try {
      final updates = {
        'name': name,
        'description': description,
      };
      await ref.read(breedRepositoryProvider).updateBreed(id, updates);
      ref.invalidateSelf();
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> deleteBreed(int id) async {
    state = const AsyncLoading();
    try {
      await ref.read(breedRepositoryProvider).deleteBreed(id);
      ref.invalidateSelf();
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }
}
