import 'dart:convert';

class Cliente {
    int id;
    String nombreCompleto;
    String email;
    String contrasena;
    String role;
    dynamic telefono;
    dynamic observaciones;
    dynamic alergenos;

    Cliente({
        required this.id,
        required this.nombreCompleto,
        required this.email,
        required this.contrasena,
        required this.role,
        required this.telefono,
        required this.observaciones,
        required this.alergenos,
    });

    factory Cliente.fromJson(String str) => Cliente.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Cliente.fromMap(Map<String, dynamic> json) => Cliente(
        id: json["id"],
        nombreCompleto: json["nombreCompleto"],
        email: json["email"],
        contrasena: json["contrasena"],
        role: json["role"],
        telefono: json["telefono"],
        observaciones: json["observaciones"],
        alergenos: json["alergenos"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "nombreCompleto": nombreCompleto,
        "email": email,
        "contrasena": contrasena,
        "role": role,
        "telefono": telefono,
        "observaciones": observaciones,
        "alergenos": alergenos,
    };
}