// path: lib/providers/register_form_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_peluqueriapp/services/auth_service.dart';

class RegisterFormProvider extends ChangeNotifier {

  // 1. Clave global para validar el formulario
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // 2. Variables de estado
  String email = '';
  String password = '';
  // Necesitamos guardar esta variable para compararla en el validador
  String confirmPassword = ''; 

  bool _isLoading = false;
  bool _obscurePassword = true;

  // GETTERS Y SETTERS
  // -----------------
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get obscurePassword => _obscurePassword;
  set obscurePassword(bool value) {
    _obscurePassword = value;
    notifyListeners();
  }

  // Método para alternar visibilidad de contraseña
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
  }

  // 3. Método de validación interna
  bool isValidForm() {
    // Esto disparará los validadores de cada TextFormField
    return formKey.currentState?.validate() ?? false;
  }

  // 4. Lógica de Envío (Orquestación)
  Future<bool> onFormSubmit(AuthService authService) async {
    // a) Validar campos (incluyendo que las contraseñas coincidan)
    if (!isValidForm()) return false;

    // b) Activar carga
    isLoading = true;

    // c) Llamar al servicio de registro
    final bool success = await authService.register(email, password);

    // d) Desactivar carga
    isLoading = false;

    return success;
  }
}