import 'dart:convert';

class Grupo {
  final int id;
  final String nombreCompleto;
  final String clase;

  Grupo({
    required this.id,
    required this.nombreCompleto,
    required this.clase,
  });

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      id: json["id"],
      nombreCompleto: json["nombreCompleto"] ?? "Grupo",
      clase: json["clase"] ?? "",
    );
  }

  // Para comparar objetos en el Dropdown
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Grupo && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}