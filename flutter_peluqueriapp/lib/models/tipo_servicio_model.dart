class TipoServicio {
  final int id;
  final String nombre;
  final String urlImg;

  TipoServicio({
    required this.id,
    required this.nombre,
    required this.urlImg,
  });

  factory TipoServicio.fromJson(Map<String, dynamic> json) {
    return TipoServicio(
      id: json["id"],
      nombre: json["nombre"],
      urlImg: json["url_img"],
    );
  }
}
