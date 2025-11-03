// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$milkingRepositoryHash() => r'162300fb72789d70c0d3f128c5ab604303d977b3';

/// =============================================================================
/// # MILKING PROVIDER
///
/// Define los providers encargados de manejar las operaciones y el estado
/// relacionados con los **Registros de Ordeño (Milkings)** dentro de la aplicación.
///
/// Basado en los principios de **Clean Architecture** y gestionado mediante
/// **Riverpod**. Este módulo coordina las acciones de persistencia, creación,
/// actualización y eliminación de registros de ordeño.
///
/// - `milkingRepositoryProvider`: expone la implementación del repositorio de ordeños.
/// - `Milkings`: gestiona el estado asíncrono de la colección de ordeños con paginación.
/// =============================================================================
/// -----------------------------------------------------------------------------
/// ## Provider: `milkingRepositoryProvider`
///
/// Inyecta una instancia de `MilkingRepositoryImpl` para acceder a las operaciones
/// de persistencia de registros de ordeño desde cualquier parte de la aplicación.
/// -----------------------------------------------------------------------------
///
/// Copied from [milkingRepository].
@ProviderFor(milkingRepository)
final milkingRepositoryProvider =
    AutoDisposeProvider<MilkingRepositoryImpl>.internal(
      milkingRepository,
      name: r'milkingRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$milkingRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MilkingRepositoryRef = AutoDisposeProviderRef<MilkingRepositoryImpl>;
String _$milkingsHash() => r'e66c8d924eb8d6682c38ff17a382a64a62ce1e24';

/// -----------------------------------------------------------------------------
/// ## Provider de Estado: `Milkings`
///
/// Gestiona la lista de registros de ordeño (`PaginatedResponse<Milking>`) usando un `AsyncNotifier`.
/// Permite ejecutar operaciones CRUD y recarga automáticamente los datos
/// después de cada cambio exitoso.
///
/// ### Métodos:
/// - `build()`: Carga inicial de los registros de ordeño.
/// - `createMilking()`: Crea un nuevo registro de ordeño.
/// - `updateMilking()`: Actualiza un registro existente.
/// - `deleteMilking()`: Elimina un registro de ordeño.
/// - `loadNextPage()`: Carga la siguiente página.
/// - `loadPreviousPage()`: Carga la página anterior.
/// - `loadPage()`: Carga una página específica.
/// -----------------------------------------------------------------------------
///
/// Copied from [Milkings].
@ProviderFor(Milkings)
final milkingsProvider =
    AutoDisposeAsyncNotifierProvider<
      Milkings,
      PaginatedResponse<Milking>
    >.internal(
      Milkings.new,
      name: r'milkingsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$milkingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Milkings = AutoDisposeAsyncNotifier<PaginatedResponse<Milking>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
