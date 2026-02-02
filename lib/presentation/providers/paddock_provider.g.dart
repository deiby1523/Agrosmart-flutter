// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paddock_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paddockRepositoryHash() => r'5d7fd2738187dcebfdb95bc5183bccced859454f';

/// =============================================================================
/// # PADDOCK PROVIDER
///
/// Este módulo define los providers encargados de manejar la lógica de negocio
/// y el estado relacionado con los **potreros (Paddocks)** en la aplicación.
///
/// Implementa un enfoque basado en **Riverpod + Clean Architecture**, separando
/// la obtención, creación, actualización y eliminación de potreros mediante
/// el repositorio correspondiente.
///
/// - `paddockRepositoryProvider`: expone el repositorio de datos de potreros.
/// - `Paddocks`: gestiona el estado reactivo y asíncrono de la lista de potreros.
/// =============================================================================
/// -----------------------------------------------------------------------------
/// ## Provider: `paddockRepositoryProvider`
///
/// Inyecta una instancia de `PaddockRepositoryImpl`, la cual proporciona acceso
/// a las operaciones CRUD del dominio de potreros.
///
/// Se utiliza dentro de otros providers o controladores de estado.
/// -----------------------------------------------------------------------------
///
/// Copied from [paddockRepository].
@ProviderFor(paddockRepository)
final paddockRepositoryProvider = Provider<PaddockRepositoryImpl>.internal(
  paddockRepository,
  name: r'paddockRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paddockRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PaddockRepositoryRef = ProviderRef<PaddockRepositoryImpl>;
String _$paddocksHash() => r'58fe02d77e7fce1f09b7c06620d2b9674bb77c8b';

/// -----------------------------------------------------------------------------
/// ## Provider de Estado: `Paddocks`
///
/// Maneja la lista de potreros (`List<Paddock>`) usando un `AsyncNotifier`.
/// Permite ejecutar operaciones de creación, actualización y eliminación,
/// asegurando que el estado de la lista se mantenga sincronizado con la fuente
/// de datos tras cada modificación.
///
/// ### Métodos principales:
/// - `build()`: Carga inicial de potreros.
/// - `createPaddock()`: Crea un nuevo potrero.
/// - `updatePaddock()`: Actualiza los datos de un potrero existente.
/// - `deletePaddock()`: Elimina un potrero.
/// -----------------------------------------------------------------------------
///
/// Copied from [Paddocks].
@ProviderFor(Paddocks)
final paddocksProvider =
    AsyncNotifierProvider<Paddocks, List<Paddock>>.internal(
      Paddocks.new,
      name: r'paddocksProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$paddocksHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Paddocks = AsyncNotifier<List<Paddock>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
