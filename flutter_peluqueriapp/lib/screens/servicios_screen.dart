import 'package:flutter/material.dart';

class ServiciosScreen extends StatefulWidget {
  const ServiciosScreen({super.key});

  @override
  State<ServiciosScreen> createState() => _ServiciosScreenState();
}

class _ServiciosScreenState extends State<ServiciosScreen> {
  // ----------------- PEINADO -----------------
  String? diaPeinadoSeleccionado;
  String? horaPeinadoSeleccionada;
  final Map<String, List<String>> diasHorasPeinado = {
    "Martes": ["11:10","11:40","12:10","12:40","13:10","13:30"],
    "Miércoles": ["08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30","12:00","12:30"],
    "Jueves": ["08:00","08:30","09:00","09:30","10:00","10:30","11:10","11:40","12:10","12:40","13:10","13:30"],
    "Viernes": ["08:00","08:30","09:00","09:30","10:00","10:30"],
  };
  List<String> get horasDisponiblesPeinado {
    if (diaPeinadoSeleccionado == null) return [];
    return diasHorasPeinado[diaPeinadoSeleccionado!] ?? [];
  }

  // ----------------- PEINADO + RECOGIDO -----------------
  String? diaRecogidoSeleccionado;
  String? horaRecogidoSeleccionada;
  final Map<String, List<String>> diasHorasRecogido = {
    "Martes": ["11:10","11:40","12:10","12:40","13:10","13:30"],
    "Jueves": ["11:10","11:40","12:10","12:40","13:10","13:30"],
  };
  List<String> get horasDisponiblesRecogido {
    if (diaRecogidoSeleccionado == null) return [];
    return diasHorasRecogido[diaRecogidoSeleccionado!] ?? [];
  }

  // ----------------- CORTE -----------------
  String? opcionCorteSeleccionada;
  String? diaCorteSeleccionado;
  String? horaCorteSeleccionada;

  final Map<String, List<String>> diasHorasConEstilo = {
    "Jueves": ["11:10","11:40","12:10","12:40"],
  };
  final Map<String, List<String>> diasHorasFemenino = {
    "Lunes": ["08:00","08:30","09:00","09:30","10:00"],
    "Miércoles": ["12:00"],
  };

  List<String> get horasDisponiblesConEstilo {
    if (diaCorteSeleccionado == null) return [];
    return diasHorasConEstilo[diaCorteSeleccionado!] ?? [];
  }

  List<String> get horasDisponiblesFemenino {
    if (diaCorteSeleccionado == null) return [];
    return diasHorasFemenino[diaCorteSeleccionado!] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Servicios"),
        backgroundColor: const Color(0xFFF4B95B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // ----------------- PEINADO -----------------
            _buildPeinadoCard(),

            const SizedBox(height: 20),

            // ----------------- PEINADO + RECOGIDO -----------------
            _buildRecogidoCard(),

            const SizedBox(height: 20),

            // ----------------- CORTE -----------------
            _buildCorteCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeinadoCard() {
  return Card(
    color: Colors.white,
    elevation: 6,
    shadowColor: Colors.orangeAccent.withOpacity(0.3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: ExpansionTile(
      collapsedIconColor: const Color(0xFFF4B95B),
      iconColor: const Color(0xFFF4B95B),
      title: const Text(
        "Peinado",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      children: [
        const Divider(color: Colors.orangeAccent, thickness: 1.2),
        const SizedBox(height: 10),
        const Text("Precio: 5€", style: TextStyle(fontSize: 18, color: Colors.black)),
        const Text("Duración: 2h", style: TextStyle(fontSize: 18, color: Colors.black)),
        const SizedBox(height: 15),
        const Text("Selecciona día:", style: TextStyle(fontSize: 18, color: Colors.black)),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          value: diaPeinadoSeleccionado,
          items: diasHorasPeinado.keys.map((dia) {
            return DropdownMenuItem(value: dia, child: Text(dia, style: const TextStyle(fontSize: 16)));
          }).toList(),
          onChanged: (value) {
            setState(() {
              diaPeinadoSeleccionado = value;
              horaPeinadoSeleccionada = null;
            });
          },
          hint: const Text("Elige un día"),
        ),
        const SizedBox(height: 15),
        const Text("Selecciona hora disponible:", style: TextStyle(fontSize: 18, color: Colors.black)),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          value: horaPeinadoSeleccionada,
          items: horasDisponiblesPeinado.map((hora) {
            return DropdownMenuItem(value: hora, child: Text(hora, style: const TextStyle(fontSize: 16)));
          }).toList(),
          onChanged: (value) {
            setState(() {
              horaPeinadoSeleccionada = value;
            });
          },
          hint: const Text("Elige una hora"),
        ),
        const SizedBox(height: 25),

        // --- Botones Reservar e Información ---
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4B95B),
                  shadowColor: Colors.orangeAccent,
                  elevation: 5,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (diaPeinadoSeleccionado == null || horaPeinadoSeleccionada == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Selecciona día y hora primero")),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Has reservado un Peinado el ${diaPeinadoSeleccionado!} a las $horaPeinadoSeleccionada")),
                  );
                },
                child: const Text("Reservar"),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFF4B95B), width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      content: Row(
                        children: [
                          // Imagen
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              "assets/peinado.jpg",
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 15),
                          // Texto
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "PEINADO",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Transforma tu look con nuestro servicio de peinados profesionales. "
                                  "Ideal para bodas, eventos especiales o un cambio de estilo único. "
                                  "Duración aproximada: 2 horas.",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Cerrar", style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text("Información"),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

  Widget _buildRecogidoCard() {
    return Card(
      color: Colors.white,
      elevation: 6,
      shadowColor: Colors.orangeAccent.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ExpansionTile(
        collapsedIconColor: const Color(0xFFF4B95B),
        iconColor: const Color(0xFFF4B95B),
        title: const Text(
          "Peinado + Recogido",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        children: [
          const Divider(color: Colors.orangeAccent, thickness: 1.2),
          const SizedBox(height: 10),
          const Text("Precio: 12€", style: TextStyle(fontSize: 18, color: Colors.black)),
          const Text("Duración: 3h", style: TextStyle(fontSize: 18, color: Colors.black)),
          const SizedBox(height: 15),
          const Text("Selecciona día:", style: TextStyle(fontSize: 18, color: Colors.black)),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            value: diaRecogidoSeleccionado,
            items: diasHorasRecogido.keys.map((dia) {
              return DropdownMenuItem(value: dia, child: Text(dia, style: const TextStyle(fontSize: 16)));
            }).toList(),
            onChanged: (value) {
              setState(() {
                diaRecogidoSeleccionado = value;
                horaRecogidoSeleccionada = null;
              });
            },
            hint: const Text("Elige un día"),
          ),
          const SizedBox(height: 15),
          const Text("Selecciona hora disponible:", style: TextStyle(fontSize: 18, color: Colors.black)),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            value: horaRecogidoSeleccionada,
            items: horasDisponiblesRecogido.map((hora) {
              return DropdownMenuItem(value: hora, child: Text(hora, style: const TextStyle(fontSize: 16)));
            }).toList(),
            onChanged: (value) {
              setState(() {
                horaRecogidoSeleccionada = value;
              });
            },
            hint: const Text("Elige una hora"),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF4B95B),
              shadowColor: Colors.orangeAccent,
              elevation: 5,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              if (diaRecogidoSeleccionado == null || horaRecogidoSeleccionada == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Selecciona día y hora primero")),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Has reservado un Peinado + Recogido el ${diaRecogidoSeleccionado!} a las $horaRecogidoSeleccionada")),
              );
            },
            child: const Text("Reservar"),
          ),
        ],
      ),
    );
  }

Widget _buildCorteCard() {
  return Card(
    color: Colors.white,
    elevation: 6,
    shadowColor: Colors.orangeAccent.withOpacity(0.3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: ExpansionTile(
      collapsedIconColor: const Color(0xFFF4B95B),
      iconColor: const Color(0xFFF4B95B),
      title: const Text(
        "Corte",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      children: [
        const Divider(color: Colors.orangeAccent, thickness: 1.2),
        const SizedBox(height: 10),
        const Text("Selecciona opción:", style: TextStyle(fontSize: 18, color: Colors.black)),
        const SizedBox(height: 10),
        
        // --- Dropdown para elegir tipo de corte ---
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          value: opcionCorteSeleccionada,
          hint: const Text("Elige una opción"),
          items: const [
            DropdownMenuItem(value: "conEstilo", child: Text("Con estilo - 5€")),
            DropdownMenuItem(value: "femenino", child: Text("Femenino - 2€")),
          ],
          onChanged: (value) {
            setState(() {
              opcionCorteSeleccionada = value;
              diaCorteSeleccionado = null;
              horaCorteSeleccionada = null;
            });
          },
        ),

        const SizedBox(height: 15),

        // --- Mostrar día, hora y botón solo si se ha elegido opción ---
        if (opcionCorteSeleccionada != null) ...[
          const Text("Selecciona día:", style: TextStyle(fontSize: 18, color: Colors.black)),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            value: diaCorteSeleccionado,
            hint: const Text("Elige un día"),
            items: (opcionCorteSeleccionada == "conEstilo" ? diasHorasConEstilo.keys : diasHorasFemenino.keys)
                .map((dia) => DropdownMenuItem(value: dia, child: Text(dia)))
                .toList(),
            onChanged: (value) {
              setState(() {
                diaCorteSeleccionado = value;
                horaCorteSeleccionada = null;
              });
            },
          ),

          const SizedBox(height: 15),
          const Text("Selecciona hora disponible:", style: TextStyle(fontSize: 18, color: Colors.black)),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            value: horaCorteSeleccionada,
            hint: const Text("Elige una hora"),
            items: (opcionCorteSeleccionada == "conEstilo" ? horasDisponiblesConEstilo : horasDisponiblesFemenino)
                .map((hora) => DropdownMenuItem(value: hora, child: Text(hora)))
                .toList(),
            onChanged: (value) {
              setState(() {
                horaCorteSeleccionada = value;
              });
            },
          ),

          const SizedBox(height: 25),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF4B95B),
              shadowColor: Colors.orangeAccent,
              elevation: 5,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              if (diaCorteSeleccionado == null || horaCorteSeleccionada == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Selecciona opción, día y hora primero")),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Has reservado un Corte (${opcionCorteSeleccionada == 'conEstilo' ? 'Con estilo' : 'Femenino'}) el $diaCorteSeleccionado a las $horaCorteSeleccionada",
                  ),
                ),
              );
            },
            child: const Text("Reservar"),
          ),
        ],
      ],
    ),
  );
}

}

