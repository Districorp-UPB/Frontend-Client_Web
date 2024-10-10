import 'dart:typed_data'; // Importa para trabajar con Uint8List
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

class AddFileEmpleado extends StatefulWidget {
  const AddFileEmpleado({super.key});

  @override
  State<AddFileEmpleado> createState() => _AddFileEmpleadoState();
}

class _AddFileEmpleadoState extends State<AddFileEmpleado> {
  ApiController apiController = ApiController();
  Uint8List? _fileBytes; // Cambiamos a Uint8List para almacenar los bytes
  String? _fileName;

  void takeSnapshot() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _fileName = result.files.single.name; // Guarda el nombre del archivo
        _fileBytes = result.files.single.bytes; // Obtiene los bytes del archivo
      });
    } else {
      print("No se seleccionó ningún archivo.");
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
                  'Agregar un Archivo',
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.center,
                          children: [
                            _fileBytes == null
                                ? const Text('No hay un archivo seleccionado.')
                                : SvgPicture.asset(
                                    cDefaultImage,
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
                                  Icons.file_present_rounded,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          icon: Icons.upload_file_sharp,
                          text: 'Subir',
                          onPressed: () async {
                            final token = await tokenProvider.verificarTokenU();
                            if (token != null && _fileBytes != null) {
                              // Usa el nombre del archivo obtenido del FilePicker
                              String fileName =
                                  _fileName ?? 'archivo_por_defecto.file';

                              // Llama al método para subir el archivo
                              int? result = await apiController
                                  .subirArchivoEmpleadoDistri(
                                      token,
                                      _fileBytes!,
                                      fileName); // Se usa _fileBytes que ya es de tipo Uint8List

                              if (result == 200) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Archivo subido exitosamente!"),
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
            cAddFile,
            height: size.height * 0.3,
          ),
        ],
      ),
    );
  }
}
