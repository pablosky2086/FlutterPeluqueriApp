import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

// Importamos Modelos y Provider
import 'package:flutter_peluqueriapp/models/servicio_model.dart';
import 'package:flutter_peluqueriapp/models/tipo_servicio_model.dart';
import 'package:flutter_peluqueriapp/providers/servicios_provider.dart';
import 'package:flutter_peluqueriapp/screens/citas_screen.dart';

class ServiciosScreen extends StatelessWidget {
  const ServiciosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServicesProvider(),
      child: const _ServiciosContent(),
    );
  }
}

class _ServiciosContent extends StatelessWidget {
  const _ServiciosContent();

  @override
  Widget build(BuildContext context) {
    final servicesProvider = Provider.of<ServicesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Servicios", style: TextStyle(color: Colors.orangeAccent)),
        backgroundColor: const Color(0xFFFFF3E0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.orangeAccent),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF3E0), Color(0xFFFDEBCF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: servicesProvider.isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.orangeAccent))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // BUSCADOR
                      TextField(
                        controller: servicesProvider.searchController,
                        onChanged: servicesProvider.onSearchChanged,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search, color: Colors.orangeAccent),
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

                      // LISTA DE RESULTADOS
                      Expanded(
                        child: servicesProvider.isSearching
                            ? _buildResultadosBusqueda(context, servicesProvider)
                            : _buildListaPorTipos(context, servicesProvider),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // Widget para mostrar resultados de búsqueda
  Widget _buildResultadosBusqueda(BuildContext context, ServicesProvider provider) {
    if (provider.searchResults.isEmpty) {
      return const Center(
        child: Text(
          "No se han encontrado servicios",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: provider.searchResults.length,
      itemBuilder: (_, i) {
        final s = provider.searchResults[i];
        return Card(
          color: const Color(0xFFFFFAF0),
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: _buildServicioTile(context, s, provider.allServices),
        );
      },
    );
  }

  // ⭐ Widget para mostrar la lista agrupada (CON AUTO-SCROLL)
  Widget _buildListaPorTipos(BuildContext context, ServicesProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: provider.types.length,
      itemBuilder: (_, i) {
        final tipo = provider.types[i];
        final serviciosDeEsteTipo = provider.groupedServices[tipo.id] ?? [];

        if (serviciosDeEsteTipo.isEmpty) return const SizedBox.shrink();

        return Card(
          // ⭐ ASIGNAMOS LA KEY AQUÍ PARA LOCALIZAR LA TARJETA
          key: provider.getKey(tipo.id),
          
          color: const Color(0xFFFFFAF0),
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              controller: provider.getController(tipo.id),
              
              // Lógica de apertura y scroll
              onExpansionChanged: (isOpen) {
                if (isOpen) {
                  // 1. Cerrar los demás
                  provider.expandType(tipo.id);
                  
                  // 2. ⭐ AUTO-SCROLL
                  // Esperamos 300ms a que termine la animación de apertura
                  Future.delayed(const Duration(milliseconds: 300), () {
                    // Verificamos que el contexto de la Key siga siendo válido
                    final currentContext = provider.getKey(tipo.id).currentContext;
                    if (currentContext != null) {
                      Scrollable.ensureVisible(
                        currentContext,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        alignment: 0.0, // 0.0 alinea el elemento arriba del todo
                      );
                    }
                  });
                }
              },

              //leading: _buildTipoImage(tipo),
              title: Text(
                tipo.nombre,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                ),
              ),
              children: serviciosDeEsteTipo
                  .map((s) => _buildServicioTile(context, s, provider.allServices))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  // Imagen del tipo de servicio
  /*Widget _buildTipoImage(TipoServicio tipo) {
    final baseUrl = dotenv.env['API_URL'] ?? '';
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        "$baseUrl${tipo.urlImg}",
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.category, color: Colors.orangeAccent),
      ),
    );
  }*/

  // Tile individual de cada servicio
  Widget _buildServicioTile(BuildContext context, Servicio s, List<Servicio> allServices) {
    return ListTile(
      title: Text(
        s.nombre,
        style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "${s.precio} € • ${s.duracion} min",
        style: const TextStyle(color: Colors.black54),
      ),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF4B95B),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CitasScreen(
                services: allServices,
                initialService: s,
              ),
            ),
          );
        },
        child: const Text("Reservar", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}