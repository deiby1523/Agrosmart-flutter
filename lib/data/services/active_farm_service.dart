import 'package:shared_preferences/shared_preferences.dart';

class ActiveFarmService {
  static const String _activeFarmKey = 'active_farm';
  final SharedPreferences _prefs;

  ActiveFarmService(this._prefs);

  Future<int?> getActiveFarmId() async {
    return _prefs.getInt(_activeFarmKey);
  }

  String? getActiveFarmName() {
    return _prefs.getString('${_activeFarmKey}_name');
  }

  String? getActiveFarmRole() {
    return _prefs.getString('${_activeFarmKey}_role');
  }

  /// Retorna el ID de la granja activa o lanza una excepción si no hay granja activa
  Future<int> getActiveFarmIdOrThrow() async {
    final farmId = await getActiveFarmId();
    if (farmId == null) {
      throw Exception('No hay una granja activa');
    }
    return farmId;
  }
}
