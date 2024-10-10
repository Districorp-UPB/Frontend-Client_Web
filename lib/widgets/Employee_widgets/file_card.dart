import 'dart:html' as html;
import 'package:districorp/models/archivo_models.dart';
import 'package:flutter/material.dart';  // Asegúrate de importar el modelo correcto

class FileCard extends StatelessWidget {
  final String title;
  final Archivo archivo; // Usa el modelo Archivo en lugar de solo el URL

  const FileCard({required this.title, required this.archivo});

  void downloadFile(String url, String fileName) {
    // Crea un elemento de anclaje
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName) // Usa el nombre del archivo para la descarga
      ..click(); // Simula un clic para iniciar la descarga
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Stack(
        children: [
          Container(
            color: Colors.grey[300], // Fondo gris para cualquier archivo
            child: Center(
              child: Icon(
                Icons.insert_drive_file, // Ícono de archivo
                size: 100,
                color: Colors.grey[700],
              ),
            ),
          ),
          // Nombre del archivo en la parte superior
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 87,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Flexible(
                    flex: 13,
                    child: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'download') {
                          downloadFile(archivo.fileUrl, archivo.nombreArchivo); // Descarga usando la URL
                        } else {
                          print("Opción seleccionada: $value");
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem(
                            value: 'download',
                            child: Text('Descargar'),
                          ),
                          const PopupMenuItem(
                            value: 'share',
                            child: Text('Compartir'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Eliminar'),
                          ),
                        ];
                      },
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
