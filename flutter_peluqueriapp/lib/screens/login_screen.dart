import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importaciones de tus providers y pantallas
import 'package:flutter_peluqueriapp/providers/auth_provider.dart';
import 'package:flutter_peluqueriapp/providers/login_form_provider.dart';
import 'package:flutter_peluqueriapp/screens/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true permite que el teclado empuje el contenido hacia arriba
      resizeToAvoidBottomInset: true, 
      body: Stack(
        children: [
          // ---------------------------------------------------
          // 1. CAPA DE FONDO (GRADIENTE)
          // ---------------------------------------------------
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFF3E0), Color(0xFFFDEBCF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // ---------------------------------------------------
          // 2. IMAGEN DECORATIVA DE FONDO (PELUQUERO)
          // ---------------------------------------------------
          Positioned(
            top: 50,
            left: -30,
            child: Opacity(
              opacity: 0.35,
              child: Image.asset(
                'assets/peluquero.png',
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.99,
              ),
            ),
          ),

          // ---------------------------------------------------
          // 3. CAPA DE CONTENIDO Y LÓGICA
          // ---------------------------------------------------
          // Envolvemos el contenido del formulario en un ChangeNotifierProvider.
          // Esto crea una instancia de LoginFormProvider que vivirá SOLO mientras
          // esta pantalla esté activa.
          ChangeNotifierProvider(
            create: (_) => LoginFormProvider(),
            child: const _LoginForm(),
          ),
        ],
      ),
    );
  }
}

/// Widget privado que contiene el Formulario.
/// Se separa para poder acceder al contexto del Provider creado arriba.
class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    
    // Obtenemos acceso al LoginFormProvider para leer/escribir datos
    final loginForm = Provider.of<LoginFormProvider>(context);

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            // Conectamos la GlobalKey del Provider al Widget Form
            // Esto permite que el provider pueda ejecutar .validate()
            key: loginForm.formKey,
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // LOGO
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset(
                    'assets/splash.png',
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 20),

                // TÍTULO
                const Text(
                  "Iniciar Sesión",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 32),

                // ---------------------------------------------------
                // INPUT EMAIL
                // ---------------------------------------------------
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
                  // Vinculación: Cuando el usuario escribe, actualizamos el provider
                  onChanged: (value) => loginForm.email = value,
                  // Validación: Lógica simple de regex para email
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

                // ---------------------------------------------------
                // INPUT PASSWORD
                // ---------------------------------------------------
                TextFormField(
                  autocorrect: false,
                  // El estado de si se ve o no la contraseña viene del Provider
                  obscureText: loginForm.obscurePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    labelText: "Contraseña",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    // Icono para mostrar/ocultar contraseña
                    suffixIcon: IconButton(
                      icon: Icon(
                        loginForm.obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      // Al pulsar, llamamos al método del provider que cambia el booleano
                      onPressed: () => loginForm.toggleObscurePassword(),
                    ),
                  ),
                  // Vinculación del texto
                  onChanged: (value) => loginForm.password = value,
                  // Validación mínima de longitud
                  validator: (value) {
                    return (value != null && value.length >= 4)
                        ? null
                        : 'La contraseña debe tener al menos 4 caracteres';
                  },
                ),

                const SizedBox(height: 30),

                // ---------------------------------------------------
                // BOTÓN DE INICIAR SESIÓN
                // ---------------------------------------------------
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
                  // Si el provider indica isLoading, deshabilitamos el botón (null)
                  onPressed: loginForm.isLoading
                      ? null
                      : () async {
                          // 1. Ocultar teclado para mejor UX
                          FocusScope.of(context).unfocus();

                          // 2. Buscamos el AuthProvider (sin escuchar cambios, solo necesitamos la instancia)
                          final authService = Provider.of<AuthProvider>(context, listen: false);

                          // 3. Ejecutamos la lógica centralizada en el LoginFormProvider
                          //    El provider validará, pondrá el loading, llamará al API y quitará el loading.
                          final bool success = await loginForm.onFormSubmit(authService);

                          // 4. Manejamos el resultado visual (El éxito lo maneja MainApp redirigiendo)
                          if (!success) {
                             // Verificamos que el widget siga "vivo" antes de usar context
                             if (!context.mounted) return;
                             
                             ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBar(
                                 content: Text("Error: Credenciales incorrectas"),
                                 backgroundColor: Colors.red,
                               ),
                             );
                          }
                        },
                  child: Text(
                    // Cambiamos el texto si está cargando
                    loginForm.isLoading ? 'Espere...' : "Iniciar Sesión",
                  ),
                ),

                const SizedBox(height: 12),

                // ---------------------------------------------------
                // NAVEGACIÓN A REGISTRO
                // ---------------------------------------------------
                TextButton(
                  onPressed: () {
                    // Navegación simple a la pantalla de registro
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "¿No tienes cuenta? Crear cuenta",
                    style: TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // TEXTO DE PIE DE PÁGINA
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
    );
  }
}