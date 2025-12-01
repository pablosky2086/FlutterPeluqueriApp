import 'package:flutter/material.dart';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  final s = widget.services[index];
                  final bool isSelected = s.name == selectedService.name;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedService = s;
                        selectedHour = null;
                      });
                    },
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.orangeAccent : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.orangeAccent, width: isSelected ? 0 : 1.5),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: Colors.orangeAccent.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              s.image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white : Colors.orangeAccent,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "${s.price} € • ${s.duration}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected ? Colors.white70 : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: widget.services.length,
              ),
            ),
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
      ),
    );
  }
}
