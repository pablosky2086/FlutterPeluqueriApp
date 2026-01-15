import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'secure_storage.dart';

class AuthService {
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  final SecureStorageService _storage = SecureStorageService();

  Future <bool> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/api/auth/login');
    try{
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password})
      );

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        // Login successful
        final data = jsonDecode(response.body);
        await _storage.saveToken(data['accessToken'], data['tokenType']);
        print(data);
        return true;
      } else {
        // Login failed
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  // Obtener el ID del usuario almacenado en SharedPreferences
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id');
  }

  Future<bool> register(String email, String password) async {
    final url = Uri.parse('$_baseUrl/api/auth/register/cliente');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        // Registration successful
        return true;
      } else {
        // Registration failed
        return false;
      }
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }


  //Funcion para dar los headers con el token
  Future<Map<String, String>> getAuthHeaders() async {
//    final prefs = await SharedPreferences.getInstance();
//    final accessToken = prefs.getString('accessToken') ?? '';
//    final tokenType = prefs.getString('tokenType') ?? '';

    final accessToken = await _storage.getAccessToken();
    final tokenType = await _storage.getTokenType();

    if (accessToken == null || tokenType == null) {
      throw Exception('No access token or token type found');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': '$tokenType $accessToken',
    };
  }

  // Función para comprobar si el token es válido
  Future<bool> checkToken() async {
  try {
    final headers = await getAuthHeaders();
    final url = Uri.parse('$_baseUrl/api/servicios/');
    final response = await http.get(url, headers: headers);
    return response.statusCode == 200;
  } catch (_) {
    return false;
  }
}

}