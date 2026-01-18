import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_peluqueriapp/models/servicio_model.dart';
import 'package:flutter_peluqueriapp/models/tipo_servicio_model.dart';
import 'package:flutter_peluqueriapp/services/servicio_service.dart';
import 'package:flutter_peluqueriapp/services/tipo_servicio_service.dart';

class ServicesProvider extends ChangeNotifier {
  final ServicioService _servicioService = ServicioService();
  final TipoServicioService _tipoServicioService = TipoServicioService();

  // Controladores de Texto y UI
  final TextEditingController searchController = TextEditingController();
  
  // Mapa de controladores para los ExpansionTiles
  final Map<int, ExpansionTileController> _controllers = {};
  
  // ⭐ NUEVO: Mapa de Keys para el auto-scroll
  final Map<int, GlobalKey> _keys = {};

  bool _isLoading = true;
  bool _isSearching = false;
  Timer? _debounce;

  // Datos
  List<TipoServicio> types = [];
  List<Servicio> allServices = [];
  Map<int, List<Servicio>> groupedServices = {};
  List<Servicio> searchResults = [];

  // Getters
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;

  ServicesProvider() {
    _loadInitialData();
  }

  // Carga inicial de datos
  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _tipoServicioService.getTipos(),
        _servicioService.getServicios(),
      ]);

      types = results[0] as List<TipoServicio>;
      allServices = results[1] as List<Servicio>;
      
      _groupServices();
      
    } catch (e) {
      print("Error cargando servicios: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Agrupar servicios por categoría
  void _groupServices() {
    groupedServices = {};
    for (var s in allServices) {
      groupedServices.putIfAbsent(s.tipoId, () => []);
      groupedServices[s.tipoId]!.add(s);
    }
  }

  // Gestión de controladores
  ExpansionTileController getController(int id) {
    return _controllers.putIfAbsent(id, () => ExpansionTileController());
  }

  // ⭐ NUEVO: Gestión de Keys
  GlobalKey getKey(int id) {
    return _keys.putIfAbsent(id, () => GlobalKey());
  }

  // Cierra todos los acordeones MENOS el que acabamos de abrir
  void expandType(int idToExpand) {
    _controllers.forEach((key, controller) {
      if (key != idToExpand) {
        if (controller.isExpanded) {
          controller.collapse();
        }
      }
    });
  }

  // Lógica del buscador
  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 350), () async {
      if (query.trim().isEmpty) {
        _isSearching = false;
        searchResults = [];
        notifyListeners();
        return;
      }

      _isSearching = true;
      notifyListeners(); 

      final res = await _servicioService.buscarServiciosPorNombre(query);
      searchResults = res;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}