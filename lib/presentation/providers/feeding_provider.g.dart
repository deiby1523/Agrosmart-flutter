// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeding_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedingRepositoryHash() => r'2565417cb4c3744da617c6a415276d7311058d62';

/// See also [feedingRepository].
@ProviderFor(feedingRepository)
final feedingRepositoryProvider =
    AutoDisposeProvider<FeedingRepositoryImpl>.internal(
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
typedef FeedingRepositoryRef = AutoDisposeProviderRef<FeedingRepositoryImpl>;
String _$feedingsHash() => r'f6542a36f643b551543590ee8daabd629d52c03f';

/// See also [Feedings].
@ProviderFor(Feedings)
final feedingsProvider =
    AutoDisposeAsyncNotifierProvider<
      Feedings,
      PaginatedResponse<Feeding>
    >.internal(
      Feedings.new,
      name: r'feedingsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$feedingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Feedings = AutoDisposeAsyncNotifier<PaginatedResponse<Feeding>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
