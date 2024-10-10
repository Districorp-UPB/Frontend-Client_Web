import 'package:districorp/controller/providers/Emp_dashboard_provider.dart';
import 'package:districorp/controller/providers/navigator_observer.dart';
import 'package:districorp/controller/providers/token_provider.dart';
import 'package:districorp/screen/Employee/Panel_agregar_album.dart';
import 'package:districorp/screen/Employee/Panel_agregar_archivo.dart';
import 'package:districorp/screen/Employee/Panel_agregar_streaming.dart';
import 'package:districorp/screen/Employee/Panel_album_empleado.dart';
import 'package:districorp/screen/Employee/Panel_files_empelado.dart';
import 'package:districorp/screen/Employee/Panel_perfil_empleado.dart';
import 'package:districorp/screen/Employee/Panel_principal_empleado.dart';
import 'package:districorp/screen/Employee/Panel_streaming_empleado.dart';
import 'package:districorp/screen/Employee/widgets/home_page_empleado.dart';
import 'package:districorp/screen/admin/Panel_a%C3%B1adir_usuarios.dart';
import 'package:districorp/screen/admin/Panel_actualizar_usuarios.dart';
import 'package:districorp/screen/admin/Panel_gestionar_empleados.dart';
import 'package:districorp/screen/admin/widgets/AdminUserManagement_page.dart';
import 'package:districorp/screen/admin/Panel_principal_admin.dart';
import 'package:districorp/screen/Login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';

void main() async {
  // Garantiza que los widgets estén inicializados antes de ejecutar la aplicación.
  WidgetsFlutterBinding.ensureInitialized();

  // Obtener una instancia de TokenProvider
  TokenProvider tokenProvider = TokenProvider();

  // Llamar al método verificarTokenU() y esperar su resultado si existe token
  String? token = await tokenProvider.getTokenU();

  // LLamar el metodo de getRolU() y saber si el token si existe que rol pertenece
  String? rol = await tokenProvider.getRolU(token);

   VideoPlayerMediaKit.ensureInitialized(
    macOS: true,
    windows: true,
    linux: true,
    android: true,
    web: true
  );

  setUrlStrategy(PathUrlStrategy());
  runApp(MyApp(
    rol: rol,
  ));
}

class MyApp extends StatelessWidget {
  final String? rol;
  const MyApp({super.key, this.rol});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EmpDashboardProvider>(
            create: (_) => EmpDashboardProvider()),
        ChangeNotifierProvider<TokenProvider>(create: (_) => TokenProvider()),
      ],
      child: Builder(builder: (context) {
        // Obtenemos el provider aquí
        final providerEmployee =
            Provider.of<EmpDashboardProvider>(context, listen: false);

        return GetMaterialApp(
          scrollBehavior: MyBehavior(),
          debugShowCheckedModeBanner: false,
          defaultTransition:
              Transition.fadeIn, // Define el tipo de transición por defecto
          transitionDuration: const Duration(
              milliseconds: 400), // Duración global para las transiciones

          initialRoute: _getInitialRoute(rol),
          theme: ThemeData(
            primarySwatch: Colors.purple,
          ),
          navigatorObservers: [CustomNavigatorObserver(providerEmployee)],
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
          },
          routes: {
            // Ruta para gestion de usuarios
            '/LoginScreen': (context) => const LoginScreen(),

            '/MainPanelPage': (context) => MainPanelPage(
                  child: AdminUserManagementPage(
                    tipoOu: 'User',
                  ),
                ),
            '/MainPanelAdminEmployeePage': (context) =>
                MainPanelAdminEmployeePage(),
            '/MainPanelActualizarUserPage': (context) =>
                MainPanelActualizarUserPage(),
            '/MainPanelAddUserPage': (context) => MainPanelAddUserPage(),

            // Rutas para los empleados
            '/EmployeePanelPage': (context) => EmployeePanelPage(
                  child: EmployeeHome(),
                ),
            '/EmployeeStreamingPanelPage': (context) =>
                EmployeeStreamingPanelPage(),
            '/EmployeeProfilePanelPage': (context) =>
                EmployeeProfilePanelPage(),
            '/EmployeeFilesPanelPage': (context) => EmployeeFilesPanelPage(),
            '/EmployeeAlbumPanelPage': (context) => EmployeeAlbumPanelPage(),
            '/EmployeeAddAlbumPanelPage': (context) =>
                EmployeeAddAlbumPanelPage(),
            '/EmployeeAddFilePanelPage': (context) =>
                EmployeeAddFilePanelPage(),
            '/EmployeeAddStreamingPanelPage': (context) =>
                EmployeeAddStreamingPanelPage(),
          },
        );
      }),
    );
  }
}

// Método para determinar la ruta inicial según el rol
String _getInitialRoute(String? rol) {
  if (rol == null) {
    return '/LoginScreen';
  } else if (rol == 'Admin') {
    return '/MainPanelPage';
  } else if (rol == 'Employee') {
    return '/EmployeePanelPage';
  }
  return '/LoginScreen'; // Por defecto
}

class MyBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics();
}
