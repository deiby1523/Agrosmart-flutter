import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class JwtService {
  static const String _activeFarmKey = 'active_farm_id';
  static const String _activeFarmNameKey = 'active_farm_name';
  static const String _activeFarmRoleKey = 'active_farm_role';

  static Future<void> processJwtToken(String token) async {
    try {
      final payload = _decodeJwtPayload(token);
      if (payload != null &&
          payload['farms'] is List &&
          payload['farms'].isNotEmpty) {
        final firstFarm = payload['farms'][0];
        final prefs = await SharedPreferences.getInstance();

        await prefs.setInt(_activeFarmKey, firstFarm['id']);
        await prefs.setString(_activeFarmNameKey, firstFarm['name']);
        await prefs.setString(_activeFarmRoleKey, firstFarm['role']);
      }
    } catch (e) {
      print('Error processing JWT token: $e');
    }
  }

  static Map<String, dynamic>? _decodeJwtPayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final resp = utf8.decode(base64Url.decode(normalized));
      return jsonDecode(resp);
    } catch (e) {
      print('Error decoding JWT: $e');
      return null;
    }
  }

  static Future<void> clearFarmData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeFarmKey);
    await prefs.remove(_activeFarmNameKey);
    await prefs.remove(_activeFarmRoleKey);
  }
}
