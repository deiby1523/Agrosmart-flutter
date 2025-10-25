// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lot_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lotRepositoryHash() => r'8c9a593be9b19d909e3929c3972cc2c503831bb5';

/// =============================================================================
/// # LOT PROVIDER
///
/// Define los providers encargados de manejar las operaciones y el estado
/// relacionados con los **Lotes (Lots)** dentro de la aplicación.
///
/// Basado en los principios de **Clean Architecture** y gestionado mediante
/// **Riverpod**. Este módulo coordina las acciones de persistencia, creación,
/// actualización y eliminación de lotes.
///
/// - `lotRepositoryProvider`: expone la implementación del repositorio de lotes.
/// - `Lots`: gestiona el estado asíncrono de la colección de lotes.
/// =============================================================================
/// -----------------------------------------------------------------------------
/// ## Provider: `lotRepositoryProvider`
///
/// Inyecta una instancia de `LotRepositoryImpl` para acceder a las operaciones
/// de persistencia de lotes desde cualquier parte de la aplicación.
/// -----------------------------------------------------------------------------
///
/// Copied from [lotRepository].
@ProviderFor(lotRepository)
final lotRepositoryProvider = AutoDisposeProvider<LotRepositoryImpl>.internal(
  lotRepository,
  name: r'lotRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lotRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LotRepositoryRef = AutoDisposeProviderRef<LotRepositoryImpl>;
String _$lotsHash() => r'547cbd760f1b1f5ce80244b57f8a735e1e8a24bb';

/// -----------------------------------------------------------------------------
/// ## Provider de Estado: `Lots`
///
/// Gestiona la lista de lotes (`List<Lot>`) usando un `AsyncNotifier`.
/// Permite ejecutar operaciones CRUD y recarga automáticamente los datos
/// después de cada cambio exitoso.
///
/// ### Métodos:
/// - `build()`: Carga inicial de los lotes.
/// - `createLot()`: Crea un nuevo lote.
/// - `updateLot()`: Actualiza un lote existente.
/// - `deleteLot()`: Elimina un lote.
/// -----------------------------------------------------------------------------
///
/// Copied from [Lots].
@ProviderFor(Lots)
final lotsProvider = AutoDisposeAsyncNotifierProvider<Lots, List<Lot>>.internal(
  Lots.new,
  name: r'lotsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lotsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Lots = AutoDisposeAsyncNotifier<List<Lot>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
