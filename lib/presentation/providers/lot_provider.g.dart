// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lot_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lotRepositoryHash() => r'95c359fe3398ee6ac6243bd2f85d094266a5929a';

/// See also [lotRepository].
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

/// See also [Lots].
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
