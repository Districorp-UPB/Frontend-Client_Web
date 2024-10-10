import 'package:districorp/constant/images.dart';
import 'package:districorp/constant/sizes.dart';
import 'package:districorp/controller/providers/Emp_dashboard_provider.dart';
import 'package:districorp/controller/providers/token_provider.dart';
import 'package:districorp/controller/services/api.dart';
import 'package:districorp/models/profile_models.dart';
import 'package:districorp/screen/Employee/Panel_perfil_empleado.dart';
import 'package:districorp/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class EmployeeProfile extends StatefulWidget {
  const EmployeeProfile({super.key});

  @override
  State<EmployeeProfile> createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {
  ApiController apiController = ApiController();
  bool isLoading = true; // Controla si se están cargando los datos

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    try {
      TokenProvider tokenProvider = TokenProvider();
      EmpDashboardProvider empDashboardProvider =
          Provider.of<EmpDashboardProvider>(context, listen: false);

      String? token = await tokenProvider.verificarTokenU();
      if (token != null) {
        Map<String, dynamic> tokenData = tokenProvider.decodeToken(token);
        String email = tokenData['email'];

        // Obtener datos personales desde la API
        Map<String, dynamic> datosPersonales =
            await apiController.obtenerDatosPersonalesDistri(email);

        // Convertir el Map en una instancia de Profiles
        Profiles profile = Profiles.fromJson(datosPersonales);

        // Actualizar el perfil en el provider
        empDashboardProvider.updateSelectedProfile(profile);

        // Desactivar la carga
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error al obtener datos personales: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmpDashboardProvider>(context);

    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(), // Mostrar un icono de carga
      );
    }

    final size = MediaQuery.of(context).size;

    apiController.nombrePerfilController.text =
        employeeProvider.selectedProfiles.nombre;
    apiController.apellidolPerfilController.text =
        employeeProvider.selectedProfiles.apellido;
    apiController.emailPerfilController.text =
        employeeProvider.selectedProfiles.email;
    apiController.phonePerfilController.text =
        employeeProvider.selectedProfiles.telefono;
    apiController.documentPerfilController.text =
        employeeProvider.selectedProfiles.documento;
    apiController.rolPerfilController.text =
        employeeProvider.selectedProfiles.rol;

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
                child: const Text(
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
                      maxWidth: 700,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Wrap(
                          spacing: 20.0,
                          runSpacing: 20.0,
                          children: [
                            CustomField(
                              
                              nameController:
                                  apiController.nombrePerfilController,
                              hintText: 'Nombre',
                              icono: Icons.person,
                            ),
                            CustomField(
                              nameController:
                                  apiController.apellidolPerfilController,
                              hintText: 'Apellidos',
                              icono: Icons.person,
                            ),
                            CustomField(
                              nameController:
                                  apiController.phonePerfilController,
                              hintText: 'Telefono',
                              icono: Icons.local_phone_sharp,
                            ),
                            CustomField(
                              nameController:
                                  apiController.emailPerfilController,
                              hintText: 'Correo',
                              icono: Icons.email,
                              enabled: false
                            ),
                            CustomField(
                              nameController:
                                  apiController.documentPerfilController,
                              hintText: 'Documento',
                              icono: Icons.assignment_ind_rounded,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          icon: Icons.replay_circle_filled_sharp,
                          text: 'Actualizar',
                          onPressed: () async {
                            final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
                  final token = await tokenProvider.verificarTokenU();
                  if (token != null) {
                    int? result = await apiController.actualizarPerfilEmpleadoDistri(token);
                    if (result == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Perfil Actualizado Existosamente!"),
                        behavior: SnackBarBehavior.floating,
                        showCloseIcon: true,
                      ));

                    _loadProfile();
                    

                    Get.to(() => EmployeeProfilePanelPage());
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
  final bool? enabled;

  const CustomField({
    super.key,
    required TextEditingController nameController,
    required this.hintText,
    required this.icono, this.enabled,
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
        enabled: enabled
    );
  }
}
