import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool isRequired;
  final bool showCopy;
  final bool isObscure;

  const PasswordInput({
    super.key,
    required this.controller,
    this.labelText = "Senha",
    this.hintText = "Insira a senha escolhida",
    this.isRequired = false,
    this.showCopy = false,
    this.isObscure = true
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _isObscured = false;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isObscure;
  }

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  void _copyPassword(value) async {
    await Clipboard.setData(ClipboardData(text: value));
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,
      cursorColor: Theme.of(context).colorScheme.tertiary,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary)),
        labelText: widget.labelText,
        hintText: widget.hintText,
        suffixIcon: widget.showCopy ? IconButton(
          onPressed: () => widget.controller?.text != null ? _copyPassword(widget.controller?.text ?? "") : null,
          icon: const FaIcon(
            size: 18,
            FontAwesomeIcons.copy,
          ),
        ) 
        : IconButton(
          onPressed: _toggleVisibility,
          icon: FaIcon(
            size: 18,
            _isObscured ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (widget.isRequired && (value == null || value.isEmpty)) {
          return 'Campo obrigatório';
        }
        return null;
      },
    );
  }
}