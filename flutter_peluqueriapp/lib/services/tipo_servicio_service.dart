import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_peluqueriapp/services/auth_service.dart';
import '../models/tipo_servicio_model.dart';

class TipoServicioService {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  final auth = AuthService();

  Future<List<TipoServicio>> getTipos() async {
    final url = Uri.parse("$baseUrl/api/tipos-servicio/");

    try {
      final headers = await auth.getAuthHeaders();

      final res = await http.get(url, headers: headers);

      print("TIPOS status: ${res.statusCode}");
      print("TIPOS body: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List;
        return data.map((e) => TipoServicio.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print("Error obteniendo tipos: $e");
      return [];
    }
  }
}
