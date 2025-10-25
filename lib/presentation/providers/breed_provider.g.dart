// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breed_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$breedRepositoryHash() => r'd0283cd8272a32178f4edebded45dbf59851db4c';

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
///
/// Copied from [breedRepository].
@ProviderFor(breedRepository)
final breedRepositoryProvider =
    AutoDisposeProvider<BreedRepositoryImpl>.internal(
      breedRepository,
      name: r'breedRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$breedRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BreedRepositoryRef = AutoDisposeProviderRef<BreedRepositoryImpl>;
String _$breedsHash() => r'4f73f7deeaa5535134454c30efbd60bf77e6ed38';

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
///
/// Copied from [Breeds].
@ProviderFor(Breeds)
final breedsProvider =
    AutoDisposeAsyncNotifierProvider<Breeds, List<Breed>>.internal(
      Breeds.new,
      name: r'breedsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$breedsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Breeds = AutoDisposeAsyncNotifier<List<Breed>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
