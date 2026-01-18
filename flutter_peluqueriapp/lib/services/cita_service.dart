import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_peluqueriapp/services/auth_service.dart';

class CitaService {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  final AuthService _authService = AuthService();

  Future<bool> createCita({
    required int agendaId,
    required String fechaHoraInicio, // Formato ISO: "2026-01-20T10:00:00"
  }) async {
    
    final url = Uri.parse('$baseUrl/api/citas/');
    
    // Obtenemos el ID del cliente logueado
    final clienteId = await _authService.getUserId();
    if (clienteId == null) return false;

    final body = {
      "clienteId": clienteId,
      "agendaId": agendaId,
      "fechaHoraInicio": fechaHoraInicio
    };

    try {
      final headers = await _authService.getAuthHeaders();
      final res = await http.post(
        url, 
        headers: headers,
        body: jsonEncode(body),
      );

      print("CREATE CITA status: ${res.statusCode}");
      print("CREATE CITA body: ${res.body}");

      if (res.statusCode == 201 || res.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print("Error creando cita: $e");
      return false;
    }
  }
}