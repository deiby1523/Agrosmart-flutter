class ApiConstants {
  static const String baseUrl = 'http://192.168.1.10:8080/api';
  
  // Auth Endpoints
  static const String authenticate = '/auth/autenticate';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';
  
  // Breed Endpoints
  static const String breeds = '/breed';              // NUEVO
  
  // Otros endpoints...
  static const String animals = '/animals';
  static const String insumos = '/insumos';
  static const String dashboard = '/dashboard';
  static const String upload = '/upload';
}