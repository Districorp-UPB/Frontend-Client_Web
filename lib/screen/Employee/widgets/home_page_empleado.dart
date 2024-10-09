import 'package:districorp/constant/sizes.dart';
import 'package:districorp/controller/providers/Emp_dashboard_provider.dart';
import 'package:districorp/screen/Employee/Panel_album_empleado.dart';
import 'package:districorp/screen/Employee/Panel_files_empelado.dart';
import 'package:districorp/screen/Employee/Panel_streaming_empleado.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class EmployeeHome extends StatelessWidget {
  const EmployeeHome({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final employeeProvider = Provider.of<EmpDashboardProvider>(context);

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1200
                  ? 3
                  : constraints.maxWidth > 800
                      ? 2
                      : 1;

              return Wrap(
                spacing: 16.0, // Espacio entre las tarjetas horizontalmente
                runSpacing: 16.0, // Espacio entre las tarjetas verticalmente
                alignment: WrapAlignment.center, // Centra las tarjetas
                children: List.generate(3, (index) {
                  return SizedBox(
                    width: (constraints.maxWidth / crossAxisCount) - 16, // Ajusta el ancho de las tarjetas
                    child: _buildInfoCard(index, employeeProvider, size),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(int index, EmpDashboardProvider provider, Size size) {
    List<Map<String, dynamic>> cardData = [
      {
        'titulo': 'Streaming',
        'subContenido':
            'Transmite videos y audios sin necesidad de descargarlos. Reproduce tu contenido multimedia.',
        'imageUrl': 'assets/playimage.jpg',
        'txtbtn': 'Mirar',
        'function': () {
          provider.updateSelectedIndex(2);
          Get.to(() => EmployeeStreamingPanelPage());
        },
      },
      {
        'titulo': 'Photo Album',
        'subContenido':
            'Organiza y guarda tus fotos en álbumes digitales accesibles desde cualquier dispositivo.',
        'imageUrl': 'assets/photo_album.png',
        'txtbtn': 'Ingresar',
        'function': () {
          provider.updateSelectedIndex(3);
          Get.to(() => EmployeeAlbumPanelPage());
        },
      },
      {
        'titulo': 'Shared Files',
        'subContenido':
            'Gestiona, sube y comparte archivos con tus compañeros de trabajo.',
        'imageUrl': 'assets/files.png',
        'txtbtn': 'Ingresar',
        'function': () {
          provider.updateSelectedIndex(4);
          Get.to(() => EmployeeFilesPanelPage());
        },
      }
    ];

    final card = cardData[index];
    return InfoCard(
      titulo: card['titulo'],
      subContenido: card['subContenido'],
      imageUrl: card['imageUrl'],
      txtbtn: card['txtbtn'],
      function: card['function'],
    );
  }
}

class InfoCard extends StatelessWidget {
  final String titulo;
  final String subContenido;
  final String imageUrl;
  final String txtbtn;
  final VoidCallback function;

  const InfoCard({
    super.key,
    required this.titulo,
    required this.subContenido,
    required this.imageUrl,
    required this.txtbtn,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8, // Sombra
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: function,
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Esto hace que el contenido se expanda
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.fill,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                        fontSize: cTitulosSize, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    subContenido,
                    style: const TextStyle(fontSize: cSubcontenidoSize),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: function,
                    icon: const Icon(Icons.play_arrow, color: Colors.white),
                    label: Text(
                      txtbtn,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: cSubcontenidoSize,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(120, 50, 220, 1),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
