// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$milkingRepositoryHash() => r'162300fb72789d70c0d3f128c5ab604303d977b3';

/// See also [milkingRepository].
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
String _$milkingsHash() => r'fcf76a7647736c0c5f969097bb728dbeaf8f028b';

/// See also [Milkings].
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
