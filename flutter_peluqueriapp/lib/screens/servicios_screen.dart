// lib/screens/servicios_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_peluqueriapp/models/servicio_model.dart';
import 'package:flutter_peluqueriapp/models/tipo_servicio_model.dart';
import 'package:flutter_peluqueriapp/services/servicio_service.dart';
import 'package:flutter_peluqueriapp/services/tipo_servicio_service.dart';
import 'package:flutter_peluqueriapp/screens/citas_screen.dart';

class ServiciosScreen extends StatefulWidget {
  const ServiciosScreen({super.key});

  @override
  State<ServiciosScreen> createState() => _ServiciosScreenState();
}

class _ServiciosScreenState extends State<ServiciosScreen> {
  final ServicioService _servicioService = ServicioService();
  final TipoServicioService _tipoServicioService = TipoServicioService();

  List<TipoServicio> tipos = [];
  List<Servicio> servicios = [];
  Map<int, List<Servicio>> agrupados = {};

  bool loading = true;

  // Buscador
  final TextEditingController _searchController = TextEditingController();
  List<Servicio> resultadosBusqueda = [];
  bool buscadorActivo = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final listaTipos = await _tipoServicioService.getTipos();
    final listaServicios = await _servicioService.getServicios();

    setState(() {
      tipos = listaTipos;
      servicios = listaServicios;
      agrupados = _agruparServicios(listaServicios);
      loading = false;
    });
  }

  Map<int, List<Servicio>> _agruparServicios(List<Servicio> lista) {
    final mapa = <int, List<Servicio>>{};
    for (var s in lista) {
      mapa.putIfAbsent(s.tipoId, () => []);
      mapa[s.tipoId]!.add(s);
    }
    return mapa;
  }

  void _onSearchChanged(String value) {
    // debounce suave para no spamear la API
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 350), () async {
      final query = value.trim();

      if (query.isEmpty) {
        setState(() {
          buscadorActivo = false;
          resultadosBusqueda = [];
        });
        return;
      }

      final res = await _servicioService.buscarServiciosPorNombre(query);
      setState(() {
        buscadorActivo = true;
        resultadosBusqueda = res;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

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
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        "Servicios",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 🔍 Buscador
                      TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: "Buscar servicio...",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Contenido (resultados o lista por tipos)
                      Expanded(
                        child: buscadorActivo
                            ? _buildResultadosBusqueda()
                            : _buildListaPorTipos(),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // Lista cuando hay búsqueda
  Widget _buildResultadosBusqueda() {
  if (resultadosBusqueda.isEmpty) {
    return const Center(
      child: Text(
        "No se han encontrado servicios",
        style: TextStyle(fontSize: 16, color: Colors.black54),
      ),
    );
  }

  return ListView.builder(
    padding: const EdgeInsets.only(top: 8),
    itemCount: resultadosBusqueda.length,
    itemBuilder: (_, i) {
      final s = resultadosBusqueda[i];
      return Card(
        color: const Color(0xFFFFFAF0),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: _buildServicioTile(s),
      );
    },
  );
}


  // Lista normal por tipos
  Widget _buildListaPorTipos() {
    return ListView.builder(
      itemCount: tipos.length,
      itemBuilder: (_, i) {
        final tipo = tipos[i];
        final serviciosDeEsteTipo = agrupados[tipo.id] ?? [];

        return Card(
          color: const Color(0xFFFFFAF0),
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: _buildTipoImage(tipo),
              title: Text(
                tipo.nombre,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                ),
              ),
              children: serviciosDeEsteTipo.map(_buildServicioTile).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTipoImage(TipoServicio tipo) {
    final baseUrl = dotenv.env['API_URL'] ?? '';
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        "$baseUrl${tipo.urlImg}",
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.image, color: Colors.orangeAccent),
      ),
    );
  }

  // Tile de un servicio (tanto para resultados como dentro de un tipo)
  Widget _buildServicioTile(Servicio s) {
  return ListTile(
    title: Text(
      s.nombre,
      style: const TextStyle(
        color: Colors.orangeAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    subtitle: Text("${s.precio} € • ${s.duracion} min"),
    trailing: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF4B95B),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CitasScreen(
              services: servicios,      // ← lista completa
              initialService: s,        // ← servicio seleccionado
            ),
          ),
        );
      },
      child: const Text(
        "Reservar",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

}
