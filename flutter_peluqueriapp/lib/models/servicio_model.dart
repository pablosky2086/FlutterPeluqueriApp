class Servicio {
  final int id;
  final String nombre;
  final String descripcion;
  final int duracion;
  final double precio;
  final int tipoId;

  Servicio({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.duracion,
    required this.precio,
    required this.tipoId,
  });

  factory Servicio.fromJson(Map<String, dynamic> json) {
    return Servicio(
      id: json["id"],
      nombre: json["nombre"],
      descripcion: json["descripcion"],
      duracion: json["duracion"],
      precio: (json["precio"] as num).toDouble(),
      tipoId: json["tipoServicio"]["id"], // ← clave correcta
    );
  }
}
