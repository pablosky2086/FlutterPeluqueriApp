import 'package:flutter/material.dart';
import 'package:flutter_peluqueriapp/providers/auth_provider.dart';

class LoginFormProvider extends ChangeNotifier {
  // key global para controlar el formulario
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // variables de estado
  String email = '';
  String password = '';
  bool _isLoading = false;
  bool _obscurePassword = true;
  // métodos
  // Getter y setter para isLoading
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  // Getter y setter para obscurePassword
  bool get obscurePassword => _obscurePassword;
  set obscurePassword(bool value) {
    _obscurePassword = value;
    notifyListeners();
  }
  // Toggle para obscurePassword
  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }
  // Validar el formulario
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  // Cuando el usuario haga submit se validara el formulario y se hara login
  Future<bool> onFormSubmit(AuthProvider authProvider) async {
    if (!isValidForm()) return false;
    isLoading = true;
    final success = await authProvider.login(email, password);
    isLoading = false;
    return success;
  }
}