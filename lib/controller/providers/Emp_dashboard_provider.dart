import 'package:districorp/models/profile_models.dart';
import 'package:districorp/models/usuarios_models.dart';
import 'package:districorp/screen/Employee/widgets/album_page_empleado.dart';
import 'package:districorp/screen/Employee/widgets/files_page_empleado.dart';
import 'package:districorp/screen/Employee/widgets/home_page_empleado.dart';
import 'package:districorp/screen/Employee/widgets/perfil_page_empleado.dart';
import 'package:districorp/screen/Employee/widgets/streaming_page_empleado.dart';
import 'package:districorp/screen/admin/widgets/AdminUserManagement_page.dart';
import 'package:districorp/screen/admin/widgets/add_user.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter/material.dart';

class EmpDashboardProvider extends ChangeNotifier {
  // Index para manejo de select en la gestion de Users
  int _selectedUserManagement = 0;

  int get selectedUserManagement => _selectedUserManagement;

  void updateSelectedUserManagement(int index) {
    _selectedUserManagement = index;
    notifyListeners();
  }

  // Index para manejo de vistas en el dashboard de Employee
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  // Método para actualizar el índice desde la URL
  void updateIndexFromUrl(String path) {
    if (path.contains('/MainPanelUserPage')) {
      _selectedUserManagement = 0; // Gestión de Usuarios
    } else if (path.contains('/MainPanelEmployeePage')) {
      _selectedUserManagement = 1; // Aceptar Usuarios
    } else if (path.contains('/MainPanelAddUserPage')) {
      _selectedUserManagement = 2; // Agregar Usuarios
    } else if (path.contains('/MainPanelActualizarUserPage')) {
      _selectedUserManagement = 3; // Actualizar Usuarios
    } else if (path.contains('/EmployeePanelPage')) {
      _selectedIndex = 0; // Panel Empleado
    } else if (path.contains('/EmployeeProfilePanelPage')) {
      _selectedIndex = 1; // Actualizar Perfil
    } else if (path.contains('/EmployeeStreamingPanelPage')) {
      _selectedIndex = 2; // Gestionar Streaming
    } else if (path.contains('/EmployeeAlbumPanelPage')) {
      _selectedIndex = 3; // Gestionar Album
    } else if (path.contains('/EmployeeAddAlbumPanelPage')) {
      _selectedIndex = 3; // Gestionar Album
    } else if (path.contains('/EmployeeFilesPanelPage')) {
      _selectedIndex = 4; // Gestionar Files
    } else if (path.contains('/EmployeeAddFilePanelPage')) {
      _selectedIndex = 4; // Gestionar Files
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Modelo para Usuarios
  late Usuarios _selectedUser;

  Usuarios get selectedUser => _selectedUser;

  void updateSelectedUser(Usuarios user) {
    _selectedUser = user;
    notifyListeners();
  }

  // Modelo para los datos personales
  late Profiles _selectedProfile;

  Profiles get selectedProfiles => _selectedProfile;

  void updateSelectedProfile(Profiles profile) {
    _selectedProfile = profile;
    notifyListeners();
  }

  // Aseguramos que notifyListeners se ejecute después de la construcción del widget

  Widget getSelectedUserPage() {
    switch (_selectedUserManagement) {
      case 0:
        return AdminUserManagementPage(
          tipoOu: 'User',
        );
      case 1:
        return EmployeeHome();
      case 2:
        return AddUserPage();

      default:
        return Container();
    }
  }

  Widget getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return EmployeeHome();
      case 1:
        return EmployeeProfile();
      case 2:
        return EmployeeStreaming();
      case 3:
        return EmployeeAlbum();
      case 4:
        return EmployeeFiles();

      default:
        return Container();
    }
  }

  String getUserTitle(int index) {
    switch (index) {
      case 0:
        return "Bienvenido @Admin";
      case 1:
        return "Bienvenido @Admin";
      case 2:
        return "Agregar Usuario";
      case 3:
        return "Actualizar Usuario";

      default:
        return "";
    }
  }

  String getTitle(int index) {
    switch (index) {
      case 0:
        return "Employee Home";
      case 1:
        return "Employee Profile";
      case 2:
        return "Employee Streaming";
      case 3:
        return "Employee Album";
      case 4:
        return "Employee Files";

      default:
        return "";
    }
  }
}
