import 'dart:typed_data';
import 'package:districorp/constant/images.dart';
import 'package:districorp/controller/providers/token_provider.dart';
import 'package:districorp/controller/services/api.dart';
import 'package:districorp/screen/Employee/Panel_album_empleado.dart';
import 'package:districorp/widgets/custom_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddStreamingEmpleado extends StatefulWidget {
  const AddStreamingEmpleado({super.key});

  @override
  State<AddStreamingEmpleado> createState() => _AddStreamingEmpleadoState();
}

class _AddStreamingEmpleadoState extends State<AddStreamingEmpleado> {
  ApiController apiController = ApiController();
  Uint8List? _imgBytes;
  String? _fileName;

  void takeSnapshot() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _imgBytes = result.files.single.bytes;
      });
      // Guarda el nombre del archivo
      String fileName = result.files.single.name;
      // Asegúrate de que `fileName` esté disponible en tu contexto.
      // Puedes guardarlo en una variable de estado si es necesario.
      _fileName =
          fileName; // Suponiendo que creaste una variable para guardar el nombre.
    } else {
      print("No se seleccionó ningún archivo o los bytes son nulos.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    return Center(
      child: Wrap(
        spacing: 20,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        runSpacing: 25,
        children: [
          Column(
            children: [
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
                child: const Text(
                  'Agregar un Video',
                  style: TextStyle(
                    fontSize: 26,
                    color: Color.fromARGB(255, 194, 51, 51),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 700, // Limita el ancho máximo de la tarjeta
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize
                          .min, // Esto permite que el Card se ajuste al contenido
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.center,
                          children: [
                            _imgBytes == null
                                ? const Text('No hay un video seleccionado.')
                                : SvgPicture.asset(
                                    cDefaultStreaming,
                                    height: size.height * 0.2,
                                    width: size.width * 0.2,
                                  ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                takeSnapshot();
                              },
                              child: ShaderMask(
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
                                child: const Icon(
                                  Icons.video_file_sharp,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          icon: Icons.arrow_circle_down_outlined,
                          text: 'Subir',
                          onPressed: () async {
                            final token = await tokenProvider.verificarTokenU();
                            if (token != null && _imgBytes != null) {
                              // Usa el nombre del archivo obtenido del FilePicker
                              String fileName = _fileName ??
                                  'video_por_defecto.mp4'; // Nombre por defecto si no hay archivo

                              int? result =
                                  await apiController.subirVideoEmpleadoDistri(
                                      token, _imgBytes!, fileName);

                              if (result == 200) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Video subido exitosamente!"),
                                  behavior: SnackBarBehavior.floating,
                                  showCloseIcon: true,
                                ));

                                Get.to(() => EmployeeAlbumPanelPage());
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SvgPicture.asset(
            cAddALbum,
            height: size.height * 0.3,
          ),
        ],
      ),
    );
  }
}


