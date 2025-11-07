import 'package:agrosmart_flutter/data/models/dashboard_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../core/network/api_client.dart';

final dashboardMetricsProvider = FutureProvider<Dashboard>((ref) async {
  final apiClient = ApiClient();
  apiClient.initialize();
  final dataSource = DashboardRemoteDataSource(apiClient);
  return dataSource.getDashboardMetrics();
});
