
import 'package:districorp/screen/Employee/Panel_principal_empleado.dart';
import 'package:districorp/screen/Employee/widgets/add_file_empleado.dart';

import 'package:flutter/material.dart';

class EmployeeAddFilePanelPage extends StatelessWidget {
  const EmployeeAddFilePanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EmployeePanelPage(
      child: AddFileEmpleado(),
      
    );
  }
}