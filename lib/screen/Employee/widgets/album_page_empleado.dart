import 'dart:convert';
import 'dart:typed_data';
import 'package:districorp/constant/sizes.dart';
import 'package:districorp/controller/providers/token_provider.dart';
import 'package:districorp/models/imagenes_models.dart';
import 'package:districorp/screen/Employee/Panel_agregar_album.dart';
import 'package:districorp/widgets/Employee_widgets/album_card.dart';
import 'package:districorp/widgets/SearchBarCustom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:districorp/controller/services/api.dart';
import 'package:provider/provider.dart';

class EmployeeAlbum extends StatefulWidget {
  const EmployeeAlbum({super.key});

  @override
  _EmployeeAlbumState createState() => _EmployeeAlbumState();
}

class _EmployeeAlbumState extends State<EmployeeAlbum> {
  final TextEditingController searchController = TextEditingController();
  final ApiController apiController = ApiController();
  late Future<List<Imagen>> futureAlbums;
  List<Imagen> filteredAlbums = []; // Almacena los álbumes filtrados

  @override
  void initState() {
    super.initState();
    futureAlbums = fetchAlbums();
  }

  Future<List<Imagen>> fetchAlbums() async {
    try {
      final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
      final token = await tokenProvider.verificarTokenU();
      if (token != null) {
        final albums = await apiController.obtenerImagenesEmpleadoDistri(token);
        filteredAlbums = albums; // Inicializa con todos los álbumes
        return albums; // Retorna la lista completa inicialmente
      } else {
        throw Exception("Token no válido");
      }
    } catch (e) {
      print("Error al obtener el token: $e");
      return []; // Retorna una lista vacía en caso de error
    }
  }

  void filterAlbum(String query) {
    final filtered = filteredAlbums.where((album) {
      final nameLower = album.nombreArchivo.toLowerCase(); // Cambiar a 'nombreArchivo'
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    setState(() {
      futureAlbums = Future.value(filtered); // Actualiza la lista futura
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
            hintext: "Buscar fotos...",
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Imagen>>(
            future: futureAlbums,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No hay álbumes disponibles.'));
              }

              final albums = snapshot.data!;
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
                    itemCount: albums.length,
                    itemBuilder: (context, index) {
                      try {
                        final album = albums[index];
                        print("Contenido del álbum completo: $album");

                        return AlbumCard(
                          title: album.nombreArchivo,
                          image: NetworkImage(album.imageUrl), // Cambia aquí a image
                          imageUrl: album.imageUrl
                        );
                      } catch (e) {
                        print("Error al decodificar la imagen: $e");
                        return Container(); // Retorna un contenedor vacío en caso de error
                      }
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
                  Get.to(() => EmployeeAddAlbumPanelPage());
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
                    Color.fromRGBO(120, 50, 220, 1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: Text(
                "Subir Album",
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
