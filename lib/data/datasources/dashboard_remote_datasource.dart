import 'package:agrosmart_flutter/data/models/dashboard_models.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';

class DashboardRemoteDataSource {
  final ApiClient client;

  DashboardRemoteDataSource(this.client);

  Future<Dashboard> getDashboardMetrics() async {
    final response = await client.dio.get(
      ApiConstants.dashboard,
    );

    return Dashboard.fromJson(response.data);
  }
}
