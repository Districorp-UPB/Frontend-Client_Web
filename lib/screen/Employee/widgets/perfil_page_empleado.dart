import 'package:districorp/constant/images.dart';
import 'package:districorp/constant/sizes.dart';
import 'package:districorp/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class EmployeeProfile extends StatefulWidget {
  const EmployeeProfile({super.key});

  @override
  State<EmployeeProfile> createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _documentIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Wrap(
        
        spacing: 20,
        crossAxisAlignment: WrapCrossAlignment.center,
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
                        child: 
                      const Text(
                        'Editar Perfil',
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
                      mainAxisSize: MainAxisSize.min, // Esto permite que el Card se ajuste al contenido
                      children: [
                        Wrap(
                          spacing: 20.0, // Espaciado entre los elementos
                          runSpacing: 20.0, // Espaciado entre líneas cuando los elementos se "envuelven"
                          children: [
                            SizedBox(
                              width: 250, // Ancho fijo para los campos
                              child: CustomField(
                                nameController: _nameController,
                                hintText: 'Nombre',
                                icono: Icons.person,
                              ),
                            ),
                            SizedBox(
                              width: 250,
                              child: CustomField(
                                nameController: _lastNameController,
                                hintText: 'Apellidos',
                                icono: Icons.person,
                              ),
                            ),
                            SizedBox(
                              width: 250,
                              child: CustomField(
                                nameController: _telephoneController,
                                hintText: 'Telefono',
                                icono: Icons.local_phone_sharp,
                              ),
                            ),
                            SizedBox(
                              width: 250,
                              child: CustomField(
                                nameController: _emailController,
                                hintText: 'Correo',
                                icono: Icons.email,
                              ),
                            ),
                            SizedBox(
                              width: 250,
                              child: CustomField(
                                nameController: _documentIdController,
                                hintText: 'Documento',
                                icono: Icons.assignment_ind_rounded,
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
        Image.asset(
            cEditProfile,
            height: size.height * 0.6,
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
