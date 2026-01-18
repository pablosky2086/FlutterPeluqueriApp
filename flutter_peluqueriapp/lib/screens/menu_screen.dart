import 'package:flutter/material.dart';
import 'servicios_screen.dart';
import 'clientes_screen.dart';
import 'citas_screen.dart';
import 'mis_citas_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de servicios directamente aquí
    /*final servicesList = [
      ServiceCategory(
        name: 'Peinado',
        price: '5',
        duration: '2h',
        schedule: {
          "Martes": ["11:10", "11:40", "12:10"],
          "Miércoles": ["08:00", "08:30", "09:00"],
        },
        image: 'assets/peinado.jpg',
        description: 'Peinados profesionales.',
      ),
      ServiceCategory(
        name: 'Peinado + Recogido',
        price: '12',
        duration: '3h',
        schedule: {
          "Martes": ["11:10", "11:40", "12:10"],
          "Jueves": ["11:10", "11:40", "12:10"],
        },
        image: 'assets/peinadoRecogido.jpg',
        description: 'Peinados + recogido.',
      ),
      ServiceCategory(
        name: 'Corte',
        price: '5 / 2',
        duration: '30min - 1h',
        schedule: {
          "Jueves": ["11:10", "11:40", "12:10"],
          "Lunes": ["08:00", "08:30", "09:00"],
        },
        image: 'assets/corte.jpg',
        description: 'Cortes profesionales.',
      ),
      ServiceCategory(
        name: 'Color',
        price: '20',
        duration: '2h',
        schedule: {
          "Martes": ["08:00", "08:30", "09:00"],
          "Miércoles": ["08:50", "09:20", "09:50"],
        },
        image: 'assets/tinte.jpg',
        description: 'Cambio de color profesional.',
      ),
    ];*/

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF3E0), Color(0xFFFDEBCF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  SizedBox(height: 300, child: Image.asset("assets/splash.png", fit: BoxFit.contain)),
                  const SizedBox(height: 40),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF4B95B),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ServiciosScreen()),
                      );
                    },
                    child: const Text("Servicios", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),

                  //const SizedBox(height: 20),

                  /*ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF4B95B),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CitasScreen(services: [])),
                      );
                    },
                    child: const Text("Citas", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),*/

                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF4B95B),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ClientesScreen()),
                      );
                    },
                    child: const Text("Perfil / Cliente", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),

                  const SizedBox(height: 20),

                  // NUEVO BOTÓN
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF4B95B),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MisCitasScreen()),
                      );
                    },
                    child: const Text("Mis Citas", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),

                  const Spacer(flex: 3),

                  const Text("¡Bienvenido a PeluqueriApp!", style: TextStyle(fontSize: 16, color: Colors.black54)),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
