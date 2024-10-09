import 'package:districorp/constant/sizes.dart';
import 'package:districorp/screen/admin/widgets/add_user.dart';
import 'package:districorp/screen/admin/Panel_principal_admin.dart';
import 'package:flutter/material.dart';

class MainPanelAddUserPage extends StatefulWidget {
  const MainPanelAddUserPage({super.key});

  @override
  State<MainPanelAddUserPage> createState() => _MainPanelAddUserPageState();
}

class _MainPanelAddUserPageState extends State<MainPanelAddUserPage> {
  @override
  Widget build(BuildContext context) {
    return MainPanelPage(
      child: Column(
        children: [
          Text(
              "Añadir Usuarios",
              style: TextStyle(fontSize: cTitulosSize, fontWeight: FontWeight.bold),
            ),
          AddUserPage(),
        ],
      ),
      
    );
  }
}