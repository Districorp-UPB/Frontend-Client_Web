import 'dart:async';

import 'package:districorp/controller/services/api.dart';
import 'package:districorp/screen/admin/Panel_principal_admin.dart';
import 'package:districorp/screen/admin/widgets/AdminUserManagement_page.dart';
import 'package:districorp/widgets/formulario_select.dart';
import 'package:flutter/material.dart';
import 'package:districorp/widgets/custom_input.dart';
import 'package:districorp/widgets/custom_button.dart';
import 'package:get/get.dart';

class AddUserPage extends StatefulWidget {
  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  ApiController apiController = ApiController();
  // Inicializamos variables para el control de errores
  String emailError = '';
  String contraError = '';
  String firstNameError = '';
  String lastNameError = '';
  String phoneError = '';
  String documentError = '';
  String tipoRolError = '';

  TextStyle errorStyle = const TextStyle(
      fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic);

  late StreamSubscription<Map<String, String>> _errorSubscription;

  @override
  void initState() {
    super.initState();
    _errorSubscription = apiController.errorStream.listen((errors) {
      setState(() {
        emailError = errors['email'] ?? '';
        contraError = errors['contrasenia'] ?? '';
        documentError = errors['documento'] ?? '';
        tipoRolError = errors['rol'] ?? '';
      });
    });
  }

  @override
  void dispose() {
    _errorSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CustomInput(
            hintText: 'Nombre',
            icon: Icons.person,
            controller: apiController.nombreNewController,
            errorText: firstNameError.isNotEmpty ? firstNameError : null,
            errorStyle: errorStyle,
          ),
          const SizedBox(height: 16),
          CustomInput(
            hintText: 'Apellido',
            icon: Icons.person,
            controller: apiController.apellidolNewController,
            errorText: lastNameError.isNotEmpty ? lastNameError : null,
            errorStyle: errorStyle,
          ),
          const SizedBox(height: 16),
          CustomInput(
            hintText: 'Correo Electrónico',
            icon: Icons.email,
            controller: apiController.emailNewController,
            errorText: emailError.isNotEmpty ? emailError : null,
            errorStyle: errorStyle,
          ),
          const SizedBox(height: 16),
          CustomInput(
            hintText: 'Documento',
            icon: Icons.assignment_ind_rounded,
            controller: apiController.documentNewController,
            errorText: documentError.isNotEmpty ? documentError : null,
            errorStyle: errorStyle,
          ),
          const SizedBox(height: 16),
          CustomInput(
            hintText: 'Teléfono',
            icon: Icons.phone,
            controller: apiController.phoneNewController,
            errorText: phoneError.isNotEmpty ? phoneError : null,
            errorStyle: errorStyle,
          ),
          const SizedBox(height: 16),
          CustomInput(
            hintText: 'Contraseña',
            icon: Icons.lock,
            controller: apiController.passwordNewController,
            isPassword: false,
            errorText: contraError.isNotEmpty ? contraError : null,
            errorStyle: errorStyle,
          ),
          const SizedBox(height: 16),
          SizedBox(
            child: FormularioSelect(
              opciones: const ["Usuario", "Empleado"],
              errorText: tipoRolError.isNotEmpty ? tipoRolError : null,
              errorStyle: errorStyle,
              controller: apiController.rolNewController,
              texto: "Tipo de Rol",
              icono: const Icon(Icons.groups),
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Guardar',
            onPressed: () async {
              try {
                // Inicializar un Map para los errores
                Map<String, String> errorsRegister = {
                  'emailError': '',
                  'contraError': '',
                  'firstNameError': '',
                  'lastNameError': '',
                  'phoneError': '',
                  'documentError': '',
                  'tipoRolError': '',
                };

                // Validaciones y asignación de mensajes de error
                if (apiController.emailNewController.text.isEmpty) {
                  errorsRegister['emailError'] =
                      'Ingrese un correo electronico para el usuario';
                }

                if (apiController.passwordNewController.text.isEmpty) {
                  errorsRegister['contraError'] =
                      'Ingrese una contraseña para el usuario';
                }

                if (apiController.nombreNewController.text.isEmpty) {
                  errorsRegister['firstNameError'] =
                      'Ingrese un nombre para el usuario';
                }
                if (apiController.apellidolNewController.text.isEmpty) {
                  errorsRegister['lastNameError'] =
                      'Ingrese un apellido para el usuario';
                }
                if (apiController.phoneNewController.text.isEmpty) {
                  errorsRegister['phoneError'] = 'Ingrese un telefono para el usuario';
                }
                if (apiController.documentNewController.text.isEmpty) {
                  errorsRegister['documentError'] =
                      'Ingrese un documento para el usuario';
                }

                if (apiController.rolNewController.text.isEmpty) {
                  errorsRegister['tipoRolError'] = 'Ingrese un rol para el usuario';
                }

                // Actualizar el estado una vez con los errores
                setState(() {
                  emailError = errorsRegister['emailError']!;
                  contraError = errorsRegister['contraError']!;
                  firstNameError = errorsRegister['firstNameError']!;
                  lastNameError = errorsRegister['lastNameError']!;
                  phoneError = errorsRegister['phoneError']!;
                  documentError = errorsRegister['documentError']!;
                  tipoRolError = errorsRegister['tipoRolError']!;
                });
                print(errorsRegister.values);
                // Si no hay errores, proceder con el login
                if (errorsRegister.values.every((error) => error.isEmpty)) {
                  print("123");
                  int? result = await apiController.registrarUsuarioDistri();
                  if (result == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Usuario Registrado Existosamente!"),
                      behavior: SnackBarBehavior.floating,
                      showCloseIcon: true,
                    ));

                    Get.to(() => MainPanelPage(
                                child: AdminUserManagementPage(tipoOu: 'User',)));
                  }
                }
              } catch (e) {
                print("Error al registrar usuario: $e");
              }
            },
          ),
        ],
      ),
    );
  }
}
