import 'package:flutter/material.dart';

class AlbumCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const AlbumCard({required this.title, required this.imageUrl});

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
            child: Image.asset(
              imageUrl,
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Nombre del album en la parte inferior
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
                  // El `Expanded` permitirá que el texto ocupe el 85% del espacio disponible
                  Expanded(
                    flex: 87,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis, // Para manejar el texto largo
                      ),
                      maxLines: 1, // Asegura que no crezca verticalmente
                    ),
                  ),
                  // Espacio para el `PopupMenuButton`, ocupará el 15%
                  Flexible(
                    flex: 13,
                    child: PopupMenuButton<String>(
                      onSelected: (value) {
                        print("Opción seleccionada: $value");
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
