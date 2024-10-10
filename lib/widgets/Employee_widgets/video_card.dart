import 'dart:html' as html;  // Importa el paquete html para web
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';  // Importa video_player para mostrar videos

class VideoCard extends StatefulWidget {
  final String title;
  final String videoUrl;  // URL del video para mostrar y descargar

  const VideoCard({required this.title, required this.videoUrl});

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoPlayerController _controller;  // Controlador del video

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});  // Actualiza el estado cuando se haya inicializado el video
      });
  }

  @override
  void dispose() {
    _controller.dispose();  // Libera el controlador cuando se destruye el widget
    super.dispose();
  }

  void downloadVideo(String url) {
    // Crea un elemento de anclaje
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', widget.title)  // Usa el título como nombre del archivo
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
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Center(child: CircularProgressIndicator()),  // Muestra un cargador si el video no está listo
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
                      widget.title,
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
                          downloadVideo(widget.videoUrl);  // Llama a la función de descarga
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
