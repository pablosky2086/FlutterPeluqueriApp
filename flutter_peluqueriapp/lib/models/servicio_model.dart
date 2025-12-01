import 'dart:convert';

class Servicio {
    int id;
    String nombre;
    String descripcion;
    int duracion;
    int precio;

    Servicio({
        required this.id,
        required this.nombre,
        required this.descripcion,
        required this.duracion,
        required this.precio,
    });

    factory Servicio.fromJson(String str) => Servicio.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Servicio.fromMap(Map<String, dynamic> json) => Servicio(
        id: json["id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        duracion: json["duracion"],
        precio: json["precio"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "duracion": duracion,
        "precio": precio,
    };
}
