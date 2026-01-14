import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/secure_storage.dart';

enum AuthStatus {
  checking,
  authenticated,
  unauthenticated,
}

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final SecureStorageService _storage = SecureStorageService();

  AuthStatus status = AuthStatus.checking;

  AuthProvider() {
    checkSession();
  }

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

    // Probamos si el token sigue siendo válido
    final isValid = await _authService.checkToken();

    print("AUTH CHECK -> backend valid: $isValid");

    status = isValid
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;

    if (!isValid) {
      await logout();
    }

    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final result = await _authService.login(email, password);
    if (result) {
      status = AuthStatus.authenticated;
      notifyListeners();
    }
    return result;
  }

  Future<void> logout() async {
    await _storage.clear();
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
