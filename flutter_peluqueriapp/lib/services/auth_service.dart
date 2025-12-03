import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';

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
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', data['accessToken']);
        await prefs.setString('tokenType', data['tokenType']);
        await prefs.setInt('id', data['id']);
        await prefs.setString('username', data['username']);

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
}

  /*Future<bool> register(String email, String password) async {
    final url = Uri.parse('$_baseUrl/api/auth/register');
    try {
      final response = await http.post(url, body: {
        'email': email,
        'password': password,
      });
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


}


class AuthService {
  final String _baseUrl = dotenv.env['API_URL'] ?? 'https://default-api-url.com';

  Future<http.Response> login(String username, String password) {
    final url = Uri.parse('$_baseUrl/login');
    return http.post(url, body: {'username': username, 'password': password});
  }

  Future<http.Response> register(String username, String password) {
    final url = Uri.parse('$_baseUrl/register');
    return http.post(url, body: {'username': username, 'password': password});
  }
}*/