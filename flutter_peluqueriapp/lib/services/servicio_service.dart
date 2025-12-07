import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_peluqueriapp/services/auth_service.dart';
import '../models/servicio_model.dart';

class ServicioService {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  final auth = AuthService();

  Future<List<Servicio>> getServicios() async {
    final url = Uri.parse("$baseUrl/api/servicios/");

    try {
      final headers = await auth.getAuthHeaders();

      final res = await http.get(url, headers: headers);

      print("SERVICIOS status: ${res.statusCode}");
      print("SERVICIOS body: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List;
        return data.map((e) => Servicio.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print("Error obteniendo servicios: $e");
      return [];
    }
  }
}
