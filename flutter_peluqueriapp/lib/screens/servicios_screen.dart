import 'package:flutter/material.dart';
import 'citas_screen.dart';

class ServiceCategory {
  final String name, price, duration, image, description;
  final Map<String, List<String>> schedule;

  ServiceCategory({
    required this.name,
    required this.price,
    required this.duration,
    required this.schedule,
    required this.image,
    required this.description,
  });
}

class ServiciosScreen extends StatefulWidget {
  const ServiciosScreen({super.key});
  @override
  State<ServiciosScreen> createState() => _ServiciosScreenState();
}

class _ServiciosScreenState extends State<ServiciosScreen> {
  // Lista de servicios (igual a la tuya, incluida aquí)
  final List<ServiceCategory> services = [
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
    ServiceCategory(
      name: 'Cambio de estilo + color',
      price: '15',
      duration: '3h',
      schedule: {
        "Miércoles": [
          "08:00", "08:30", "09:00", "09:30", "10:00", "10:30",
          "11:00", "11:30", "12:00", "12:30", "13:00",
        ],
        "Jueves": ["11:10", "11:40", "12:10"],
      },
      image: 'assets/estiloColor.jpg',
      description: 'Servicio de cambio de estilo y color profesional.',
    ),
    ServiceCategory(
      name: 'Cambio de forma permanente',
      price: '10',
      duration: '4h',
      schedule: {
        "Lunes": [
          "08:00", "08:30", "09:00", "09:30", "10:00", "10:30",
          "11:00", "11:30", "12:00",
        ],
        "Miércoles": [
          "08:00", "08:30", "09:00", "09:30", "10:00",
          "10:30", "11:00", "11:30", "12:00", "12:30", "13:00",
        ],
      },
      image: 'assets/permanente.jpg',
      description: 'Cambio de forma permanente profesional.',
    ),
    ServiceCategory(
      name: 'Tratamiento',
      price: '5',
      duration: '3h',
      schedule: {
        "Viernes": ["08:00", "08:30", "09:00", "09:30", "10:00", "10:30"],
      },
      image: 'assets/tratamiento.jpg',
      description: 'Tratamiento capilar profesional.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Servicios",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: services.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ServiceCard(
                      service: services[i],
                      allServices: services, // paso la lista completa
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final ServiceCategory service;
  final List<ServiceCategory> allServices;

  const ServiceCard({
    super.key,
    required this.service,
    required this.allServices,
  });

  void showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(
          child: Text(
            service.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.orangeAccent,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                service.image,
                width: 250,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              service.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cerrar",
              style: TextStyle(color: Colors.orangeAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      shadowColor: Colors.orangeAccent.withOpacity(0.35),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            iconColor: Colors.orangeAccent,
            collapsedIconColor: Colors.orangeAccent,
            childrenPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            title: Text(
              service.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      service.image,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Precio: ${service.price}",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Duración: ${service.duration}",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Botón Reservar (abre Citas y preselecciona este servicio)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF4B95B),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CitasScreen(
                              services: allServices,
                              initialService: service,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Reservar",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Botón Información (más ancho)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFF4B95B), width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => showInfo(context),
                      child: const Text(
                        "Información",
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
