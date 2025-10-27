import 'package:agrosmart_flutter/data/repositories/animal_repository_impl.dart';
import 'package:agrosmart_flutter/domain/entities/animal.dart';
import 'package:agrosmart_flutter/domain/entities/breed.dart';
import 'package:agrosmart_flutter/domain/entities/farm.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:agrosmart_flutter/domain/entities/paddock.dart';
import 'package:agrosmart_flutter/domain/entities/paginated_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'animal_provider.g.dart';

@riverpod
AnimalRepositoryImpl animalRepository(Ref ref) {
  return AnimalRepositoryImpl();
}

@riverpod
class Animals extends _$Animals {
  // Variables para controlar la paginación
  int _currentPage = 0;
  int _pageSize = 10;

  /// ---------------------------------------------------------------------------
  /// Carga inicial de la lista de animales desde el repositorio con paginación.
  ///
  /// Retorna un `PaginatedResponse<Animal>` envuelto en un `AsyncValue`.
  /// ---------------------------------------------------------------------------
  @override
  FutureOr<PaginatedResponse<Animal>> build() async {
    // Carga inicial - página 1
    return await _loadAnimals(page: _currentPage, size: _pageSize);
  }

  /// ---------------------------------------------------------------------------
  /// Carga una página específica de animales
  /// ---------------------------------------------------------------------------
  Future<void> loadPage(int page, {int size = 10}) async {
    // No modificar el state directamente, usar AsyncValue.guard
    state = await AsyncValue.guard(() async {
      final response = await _loadAnimals(page: page, size: size);
      _currentPage = page;
      _pageSize = size;
      return response;
    });
  }

  /// ---------------------------------------------------------------------------
  /// Carga la siguiente página de animales
  /// ---------------------------------------------------------------------------
  Future<void> loadNextPage() async {
    if (state.value?.paginationInfo.hasNext == true) {
      await loadPage(_currentPage + 1, size: _pageSize);
    }
  }

  /// ---------------------------------------------------------------------------
  /// Carga la página anterior de animales
  /// ---------------------------------------------------------------------------
  Future<void> loadPreviousPage() async {
    if (state.value?.paginationInfo.hasPrevious == true) {
      await loadPage(_currentPage - 1, size: _pageSize);
    }
  }

  /// ---------------------------------------------------------------------------
  /// Crea un nuevo animal en el sistema.
  /// Recarga la página actual al finalizar.
  /// ---------------------------------------------------------------------------
  Future<void> createAnimal(
    String code,
    String name,
    DateTime birthday,
    DateTime? purchaseDate,
    String sex,
    String registerType,
    String health,
    double birthWeight,
    String status,
    double? purchasePrice,
    String color,
    String? brand,
    Breed breed,
    Lot lot,
    Paddock paddockCurrent,
    Animal? father,
    Animal? mother,
    Farm? farm,
  ) async {
    // Usar guard para manejar el estado de forma segura
    state = await AsyncValue.guard(() async {
      final animal = Animal(
        code: code,
        name: name,
        birthday: birthday,
        sex: sex,
        registerType: registerType,
        health: health,
        birthWeight: birthWeight,
        status: status,
        color: color,
        breed: breed,
        brand: brand,
        lot: lot,
        paddockCurrent: paddockCurrent,
        farm: farm,
        father: father,
        mother: mother,
        purchaseDate: purchaseDate,
        purchasePrice: purchasePrice
      );

      
      await ref.read(animalRepositoryProvider).createAnimal(animal);
      // Recargar la página actual después de crear
      return await _loadAnimals(page: _currentPage, size: _pageSize);
    });
  }

  /// ---------------------------------------------------------------------------
  /// Actualiza un animal existente en base a su [id].
  ///
  /// Tras actualizar, recarga la página actual.
  /// ---------------------------------------------------------------------------
  Future<void> updateAnimal(
    int id,
    String code,
    String name,
    DateTime birthday,
    DateTime? purchaseDate,
    String sex,
    String registerType,
    String health,
    double birthWeight,
    String status,
    double? purchasePrice,
    String color,
    String? brand,
    Breed breed,
    Lot lot,
    Paddock paddockCurrent,
    Animal? father,
    Animal? mother,
    Farm? farm,
  ) async {
    state = await AsyncValue.guard(() async {
      final updates = {
        'name': name,
        'birthday': birthday.toIso8601String(),
        if (purchaseDate != null)
          'purchaseDate': purchaseDate.toIso8601String(),
        'sex': sex,
        'registerType': registerType,
        'health': health,
        'birthWeight': birthWeight,
        'status': status,
        if (purchasePrice != null) 'purchasePrice': purchasePrice,
        'color': color,
        if (brand != null) 'brand': brand,
        'breed': {
          'id': breed.id,
          'name': breed.name,
          if (breed.description != null) 'description': breed.description,
        },
        'lot': {
          'id': lot.id,
          'name': lot.name,
          if (lot.description != null) 'description': lot.description,
        },
        'paddockCurrent': {
          'id': paddockCurrent.id,
          'name': paddockCurrent.name,
          'location': paddockCurrent.location,
          'surface': paddockCurrent.surface,
          if (paddockCurrent.description != null)
            'description': paddockCurrent.description,
          if (paddockCurrent.grassType != null)
            'grassType': paddockCurrent.grassType,
        },
        if (father != null)
          'father': {'id': father.id, 'name': father.name, 'code': father.code},
        if (mother != null)
          'mother': {'id': mother.id, 'name': mother.name, 'code': mother.code},
        if (farm != null) 'farm': {'id': farm.id, 'name': farm.name},
      };
      await ref.read(animalRepositoryProvider).updateAnimal(id, updates);
      // Recargar la página actual después de actualizar
      return await _loadAnimals(page: _currentPage, size: _pageSize);
    });
  }

  /// ---------------------------------------------------------------------------
  /// Elimina un animal existente por su [id].
  ///
  /// Actualiza el estado y recarga la página actual tras la eliminación.
  /// ---------------------------------------------------------------------------
  Future<void> deleteAnimal(int id) async {
    state = await AsyncValue.guard(() async {
      await ref.read(animalRepositoryProvider).deleteAnimal(id);
      // Recargar la página actual después de eliminar
      return await _loadAnimals(page: _currentPage, size: _pageSize);
    });
  }

  // ---------------------------------------------------------------------------
  // Métodos privados
  // ---------------------------------------------------------------------------

  /// Carga animales desde el repositorio
  Future<PaginatedResponse<Animal>> _loadAnimals({int page = 1, int size = 10}) async {
    return await ref.read(animalRepositoryProvider).getAnimals(
      page: page,
      size: size,
    );
  }

  /// ---------------------------------------------------------------------------
  /// Getters para acceder a información de paginación desde la UI
  /// ---------------------------------------------------------------------------
  
  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  
  bool get hasNextPage => state.value?.paginationInfo.hasNext ?? false;
  bool get hasPreviousPage => state.value?.paginationInfo.hasPrevious ?? false;
  bool get isFirstPage => state.value?.paginationInfo.isFirst ?? true;
  bool get isLastPage => state.value?.paginationInfo.isLast ?? true;
}