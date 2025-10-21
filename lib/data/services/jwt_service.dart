import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/jwt_claims_model.dart';

class JwtService {
  static const String _activeUserKey = 'active_user';
  static const String _activeFarmKey = 'active_farm';
  final SharedPreferences _prefs;

  JwtService(this._prefs);

  Future<void> saveActiveFarm(FarmClaimModel farm) async {
    await _prefs.setInt(_activeFarmKey, farm.id);
    await _prefs.setString('${_activeFarmKey}_name', farm.name);
    await _prefs.setString('${_activeFarmKey}_role', farm.role);
  }

  Future<FarmClaimModel?> getActiveFarm() async {
    final id = _prefs.getInt(_activeFarmKey);
    if (id == null) return null;

    return FarmClaimModel(
      id: id,
      name: _prefs.getString('${_activeFarmKey}_name') ?? '',
      role: _prefs.getString('${_activeFarmKey}_role') ?? '',
    );
  }

  JwtClaimsModel? decodeToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final resp = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> json = jsonDecode(resp);

      return JwtClaimsModel.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearFarmData() async {
    await _prefs.remove(_activeFarmKey);
    await _prefs.remove('${_activeFarmKey}_name');
    await _prefs.remove('${_activeFarmKey}_role');
  }
}
