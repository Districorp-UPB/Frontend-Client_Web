import 'package:districorp/controller/providers/Emp_dashboard_provider.dart';
import 'package:districorp/controller/providers/navigator_observer.dart';
import 'package:districorp/controller/providers/token_provider.dart';
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

void main() async {
  // Garantiza que los widgets estén inicializados antes de ejecutar la aplicación.
  WidgetsFlutterBinding.ensureInitialized();

  // Obtener una instancia de TokenProvider
  TokenProvider tokenProvider = TokenProvider();

  // Llamar al método verificarTokenU() y esperar su resultado si existe token
  String? token = await tokenProvider.getTokenU();
  setUrlStrategy(PathUrlStrategy());
  runApp(MyApp(
    token: token,
  ));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key, this.token});

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
          initialRoute: '/MainPanelPage',
          // initialRoute: (token != null) ? '/MainPanelPage':'/LoginScreen',
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
                  child: AdminUserManagementPage(tipoOu: 'User',),
                ),
            '/MainPanelAdminEmployeePage': (context) => MainPanelAdminEmployeePage(),
            '/MainPanelActualizarUserPage': (context) =>
                MainPanelActualizarUserPage(
                
                ),
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
          },
        );
      }),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics();
}
