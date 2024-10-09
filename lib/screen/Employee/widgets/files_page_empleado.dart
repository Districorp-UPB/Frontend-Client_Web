import 'package:districorp/constant/sizes.dart';
import 'package:districorp/widgets/Employee_widgets/album_card.dart';
import 'package:districorp/widgets/Employee_widgets/file_card.dart';
import 'package:districorp/widgets/SearchBarCustom.dart';
import 'package:flutter/material.dart';

class EmployeeFiles extends StatefulWidget {
  const EmployeeFiles({super.key});

  @override
  _EmployeeFilesState createState() => _EmployeeFilesState();
}

class _EmployeeFilesState extends State<EmployeeFiles> {
  final TextEditingController searchController = TextEditingController();
  final List<Map<String, String>> sharedFiles = [
    {"title": "Reporte Ambiental", "image": "assets/texto1.txt"},
    {"title": "Infografia Etica Moral", "image": "assets/text2.txt"},
    {"title": "Documento Parcial 3", "image": "assets/texto3.txt"},
  ];
  List<Map<String, String>> filteredFiles = [];

  @override
  void initState() {
    super.initState();
    filteredFiles = sharedFiles; // Inicialmente mostrar todos los albunes
  }

  void filterFiles(String query) {
    final filtered = sharedFiles.where((video) {
      final titleLower = video['title']!.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredFiles = filtered;
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
                onChanged: filterFiles,
                hintext: "Buscar archivos...")),
        Expanded(
          child: Padding(
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
                  crossAxisCount: crossAxisCount, // 2 columnas por fila
                  crossAxisSpacing: 140, // Espacio horizontal entre tarjetas
                  mainAxisSpacing: 70, // Espacio vertical entre tarjetas
                  childAspectRatio: 1, // Relación de aspecto
                ),
                itemCount: filteredFiles.length,
                itemBuilder: (context, index) {
                  final video = filteredFiles[index];
                  return FileCard(
                    title: video['title']!,
                    fileUrl: video['image']!,
                  );
                },
              );
            }),
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
                      Icons.upload_file_sharp,
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
                    "Subir Archivo",
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
