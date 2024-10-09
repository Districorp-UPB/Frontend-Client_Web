import 'dart:async'; // Para el Timer

import 'package:districorp/constant/images.dart';
import 'package:districorp/constant/sizes.dart';
import 'package:districorp/controller/providers/Emp_dashboard_provider.dart';
import 'package:districorp/controller/providers/token_provider.dart';
import 'package:districorp/controller/services/api.dart';
import 'package:districorp/models/usuarios_models.dart';
import 'package:districorp/screen/admin/Panel_a%C3%B1adir_usuarios.dart';
import 'package:districorp/screen/admin/Panel_actualizar_usuarios.dart';
import 'package:districorp/widgets/SearchBarCustom.dart';
import 'package:districorp/widgets/UserItem_caja.dart';
import 'package:districorp/widgets/custom__button_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AdminUserManagementPage extends StatefulWidget {
  final String tipoOu;

  const AdminUserManagementPage({super.key, required this.tipoOu});

  @override
  _AdminUserManagementPageState createState() => _AdminUserManagementPageState();
}

class _AdminUserManagementPageState extends State<AdminUserManagementPage> {
  ApiController apiController = ApiController();
  final TextEditingController searchController = TextEditingController();
  List<Usuarios> users = [];
  List<Usuarios> filteredUsers = [];
  final ScrollController _scrollController = ScrollController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Cargar los usuarios desde la API al iniciar
    fetchUsers();

    // Configurar el polling cada 2 minutos
    _timer = Timer.periodic(Duration(minutes: 2), (timer) {
      fetchUsers();
    });

    // Escuchar el desplazamiento del scroll para actualizar al subir
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
          // El scroll está en la parte superior, recargar datos
          fetchUsers();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer.cancel(); // Cancelar el polling cuando se destruya el widget
    super.dispose();
  }

  // Mapeo de roles
  Map<String, String> rolesMap = {
    "Employee": "Empleados",
    "User": "Usuarios",
  };

  // Función para obtener usuarios desde la API
  Future<void> fetchUsers() async {
    try {
      final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
      final token = await tokenProvider.verificarTokenU();
      if (token != null) {
        var response = await apiController.obtenerUsuariosDistri(widget.tipoOu, token);
        var jsonResponse = response['users'] as List;

        List<Usuarios> fetchedUsers = jsonResponse.map((userJson) {
          return Usuarios.fromJson(userJson);
        }).toList();

        setState(() {
          users = fetchedUsers;
          filteredUsers = fetchedUsers;
        });
      }
    } catch (e) {
      print("Error al obtener usuarios: $e");
    }
  }

  // Función para filtrar los usuarios
  void filterUsers(String query) {
    final filtered = users.where((user) {
      final emailLower = user.email.toLowerCase();
      final nameLower = (user.nombre + " " + user.apellido).toLowerCase();
      final searchLower = query.toLowerCase();
      return emailLower.contains(searchLower) || nameLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredUsers = filtered;
    });
  }

  void _deleteUser(Usuarios user, BuildContext context) async {
    try {
      final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
      final token = await tokenProvider.verificarTokenU();

      if (token != null) {
        await apiController.eliminarUsuariosDistri(user.email, user.rol);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Usuario eliminado exitosamente!"),
            behavior: SnackBarBehavior.floating,
            showCloseIcon: true,
          ),
        );

        await fetchUsers(); // Refrescar la lista de usuarios
      }
    } catch (e) {
      print("Error al eliminar usuario: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final employeeProvider = Provider.of<EmpDashboardProvider>(context);
    String? rolTipoConvertido = rolesMap[widget.tipoOu];

    return Stack(
      children: [
        Column(
          children: [
            Text(
              "Gestionar $rolTipoConvertido",
              style: TextStyle(fontSize: cTitulosSize, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBarCustom(
                controller: searchController,
                onChanged: filterUsers,
                hintext: 'Buscar ${rolTipoConvertido!.toLowerCase()}...',
              ),
            ),
            Expanded(
              child: filteredUsers.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: fetchUsers,
                      child: GridView.builder(
                        controller: _scrollController, // Vincular el ScrollController
                        physics: BouncingScrollPhysics(),
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
                            name: filteredUsers[index].nombre + " " + filteredUsers[index].apellido,
                            email: filteredUsers[index].email,
                            phone: filteredUsers[index].telefono,
                            onUpdate: () {
                              employeeProvider.updateSelectedUserManagement(3);
                              Usuarios user = filteredUsers[index];
                              employeeProvider.updateSelectedUser(user);
                              Get.to(() => MainPanelActualizarUserPage());
                            },
                            onDelete: () async {
                              Usuarios user = filteredUsers[index];
                              employeeProvider.updateSelectedUser(user);
                              _deleteUser(employeeProvider.selectedUser, context);
                            },
                          );
                        },
                      ),
                    )
                  : Center(child: CupertinoActivityIndicator()),
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
