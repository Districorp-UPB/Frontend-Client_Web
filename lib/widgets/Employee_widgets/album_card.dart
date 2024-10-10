import 'dart:html' as html;

import 'package:flutter/material.dart';  // Importa el paquete html para web

class AlbumCard extends StatelessWidget {
  final String title;
  final ImageProvider image;
  final String imageUrl;  // Asegúrate de tener esto para la descarga

  const AlbumCard({required this.title, required this.image, required this.imageUrl});

  void downloadImage(String url) {
    // Crea un elemento de anclaje
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', title)  // Usa el título como nombre del archivo
      ..click();  // Simula un clic en el anclaje para iniciar la descarga
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
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: image,
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
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
                          downloadImage(imageUrl);  // Llama a la función de descarga
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
