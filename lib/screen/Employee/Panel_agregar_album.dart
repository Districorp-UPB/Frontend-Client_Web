
import 'package:districorp/screen/Employee/Panel_principal_empleado.dart';
import 'package:districorp/screen/Employee/widgets/add_album_empleado.dart';
import 'package:districorp/screen/Employee/widgets/album_page_empleado.dart';

import 'package:flutter/material.dart';

class EmployeeAddAlbumPanelPage extends StatelessWidget {
  const EmployeeAddAlbumPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EmployeePanelPage(
      child: AddAlbumEmpleado(),
      
    );
  }
}