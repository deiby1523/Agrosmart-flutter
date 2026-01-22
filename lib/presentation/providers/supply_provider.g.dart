// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supply_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supplyRepositoryHash() => r'9753ecb13c3bd7fb3252ad9fdf49adf90a6581c7';

/// See also [supplyRepository].
@ProviderFor(supplyRepository)
final supplyRepositoryProvider =
    AutoDisposeProvider<SupplyRepositoryImpl>.internal(
      supplyRepository,
      name: r'supplyRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$supplyRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SupplyRepositoryRef = AutoDisposeProviderRef<SupplyRepositoryImpl>;
String _$suppliesHash() => r'6a4c7a05d93795c09e681a8293acbf3bb1322825';

/// See also [Supplies].
@ProviderFor(Supplies)
final suppliesProvider =
    AutoDisposeAsyncNotifierProvider<
      Supplies,
      PaginatedResponse<Supply>
    >.internal(
      Supplies.new,
      name: r'suppliesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$suppliesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Supplies = AutoDisposeAsyncNotifier<PaginatedResponse<Supply>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
