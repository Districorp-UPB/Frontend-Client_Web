import 'package:districorp/screen/admin/widgets/AdminUserManagement_page.dart';
import 'package:districorp/screen/admin/widgets/add_user.dart';
import 'package:districorp/screen/admin/Panel_principal_admin.dart';
import 'package:flutter/material.dart';

class MainPanelAdminEmployeePage extends StatelessWidget {
  const MainPanelAdminEmployeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainPanelPage(
      child: AdminUserManagementPage(tipoOu: "Employee"),
      
    );
  }
}