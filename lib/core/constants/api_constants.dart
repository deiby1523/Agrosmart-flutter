class ApiConstants {
  // static const String baseUrl = 'https://agrosmartrest.onrender.com/api';
  static const String baseUrl = 'http://localhost:8080/api';

  // Auth Endpoints
  static const String authenticate = '/auth/authenticate';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';

  // Breed Endpoints
  static const String breeds = '/breed';

  // Lot Endpoints
  static const String lots = '/lots';

  // Paddock Endpoints
  static const String paddocks = '/paddocks';

  // Other endpoints...
  static const String animals = '/animals';
  static const String insumos = '/insumos';
  static const String dashboard = '/dashboard';
  static const String upload = '/upload';
}
