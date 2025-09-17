// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paddock_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paddockRepositoryHash() => r'7a1826b3312bba053ea6a6e3b186592bfa00bd3c';

/// See also [paddockRepository].
@ProviderFor(paddockRepository)
final paddockRepositoryProvider =
    AutoDisposeProvider<PaddockRepositoryImpl>.internal(
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
typedef PaddockRepositoryRef = AutoDisposeProviderRef<PaddockRepositoryImpl>;
String _$paddocksHash() => r'9540d9da14bdbe891b73fa3cafecb9ec728f1a75';

/// See also [Paddocks].
@ProviderFor(Paddocks)
final paddocksProvider =
    AutoDisposeAsyncNotifierProvider<Paddocks, List<Paddock>>.internal(
      Paddocks.new,
      name: r'paddocksProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$paddocksHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Paddocks = AutoDisposeAsyncNotifier<List<Paddock>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
