import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'token_storage.dart';

class BackendService {
  // ✅ Change this for phone testing: put your laptop IP (same Wi-Fi)
  // Example: "192.168.1.10"
  static const String _lanIp = "172.16.84.255";

  static String get baseUrl {
    // Flutter Web / Desktop usually can use localhost
    if (kIsWeb) return "http://127.0.0.1:8000";

    // For Android emulator, localhost is 10.0.2.2
    // For physical phone, must use your laptop LAN IP
    // We'll default to LAN IP for safety (works on phone).
    // If you're testing on emulator only, you can switch to 10.0.2.2.
    return "http://$_lanIp:8000";
  }

  // -----------------------------
  // ✅ YOUR EXISTING VOICE API
  // -----------------------------
  static Future<Map<String, dynamic>> processVoice({
    required String text,
    required String languageCode,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/process-voice"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "text_input": text,
        "language_code": languageCode,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception("Voice backend error: ${response.statusCode}");
    }
  }

  // -----------------------------
  // ✅ AUTH: LOGIN
  // Backend: POST /auth/login
  // Expected response: { "access_token": "...", ... }
  // -----------------------------
  static Future<bool> login({
    required String phone,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "phone": phone,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final token = data["access_token"]?.toString();
      if (token == null || token.isEmpty) return false;

      await TokenStorage().saveToken(token);
      return true;
    }
    return false;
  }

  // -----------------------------
  // ✅ AUTH: VERIFY (AuthGate uses this)
  // Backend: GET /auth/me (protected)
  // 200 => user json
  // 401/403 => invalid token
  // -----------------------------
  static Future<Map<String, dynamic>?> getMe() async {
    final token = await TokenStorage().getToken();
    if (token == null || token.isEmpty) return null;

    final response = await http.get(
      Uri.parse("$baseUrl/auth/me"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    return null;
  }

  // -----------------------------
  // ✅ LOGOUT (client side)
  // -----------------------------
  static Future<void> logout() async {
    await TokenStorage().clearToken();
  }
}
