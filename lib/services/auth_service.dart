import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:8000/api/users';  // Para emulador

  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login/');
    print("🔄 Intentando login en: $url");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    print("🟡 Código de respuesta: ${response.statusCode}");
    print("🟡 Respuesta: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['token'];
      print("✅ Token recibido: $token");
      await _saveToken(token);
      return true;
    } else {
      print("❌ Error en login: ${response.body}");
      return false;
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}