import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;
  final String? errorText;
  final TextStyle? errorStyle;
  final bool? enabled;

  const CustomInput({
    super.key,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    required this.controller, this.errorText, this.errorStyle, this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        errorText: errorText,
        errorStyle: errorStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      enabled: enabled,
    );
  }
}
