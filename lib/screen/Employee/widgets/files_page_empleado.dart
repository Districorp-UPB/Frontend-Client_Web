import 'dart:convert';
import 'package:districorp/constant/sizes.dart';
import 'package:districorp/controller/providers/token_provider.dart';// Asegúrate de tener un modelo adecuado para archivos
import 'package:districorp/models/archivo_models.dart';
import 'package:districorp/widgets/Employee_widgets/file_card.dart';
import 'package:districorp/widgets/SearchBarCustom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:districorp/controller/services/api.dart';
import 'package:provider/provider.dart';

class EmployeeFiles extends StatefulWidget {
  const EmployeeFiles({super.key});

  @override
  _EmployeeFilesState createState() => _EmployeeFilesState();
}

class _EmployeeFilesState extends State<EmployeeFiles> {
  final TextEditingController searchController = TextEditingController();
  final ApiController apiController = ApiController();
  late Future<List<Archivo>> futureFiles; // Usar el modelo adecuado
  List<Archivo> filteredFiles = []; // Almacena los archivos filtrados

  @override
  void initState() {
    super.initState();
    futureFiles = fetchFiles();
  }

  Future<List<Archivo>> fetchFiles() async {
    try {
      final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
      final token = await tokenProvider.verificarTokenU();
      if (token != null) {
        final files = await apiController.obtenerArchivosEmpleadoDistri(token); // Cambiado aquí
        filteredFiles = files; // Inicializa con todos los archivos
        return files; // Retorna la lista completa inicialmente
      } else {
        throw Exception("Token no válido");
      }
    } catch (e) {
      print("Error al obtener el token: $e");
      return []; // Retorna una lista vacía en caso de error
    }
  }

  void filterFiles(String query) {
    final filtered = filteredFiles.where((file) {
      final nameLower = file.nombreArchivo.toLowerCase(); // Cambiar a 'nombreArchivo'
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    setState(() {
      futureFiles = Future.value(filtered); // Actualiza la lista futura
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
            hintext: "Buscar archivos...",
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Archivo>>(
            future: futureFiles,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No hay archivos disponibles.'));
              }

              final files = snapshot.data!;
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
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      try {
                        final file = files[index];
                        print("Contenido del archivo completo: $file");

                        return FileCard(
                          title: file.nombreArchivo, // Asegúrate de tener un widget FileCard
                          archivo: file,
                        );
                      } catch (e) {
                        print("Error al decodificar el archivo: $e");
                        return Container(); // Retorna un contenedor vacío en caso de error
                      }
                    },
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }
}
