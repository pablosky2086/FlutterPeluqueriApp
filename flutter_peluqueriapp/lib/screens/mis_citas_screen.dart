import 'package:flutter/material.dart';
import 'package:flutter_peluqueriapp/screens/cita_detalle_screen.dart';

class MisCitasScreen extends StatelessWidget {
  const MisCitasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // DATOS MOCK PARA VISUALIZACIÓN
    final List<Map<String, dynamic>> mockCitas = [
      {
        "fecha": "20/01",
        "hora": "10:00",
        "servicio": "Corte de Caballero",
        "grupo": "Juan Peluquero",
        "precio": "15.0 €",
        "estado": "Pendiente"
      },
      {
        "fecha": "15/12",
        "hora": "17:30",
        "servicio": "Tinte y Mechas",
        "grupo": "Maria Estilista",
        "precio": "45.0 €",
        "estado": "Completada"
      },
      {
        "fecha": "02/11",
        "hora": "09:00",
        "servicio": "Afeitado",
        "grupo": "Carlos Barber",
        "precio": "10.0 €",
        "estado": "Completada"
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFDEBCF),
      appBar: AppBar(
        title: const Text("Mis Citas", style: TextStyle(color: Colors.orangeAccent)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.orangeAccent),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockCitas.length,
        itemBuilder: (context, index) {
          final cita = mockCitas[index];
          return GestureDetector(
            onTap: () {
              // Navegar al detalle pasando datos básicos
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CitaDetalleScreen(citaData: cita),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  // CORRECCIÓN AQUÍ:
                  border: Border(
                    left: BorderSide(
                      color: cita["estado"] == "Completada" 
                          ? Colors.grey 
                          : Colors.orangeAccent,
                      width: 5,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${cita["fecha"]} • ${cita["hora"]}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: cita["estado"] == "Completada" 
                                ? Colors.grey[200] 
                                : Colors.orange[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            cita["estado"],
                            style: TextStyle(
                              color: cita["estado"] == "Completada" 
                                  ? Colors.grey 
                                  : Colors.orangeAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Text(
                      cita["servicio"],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.person, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(cita["grupo"], style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}