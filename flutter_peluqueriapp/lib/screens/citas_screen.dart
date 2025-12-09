import 'package:flutter/material.dart';
import 'package:flutter_peluqueriapp/models/servicio_model.dart';

class CitasScreen extends StatefulWidget {
  final List<Servicio> services;
  final Servicio? initialService;

  const CitasScreen({super.key, required this.services, this.initialService});

  @override
  State<CitasScreen> createState() => _CitasScreenState();
}

class _CitasScreenState extends State<CitasScreen> {
  late Servicio selectedService;
  DateTime selectedDay = DateTime.now();
  String? selectedHour;

  /// HORARIOS MOCK (solo para boceto)
  final Map<int, List<String>> mockSchedule = {
    1: ["09:00", "09:30", "10:00", "10:30"],
    2: ["11:00", "11:30", "12:00", "12:30"],
    3: ["16:00", "16:30", "17:00"],
    4: ["08:00", "08:30", "09:00"],
    5: ["15:00", "15:30", "16:00", "16:30"],
    6: ["10:00", "11:00", "12:00"],
    7: ["17:00", "17:30", "18:00"],
    8: ["09:00", "10:00", "11:00"],
  };

  final Map<int, String> weekdays = {
    1: "Lunes",
    2: "Martes",
    3: "Miércoles",
    4: "Jueves",
    5: "Viernes",
    6: "Sábado",
    7: "Domingo",
  };

  @override
  void initState() {
    super.initState();
    selectedService = widget.initialService ?? widget.services.first;
  }

  List<String> get availableHours {
    return mockSchedule[selectedService.tipoId] ?? [];
  }

  List<Servicio> get serviciosMismoTipo {
    return widget.services
        .where((s) => s.tipoId == selectedService.tipoId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEBCF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.orangeAccent),
        title: const Text(
          "Reservar cita",
          style: TextStyle(color: Colors.orangeAccent),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  // ---------------------------
                  // SELECTOR DE SERVICIO
                  // ---------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orangeAccent,
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButton<Servicio>(
                        value: selectedService,
                        isExpanded: true,
                        underline: const SizedBox(),
                        itemHeight: 60,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.orangeAccent,
                        ),

                        items: serviciosMismoTipo.map((s) {
                          return DropdownMenuItem(
                            value: s,
                            child: Text(
                              s.nombre,
                              style: const TextStyle(
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),

                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedService = value;
                              selectedHour = null;
                            });
                          }
                        },
                      ),
                    ),
                  ),

                  // ---------------------------
                  // CALENDARIO
                  // ---------------------------
                  Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CalendarDatePicker(
                        initialDate: selectedDay,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),

                        // 🚫 DESACTIVA FINES DE SEMANA Y DÍAS PASADOS
                        selectableDayPredicate: (day) {
                          // Desactivar días pasados
                          if (day.isBefore(
                            DateTime.now().subtract(const Duration(days: 1)),
                          )) {
                            return false;
                          }

                          // weekday: 1=Lunes ... 7=Domingo
                          if (day.weekday == DateTime.saturday ||
                              day.weekday == DateTime.sunday) {
                            return false;
                          }

                          return true; // Se puede seleccionar
                        },

                        onDateChanged: (date) {
                          setState(() {
                            selectedDay = date;
                            selectedHour = null;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ---------------------------
                  // TITULO HORAS DISPONIBLES
                  // ---------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: const [
                        Icon(Icons.access_time, color: Colors.orangeAccent),
                        SizedBox(width: 8),
                        Text(
                          "Horas disponibles",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ---------------------------
                  // LISTA DE HORAS
                  // ---------------------------
                  availableHours.isEmpty
                      ? const Text(
                          "No hay horas disponibles",
                          style: TextStyle(color: Colors.grey),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 4,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 2.5,
                            children: availableHours.map((h) {
                              final bool isSel = h == selectedHour;
                              return GestureDetector(
                                onTap: () => setState(() => selectedHour = h),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSel
                                        ? Colors.orangeAccent
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.orangeAccent,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    h,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isSel
                                          ? Colors.white
                                          : Colors.orangeAccent,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                ],
              ),
            ),
          ),

          // ---------------------------
          // BARRA INFERIOR DE CONFIRMACIÓN
          // ---------------------------
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedService.nombre,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        selectedHour == null
                            ? "${selectedDay.day}/${selectedDay.month}"
                            : "${selectedDay.day}/${selectedDay.month} • $selectedHour",
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedHour == null
                        ? Colors.grey
                        : Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  onPressed: selectedHour == null
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Cita reservada: ${selectedService.nombre} • ${selectedDay.day}/${selectedDay.month} • $selectedHour",
                              ),
                            ),
                          );
                        },
                  child: const Text(
                    "Confirmar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'servicios_screen.dart';

class CitasScreen extends StatefulWidget {
  final List<ServiceCategory> services;
  final ServiceCategory? initialService;

  const CitasScreen({
    super.key,
    required this.services,
    this.initialService,
  });

  @override
  State<CitasScreen> createState() => _CitasScreenState();
}

class _CitasScreenState extends State<CitasScreen> {
  late ServiceCategory selectedService;
  DateTime selectedDay = DateTime.now();
  String? selectedHour;

  final Map<int, String> weekdays = {
    1: "Lunes",
    2: "Martes",
    3: "Miércoles",
    4: "Jueves",
    5: "Viernes",
    6: "Sábado",
    7: "Domingo",
  };

  @override
  void initState() {
    super.initState();
    selectedService = widget.initialService ?? widget.services.first;
  }

  List<String> get availableHours {
    final key = weekdays[selectedDay.weekday]!;
    return selectedService.schedule[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: const Color(0xFFFDEBCF),
  appBar: AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.orangeAccent),
    title: const Text(
      "Reservar cita",
      style: TextStyle(color: Colors.orangeAccent),
    ),
  ),
  body: Column(
    children: [

      // 👇 TODO EL CONTENIDO QUE PUEDE CRECER VA AQUÍ
      // 👇 LO ENVOLVEMOS EN EXPANDED
      Expanded(  // <--- AQUÍ
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              // --- aquí va todo tu contenido ---
              // Dropdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orangeAccent, width: 1.5),
                  ),
                  child: DropdownButton<ServiceCategory>(
                    itemHeight: 83,
                    value: selectedService,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.orangeAccent),
                    underline: const SizedBox(),
                    dropdownColor: Colors.white,
                    menuMaxHeight: 800,
                    items: widget.services.map((s) {
                      return DropdownMenuItem<ServiceCategory>(
                        value: s,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                s.image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.name,
                                    style: const TextStyle(
                                      color: Colors.orangeAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${s.price} € • ${s.duration}",
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (service) {
                      if (service != null) {
                        setState(() {
                          selectedService = service;
                          selectedHour = null;
                        });
                      }
                    },
                  ),
                ),
              ),

              // Calendario
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CalendarDatePicker(
                    initialDate: selectedDay,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    onDateChanged: (date) {
                      setState(() {
                        selectedDay = date;
                        selectedHour = null;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const [
                    Icon(Icons.access_time, color: Colors.orangeAccent),
                    SizedBox(width: 8),
                    Text(
                      "Horas disponibles",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Horas disponibles
              availableHours.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "No hay horas disponibles para ${weekdays[selectedDay.weekday]}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 2.5,
                        children: availableHours.map((h) {
                          final bool isSel = h == selectedHour;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedHour = h;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSel ? Colors.orangeAccent : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.orangeAccent, width: 1.5),
                              ),
                              child: Text(
                                h,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isSel ? Colors.white : Colors.orangeAccent,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
            ],
          ),
        ),
      ),

      // 🔥 ESTO QUEDA PEGADO ABAJO 🔥
      Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 50),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedService.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedHour == null
                        ? "${selectedDay.day}/${selectedDay.month}"
                        : "${selectedDay.day}/${selectedDay.month} • $selectedHour",
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedHour == null ? Colors.grey : Colors.orangeAccent,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: selectedHour == null
                  ? null
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Cita: ${selectedService.name} • ${selectedDay.day}/${selectedDay.month} • $selectedHour",
                          ),
                        ),
                      );
                    },
              child: const Text(
                "Confirmar",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    ],
  ),
);
  }
}*/
