import '../entities/breed.dart';

abstract class BreedRepository {
  Future<List<Breed>> getBreeds();
  Future<Breed> getBreedById(int id);
  Future<Breed> createBreed(Breed breed);
  Future<Breed> updateBreed(int id, Map<String, dynamic> updates);
  Future<void> deleteBreed(int id);
}