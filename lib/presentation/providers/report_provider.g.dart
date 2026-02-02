// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reportRepositoryHash() => r'f83082572963079bbad0dd915dc2f6bf1814b1c9';

/// See also [reportRepository].
@ProviderFor(reportRepository)
final reportRepositoryProvider =
    AutoDisposeProvider<ReportRepositoryImpl>.internal(
      reportRepository,
      name: r'reportRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$reportRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReportRepositoryRef = AutoDisposeProviderRef<ReportRepositoryImpl>;
String _$reportsHash() => r'e0a429a4971e1f89915ff5cb9765c2d649911b86';

/// See also [Reports].
@ProviderFor(Reports)
final reportsProvider =
    AutoDisposeAsyncNotifierProvider<Reports, void>.internal(
      Reports.new,
      name: r'reportsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$reportsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Reports = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
