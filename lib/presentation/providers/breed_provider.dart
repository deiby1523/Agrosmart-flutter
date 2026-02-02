import 'package:agrosmart_flutter/presentation/providers/dashboard_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/breed_repository_impl.dart';
import '../../domain/entities/breed.dart';

part 'breed_provider.g.dart';

/// =============================================================================
/// # BREED PROVIDER
///
/// Este archivo define los providers responsables de gestionar las razas (`Breed`)
/// dentro de la aplicación siguiendo los principios de **Clean Architecture**.
///
/// - `breedRepositoryProvider`: expone la implementación del repositorio.
/// - `Breeds`: maneja el estado asíncrono de la lista de razas, incluyendo
///   operaciones CRUD (crear, actualizar, eliminar).
/// =============================================================================

/// -----------------------------------------------------------------------------
/// ## Provider: `breedRepositoryProvider`
///
/// Inyecta una instancia de `BreedRepositoryImpl`, permitiendo acceder a las
/// operaciones del repositorio de razas desde cualquier punto de la app.
/// -----------------------------------------------------------------------------
@Riverpod(keepAlive: true)
BreedRepositoryImpl breedRepository(Ref ref) {
  return BreedRepositoryImpl();
}

/// -----------------------------------------------------------------------------
/// ## Provider de Estado: `Breeds`
///
/// Gestiona el estado de la colección de razas (`List<Breed>`) mediante
/// un `AsyncNotifier`. Permite ejecutar operaciones CRUD y actualiza
/// automáticamente la lista después de cada operación.
///
/// ### Métodos:
/// - `build()`: Carga inicial de razas.
/// - `createBreed()`: Crea una nueva raza.
/// - `updateBreed()`: Actualiza una raza existente.
/// - `deleteBreed()`: Elimina una raza por su ID.
/// -----------------------------------------------------------------------------
@Riverpod(keepAlive: true)
class Breeds extends _$Breeds {
  /// ---------------------------------------------------------------------------
  /// Carga inicial de la lista de razas desde el repositorio.
  ///
  /// Retorna un `List<Breed>` envuelto en un `AsyncValue`.
  /// ---------------------------------------------------------------------------
  @override
  FutureOr<List<Breed>> build() async {
    return await ref.read(breedRepositoryProvider).getBreeds();
  }

  /// ---------------------------------------------------------------------------
  /// Crea una nueva raza en el sistema.
  ///
  /// - [name]: Nombre de la raza.
  /// - [description]: Descripción opcional.
  ///
  /// Actualiza el estado a `AsyncLoading` durante la operación y vuelve
  /// a cargar la lista de razas al finalizar.
  /// ---------------------------------------------------------------------------
  Future<void> createBreed(String name, String? description) async {
    state = const AsyncLoading();
    try {
      final breed = Breed(name: name, description: description);
      await ref.read(breedRepositoryProvider).createBreed(breed);
      ref.invalidate(dashboardMetricsProvider);
      ref.invalidateSelf(); // Fuerza reconstrucción del estado
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }

  /// ---------------------------------------------------------------------------
  /// Actualiza una raza existente en base a su [id].
  ///
  /// - [id]: Identificador de la raza.
  /// - [name]: Nuevo nombre.
  /// - [description]: Nueva descripción.
  ///
  /// Tras actualizar, invalida el provider para recargar la lista.
  /// ---------------------------------------------------------------------------
  Future<void> updateBreed(int id, String name, String? description) async {
    state = const AsyncLoading();
    try {
      final updates = {'name': name, 'description': description};
      await ref.read(breedRepositoryProvider).updateBreed(id, updates);
      ref.invalidate(dashboardMetricsProvider);
      ref.invalidateSelf();
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }

  /// ---------------------------------------------------------------------------
  /// Elimina una raza existente por su [id].
  ///
  /// Actualiza el estado y recarga la lista de razas tras la eliminación.
  /// ---------------------------------------------------------------------------
  Future<void> deleteBreed(int id) async {
    state = const AsyncLoading();
    try {
      await ref.read(breedRepositoryProvider).deleteBreed(id);
      ref.invalidate(dashboardMetricsProvider);
      ref.invalidateSelf();
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }
}
