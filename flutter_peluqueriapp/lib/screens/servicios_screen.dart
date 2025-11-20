import 'package:flutter/material.dart';

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
  final List<ServiceCategory> services = [
    ServiceCategory(
      name: 'Peinado',
      price: '5€',
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
      price: '12€',
      duration: '3h',
      schedule: {
        "Martes": ["11:10", "11:40", "12:10"],
        "Jueves": ["11:10", "11:40", "12:10"],
      },
      image: 'assets/peinado.jpg',
      description: 'Peinados + recogido.',
    ),
    ServiceCategory(
      name: 'Corte',
      price: '5€ / 2€',
      duration: '30min - 1h',
      schedule: {
        "Jueves": ["11:10", "11:40", "12:10"],
        "Lunes": ["08:00", "08:30", "09:00"],
      },
      image: 'assets/peinado.jpg',
      description: 'Cortes profesionales.',
    ),
    ServiceCategory(
      name: 'Color',
      price: '20€',
      duration: '2h',
      schedule: {
        "Martes": ["08:00", "08:30", "09:00"],
        "Miércoles": ["08:50", "09:20", "09:50"],
      },
      image: 'assets/peinado.jpg',
      description: 'Cambio de color profesional.',
    ),
    ServiceCategory(
      name: 'Cambio de estilo + color',
      price: '15€',
      duration: '3h',
      schedule: {
        "Miércoles": [
          "08:00",
          "08:30",
          "09:00",
          "09:30",
          "10:00",
          "10:30",
          "11:00",
          "11:30",
          "12:00",
          "12:30",
          "13:00",
        ],
        "Jueves": ["11:10", "11:40", "12:10"],
      },
      image: 'assets/peinado.jpg',
      description: 'Servicio de cambio de estilo y color profesional.',
    ),
    ServiceCategory(
      name: 'Cambio de forma permanente',
      price: '10€',
      duration: '4h',
      schedule: {
        "Lunes": [
          "08:00",
          "08:30",
          "09:00",
          "09:30",
          "10:00",
          "10:30",
          "11:00",
          "11:30",
          "12:00",
        ],
        "Miércoles": [
          "08:00",
          "08:30",
          "09:00",
          "09:30",
          "10:00",
          "10:30",
          "11:00",
          "11:30",
          "12:00",
          "12:30",
          "13:00",
        ],
      },
      image: 'assets/peinado.jpg',
      description: 'Cambio de forma permanente profesional.',
    ),
    ServiceCategory(
      name: 'Tratamiento',
      price: '5€',
      duration: '3h',
      schedule: {
        "Viernes": ["08:00", "08:30", "09:00", "09:30", "10:00", "10:30"],
      },
      image: 'assets/peinado.jpg',
      description: 'Tratamiento capilar profesional.',
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.grey[100],
    appBar: AppBar(
      title: const Text('Servicios'),
      backgroundColor: const Color(0xFFF4B95B),
    ),
    body: ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: services.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ServiceCard(
          service: services[i],
          onSelected: (day, hour) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Has reservado ${services[i].name} el $day a las $hour',
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class ServiceCard extends StatefulWidget {
  final ServiceCategory service;
  final void Function(String day, String hour) onSelected;
  const ServiceCard({
    super.key,
    required this.service,
    required this.onSelected,
  });
  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  String? day, hour;
  List<String> get hours =>
      day == null ? [] : widget.service.schedule[day!] ?? [];

  Widget dropdown(
    String hint,
    String? value,
    List<String> items,
    void Function(String?) onChange,
  ) => DropdownButtonFormField<String>(
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.grey[200],
    ),
    value: value,
    items: items
        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
        .toList(),
    onChanged: onChange,
    hint: Text(hint),
  );

  void showInfo() => showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              widget.service.image,
              width: 250,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            widget.service.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(widget.service.description, textAlign: TextAlign.center),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cerrar"),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white,
    elevation: 6,
    shadowColor: Colors.orangeAccent.withOpacity(0.3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: ExpansionTile(
      collapsedIconColor: const Color(0xFFF4B95B),
      iconColor: const Color(0xFFF4B95B),
      title: Text(
        widget.service.name,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      children: [
        const Divider(color: Colors.orangeAccent, thickness: 1.2),
        Text("Precio: ${widget.service.price}"),
        Text("Duración: ${widget.service.duration}"),
        const SizedBox(height: 10),
        dropdown("Elige un día", day, widget.service.schedule.keys.toList(), (
          v,
        ) {
          setState(() {
            day = v;
            hour = null;
          });
        }),
        const SizedBox(height: 10),
        dropdown("Elige una hora", hour, hours, (v) {
          setState(() => hour = v);
        }),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4B95B),
                ),
                onPressed: () {
                  if (day == null || hour == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Selecciona día y hora primero"),
                      ),
                    );
                    return;
                  }
                  widget.onSelected(day!, hour!);
                },
                child: const Text("Reservar"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFF4B95B), width: 2),
                ),
                onPressed: showInfo,
                child: const Text("Información"),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
