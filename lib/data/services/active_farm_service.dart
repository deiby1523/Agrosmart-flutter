// =============================================================================
// ACTIVE FARM SERVICE - Servicio para Gestión de la Granja Activa
// =============================================================================
// Administra la información de la granja seleccionada actualmente en la aplicación.
// - Obtiene el ID, nombre y rol asociados a la granja activa.
// - Persiste los datos usando SharedPreferences.
// - Permite recuperar el ID de la granja activa o lanzar excepción si no existe.
//
// Claves almacenadas:
// - active_farm → ID de la granja activa
// - active_farm_name → Nombre de la granja activa
// - active_farm_role → Rol del usuario en la granja activa

import 'package:shared_preferences/shared_preferences.dart';

class ActiveFarmService {
  static const String _activeFarmKey = 'active_farm';
  final SharedPreferences _prefs;

  ActiveFarmService(this._prefs);

  // --- GET: Active Farm ID ---
  /// Retorna el ID de la granja activa, o `null` si no existe.
  Future<int?> getActiveFarmId() async {
    return _prefs.getInt(_activeFarmKey);
  }

  // --- GET: Active Farm Name ---
  /// Retorna el nombre de la granja activa, o `null` si no se ha guardado.
  String? getActiveFarmName() {
    return _prefs.getString('${_activeFarmKey}_name');
  }

  // --- GET: Active Farm Role ---
  /// Retorna el rol del usuario en la granja activa, o `null` si no se ha guardado.
  String? getActiveFarmRole() {
    return _prefs.getString('${_activeFarmKey}_role');
  }

  // --- VALIDATED GET: Active Farm ID or Exception ---
  /// Retorna el ID de la granja activa o lanza una excepción si no hay ninguna seleccionada.
  Future<int> getActiveFarmIdOrThrow() async {
    final farmId = await getActiveFarmId();
    if (farmId == null) {
      throw Exception('No hay una granja activa');
    }
    return farmId;
  }
}
