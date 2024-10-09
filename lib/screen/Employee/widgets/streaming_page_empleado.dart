import 'package:districorp/constant/sizes.dart';
import 'package:districorp/widgets/Employee_widgets/video_card.dart';
import 'package:districorp/widgets/SearchBarCustom.dart';
import 'package:flutter/material.dart';

class EmployeeStreaming extends StatefulWidget {
  const EmployeeStreaming({super.key});

  @override
  _EmployeeStreamingState createState() => _EmployeeStreamingState();
}

class _EmployeeStreamingState extends State<EmployeeStreaming> {
  final TextEditingController searchController = TextEditingController();
  final List<Map<String, String>> streamingVideos = [
    {"title": "Venom 3", "image": "assets/video1.png"},
    {"title": "Venom 3", "image": "assets/video1.png"},
    {"title": "Venom 3", "image": "assets/video1.png"},
    {"title": "Venom 3", "image": "assets/video1.png"},
    {"title": "Venom 3", "image": "assets/video1.png"},
    {"title": "Venom 3", "image": "assets/video1.png"},
    {"title": "Venom 3", "image": "assets/video1.png"},
    {"title": "Venom 3", "image": "assets/video1.png"},
    {"title": "Venom 3", "image": "assets/video1.png"},
    {"title": "Venom 3", "image": "assets/video1.png"},
    {"title": "Venom 3", "image": "assets/video1.png"},
    {"title": "Venom 3", "image": "assets/video1.png"},
    {"title": "Venom 3", "image": "assets/video1.png"},
    {"title": "Joker 2", "image": "assets/video2.png"},
    {"title": "Gladiator 2", "image": "assets/video3.png"},
  ];
  List<Map<String, String>> filteredVideos = [];

  @override
  void initState() {
    super.initState();
    filteredVideos = streamingVideos; // Inicialmente mostrar todos los videos
  }

  void filterVideos(String query) {
    final filtered = streamingVideos.where((video) {
      final titleLower = video['title']!.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredVideos = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBarCustom(
                controller: searchController,
                onChanged: filterVideos,
                hintext: "Buscar videos...")),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints){
                final crossAxisCount = constraints.maxWidth > 1200
                  ? 4
                  : constraints.maxWidth > 800
                      ? 3
                      : constraints.maxWidth > 600
                          ? 2
                          : 1;
              
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount, // 2 columnas por fila
                  crossAxisSpacing: 140, // Espacio horizontal entre tarjetas
                  mainAxisSpacing: 70, // Espacio vertical entre tarjetas
                  childAspectRatio: 1, // Relación de aspecto
                ),
                itemCount: filteredVideos.length,
                itemBuilder: (context, index) {
                  final video = filteredVideos[index];
                  return VideoCard(
                    title: video['title']!,
                    imageUrl: video['image']!,
                  );
                },
              );
              }
            ),
          ),
        ),
        Column(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(235, 2, 56, 1),
                        Color.fromRGBO(120, 50, 220, 1)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Acción del botón de play
                    },
                    icon: Icon(
                      Icons.arrow_circle_down_outlined,
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
                        Color.fromRGBO(120, 50, 220, 1)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Text(
                    "Subir Video",
                    style: TextStyle(
                      color: Colors
                          .white, // Esto es necesario aunque será cubierto por el shader
                      fontSize: cSubcontenidoSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ],
        )
      ],
    );
  }
}
