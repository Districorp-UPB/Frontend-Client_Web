import 'package:districorp/constant/sizes.dart';
import 'package:districorp/screen/admin/widgets/add_user.dart';
import 'package:districorp/screen/admin/widgets/update_user.dart';
import 'package:districorp/screen/admin/Panel_principal_admin.dart';
import 'package:flutter/material.dart';

class MainPanelActualizarUserPage extends StatelessWidget {
  final String email;
  const MainPanelActualizarUserPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return MainPanelPage(
      child: Column(
        children: [
          Text(
              "Actualizar Usuarios",
              style: TextStyle(fontSize: cTitulosSize, fontWeight: FontWeight.bold),
            ),
          UpdateUserPage(email: email,),
        ],
      ),
      
    );
  }
}