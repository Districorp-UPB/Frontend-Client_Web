import 'dart:typed_data';
import 'package:districorp/constant/colors.dart';
import 'package:districorp/constant/images.dart';
import 'package:districorp/widgets/custom_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddAlbumEmpleado extends StatefulWidget {
  const AddAlbumEmpleado({super.key});

  @override
  State<AddAlbumEmpleado> createState() => _AddAlbumEmpleadoState();
}

class _AddAlbumEmpleadoState extends State<AddAlbumEmpleado> {
  Uint8List? _imgBytes;

  void takeSnapshot() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _imgBytes = result.files.single.bytes;
      });
    } else {
      print("No se seleccionó ningún archivo o los bytes son nulos.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                  'Agregar una Foto',
                  style: TextStyle(
                    fontSize: 30,
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
                                ? const Text('No hay una imagen seleccionada.')
                                : Container(
                                    height: size.height * 0.4,
                                    width: size.width * 0.4,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      image: DecorationImage(
                                        image: MemoryImage(_imgBytes!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
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
                                  Icons.image_search_sharp,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          icon: Icons.replay_circle_filled_sharp,
                          text: 'Actualizar',
                          onPressed: () {},
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

class CustomField extends StatelessWidget {
  final TextEditingController _nameController;
  final String hintText;
  final IconData icono;

  const CustomField({
    super.key,
    required TextEditingController nameController,
    required this.hintText,
    required this.icono,
  }) : _nameController = nameController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: hintText,
        prefixIcon: Icon(icono),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
