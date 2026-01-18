import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'secure_storage.dart';

class AuthService {
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  final SecureStorageService _storage = SecureStorageService();

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/api/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // 1. Guardar Tokens (Seguro)
        await _storage.saveToken(data['accessToken'], data['tokenType']);

        // 2. ⭐ NUEVO: Guardar ID del usuario en SharedPreferences
        // Esto es necesario para que ClientFormProvider sepa qué usuario cargar
        final prefs = await SharedPreferences.getInstance();
        if (data.containsKey('id')) {
           await prefs.setInt('id', data['id']);
           print("ID Guardado: ${data['id']}");
        }
        
        // Opcional: Guardar nombre o email si vienen en la respuesta para mostrarlos rápido
        if (data.containsKey('email')) {
           await prefs.setString('email', data['email']);
        }

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  // ... (getUserId, register y getAuthHeaders se quedan igual) ...
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
      return response.statusCode == 200; // Simplificado
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  Future<Map<String, String>> getAuthHeaders() async {
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

  // ⭐ NUEVO: Método logout en el servicio para limpiar todo
  Future<void> logout() async {
    // Borrar tokens
    await _storage.clear(); 
    // Borrar ID y datos de sesión
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 
  }

  // Método para solicitar recuperación de contraseña
  Future<bool> requestPasswordReset(String email) async {
    // Construimos la URL con el parámetro query 'email'
    // Tu backend: @PostMapping("/forgot-password") public String solicitarReset(@RequestParam String email)
    final url = Uri.parse('$_baseUrl/api/auth/forgot-password')
        .replace(queryParameters: {'email': email});

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print("RESET PASSWORD status: ${response.statusCode}");
      
      // Tu backend devuelve un String plano, no un JSON, así que solo miramos el status 200
      return response.statusCode == 200;
    } catch (e) {
      print("Error solicitando reset password: $e");
      return false;
    }
  }
}