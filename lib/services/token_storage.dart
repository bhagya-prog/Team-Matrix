import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _key = 'auth_token';

  Future<void> saveToken(String token) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, token);
    } else {
      const storage = FlutterSecureStorage();
      await storage.write(key: _key, value: token);
    }
  }

  Future<String?> getToken() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_key);
    } else {
      const storage = FlutterSecureStorage();
      return storage.read(key: _key);
    }
  }

  Future<void> clearToken() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } else {
      const storage = FlutterSecureStorage();
      await storage.delete(key: _key);
    }
  }
}

class FlutterSecureStorage {
  const FlutterSecureStorage();
  
  Future<void> write({required String key, required String value}) async {}
  
  Future<void> delete({required String key}) async {}
  
  Future<String?> read({required String key}) async {}
}
