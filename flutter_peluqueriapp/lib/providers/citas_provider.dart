import 'package:flutter/material.dart';
import 'package:flutter_peluqueriapp/models/grupo_model.dart';
import 'package:flutter_peluqueriapp/models/servicio_model.dart';
import 'package:flutter_peluqueriapp/services/agenda_service.dart';

class CitasProvider extends ChangeNotifier {
  final AgendaService _agendaService = AgendaService();

  // --- ESTADO ---
  Servicio? _selectedService;
  Grupo? _selectedGrupo; // null significa "Cualquier grupo"
  DateTime _selectedDate = DateTime.now(); // Día seleccionado en calendario
  String? _selectedHour; // Hora seleccionada ("10:30")

  // --- DATOS CARGADOS ---
  List<Grupo> grupos = [];
  List<DateTime> diasDisponibles = []; // Días pintados en el calendario
  Map<String, bool> horasDisponibles = {}; // Horas para el día seleccionado

  bool _isLoadingGrupos = false;
  bool _isLoadingDias = false;
  bool _isLoadingHoras = false;

  // Getters
  Servicio? get selectedService => _selectedService;
  Grupo? get selectedGrupo => _selectedGrupo;
  DateTime get selectedDate => _selectedDate;
  String? get selectedHour => _selectedHour;
  
  bool get isLoading => _isLoadingGrupos || _isLoadingDias || _isLoadingHoras;

  // --- LÓGICA ---

  // 1. Inicializar con un servicio (cuando entras a la pantalla)
  void init(Servicio servicio) {
    _selectedService = servicio;
    _selectedGrupo = null;
    _selectedHour = null;
    _selectedDate = DateTime.now(); // O la lógica de siguiente Lunes
    
    _loadGrupos(); // Cargar grupos para este servicio
    _loadDias();   // Cargar días disponibles iniciales
  }

  // 2. Cambiar Servicio (desde el dropdown 1)
  void setService(Servicio? s) {
    if (s == null || s == _selectedService) return;
    _selectedService = s;
    _selectedGrupo = null; // Reset grupo
    _selectedHour = null;  // Reset hora
    
    notifyListeners();
    _loadGrupos();
    _loadDias();
  }

  // 3. Cambiar Grupo (desde el dropdown 2)
  void setGrupo(Grupo? g) {
    if (g == _selectedGrupo) return;
    _selectedGrupo = g;
    _selectedHour = null; // Reset hora, porque el nuevo grupo puede no tener esa hora
    
    notifyListeners();
    _loadDias(); // Los días cambian según el grupo
    // Si la fecha seleccionada ya no es válida, deberíamos manejarlo, 
    // pero _loadHoras se encargará de refrescar
    _loadHoras(); 
  }

  // 4. Cambiar Fecha (click en Calendario)
  void setDate(DateTime date) {
    // Normalizamos la fecha para evitar problemas de horas
    final newDate = DateTime(date.year, date.month, date.day);
    if (_selectedDate.isAtSameMomentAs(newDate)) return;

    _selectedDate = newDate;
    _selectedHour = null; // Nueva fecha, reseteamos hora seleccionada
    notifyListeners();
    
    _loadHoras();
  }

  // 5. Cambiar Hora (click en chip de hora)
  void setHour(String h) {
    _selectedHour = h;
    notifyListeners();
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

  

  // En lib/providers/citas_provider.dart

  // Necesitarás esta función auxiliar dentro de la clase CitasProvider
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _loadDias() async {
    if (_selectedService == null) return;
    
    // 1. Obtenemos los días del backend
    final nuevosDias = await _agendaService.getDiasDisponibles(
      servicioId: _selectedService!.id,
      grupoId: _selectedGrupo?.id,
      mes: _selectedDate,
    );

    // 2. Actualizamos la lista
    diasDisponibles = nuevosDias;

    // 3. ⭐ LA CORRECCIÓN: Validar la fecha seleccionada
    if (diasDisponibles.isNotEmpty) {
      // Verificamos si la fecha que tenemos seleccionada (ej. Hoy) está en la lista de la API
      bool fechaActualEsValida = diasDisponibles.any((d) => _isSameDay(d, _selectedDate));

      if (!fechaActualEsValida) {
        // Si "Hoy" no es válido, forzamos la selección al PRIMER día disponible que devolvió la API
        _selectedDate = diasDisponibles.first;
        // Y como cambiamos de fecha, hay que recargar las horas para esa nueva fecha
        _selectedHour = null; // Reseteamos hora
        notifyListeners(); // Notificamos para que la UI se entere del cambio de fecha
        _loadHoras(); // Cargamos horas de la nueva fecha
        return; // Salimos para no llamar a loadHoras dos veces
      }
    } else {
      // Si no hay días disponibles en absoluto
      _selectedHour = null;
    }
    
    notifyListeners();
    // Si la fecha era válida, cargamos las horas normalmente
    if (diasDisponibles.isNotEmpty) {
      _loadHoras();
    }
  }

  Future<void> _loadHoras() async {
    if (_selectedService == null) return;
    _isLoadingHoras = true;
    horasDisponibles = {}; // Limpiamos visualmente
    notifyListeners();

    horasDisponibles = await _agendaService.getHorasDisponibles(
      servicioId: _selectedService!.id,
      grupoId: _selectedGrupo?.id,
      fecha: _selectedDate,
    );

    _isLoadingHoras = false;
    notifyListeners();
  }
}