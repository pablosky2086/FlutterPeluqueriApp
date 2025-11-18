import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PeluqueriApp"),
        backgroundColor: const Color(0xFFF4B95B),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Crear Cuenta",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // Usuario
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: "Nombre de usuario",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Contraseña
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Repetir contraseña
            TextField(
              controller: repeatPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Repetir contraseña",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            // Botón Aceptar
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF4B95B),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                // Aquí iría la validación que quieras
                String user = usernameController.text;
                String pass = passwordController.text;
                String pass2 = repeatPasswordController.text;

                if (user.isEmpty || pass.isEmpty || pass2.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Rellena todos los campos")),
                  );
                  return;
                }

                if (pass != pass2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Las contraseñas no coinciden")),
                  );
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Cuenta creada correctamente")),
                );
              },
              child: const Text(
                "Aceptar",
                style: TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 10),

            // Botón Cancelar
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancelar",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
