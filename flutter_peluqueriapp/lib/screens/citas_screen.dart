import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Importaciones del proyecto
import 'package:flutter_peluqueriapp/models/servicio_model.dart';
import 'package:flutter_peluqueriapp/models/grupo_model.dart';
import 'package:flutter_peluqueriapp/providers/citas_provider.dart';

class CitasScreen extends StatelessWidget {
  final List<Servicio> services;
  final Servicio? initialService;

  const CitasScreen({
    super.key,
    required this.services,
    this.initialService,
  });

  @override
  Widget build(BuildContext context) {
    // Inicializamos el Provider con el servicio seleccionado
    return ChangeNotifierProvider(
      create: (_) => CitasProvider()..init(initialService ?? services.first),
      child: _CitasContent(allServices: services),
    );
  }
}

class _CitasContent extends StatefulWidget {
  final List<Servicio> allServices;
  const _CitasContent({required this.allServices});

  @override
  State<_CitasContent> createState() => _CitasContentState();
}

class _CitasContentState extends State<_CitasContent> {
  
  // Función auxiliar para saber si dos fechas son el mismo día
  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _reservar(BuildContext context, CitasProvider provider) async {
    // Lógica simulada de reserva
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Cita reservada: ${provider.selectedService?.nombre} • "
          "${DateFormat('dd/MM').format(provider.selectedDate)} • ${provider.selectedHour}"
        ),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CitasProvider>(context);

    // Filtramos servicios del mismo tipo
    final serviciosMismoTipo = widget.allServices
        .where((s) => s.tipoId == provider.selectedService?.tipoId)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFDEBCF), // Color de fondo original
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
                  // 1. SELECTOR DE SERVICIO (Estilo Original)
                  // ---------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orangeAccent,
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Servicio>(
                          value: provider.selectedService,
                          isExpanded: true,
                          itemHeight: 60,
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.orangeAccent),
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
                          onChanged: provider.setService,
                        ),
                      ),
                    ),
                  ),

                  // ---------------------------
                  // 2. SELECTOR DE GRUPO (Nuevo widget con Estilo Original)
                  // ---------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orangeAccent,
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Grupo?>(
                          value: provider.selectedGrupo,
                          isExpanded: true,
                          itemHeight: 60,
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.orangeAccent),
                          hint: Text(
                             provider.grupos.isEmpty ? "Cargando..." : "Cualquier grupo",
                             style: const TextStyle(color: Colors.grey),
                          ),
                          onChanged: provider.grupos.isEmpty ? null : provider.setGrupo,
                          items: [
                            const DropdownMenuItem<Grupo?>(
                              value: null,
                              child: Text(
                                "Cualquier grupo",
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...provider.grupos.map((g) {
                              return DropdownMenuItem<Grupo?>(
                                value: g,
                                child: Text(
                                  g.nombreCompleto,
                                  style: const TextStyle(
                                    color: Colors.orangeAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ---------------------------
                  // 3. CALENDARIO (Estilo Original)
                  // ---------------------------
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: provider.diasDisponibles.isEmpty 
                        ? const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(child: CircularProgressIndicator(color: Colors.orangeAccent)),
                          )
                        : CalendarDatePicker(
                          initialDate: provider.selectedDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 1)),
                          lastDate: DateTime.now().add(const Duration(days: 90)),
                          
                          // Lógica de bloqueo de días (Backend)
                          selectableDayPredicate: (day) {
                             if (day.isBefore(DateTime.now().subtract(const Duration(days: 1)))) return false;
                             return provider.diasDisponibles.any((d) => isSameDay(d, day));
                          },
                          onDateChanged: provider.setDate,
                        ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ---------------------------
                  // 4. TÍTULO HORAS (Estilo Original)
                  // ---------------------------
                  if (provider.diasDisponibles.isNotEmpty) ...[
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
                    // 5. GRID DE HORAS (Estilo Original)
                    // ---------------------------
                    provider.horasDisponibles.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("No hay horas disponibles", style: TextStyle(color: Colors.grey)),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 2.5, // Ratio original
                            ),
                            itemCount: provider.horasDisponibles.length,
                            itemBuilder: (context, index) {
                              final horaKey = provider.horasDisponibles.keys.elementAt(index);
                              final isAvailable = provider.horasDisponibles.values.elementAt(index);
                              final isSelected = provider.selectedHour == horaKey;

                              return GestureDetector(
                                onTap: isAvailable ? () => provider.setHour(horaKey) : null,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    // Si seleccionado: Naranja relleno
                                    // Si disponible no seleccionado: Blanco con borde naranja
                                    // Si no disponible: Gris claro
                                    color: isSelected 
                                        ? Colors.orangeAccent 
                                        : (isAvailable ? Colors.white : Colors.grey[200]),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isAvailable ? Colors.orangeAccent : Colors.grey[300]!,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    horaKey,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      // Texto blanco si seleccionado, Naranja si disponible, Gris si ocupado
                                      color: isSelected 
                                          ? Colors.white 
                                          : (isAvailable ? Colors.orangeAccent : Colors.grey),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                  ]
                ],
              ),
            ),
          ),

          // ---------------------------
          // 6. BARRA INFERIOR (Con SafeArea + Info de Grupo)
          // ---------------------------
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12, 
                  blurRadius: 4, 
                  offset: Offset(0, -2),
                )
              ],
            ),
            child: SafeArea(
              top: false, 
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min, // Ajuste para evitar espacios extra
                        children: [
                          // Nombre del Servicio
                          Text(
                            provider.selectedService?.nombre ?? "",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 1, 
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Detalles: Fecha • Hora • Grupo
                          Text(
                            provider.selectedHour == null
                                // Sin hora seleccionada
                                ? "${DateFormat('dd/MM').format(provider.selectedDate)} • ${provider.selectedGrupo?.nombreCompleto ?? 'Cualquier grupo'}"
                                // Con hora seleccionada
                                : "${DateFormat('dd/MM').format(provider.selectedDate)} • ${provider.selectedHour} • ${provider.selectedGrupo?.nombreCompleto ?? 'Cualquier grup.'}",
                            style: const TextStyle(color: Colors.black54, fontSize: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: provider.selectedHour == null
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
                      onPressed: provider.selectedHour == null
                          ? null
                          : () => _reservar(context, provider),
                      child: const Text(
                        "Confirmar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}