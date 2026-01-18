import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_peluqueriapp/services/auth_service.dart';
import 'package:flutter_peluqueriapp/models/grupo_model.dart';
import 'package:intl/intl.dart'; // Asegúrate de tener intl en pubspec.yaml

class AgendaService {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';
  final AuthService _authService = AuthService();

  // 1. Obtener grupos que dan un servicio específico
  Future<List<Grupo>> getGruposPorServicio(int servicioId) async {
    final url = Uri.parse('$baseUrl/api/grupos/?servicio=$servicioId');
    try {
      final headers = await _authService.getAuthHeaders();
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        return data.map((e) => Grupo.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print("Error obteniendo grupos: $e");
      return [];
    }
  }

  // 2. Obtener DÍAS disponibles (LocalDate)
  // Devuelve una lista de DateTime limpios (sin hora)
  Future<List<DateTime>> getDiasDisponibles({
    required int servicioId,
    int? grupoId,
    required DateTime mes, // Para optimizar y no pedir años enteros si no quieres
  }) async {
    // Pedimos desde hoy hasta dentro de 3 meses por ejemplo
    final start = DateTime.now();
    final end = start.add(const Duration(days: 90));
    
    final f = DateFormat('yyyy-MM-dd');
    String query = "servicio=$servicioId&desde=${f.format(start)}&hasta=${f.format(end)}";
    if (grupoId != null) query += "&grupo=$grupoId";

    final url = Uri.parse('$baseUrl/api/agendas/dias/?$query');

    try {
      final headers = await _authService.getAuthHeaders();
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        // El backend devuelve strings "2024-01-20", los parseamos
        return data.map((dateStr) => DateTime.parse(dateStr)).toList();
      }
      return [];
    } catch (e) {
      print("Error obteniendo días: $e");
      return [];
    }
  }

  // 3. Obtener HORAS (AgendaResponseDTO)
  // Devuelve un mapa de Hora -> Disponible(true/false)
  // En lib/services/agenda_service.dart

  // Devuelve: "10:00" -> {"disponible": true, "agendaId": 5}
  Future<Map<String, Map<String, dynamic>>> getHorasDisponibles({
    required int servicioId,
    int? grupoId,
    required DateTime fecha,
  }) async {
    final f = DateFormat('yyyy-MM-dd');
    String dateStr = f.format(fecha);
    
    String query = "servicio=$servicioId&desde=$dateStr&hasta=$dateStr";
    if (grupoId != null) query += "&grupo=$grupoId";

    final url = Uri.parse('$baseUrl/api/agendas/?$query');

    try {
      final headers = await _authService.getAuthHeaders();
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        
        // Mapa final: "10:00" -> { disponible: true, agendaId: 123 }
        Map<String, Map<String, dynamic>> horasInfo = {};

        for (var agenda in data) {
          int agendaId = agenda['id']; // Capturamos el ID de la agenda
          Map<String, dynamic> horasMap = agenda['horasDisponiblesEstado'];
          
          horasMap.forEach((key, value) {
            // key es "2025-01-20T10:00:00"
            DateTime fullDate = DateTime.parse(key);
            String horaSimple = DateFormat('HH:mm').format(fullDate);
            bool isAvailable = value == true;

            // Lógica de prioridad:
            // Si la hora ya existe en el mapa:
            // 1. Si la que teníamos NO estaba disponible y la nueva SÍ -> Nos quedamos con la nueva.
            // 2. Si ya estaba disponible, no hace falta cambiar (cualquier agenda disponible nos vale).
            // Si no existe, la añadimos.
            
            if (horasInfo.containsKey(horaSimple)) {
               bool currentAvailable = horasInfo[horaSimple]!['disponible'];
               if (!currentAvailable && isAvailable) {
                 horasInfo[horaSimple] = {'disponible': true, 'agendaId': agendaId};
               }
            } else {
               horasInfo[horaSimple] = {'disponible': isAvailable, 'agendaId': agendaId};
            }
          });
        }
        
        // Ordenamos por hora para que salgan en orden (09:00, 09:30...)
        var sortedKeys = horasInfo.keys.toList()..sort();
        return {for (var k in sortedKeys) k: horasInfo[k]!};
      }
      return {};
    } catch (e) {
      print("Error obteniendo horas: $e");
      return {};
    }
  }
}