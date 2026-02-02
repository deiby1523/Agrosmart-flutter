// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$milkingRepositoryHash() => r'9d43933c5d48b252a196320567cb6d98d83a8b46';

/// See also [milkingRepository].
@ProviderFor(milkingRepository)
final milkingRepositoryProvider = Provider<MilkingRepositoryImpl>.internal(
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
typedef MilkingRepositoryRef = ProviderRef<MilkingRepositoryImpl>;
String _$milkingsHash() => r'7f39fac51424aedbe546fbdd582b574dbbe63993';

/// See also [Milkings].
@ProviderFor(Milkings)
final milkingsProvider =
    AsyncNotifierProvider<Milkings, PaginatedResponse<Milking>>.internal(
      Milkings.new,
      name: r'milkingsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$milkingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Milkings = AsyncNotifier<PaginatedResponse<Milking>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
