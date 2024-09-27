import 'package:flutter/material.dart';
import '../widgets/gradient_appbar.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      bool success = await ApiService.login(email, password);
      if (success) {
        // para manejar en caso de login exitoso
        print("Login Exitoso");
      } else {
        // para manejar  errrores de login
        print("Login Fallido");
      }
    } else {
      print("Por favor ingresa todos los campos");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const GradientAppBar(
        implyLeading: false,
        title: 'Bienvenido',
        titleColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo_3.png',
                  height: 130,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                CustomInput(
                  hintText: 'Correo Electrónico',
                  icon: Icons.email,
                  controller: _emailController,
                ),
                const SizedBox(height: 20),
                CustomInput(
                  hintText: 'Contraseña',
                  icon: Icons.lock,
                  isPassword: true,
                  controller: _passwordController,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Iniciar Sesión',
                    onPressed: _login,
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
