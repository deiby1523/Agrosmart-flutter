// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeding_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedingRepositoryHash() => r'7920e905d9aebdac932f1f72f9ade9a0b82afaa5';

/// See also [feedingRepository].
@ProviderFor(feedingRepository)
final feedingRepositoryProvider = Provider<FeedingRepositoryImpl>.internal(
  feedingRepository,
  name: r'feedingRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$feedingRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FeedingRepositoryRef = ProviderRef<FeedingRepositoryImpl>;
String _$feedingsHash() => r'9b0114c0f4bba052e0a41a72020587c04cfd9ccd';

/// See also [Feedings].
@ProviderFor(Feedings)
final feedingsProvider =
    AsyncNotifierProvider<Feedings, PaginatedResponse<Feeding>>.internal(
      Feedings.new,
      name: r'feedingsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$feedingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Feedings = AsyncNotifier<PaginatedResponse<Feeding>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
