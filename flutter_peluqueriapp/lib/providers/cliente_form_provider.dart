import 'package:flutter/material.dart';
import 'package:flutter_peluqueriapp/services/cliente_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ClienteService _clienteService = ClienteService();

  // Mantenemos los controladores aquí para poder asignarles 
  // el texto cuando lleguen los datos de la API.
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController(); // Email suele ser solo lectura
  TextEditingController allergiesCtrl = TextEditingController();
  TextEditingController observationsCtrl = TextEditingController();

  bool _isLoading = true; // Empieza cargando porque hay que pedir datos
  bool get isLoading => _isLoading;
  
  int? _userId;

  ClientFormProvider() {
    _loadInitialData();
  }

  // Carga inicial de datos
  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    // 1. Obtener ID del usuario logueado
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('id');

    if (_userId != null) {
      // 2. Pedir datos a la API
      final data = await _clienteService.getClienteInfo(_userId!);
      
      if (data != null) {
        // 3. Rellenar los controladores con la info recibida
        nameCtrl.text = data['nombreCompleto'] ?? '';
        phoneCtrl.text = data['telefono'] ?? '';
        emailCtrl.text = data['email'] ?? '';
        allergiesCtrl.text = data['alergenos'] ?? '';
        observationsCtrl.text = data['observaciones'] ?? '';
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  // Método para guardar cambios
  Future<bool> updateClient() async {
    if (!formKey.currentState!.validate()) return false;
    if (_userId == null) return false;

    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> data = {
      "nombreCompleto": nameCtrl.text,
      "telefono": phoneCtrl.text,
      "email": emailCtrl.text, // A veces el backend no permite cambiar email
      "alergenos": allergiesCtrl.text,
      "observaciones": observationsCtrl.text,
    };

    final success = await _clienteService.updateCliente(_userId!, data);

    _isLoading = false;
    notifyListeners();
    
    return success;
  }
  
  // Limpieza de controladores al destruir el provider
  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    allergiesCtrl.dispose();
    observationsCtrl.dispose();
    super.dispose();
  }
}