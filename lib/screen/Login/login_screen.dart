import 'dart:async';

import 'package:districorp/constant/images.dart';
import 'package:districorp/controller/providers/token_provider.dart';
import 'package:districorp/controller/services/api.dart';
import 'package:districorp/screen/Employee/Panel_principal_empleado.dart';
import 'package:districorp/screen/Employee/widgets/home_page_empleado.dart';
import 'package:districorp/screen/admin/Panel_principal_admin.dart';
import 'package:districorp/screen/admin/widgets/AdminUserManagement_page.dart';
import 'package:districorp/widgets/formulario_select.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../widgets/gradient_appbar.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ApiController apiController = ApiController();
  // Inicializamos una variable para controlar la visibilidad de la contraseña
  bool visiIcon = false;

  visibilityIcon() {
    setState(() {
      visiIcon = !visiIcon;
    });
  }

  // Inicializamos variables para el control de errores
  String emailError = '';
  String contraError = '';
  String rolError = '';

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
        rolError = errors['rol'] ?? '';
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
    final tokenProvider = Provider.of<TokenProvider>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const GradientAppBar(
        implyLeading: false,
        titleColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 50,
                  child: Image.asset(
                    cCloudIlustration,
                    height: size.height * 0.9,
                  ),
                ),
                Flexible(
                  flex: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        cLogoMain,
                        height: size.height * 0.2,
                      ),
                      const SizedBox(height: 10),
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
                          'Iniciar Sesión',
                          style: TextStyle(
                            fontSize: 26,
                            color: Color.fromARGB(255, 194, 51, 51),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: size.width * 0.3,
                        child: CustomInput(
                          hintText: 'Correo Electrónico',
                          icon: Icons.email,
                          controller: apiController.emailController,
                          errorText: emailError.isNotEmpty ? emailError : null,
                          errorStyle: errorStyle,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: size.width * 0.3,
                        child: FormularioSelect(
                          opciones: const [
                            "Usuario",
                            "Empleado",
                            "Administrador"
                          ],
                          errorText: rolError.isNotEmpty ? rolError : null,
                          errorStyle: errorStyle,
                          controller: apiController.tipoRolController,
                          texto: "Tipo de Rol",
                          icono: const Icon(Icons.groups),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: size.width * 0.3,
                        child: TextField(
                          controller: apiController.passwordController,
                          obscureText: visiIcon ? false : true,
                          decoration: InputDecoration(
                              hintText: 'Contraseña',
                              prefixIcon: Icon(Icons.lock),
                              errorText:
                                  contraError.isNotEmpty ? contraError : null,
                              errorStyle: errorStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: IconButton(
                                  splashColor: Colors.transparent,
                                  onPressed: () {
                                    visibilityIcon();
                                  },
                                  icon: visiIcon
                                      ? const Icon(
                                          Icons.remove_red_eye_sharp,
                                        )
                                      : const Icon(Icons.visibility_off))),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: size.width * 0.3,
                        height: size.height * 0.05,
                        child: CustomButton(
                          text: 'Iniciar Sesión',
                          onPressed: () async {
                            try {
                              // Inicializar un Map para los errores
                              Map<String, String> errors = {
                                'emailError': '',
                                'contraError': '',
                                'rolError': '',
                              };

                              // Validaciones y asignación de mensajes de error
                              if (apiController.emailController.text.isEmpty) {
                                errors['emailError'] =
                                    'Ingrese un correo electronico';
                              }

                              if (apiController
                                  .passwordController.text.isEmpty) {
                                errors['contraError'] =
                                    'Ingrese una contraseña';
                              }

                              if (apiController
                                  .tipoRolController.text.isEmpty) {
                                errors['rolError'] = 'Ingrese un rol';
                              }

                              // Actualizar el estado una vez con los errores
                              setState(() {
                                emailError = errors['emailError']!;
                                contraError = errors['contraError']!;
                                rolError = errors['rolError']!;
                              });

                              // Si no hay errores, proceder con el login
                              if (errors.values
                                  .every((error) => error.isEmpty)) {
                                dynamic result =
                                    await apiController.loginDistri();

                                if (result != {}) {
                                  tokenProvider.setTokenU(result['token']);

                                  switch (result['rol']) {
                                    case 'Employee':
                                      Get.to(() => EmployeePanelPage(
                                          child: EmployeeHome()));
                                      break;
                                    case 'Admin':
                                      Get.to(() => MainPanelPage(
                                          child: AdminUserManagementPage(tipoOu: 'User',)));
                                      break;
                                    default:
                                      // Manejo de rol no reconocido
                                      print('Rol no reconocido');
                                  }
                                }
                              }
                            } catch (e) {
                              print("Error al registrar usuario: $e");
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
