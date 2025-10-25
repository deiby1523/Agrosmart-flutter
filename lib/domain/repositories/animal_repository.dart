import 'package:agrosmart_flutter/domain/entities/paginated_response.dart';

import '../entities/animal.dart';

abstract class AnimalRepository {
  Future<PaginatedResponse<Animal>> getAnimals({int page, int size});
  Future<Animal> getAnimalById(int id);
  Future<Animal> createAnimal(Animal animal);
  Future<Animal> updateAnimal(int id, Map<String, dynamic> updates);
  Future<void> deleteAnimal(int id);
}
