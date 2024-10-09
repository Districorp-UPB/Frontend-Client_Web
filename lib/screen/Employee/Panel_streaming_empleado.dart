import 'package:districorp/screen/Employee/Panel_principal_empleado.dart';
import 'package:districorp/screen/Employee/widgets/streaming_page_empleado.dart';
import 'package:districorp/screen/admin/widgets/add_user.dart';
import 'package:districorp/screen/admin/Panel_principal_admin.dart';
import 'package:flutter/material.dart';

class EmployeeStreamingPanelPage extends StatelessWidget {
  const EmployeeStreamingPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EmployeePanelPage(
      child: EmployeeStreaming(),
      
    );
  }
}