import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  // ignore: prefer_initializing_formals
  TokenStorage({SharedPreferences? prefs}) : _prefs = prefs;

  static const _accessTokenKey = 'access_token';

  final SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async => _prefs ?? await SharedPreferences.getInstance();

  Future<String?> readAccessToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(_accessTokenKey);
  }

  Future<void> saveAccessToken(String token) async {
    final prefs = await _getPrefs();
    await prefs.setString(_accessTokenKey, token);
  }

  Future<void> clearAccessToken() async {
    final prefs = await _getPrefs();
    await prefs.remove(_accessTokenKey);
  }
}
