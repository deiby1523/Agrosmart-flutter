class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://localhost:8080/api';

  // Auth Endpoints - These remain unchanged
  static const String authenticate = '/auth/authenticate';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';

  // Farm-specific endpoints
  static const String breeds = '/farm/{farmId}/breeds';
  static const String lots = '/farm/{farmId}/lots';
  static const String paddocks = '/farm/{farmId}/paddocks';
  static const String animals = '/farm/{farmId}/animals';
  static const String insumos = '/farm/{farmId}/insumos';
  static const String dashboard = '/farm/{farmId}/dashboard';
  static const String upload = '/farm/{farmId}/upload';
}
