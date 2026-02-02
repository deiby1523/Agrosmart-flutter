// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$animalRepositoryHash() => r'1c2651fff783a5ecc08808f200ee1eca90d3d44e';

/// See also [animalRepository].
@ProviderFor(animalRepository)
final animalRepositoryProvider = Provider<AnimalRepositoryImpl>.internal(
  animalRepository,
  name: r'animalRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$animalRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnimalRepositoryRef = ProviderRef<AnimalRepositoryImpl>;
String _$animalsHash() => r'9f8f716e91c36b92ade4ff6557639640879b7b7c';

/// See also [Animals].
@ProviderFor(Animals)
final animalsProvider =
    AsyncNotifierProvider<Animals, PaginatedResponse<Animal>>.internal(
      Animals.new,
      name: r'animalsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$animalsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Animals = AsyncNotifier<PaginatedResponse<Animal>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
