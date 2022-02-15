import 'package:flutter/material.dart';

class EntradaTexto extends StatelessWidget {

  String hint;
  bool obscure;
  TextInputType inputType;
  Function(String) onChanged;

  EntradaTexto({Key? key, required this.hint, this.obscure = false, required this.onChanged, required this.inputType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      obscureText: obscure,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: hint,
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

}