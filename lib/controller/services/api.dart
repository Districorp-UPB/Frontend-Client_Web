import 'dart:async';
import 'dart:convert';

import 'package:districorp/controller/services/api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiController {
//Manejador de errores
  void handleLoginError(int statusCode, String errorMsg) {
    switch (statusCode) {
      case 400:
        updateErrorMessages(
          contraError: errorMsg,
        );
        break;
      case 500:
        updateErrorMessages(
          contraError: "Las credenciales son incorrectas!",
        );
        break;
      default:
        // Otros códigos de error
        break;
    }
  }

  void handleRegistrationError(int statusCode, String errorMsg) {
    switch (statusCode) {
      case 400:
        updateErrorMessages(
          emailError: "Ya existe un usuario con este correo.",
        );
        break;
      case 500:
        updateErrorMessages(
          rolError: errorMsg,
        );
        break;
      default:
        // Otros códigos de error
        break;
    }
  }

  final _errorController = StreamController<Map<String, String>>.broadcast();
  Stream<Map<String, String>> get errorStream => _errorController.stream;

  void updateErrorMessages({
    String? emailError,
    String? contraError,
    String? rolError,
    String? documentoError,
  }) {
    Map<String, String> errors = {
      'email': emailError ?? '',
      'contrasenia': contraError ?? '',
      'rol': rolError ?? '',
      'documento': documentoError ?? '',
    };
    _errorController.add(errors);
  }

  void dispose() {
    _errorController.close();
  }

// Metodos de login y inicio de sesion de la app

  // Controladores de texto de Inicio de Sesion y Registro
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController tipoRolController = TextEditingController();

  Future<Map<String, dynamic>> loginDistri() async {
    try {
      Map<String, String> rolesMap = {
        "Administrador": "Admin",
        "Empleado": "Employee",
        "Usuario": "User",
      };

      String? rolTipoConvertido = rolesMap[tipoRolController.text];

      Map<String, String> regBody = {
        "email": emailController.text,
        "password": passwordController.text,
        "ou": rolTipoConvertido!,
      };
      print(regBody);

      print(loginUrl);

      var responseLogin = await http.post(Uri.parse(loginUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponseLog = jsonDecode(responseLogin.body);

      print("Respuesta: ${jsonResponseLog}");
      print("Respuesta Login: ${responseLogin.statusCode}");

      if (responseLogin.statusCode == 200) {
        Map<String, String> respuestaCompleta = {
          "token": jsonResponseLog['token'],
          "rol": rolTipoConvertido,
        };

        return respuestaCompleta;
      } else if (responseLogin.statusCode == 400) {
        handleLoginError(responseLogin.statusCode, jsonResponseLog['error']);
        throw Exception("Error 400");
      } else if (responseLogin.statusCode == 500) {
        handleLoginError(responseLogin.statusCode, jsonResponseLog['error']);
        throw Exception("Error 500");
      } else {
        throw Exception("Error en la : ${responseLogin.statusCode}");
      }
    } catch (e) {
      print("Error en la solicitud: $e");
      return {};
    }
  }

  // Controladores de texto de Inicio de Sesion y Registro
  final TextEditingController nombreNewController = TextEditingController();
  final TextEditingController apellidolNewController = TextEditingController();
  final TextEditingController emailNewController = TextEditingController();
  final TextEditingController phoneNewController = TextEditingController();
  final TextEditingController documentNewController = TextEditingController();
  final TextEditingController passwordNewController = TextEditingController();
  final TextEditingController rolNewController = TextEditingController();

  Future<int?> registrarUsuarioDistri(String token) async {
    try {
      Map<String, String> rolesMap = {
        "Administrador": "Admin",
        "Empleado": "Employee",
        "Usuario": "User",
      };

      String? rolTipoConvertido = rolesMap[rolNewController.text];

      Map<String, dynamic> regBodyActivo = {
        "name": nombreNewController.text,
        "surname": apellidolNewController.text,
        "email": emailNewController.text,
        "phone": phoneNewController.text,
        "document": documentNewController.text,
        "password": passwordNewController.text,
        "ou": rolTipoConvertido,
      };

      print(regBodyActivo);

      print("$registerUserUrl$token");

      var response = await http.post(
        Uri.parse("$registerUserUrl/$token"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(regBodyActivo),
      );

      var jsonRegisterResponse = jsonDecode(response.body);

      print(
          "este es el response $jsonRegisterResponse y el codigo ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Usuario registrado");
        return 200;
      } else if (response.statusCode == 400 &&
          jsonRegisterResponse.containsKey('message')) {
        handleRegistrationError(
            response.statusCode, jsonRegisterResponse['message']);
        throw Exception("Usuario ya existente.");
      } else if (response.statusCode == 400 &&
          jsonRegisterResponse.containsKey('error')) {
        // Si existe 'error', maneja el mensaje de error de la API
        handleRegistrationError(
            response.statusCode, jsonRegisterResponse['error']);
        throw Exception(
            "Error proporcionado por la API: ${jsonRegisterResponse['error']}");
      } else {
        throw Exception("Error desconocido al registrar usuario.");
      }
    } catch (e) {
      print("Error al realizar la peticion: $e");
    }
    return null;
  }

  // Controladores de texto de Actualizar Usuario por parte del Administrador
  final TextEditingController nombreActualizarController =
      TextEditingController();
  final TextEditingController apellidolActualizarController =
      TextEditingController();
  final TextEditingController emailActualizarController =
      TextEditingController();
  final TextEditingController phoneActualizarController =
      TextEditingController();
  final TextEditingController documentActualizarController =
      TextEditingController();
  final TextEditingController rolActualizarController = TextEditingController();

  Future<int?> actualizarUsuarioDistri(String token) async {
    try {
      Map<String, dynamic> regBodyActivo = {
        "name": nombreActualizarController.text,
        "surname": apellidolActualizarController.text,
        "email": emailActualizarController.text,
        "phone": phoneActualizarController.text,
        "document": documentActualizarController.text,
        "ou": rolActualizarController.text,
      };

      print(regBodyActivo);

      var response = await http.post(
        Uri.parse("$actualizarProfileUrl/$token"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(regBodyActivo),
      );

      var jsonRegisterResponse = jsonDecode(response.body);

      print(
          "este es el response $jsonRegisterResponse y el codigo ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Usuario actualizado");
        return 200;
      } else if (response.statusCode == 400 &&
          jsonRegisterResponse.containsKey('message')) {
        handleRegistrationError(
            response.statusCode, jsonRegisterResponse['message']);
        throw Exception("Usuario ya existente.");
      } else if (response.statusCode == 400 &&
          jsonRegisterResponse.containsKey('error')) {
        // Si existe 'error', maneja el mensaje de error de la API
        handleRegistrationError(
            response.statusCode, jsonRegisterResponse['error']);
        throw Exception(
            "Error proporcionado por la API: ${jsonRegisterResponse['error']}");
      } else {
        throw Exception("Error desconocido al actualizar usuario.");
      }
    } catch (e) {
      print("Error al realizar la peticion: $e");
    }
    return null;
  }

  // Obtener lista Usuarios
  Future<Map<String, dynamic>> obtenerUsuariosDistri(
      String rol, String token) async {
    try {
      var response = await http.post(
        Uri.parse("$obtenerUserUrl/$rol/$token"),
        headers: {
          "Content-Type": "application/json",
        },
      );

      var jsonRegisterResponse = jsonDecode(response.body);

      print(
          "este es el response $jsonRegisterResponse y el codigo ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Usuario obtenidos");
        return jsonRegisterResponse;
      } else {
        throw Exception("Error desconocido al obtener usuarios.");
      }
    } catch (e) {
      print("Error al realizar la peticion: $e");
    }
    return {};
  }

  //Eliminar un usuario por parte del admin
  Future<int?> eliminarUsuariosDistri(
      String email, String rol, String token) async {
    try {
      Map<String, dynamic> regBody = {
        "email": email,
        "ou": rol,
      };

      var response = await http.post(Uri.parse("$eliminarUserUrl/$token"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(regBody));

      var jsonRegisterResponse = jsonDecode(response.body);

      print(
          "este es el response $jsonRegisterResponse y el codigo ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Usuario Eliminado");
        return jsonRegisterResponse;
      } else {
        throw Exception("Error desconocido al obtener usuarios.");
      }
    } catch (e) {
      print("Error al realizar la peticion: $e");
    }
    return null;
  }


  /// APARTADO DEL EMPLEADO

  // Obtener Datos Personales de un empleado
  Future<Map<String, dynamic>> obtenerDatosPersonalesDistri(
      String email) async {
    try {
      var response = await http.get(
        Uri.parse("$obtenerDatosPersonalesUrl/$email"),
        headers: {
          "Content-Type": "application/json",
        },
      );

      var jsonRegisterResponse = jsonDecode(response.body);

      print(
          "este es el response $jsonRegisterResponse y el codigo ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Datos Personales Obtenidos");
        return jsonRegisterResponse['usuario'];
      } else {
        throw Exception("Error desconocido al obtener datos personales.");
      }
    } catch (e) {
      print("Error al realizar la peticion: $e");
    }
    return {};
  }

  final TextEditingController nombrePerfilController =
      TextEditingController();
  final TextEditingController apellidolPerfilController =
      TextEditingController();
  final TextEditingController emailPerfilController =
      TextEditingController();
  final TextEditingController phonePerfilController =
      TextEditingController();
  final TextEditingController documentPerfilController =
      TextEditingController();
  final TextEditingController rolPerfilController = TextEditingController();

  Future<int?> actualizarPerfilEmpleadoDistri(String token) async {
    try {
      Map<String, dynamic> regBodyActivo = {
        "name": nombrePerfilController.text,
        "surname": apellidolPerfilController.text,
        "email": emailPerfilController.text,
        "phone": phonePerfilController.text,
        "document": documentPerfilController.text,
        "ou": rolPerfilController.text,
      };

      print(regBodyActivo);

      var response = await http.post(
        Uri.parse("$actualizarProfileUrl/$token"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(regBodyActivo),
      );

      var jsonRegisterResponse = jsonDecode(response.body);

      print(
          "este es el response $jsonRegisterResponse y el codigo ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Usuario actualizado");
        return 200;
      } else if (response.statusCode == 400 &&
          jsonRegisterResponse.containsKey('message')) {
        handleRegistrationError(
            response.statusCode, jsonRegisterResponse['message']);
        throw Exception("Usuario ya existente.");
      } else if (response.statusCode == 400 &&
          jsonRegisterResponse.containsKey('error')) {
        // Si existe 'error', maneja el mensaje de error de la API
        handleRegistrationError(
            response.statusCode, jsonRegisterResponse['error']);
        throw Exception(
            "Error proporcionado por la API: ${jsonRegisterResponse['error']}");
      } else {
        throw Exception("Error desconocido al actualizar usuario.");
      }
    } catch (e) {
      print("Error al realizar la peticion: $e");
    }
    return null;
  }






}
