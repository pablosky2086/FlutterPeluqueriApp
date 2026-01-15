// path: lib/screens/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importamos Providers y Servicios
import 'package:flutter_peluqueriapp/services/auth_service.dart';
import 'package:flutter_peluqueriapp/providers/register_form_provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Envolvemos el cuerpo en el Provider del formulario de registro
      body: ChangeNotifierProvider(
        create: (_) => RegisterFormProvider(),
        child: const _RegisterFormContent(),
      ),
    );
  }
}

class _RegisterFormContent extends StatelessWidget {
  const _RegisterFormContent();

  @override
  Widget build(BuildContext context) {
    // Accedemos al provider del formulario
    final registerForm = Provider.of<RegisterFormProvider>(context);

    return Container(
      // Decoración de fondo igual que el login
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFF3E0), Color(0xFFFDEBCF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              // Conectamos la Key para poder validar
              key: registerForm.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // CABECERA
                  Column(
                    children: [
                      Image.asset('assets/splash.png', width: 100, height: 100),
                      const SizedBox(height: 16),
                      const Text(
                        "Crear Cuenta",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),

                  // ------------------------------------------------
                  // INPUT EMAIL
                  // ------------------------------------------------
                  TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      labelText: "Email",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) => registerForm.email = value,
                    validator: (value) {
                       String pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regExp = RegExp(pattern);
                      return regExp.hasMatch(value ?? '')
                          ? null
                          : 'El correo no es válido';
                    },
                  ),
                  const SizedBox(height: 20),

                  // ------------------------------------------------
                  // INPUT PASSWORD
                  // ------------------------------------------------
                  TextFormField(
                    autocorrect: false,
                    obscureText: registerForm.obscurePassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      labelText: "Contraseña",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          registerForm.obscurePassword 
                            ? Icons.visibility 
                            : Icons.visibility_off
                        ),
                        onPressed: () => registerForm.togglePasswordVisibility(),
                      )
                    ),
                    onChanged: (value) => registerForm.password = value,
                    validator: (value) {
                      return (value != null && value.length >= 6)
                          ? null
                          : 'La contraseña debe tener 6 caracteres';
                    },
                  ),
                  const SizedBox(height: 20),

                  // ------------------------------------------------
                  // INPUT REPEAT PASSWORD
                  // ------------------------------------------------
                  TextFormField(
                    autocorrect: false,
                    obscureText: registerForm.obscurePassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      labelText: "Repetir contraseña",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    // Guardamos también este valor para futuras comprobaciones si hicieran falta
                    onChanged: (value) => registerForm.confirmPassword = value,
                    // VALIDACIÓN ESPECIAL: Comparamos con la contraseña guardada en el provider
                    validator: (value) {
                      if (value != registerForm.password) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // ------------------------------------------------
                  // BOTÓN CREAR CUENTA
                  // ------------------------------------------------
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF4B95B),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Deshabilitar si está cargando
                    onPressed: registerForm.isLoading
                        ? null
                        : () async {
                            // 1. Quitar teclado
                            FocusScope.of(context).unfocus();

                            // 2. Obtener servicio de autenticación
                            final authService = Provider.of<AuthService>(context, listen: false);

                            // 3. Ejecutar submit en el Provider del formulario
                            final bool success = await registerForm.onFormSubmit(authService);

                            if (success) {
                              // Mostrar éxito y volver al login
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Cuenta creada correctamente"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              // Volvemos atrás (al Login)
                              Navigator.pop(context);
                            } else {
                              // Mostrar error
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Error al crear la cuenta (Email en uso o error de red)"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                    child: Text(
                      registerForm.isLoading ? 'Registrando...' : "Crear usuario"
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ------------------------------------------------
                  // BOTÓN CANCELAR
                  // ------------------------------------------------
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(
                        color: Color(0xFFF4B95B),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(fontSize: 18, color: Color(0xFFF4B95B)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Center(
                    child: Text(
                      "¡Bienvenido a PeluqueriApp!",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}