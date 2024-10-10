import 'dart:convert';
import 'dart:typed_data';

class Imagen {
  final int id;
  final int usuarioId;
  final String nombreArchivo;
  final String binaryFile;

  Imagen({
    required this.id,
    required this.usuarioId,
    required this.nombreArchivo,
    required this.binaryFile,
  });

  // Método para crear una instancia de Imagen desde un mapa
  factory Imagen.fromJson(Map<String, dynamic> json) {
    return Imagen(
      id: json['id'],
      usuarioId: json['usuario_id'],
      nombreArchivo: json['nombre_archivo'],
      binaryFile: json['binary_file'],
    );
  }

  // Método para convertir la imagen a una representación base64
  String toBase64Image() {
    // Decodifica la cadena en binario
    Uint8List bytes = base64Decode(binaryFile);
    // Convierte a imagen utilizando base64
    return base64Encode(bytes);
  }

  // Método para obtener la URL de la imagen en formato base64
  String get imageUrl => 'data:image/jpg;base64,$binaryFile'; // Cambia a "image/png" si tus imágenes son PNG
}
