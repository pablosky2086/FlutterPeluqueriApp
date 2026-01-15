import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/secure_storage.dart';

enum AuthStatus {
  checking,        // Comprobando si hay token guardado
  authenticated,   // Usuario logueado y token válido
  unauthenticated, // No hay usuario o el token expiró
}

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final SecureStorageService _storage = SecureStorageService();

  // Estado inicial: Comprobando
  AuthStatus status = AuthStatus.checking;

  AuthProvider() {
    checkSession();
  }

  // Verificar si ya existe una sesión guardada al abrir la app
  Future<void> checkSession() async {
    final token = await _storage.getAccessToken();
    final type = await _storage.getTokenType();

    print("AUTH CHECK -> token: $token");
    print("AUTH CHECK -> type: $type");

    if (token == null || type == null) {
      status = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }

    // Opcional: Verificar con el backend si el token sigue siendo válido
    final isValid = await _authService.checkToken();

    print("AUTH CHECK -> backend valid: $isValid");

    if (isValid) {
      status = AuthStatus.authenticated;
      notifyListeners();
    } else {
      // Si el token expiró o no es válido, cerramos sesión
      await logout();
    }
  }

  // Método de Login
  Future<bool> login(String email, String password) async {
    // El servicio se encarga de guardar el Token y el ID del usuario en disco
    final result = await _authService.login(email, password);
    
    if (result) {
      status = AuthStatus.authenticated;
      notifyListeners(); // Esto redirige al MenuScreen automáticamente
    }
    return result;
  }

  // Método de Registro (opcional, si quieres gestionarlo desde aquí)
  Future<bool> register(String email, String password) async {
    final result = await _authService.register(email, password);
    // Nota: Normalmente el registro no hace login automático, 
    // pero si tu API devuelve token al registrar, podrías hacer:
    // if (result) await login(email, password);
    return result;
  }

  // Método de Logout
  Future<void> logout() async {
    // 1. Limpiamos datos del dispositivo (Tokens y SharedPreferences con el ID)
    await _authService.logout();
    
    // 2. Cambiamos el estado
    status = AuthStatus.unauthenticated;
    
    // 3. Notificamos a los widgets (especialmente al main.dart)
    notifyListeners();
  }
}