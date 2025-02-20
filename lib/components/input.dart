import 'package:flutter/material.dart';
import 'package:goldinventory/utils/formatters.dart';

class Input extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isEmail;
  final bool isPhone;
  final bool isRequired;
  final ValueChanged<String>? onChanged;
  final int? maxLength;

  const Input({
    super.key,
    required this.label,
    required this.controller,
    this.isEmail = false,
    this.isPhone = false,
    this.isRequired = false,
    this.onChanged,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      cursorColor: const Color.fromARGB(255, 58, 57, 57),
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 12, 12, 12)),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
        ),
      ),
      keyboardType: isEmail ? TextInputType.emailAddress : null,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'Campo obrigatório';
        } else if (isPhone &&
            isRequired &&
            value != null &&
            value.length < 15) {
          return 'Número de telefone inválido';
        }
        return null;
      },
      inputFormatters: isPhone ? [phoneMask] : [],
    );
  }
}
