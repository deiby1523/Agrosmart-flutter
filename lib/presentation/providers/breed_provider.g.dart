// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breed_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$breedRepositoryHash() => r'd7d02d2dc62b688b5a4d6169dd93483deaa00b79';

/// See also [breedRepository].
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

/// See also [Breeds].
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
