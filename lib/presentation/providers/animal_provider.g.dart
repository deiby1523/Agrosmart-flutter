// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$animalRepositoryHash() => r'1d12058986dece41eb67bf427dea3eedd82dd1fe';

/// See also [animalRepository].
@ProviderFor(animalRepository)
final animalRepositoryProvider =
    AutoDisposeProvider<AnimalRepositoryImpl>.internal(
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
typedef AnimalRepositoryRef = AutoDisposeProviderRef<AnimalRepositoryImpl>;
String _$animalsHash() => r'1f71e9cd41774ccc604aafe2cf83d3168670b715';

/// See also [Animals].
@ProviderFor(Animals)
final animalsProvider =
    AutoDisposeAsyncNotifierProvider<
      Animals,
      PaginatedResponse<Animal>
    >.internal(
      Animals.new,
      name: r'animalsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$animalsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Animals = AutoDisposeAsyncNotifier<PaginatedResponse<Animal>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
