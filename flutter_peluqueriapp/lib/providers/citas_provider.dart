// path: lib/providers/citas_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_peluqueriapp/models/grupo_model.dart';
import 'package:flutter_peluqueriapp/models/servicio_model.dart';
import 'package:flutter_peluqueriapp/services/agenda_service.dart';

class CitasProvider extends ChangeNotifier {
  final AgendaService _agendaService = AgendaService();

  // --- ESTADO SELECCIONADO ---
  Servicio? _selectedService;
  Grupo? _selectedGrupo; // null significa "Cualquier grupo"
  DateTime _selectedDate = DateTime.now(); 
  String? _selectedHour; 
  int? _selectedAgendaId; // ⭐ NUEVO: ID de la agenda para el POST

  // --- DATOS CARGADOS DESDE API ---
  List<Grupo> grupos = [];
  List<DateTime> diasDisponibles = []; 
  
  // ⭐ NUEVA ESTRUCTURA: Mapa complejo
  // Key: "10:00" -> Value: { "disponible": true, "agendaId": 15 }
  Map<String, Map<String, dynamic>> horasInfo = {}; 

  // --- FLAGS DE CARGA ---
  bool _isLoadingGrupos = false;
  bool _isLoadingDias = false; // (Opcional usarlo en UI)
  bool _isLoadingHoras = false;

  // --- GETTERS ---
  Servicio? get selectedService => _selectedService;
  Grupo? get selectedGrupo => _selectedGrupo;
  DateTime get selectedDate => _selectedDate;
  String? get selectedHour => _selectedHour;
  int? get selectedAgendaId => _selectedAgendaId;
  
  bool get isLoading => _isLoadingGrupos || _isLoadingDias || _isLoadingHoras;

  // --- MÉTODOS DE LÓGICA DE NEGOCIO ---

  // 1. Inicializar (Al entrar a la pantalla)
  void init(Servicio servicio) {
    _selectedService = servicio;
    _selectedGrupo = null;
    _selectedHour = null;
    _selectedAgendaId = null;
    _selectedDate = DateTime.now(); 
    
    _loadGrupos(); 
    _loadDias();   
  }

  // 2. Cambiar Servicio
  void setService(Servicio? s) {
    if (s == null || s == _selectedService) return;
    _selectedService = s;
    // Reseteamos cascada hacia abajo
    _selectedGrupo = null; 
    _selectedHour = null;
    _selectedAgendaId = null;
    
    notifyListeners();
    _loadGrupos();
    _loadDias();
  }

  // 3. Cambiar Grupo
  void setGrupo(Grupo? g) {
    if (g == _selectedGrupo) return;
    _selectedGrupo = g;
    // Reseteamos hora
    _selectedHour = null; 
    _selectedAgendaId = null;
    
    notifyListeners();
    _loadDias(); // Los días pueden cambiar según el grupo
  }

  // 4. Cambiar Fecha
  void setDate(DateTime date) {
    // Normalizamos fecha (quitamos hora) para comparaciones limpias
    final newDate = DateTime(date.year, date.month, date.day);
    
    if (_isSameDay(_selectedDate, newDate)) return;

    _selectedDate = newDate;
    _selectedHour = null; // Nueva fecha = hora reseteada
    _selectedAgendaId = null;

    notifyListeners();
    _loadHoras();
  }

  // 5. Cambiar Hora
  void setHour(String h) {
    _selectedHour = h;
    
    // ⭐ Buscamos el ID de la agenda asociado a esta hora
    if (horasInfo.containsKey(h)) {
      _selectedAgendaId = horasInfo[h]!['agendaId'];
    }

    notifyListeners();
  }

  // Helper para comparar fechas
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // --- CARGAS ASÍNCRONAS ---

  Future<void> _loadGrupos() async {
    if (_selectedService == null) return;
    _isLoadingGrupos = true;
    notifyListeners();

    grupos = await _agendaService.getGruposPorServicio(_selectedService!.id);
    
    _isLoadingGrupos = false;
    notifyListeners();
  }

  Future<void> _loadDias() async {
    if (_selectedService == null) return;
    // _isLoadingDias = true; // Opcional
    
    // 1. Pedir días al backend
    final nuevosDias = await _agendaService.getDiasDisponibles(
      servicioId: _selectedService!.id,
      grupoId: _selectedGrupo?.id,
      mes: _selectedDate,
    );
    
    diasDisponibles = nuevosDias;

    // 2. ⭐ LÓGICA ANTI-CRASH: Validar fecha seleccionada
    if (diasDisponibles.isNotEmpty) {
      // Verificamos si la fecha actual está en la lista de disponibles
      bool fechaActualEsValida = diasDisponibles.any((d) => _isSameDay(d, _selectedDate));

      if (!fechaActualEsValida) {
        // Si no es válida, saltamos automáticamente a la primera disponible
        _selectedDate = diasDisponibles.first;
        _selectedHour = null;
        _selectedAgendaId = null;
        
        notifyListeners(); // Actualizar UI (Calendario cambiará de mes si hace falta)
        _loadHoras();      // Cargar horas de la NUEVA fecha
        return;            // Salimos
      }
    } else {
      // Si no hay días, limpiamos todo
      _selectedHour = null;
      _selectedAgendaId = null;
    }
    
    notifyListeners();
    // Si la fecha era válida, cargamos horas normalmente
    if (diasDisponibles.isNotEmpty) {
      _loadHoras();
    }
  }

  Future<void> _loadHoras() async {
    if (_selectedService == null) return;
    _isLoadingHoras = true;
    horasInfo = {}; // Limpiar visualmente antes de cargar
    notifyListeners();

    horasInfo = await _agendaService.getHorasDisponibles(
      servicioId: _selectedService!.id,
      grupoId: _selectedGrupo?.id,
      fecha: _selectedDate,
    );

    _isLoadingHoras = false;
    notifyListeners();
  }
}