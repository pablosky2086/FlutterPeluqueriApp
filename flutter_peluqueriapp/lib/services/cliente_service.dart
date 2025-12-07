import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_peluqueriapp/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ClienteService {
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  final AuthService _authService = AuthService();

  Future <Map<String, dynamic>?> getClienteInfo(int id) async {
    final url = Uri.parse('$_baseUrl/api/clientes/$id');
    try{

      Map<String, String> headers = await  _authService.getAuthHeaders();
      final response = await http.get(
        url,
        headers: headers,
      );

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        // Login successful
        final data = jsonDecode(response.body);
        return data;
      } else {
        // Login failed
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  Future<bool> updateCliente(int id, Map<String, dynamic> data) async {
  final url = Uri.parse('$_baseUrl/api/clientes/$id');

  try {
    Map<String, String> headers = await _authService.getAuthHeaders();
    headers['Content-Type'] = 'application/json';

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    print("UPDATE status: ${response.statusCode}");
    return response.statusCode == 200;
  } catch (e) {
    print("Error updating client: $e");
    return false;
  }
}


}