// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supply_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supplyRepositoryHash() => r'5555232980193197059ea82d7f31da9afc88b4b3';

/// See also [supplyRepository].
@ProviderFor(supplyRepository)
final supplyRepositoryProvider = Provider<SupplyRepositoryImpl>.internal(
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
typedef SupplyRepositoryRef = ProviderRef<SupplyRepositoryImpl>;
String _$suppliesHash() => r'4f6da9b3712a2a21c937b128dc7288fe2725b583';

/// See also [Supplies].
@ProviderFor(Supplies)
final suppliesProvider =
    AsyncNotifierProvider<Supplies, PaginatedResponse<Supply>>.internal(
      Supplies.new,
      name: r'suppliesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$suppliesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Supplies = AsyncNotifier<PaginatedResponse<Supply>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
