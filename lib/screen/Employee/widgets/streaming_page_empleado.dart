
import 'package:districorp/constant/sizes.dart';
import 'package:districorp/controller/providers/token_provider.dart';
import 'package:districorp/models/video_models.dart';
import 'package:districorp/screen/Employee/Panel_agregar_streaming.dart';
import 'package:districorp/widgets/Employee_widgets/video_card.dart';
import 'package:districorp/widgets/SearchBarCustom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:districorp/controller/services/api.dart';
import 'package:provider/provider.dart';

class EmployeeStreaming extends StatefulWidget {
  const EmployeeStreaming({super.key});

  @override
  _EmployeeStreamingState createState() => _EmployeeStreamingState();
}

class _EmployeeStreamingState extends State<EmployeeStreaming> {
  final TextEditingController searchController = TextEditingController();
  final ApiController apiController = ApiController();
  late Future<List<Video>> futureVideos;
  List<Video> filteredVideos = []; // Almacena los videos filtrados

  @override
  void initState() {
    super.initState();
    futureVideos = fetchVideos();
  }

  Future<List<Video>> fetchVideos() async {
    try {
      final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
      final token = await tokenProvider.verificarTokenU();
      if (token != null) {
        final videos = await apiController.obtenerVideosEmpleadoDistri(token);
        filteredVideos = videos; // Inicializa con todos los videos
        return videos; // Retorna la lista completa inicialmente
      } else {
        throw Exception("Token no válido");
      }
    } catch (e) {
      print("Error al obtener el token: $e");
      return []; // Retorna una lista vacía en caso de error
    }
  }

  void filterVideos(String query) {
    final filtered = filteredVideos.where((video) {
      final nameLower = video.nombreArchivo.toLowerCase();
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    setState(() {
      futureVideos = Future.value(filtered); // Actualiza la lista futura
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SearchBarCustom(
            controller: searchController,
            onChanged: filterVideos,
            hintext: "Buscar videos...",
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Video>>(
            future: futureVideos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No hay videos disponibles.'));
              }

              final videos = snapshot.data!;
              return Padding(
                padding: EdgeInsets.all(16),
                child: LayoutBuilder(builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 1200
                      ? 4
                      : constraints.maxWidth > 800
                          ? 3
                          : constraints.maxWidth > 600
                              ? 2
                              : 1;

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 140,
                      mainAxisSpacing: 70,
                      childAspectRatio: 1,
                    ),
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      final video = videos[index];

                      return VideoCard(
                        title: video.nombreArchivo,
                        videoUrl: video.binaryFile, // Cambia aquí para la reproducción del video
                      );
                    },
                  );
                }),
              );
            },
          ),
        ),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(235, 2, 56, 1),
                    Color.fromRGBO(120, 50, 220, 1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: IconButton(
                onPressed: () {
                  Get.to(() => EmployeeAddStreamingPanelPage());
                },
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [
                    Color.fromRGBO(235, 2, 56, 1),
                    Color.fromRGBO(120, 50, 220, 1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: Text(
                "Subir Video",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: cSubcontenidoSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
