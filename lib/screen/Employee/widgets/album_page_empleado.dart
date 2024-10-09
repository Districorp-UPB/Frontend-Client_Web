import 'package:districorp/constant/sizes.dart';
import 'package:districorp/widgets/Employee_widgets/album_card.dart';
import 'package:districorp/widgets/SearchBarCustom.dart';
import 'package:flutter/material.dart';

class EmployeeAlbum extends StatefulWidget {
  const EmployeeAlbum({super.key});

  @override
  _EmployeeAlbumState createState() => _EmployeeAlbumState();
}

class _EmployeeAlbumState extends State<EmployeeAlbum> {
  final TextEditingController searchController = TextEditingController();
  final List<Map<String, String>> photoAlbums = [
    {"title": "Resting Forest", "image": "assets/nature1.jpg"},
    {"title": "Shining Stars", "image": "assets/nature2.jpg"},
    {"title": "Pearl City", "image": "assets/nature3.jpg"},
  ];
  List<Map<String, String>> filteredAlbums = [];

  @override
  void initState() {
    super.initState();
    filteredAlbums = photoAlbums; // Inicialmente mostrar todos los albunes
  }

  void filterAlbum(String query) {
    final filtered = photoAlbums.where((video) {
      final titleLower = video['title']!.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredAlbums = filtered;
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
                onChanged: filterAlbum,
                hintext: "Buscar fotos...")),
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
                itemCount: filteredAlbums.length,
                itemBuilder: (context, index) {
                  final video = filteredAlbums[index];
                  return AlbumCard(
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
                      Icons.add_photo_alternate_sharp,
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
                    "Subir Album",
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
