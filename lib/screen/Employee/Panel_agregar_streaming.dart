
import 'package:districorp/screen/Employee/Panel_principal_empleado.dart';

import 'package:districorp/screen/Employee/widgets/add_streaming_empleado.dart';

import 'package:flutter/material.dart';

class EmployeeAddStreamingPanelPage extends StatelessWidget {
  const EmployeeAddStreamingPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EmployeePanelPage(
      child: AddStreamingEmpleado(),
      
    );
  }
}