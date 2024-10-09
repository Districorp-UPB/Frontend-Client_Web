import 'package:districorp/constant/sizes.dart';
import 'package:districorp/controller/providers/Emp_dashboard_provider.dart';
import 'package:districorp/screen/Employee/Panel_album_empleado.dart';
import 'package:districorp/screen/Employee/Panel_files_empelado.dart';
import 'package:districorp/screen/Employee/Panel_perfil_empleado.dart';
import 'package:districorp/screen/Employee/Panel_streaming_empleado.dart';
import 'package:districorp/screen/Employee/widgets/home_page_empleado.dart';
import 'package:districorp/screen/admin/Panel_gestionar_empleados.dart';
import 'package:districorp/screen/Login/login_screen.dart';
import 'package:districorp/widgets/drawer_tile.dart';
import 'package:districorp/widgets/gradient_appbar_total.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class EmployeePanelPage extends StatefulWidget {
  final Widget child; // Agregamos el parámetro child

  const EmployeePanelPage({Key? key, required this.child}) : super(key: key);

  @override
  State<EmployeePanelPage> createState() => _EmployeePanelPageState();
}

class _EmployeePanelPageState extends State<EmployeePanelPage> {
  // Controla el estado del hover
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    // Esperamos a que el widget esté montado para actualizar el índice
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<EmpDashboardProvider>(context, listen: false);
      String currentPath = ModalRoute.of(context)?.settings.name ?? '/';
      provider.updateIndexFromUrl(currentPath);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final employeeProvider = Provider.of<EmpDashboardProvider>(context);

    return Scaffold(
      appBar: GradientAppBarTotal(
        implyLeading: false,
        title: employeeProvider.getTitle(employeeProvider.selectedIndex),
        actions: [],
      ),
      body: Container(
        // Aplicamos el gradiente al fondo completo
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(235, 2, 56, 1),
              Color.fromRGBO(120, 50, 220, 1)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          children: [
            // Sidebar que ocupa el 20% del ancho de la pantalla
            Expanded(
              flex: 15, // 20% del espacio
              child: Column(
                children: [
                  SizedBox(
                    height: 55,
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 4),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person,
                        color: Colors.white, size: size.height * 0.08),
                  ),
                  SizedBox(
                    height: cDefaultSize,
                  ),
                  Expanded(
                    flex: 3,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        DrawerTile(
                          size: size,
                          texto: "Home",
                          
                          icono: Icons.other_houses_rounded,
                          onTap: () {
                            // Actualizar el indice de las paginas
                            employeeProvider.updateSelectedIndex(0);
                            Get.to(() => EmployeePanelPage(child: EmployeeHome(),));
                          },
                          selected: employeeProvider.selectedIndex == 0,
                          color: Colors.amber,
                        ),
                        DrawerTile(
                          size: size,
                          texto: "Editar Perfil",
                          icono: Icons.edit,
                          onTap: () {
                            // Actualizar el indice de las paginas
                            employeeProvider.updateSelectedIndex(1);
                            Get.to(() => EmployeeProfilePanelPage());
                          },
                          selected: employeeProvider.selectedIndex == 1,
                          color: Colors.amber,
                        ),
                        DrawerTile(
                          size: size,
                          texto: "Streaming",
                          icono: Icons.play_circle_sharp,
                          onTap: () {
                            // Actualizar el indice de las paginas
                            employeeProvider.updateSelectedIndex(2);
                            Get.to(() => EmployeeStreamingPanelPage());
                          },
                          selected: employeeProvider.selectedIndex == 2,
                          color: Colors.amber,
                        ),
                        DrawerTile(
                          size: size,
                          texto: "Photo Album",
                          icono: Icons.photo_camera_back_sharp,
                          onTap: () {
                            // Actualizar el indice de las paginas
                            employeeProvider.updateSelectedIndex(3);
                            Get.to(() => EmployeeAlbumPanelPage());
                          },
                          selected: employeeProvider.selectedIndex == 3,
                          color: Colors.amber,
                        ),
                        DrawerTile(
                          size: size,
                          texto: "Files",
                          icono: Icons.upload_file_sharp,
                          onTap: () {
                            // Actualizar el indice de las paginas
                            employeeProvider.updateSelectedIndex(4);
                            Get.to(() => EmployeeFilesPanelPage());
                          },
                          selected: employeeProvider.selectedIndex == 4,
                          color: Colors.amber,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) {
                        setState(() {
                          _isHovered = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _isHovered = false;
                        });
                      },
                      child: GestureDetector(
                        onTap: () {
                          print('Logout');
                          Get.to(() => const LoginScreen());
                        },
                        child: AnimatedContainer(
                          duration: Duration(
                              milliseconds: 200), // Duración de la animación
                          padding: EdgeInsets.all(12), // Espaciado interno
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Row(
                                children: [
                                  Icon(
                                    Icons.logout,
                                    color: _isHovered
                                        ? Colors.amber
                                        : Colors.white,
                                  ),
                                  // Controlamos el texto basado en el ancho disponible
                                  if (constraints.maxWidth > 100) ...[
                                    SizedBox(
                                        width:
                                            8), // Espaciado entre el icono y el texto
                                    Text(
                                      "Log Out",
                                      style: TextStyle(
                                        fontSize: 18.5,
                                        color: _isHovered
                                            ? Colors.amber
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            // Contenido principal que ocupa el 80% del ancho
            Expanded(
              flex: 85, // 80% del espacio
              child: Container(
                height: size.height,
                // Color de fondo del contenido principal (el default del scaffold)
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .scaffoldBackgroundColor, // Color de fondo predeterminado
                  borderRadius: const BorderRadius.only(
                    topLeft:
                        Radius.circular(50), // Curvatura superior izquierda
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: widget.child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
