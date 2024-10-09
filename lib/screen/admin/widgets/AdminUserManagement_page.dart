import 'package:districorp/constant/images.dart';
import 'package:districorp/constant/sizes.dart';
import 'package:districorp/controller/providers/Emp_dashboard_provider.dart';
import 'package:districorp/controller/services/api.dart';
import 'package:districorp/screen/admin/Panel_a%C3%B1adir_usuarios.dart';
import 'package:districorp/screen/admin/Panel_actualizar_usuarios.dart';
import 'package:districorp/widgets/SearchBarCustom.dart';
import 'package:districorp/widgets/UserItem_caja.dart';
import 'package:districorp/widgets/custom__button_image.dart';
import 'package:districorp/screen/admin/widgets/update_user.dart';
import 'package:flutter/material.dart';
import 'package:districorp/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AdminUserManagementPage extends StatefulWidget {
  final String tipoOu;

  const AdminUserManagementPage({super.key, required this.tipoOu});

  @override
  _AdminUserManagementPageState createState() =>
      _AdminUserManagementPageState();
}

class _AdminUserManagementPageState extends State<AdminUserManagementPage> {
  ApiController apiController = ApiController();
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    // Cargar los usuarios desde la API al iniciar
    fetchUsers();
  }

  // Función para obtener usuarios desde la API
  Future<void> fetchUsers() async {
    try {
      var response = await apiController.obtenerUsuariosDistri(widget.tipoOu);
      var jsonResponse = response['users'] as List;
      List<Map<String, dynamic>> fetchedUsers = jsonResponse.map((user) {
        return {
          'name': user['name'] + " " + user['surname'],
          'email': user['email'],
          'phone': user['phone'],
        };
      }).toList();

      setState(() {
        users = fetchedUsers;
        filteredUsers = fetchedUsers; // Inicialmente mostrar todos los usuarios
      });
    } catch (e) {
      print("Error al obtener usuarios: $e");
    }
  }

  void filterUsers(String query) {
    final filtered = users.where((user) {
      final emailLower = user['email']!.toLowerCase();
      final searchLower = query.toLowerCase();
      return emailLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredUsers = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final employeeProvider = Provider.of<EmpDashboardProvider>(context);

    return Stack(
      children: [
        Column(
          children: [
            Text(
              "Gestionar Usuarios",
              style: TextStyle(fontSize: cTitulosSize, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBarCustom(
                controller: searchController,
                onChanged: filterUsers,
                hintext: 'Buscar usuarios...',
              ),
            ),
            Expanded(
              child: filteredUsers.isNotEmpty
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: size.width > 1280 ? 3 : 2,
                        childAspectRatio: size.width > 1680 ? 2.6 : 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      padding: const EdgeInsets.all(16.0),
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        return UserItem(
                          name: filteredUsers[index]['name']!,
                          email: filteredUsers[index]['email']!,
                          phone: filteredUsers[index]['phone']!,
                          onUpdate: () {
                            employeeProvider.updateSelectedUserManagement(3);
                            Get.to(() => MainPanelActualizarUserPage(
                                  email: filteredUsers[index]['email']!,
                                ));
                          },
                          onDelete: () {
                            // Implementar la función para eliminar usuarios
                          },
                        );
                      },
                    )
                  : Center(child: CircularProgressIndicator()), // Indicador de carga mientras se obtienen los usuarios
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: CustomImageButton(
            imageUrl: cAddUser,
            onPressed: () {
              employeeProvider.updateSelectedUserManagement(2);
              Get.to(() => MainPanelAddUserPage());
            },
            tooltip: "Agregar Usuario",
          ),
        ),
      ],
    );
  }
}