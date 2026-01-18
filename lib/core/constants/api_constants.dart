// =============================================================================
// API CONSTANTS - Endpoints del Backend Springboot
// =============================================================================

class ApiConstants {
  // --- Base URL ---
  static const String baseUrl = 'http://localhost:8080/api';

  // --- Authentication ---
  static const String authenticate = '/auth/authenticate'; // Login
  static const String register = '/auth/register'; // Registro
  static const String refresh = '/auth/refresh'; // Refresh token

  // static const String farms = '/farm/{farmId}/farms';

  // --- Farm Resources ---
  static const String breeds = '/farm/{farmId}/breeds'; // CRUD Razas
  static const String lots = '/farm/{farmId}/lots'; // CRUD Lotes
  static const String paddocks = '/farm/{farmId}/paddocks'; // CRUD Potreros
  static const String animals = '/farm/{farmId}/animals'; // CRUD Animales
  static const String milkings = '/farm/{farmId}/milkings'; // CRUD Ordeños
  static const String insumos = '/farm/{farmId}/insumos'; // CRUD Insumos

  static const String dashboard = '/farm/{farmId}/metrics/dashboard'; // Estadísticas
  
  static const String upload = '/farm/{farmId}/upload'; // Subir archivos

  // static const String dashboardMetricsEndpoint = "/api/farm/metrics/dashboard";
  

}
