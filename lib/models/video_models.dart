class Video {
  final int id;
  final String nombreArchivo;
  final String url; // Asegúrate de que este campo está en tu modelo

  Video({required this.id, required this.nombreArchivo, required this.url});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      nombreArchivo: json['nombre_archivo'],
      url: json['url'], // Mapea correctamente la URL del video
    );
  }
}
