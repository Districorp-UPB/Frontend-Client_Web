import 'package:flutter/material.dart';

class FormularioSelect extends StatefulWidget {
  const FormularioSelect({
    super.key,
    required this.controller,
    required this.texto,
    required this.icono,
    required this.opciones,
    this.permitirSoloNumeros,
    this.maxCaracteres,
    this.enabled, this.errorText, this.errorStyle,
  });

  final String texto;
  final TextEditingController controller;
  final Icon icono;
  final TextInputType? permitirSoloNumeros;
  final int? maxCaracteres;
  final bool? enabled;
  final List<String> opciones;
  final String? errorText;
  final TextStyle? errorStyle;

  @override
  State<FormularioSelect> createState() => _FormularioSelectState();
}

class _FormularioSelectState extends State<FormularioSelect> {
  String? _selectedValue; // Nuevo campo para almacenar el valor seleccionado

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedValue, // Valor seleccionado actualmente
      onChanged: (String? newValue) {
        if (newValue != null) {
          _selectedValue = newValue;
          widget.controller.text =
              newValue; // Actualiza el valor del controller al seleccionar una opción
        }
      },
      items: widget.opciones.map((option) {
        return DropdownMenuItem<String>(
          alignment: Alignment.centerLeft,
          value: option,
          child: Text(
            option,
          ),
        );
      }).toList(),
      decoration: InputDecoration(
          prefixIcon: widget.icono,
          labelText: widget.texto,
          hintText: widget.texto,
          errorText: widget.errorText,
          errorStyle: widget.errorStyle,
          hintStyle: TextStyle(fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
  }
}