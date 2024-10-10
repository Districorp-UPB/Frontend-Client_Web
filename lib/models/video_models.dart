import 'dart:convert';
import 'dart:typed_data';

class Video {
  final int id;
  final int usuarioId;
  final String nombreArchivo;
  final String binaryFile;

  Video({
    required this.id,
    required this.usuarioId,
    required this.nombreArchivo,
    required this.binaryFile,
  });

  // Método para crear una instancia de Video desde un mapa
  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      usuarioId: json['usuario_id'],
      nombreArchivo: json['nombre_archivo'],
      binaryFile: json['binary_file'],
    );
  }

  // Método para obtener la URL del video en formato base64
  String get videoUrl {
    Uint8List bytes = base64Decode(binaryFile);
    return 'data:video/mp4;base64,${base64Encode(bytes)}';
  }
}
