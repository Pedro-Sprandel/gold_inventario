import 'package:flutter/material.dart';
import 'package:goldinventory/services/roles.dart';

class RoleSelect extends StatefulWidget {
  const RoleSelect({
    super.key,
    required this.options,
    required this.value,
    required this.onSelect,
  });

  final List<Role> options;
  final Role? value;
  final Function(Role) onSelect;

  @override
  State<RoleSelect> createState() => _SelectState();
}

class _SelectState extends State<RoleSelect> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
          labelText: 'Cargo*',
          border: const OutlineInputBorder(),
          labelStyle: const TextStyle(color: Color.fromARGB(255, 12, 12, 12)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.tertiary))),
      hint: const Text('Selecione o cargo',
          style: TextStyle(color: Colors.black)),
      focusColor: Colors.transparent,
      isExpanded: false,
      value: widget.value?.name,
      items: widget.options.map((role) {
        return DropdownMenuItem(
          value: role.name,
          child: Text(role.name),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null && value.isNotEmpty) {
          widget.onSelect(widget.options.firstWhere((e) => e.name == value));
        }
      },
      validator: (value) {
        if (value == null) {
          return 'Campo obrigatório';
        }
        return null;
      },
    );
  }
}
