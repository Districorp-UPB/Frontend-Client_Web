import 'dart:convert';
import 'dart:typed_data';

class Archivo {
  final int id;
  final int usuarioId;
  final String nombreArchivo;
  final String binaryFile;

  Archivo({
    required this.id,
    required this.usuarioId,
    required this.nombreArchivo,
    required this.binaryFile,
  });

  // Método para crear una instancia de Archivo desde un mapa
  factory Archivo.fromJson(Map<String, dynamic> json) {
    return Archivo(
      id: json['id'],
      usuarioId: json['usuario_id'],
      nombreArchivo: json['nombre_archivo'],
      binaryFile: json['binary_file'],
    );
  }

  // Método para obtener la URL del archivo en formato base64
  String get fileUrl {
    // Decodifica la cadena en binario
    Uint8List bytes = base64Decode(binaryFile);
    // Convierte los datos a una URL en base64
    return 'data:application/octet-stream;base64,${base64Encode(bytes)}';
  }
}
