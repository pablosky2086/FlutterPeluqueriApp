import 'package:flutter/material.dart';
import 'servicios_screen.dart';
import 'clientes_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PeluqueriApp"),
        backgroundColor: const Color(0xFFF4B95B),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Spacer(flex: 2), 

                SizedBox(
                  height: 160,
                  child: Image.asset(
                    "assets/splash.png",
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 40),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF4B95B),
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ServiciosScreen()),
                    );
                  },
                  child: const Text(
                    "Servicios",
                    style: TextStyle(fontSize: 20),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF4B95B),
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ClientesScreen()),
                    );
                  },
                  child: const Text(
                    "Perfil / Cliente",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const Spacer(flex: 3), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}
