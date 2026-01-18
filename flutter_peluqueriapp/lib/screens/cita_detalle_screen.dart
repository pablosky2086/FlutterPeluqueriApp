import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_peluqueriapp/providers/cita_detalle_provider.dart';

class CitaDetalleScreen extends StatelessWidget {
  final Map<String, dynamic> citaData;

  const CitaDetalleScreen({super.key, required this.citaData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CitaDetalleProvider(),
      child: Scaffold(
        // SingleChildScrollView para que el teclado no tape el contenido
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ------------------------------------------------
              // 1. ZONA SUPERIOR: IMAGEN + BOTONES
              // ------------------------------------------------
              Stack(
                children: [
                  // La Imagen de fondo
                  const _CitaImage(),
                  
                  // Botón de Volver (Atrás)
                  Positioned(
                    top: 50, // Ajustado para no chocar con la barra de estado
                    left: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black26, 
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 25, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),

                  // Botones de Cámara y Galería
                  Positioned(
                    top: 50,
                    right: 20,
                    child: Row(
                      children: const [
                        _ImageButton(
                          icon: Icons.photo_library_outlined,
                          source: ImageSource.gallery,
                        ),
                        SizedBox(width: 15),
                        _ImageButton(
                          icon: Icons.camera_alt_outlined,
                          source: ImageSource.camera,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // ------------------------------------------------
              // 2. FORMULARIO Y DETALLES
              // ------------------------------------------------
              _CitaDetailsForm(citaData: citaData),
            ],
          ),
        ),
        
        // Botón Flotante para Guardar
        floatingActionButton: const _SaveFab(),
      ),
    );
  }
}

// ------------------------------------------------------------------
// WIDGETS PRIVADOS AUXILIARES
// ------------------------------------------------------------------

class _CitaImage extends StatelessWidget {
  const _CitaImage();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CitaDetalleProvider>(context);
    
    ImageProvider imageProvider;

    // Lógica visual: Si eligió foto, muestra esa. Si no, muestra la de la app.
    if (provider.newPictureFile != null) {
      imageProvider = FileImage(provider.newPictureFile!);
    } else {
      imageProvider = const AssetImage('assets/splash.png'); 
    }

    return SizedBox(
      width: double.infinity,
      height: 400, // Altura grande para que luzca bien
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        child: FadeInImage(
          placeholder: const AssetImage('assets/splash.png'), // Mientras carga
          image: imageProvider,
          fit: BoxFit.cover, // Para que ocupe todo el espacio sin deformarse
          imageErrorBuilder: (_,__,___) => Container(color: Colors.grey[200]),
        ),
      ),
    );
  }
}

class _ImageButton extends StatelessWidget {
  final IconData icon;
  final ImageSource source;

  const _ImageButton({required this.icon, required this.source});

  @override
  Widget build(BuildContext context) {
    // listen: false porque este botón solo dispara acciones, no cambia de color
    final provider = Provider.of<CitaDetalleProvider>(context, listen: false);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.black45, // Fondo oscuro semitransparente
        borderRadius: BorderRadius.circular(30),
      ),
      child: IconButton(
        icon: Icon(icon, size: 25, color: Colors.white),
        onPressed: () async {
          // Abrimos el selector nativo del móvil
          final picker = ImagePicker();
          final XFile? pickedFile = await picker.pickImage(
            source: source,
            imageQuality: 80,
          );

          if (pickedFile == null) return;
          
          // Solo actualizamos la vista local
          provider.updateSelectedImage(pickedFile.path);
        },
      ),
    );
  }
}

class _CitaDetailsForm extends StatelessWidget {
  final Map<String, dynamic> citaData;

  const _CitaDetailsForm({required this.citaData});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CitaDetalleProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título del Servicio
          Text(
            citaData["servicio"] ?? "Servicio",
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
          ),
          const SizedBox(height: 8),
          
          // Detalles de la cita
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
              const SizedBox(width: 6),
              Text(
                "${citaData["fecha"]} - ${citaData["hora"]}",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.person, size: 16, color: Colors.black54),
              const SizedBox(width: 6),
              Text(
                "Profesional: ${citaData["grupo"]}",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Sección Valoración
          const Text("Valora tu experiencia", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          
          // Estrellas Interactivas
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  iconSize: 45,
                  icon: Icon(
                    index < provider.rating ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    provider.setRating(index + 1.0);
                  },
                );
              }),
            ),
          ),

          const SizedBox(height: 30),

          // Campo de Comentario
          const Text("¿Algo que destacar?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(
            maxLines: 4,
            onChanged: (value) => provider.comment = value,
            decoration: InputDecoration(
              hintText: 'Escribe aquí tu opinión sobre el servicio...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
              ),
            ),
          ),
          
          const SizedBox(height: 80), // Espacio extra al final
        ],
      ),
    );
  }
}

class _SaveFab extends StatelessWidget {
  const _SaveFab();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CitaDetalleProvider>(context);

    return FloatingActionButton.extended(
      backgroundColor: const Color(0xFFF4B95B),
      onPressed: provider.isSaving 
        ? null 
        : () async {
            // Simulamos guardado
            await provider.saveReview();
            
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("¡Opinión guardada correctamente!"), backgroundColor: Colors.green),
              );
              Navigator.pop(context);
            }
          },
      icon: provider.isSaving 
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
          : const Icon(Icons.save),
      label: Text(
        provider.isSaving ? "Guardando..." : "Enviar Reseña",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}