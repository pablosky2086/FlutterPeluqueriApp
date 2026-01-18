import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CitaDetalleProvider extends ChangeNotifier {
  
  // Estado para la valoración
  double rating = 0; 
  String comment = "";
  
  // Estado para la imagen (Solo visualización local)
  File? newPictureFile; 
  bool isSaving = false;

  void setRating(double value) {
    rating = value;
    notifyListeners();
  }

  // Esto solo actualiza la pantalla con la foto que elijas del móvil
  void updateSelectedImage(String path) {
    newPictureFile = File(path);
    notifyListeners();
  }

  // Simulación visual de guardado (sin subir nada)
  Future<void> saveReview() async {
    isSaving = true;
    notifyListeners();

    // Esperamos 2 segundos para que parezca que hace algo
    await Future.delayed(const Duration(seconds: 2));

    // AQUÍ NO HAY CÓDIGO DE SUBIDA AL SERVIDOR
    
    isSaving = false;
    notifyListeners();
  }
}