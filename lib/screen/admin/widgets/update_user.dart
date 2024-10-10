import 'dart:async';

import 'package:districorp/controller/providers/Emp_dashboard_provider.dart';
import 'package:districorp/controller/providers/token_provider.dart';
import 'package:districorp/controller/services/api.dart';
import 'package:districorp/screen/admin/Panel_principal_admin.dart';
import 'package:districorp/screen/admin/widgets/AdminUserManagement_page.dart';
import 'package:districorp/widgets/formulario_select.dart';
import 'package:flutter/material.dart';
import 'package:districorp/widgets/custom_input.dart';
import 'package:districorp/widgets/custom_button.dart';
import 'package:districorp/widgets/gradient_appbar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class UpdateUserPage extends StatefulWidget {

  UpdateUserPage();

  @override
  State<UpdateUserPage> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
 
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
    final employeeProvider = Provider.of<EmpDashboardProvider>(context);
    // Inicialiamos las variables de los campos del usuario
    apiController.nombreActualizarController.text = employeeProvider.selectedUser.nombre;
    apiController.apellidolActualizarController.text = employeeProvider.selectedUser.apellido;
    apiController.emailActualizarController.text = employeeProvider.selectedUser.email;
    apiController.documentActualizarController.text = employeeProvider.selectedUser.documento;
    apiController.phoneActualizarController.text = employeeProvider.selectedUser.telefono;
    apiController.rolActualizarController.text = employeeProvider.selectedUser.rol;

    return 
       Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
        children: [
          CustomInput(
            hintText: 'Nombre',
            icon: Icons.person,
            controller: apiController.nombreActualizarController,
            errorText: firstNameError.isNotEmpty ? firstNameError : null,
            errorStyle: errorStyle,
          ),
          const SizedBox(height: 16),
          CustomInput(
            hintText: 'Apellido',
            icon: Icons.person,
            controller: apiController.apellidolActualizarController,
            errorText: lastNameError.isNotEmpty ? lastNameError : null,
            errorStyle: errorStyle,
          ),
          const SizedBox(height: 16),
          CustomInput(
            hintText: 'Correo Electrónico',
            icon: Icons.email,
            controller: apiController.emailActualizarController,
            errorText: emailError.isNotEmpty ? emailError : null,
            errorStyle: errorStyle,
            enabled: false,
          ),
          const SizedBox(height: 16),
          CustomInput(
            hintText: 'Documento',
            icon: Icons.assignment_ind_rounded,
            controller: apiController.documentActualizarController,
            errorText: documentError.isNotEmpty ? documentError : null,
            errorStyle: errorStyle,
            
          ),
          const SizedBox(height: 16),
          CustomInput(
            hintText: 'Teléfono',
            icon: Icons.phone,
            controller: apiController.phoneActualizarController,
            errorText: phoneError.isNotEmpty ? phoneError : null,
            errorStyle: errorStyle,
          ),
          const SizedBox(height: 16),
          CustomInput(
            hintText: 'Tipo de Rol',
            icon: Icons.groups,
            controller: apiController.rolActualizarController,
            
            errorText: contraError.isNotEmpty ? contraError : null,
            errorStyle: errorStyle,
            enabled: false,
          ),
        
          const SizedBox(height: 24),
          CustomButton(
            text: 'Actualizar',
            onPressed: () async {
              try {
                // Inicializar un Map para los errores
                Map<String, String> errorsRegister = {
                  'firstNameError': '',
                  'lastNameError': '',
                  'phoneError': '',
                  'documentError': '',
                };

                // Validaciones y asignación de mensajes de error
                if (apiController.nombreActualizarController.text.isEmpty) {
                  errorsRegister['firstNameError'] =
                      'Ingrese un nombre para el usuario';
                }
                if (apiController.apellidolActualizarController.text.isEmpty) {
                  errorsRegister['lastNameError'] =
                      'Ingrese un apellido para el usuario';
                }
                if (apiController.phoneActualizarController.text.isEmpty) {
                  errorsRegister['phoneError'] = 'Ingrese un telefono para el usuario';
                }
                if (apiController.documentActualizarController.text.isEmpty) {
                  errorsRegister['documentError'] =
                      'Ingrese un documento para el usuario';
                }

                // Actualizar el estado una vez con los errores
                setState(() {
                  firstNameError = errorsRegister['firstNameError']!;
                  lastNameError = errorsRegister['lastNameError']!;
                  phoneError = errorsRegister['phoneError']!;
                  documentError = errorsRegister['documentError']!;

                });
                print(errorsRegister.values);
                // Si no hay errores, proceder con el login
                if (errorsRegister.values.every((error) => error.isEmpty)) {
                  final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
                  final token = await tokenProvider.verificarTokenU();
                  if (token != null) {
                    int? result = await apiController.actualizarUsuarioDistri(token);
                    if (result == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Usuario Actualizado Existosamente!"),
                        behavior: SnackBarBehavior.floating,
                        showCloseIcon: true,
                      ));

                      Get.to(() => MainPanelPage(
                                  child: AdminUserManagementPage(tipoOu: 'User',)));
                    }
                    
                  }
                }
              } catch (e) {
                print("Error al actualizar usuario: $e");
              }
            },
          ),
        ],
      ),
    );
  }
}
