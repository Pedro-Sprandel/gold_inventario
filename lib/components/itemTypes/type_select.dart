import 'package:flutter/material.dart';
import 'package:goldinventory/services/types.dart';

class TypesSelect extends StatelessWidget {
  const TypesSelect({
    super.key,
    required this.options,
    required this.value,
    required this.onSelect,
  });

  final List<ItemType> options;
  final ItemType? value;
  final Function(ItemType) onSelect;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
          labelText: 'Tipo de equipamento',
          border: const OutlineInputBorder(),
          labelStyle: const TextStyle(color: Color.fromARGB(255, 12, 12, 12)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.tertiary))),
      hint:
          const Text('Selecione o tipo', style: TextStyle(color: Colors.black)),
      focusColor: Colors.transparent,
      isExpanded: false,
      value: value?.name,
      items: options.map((role) {
        return DropdownMenuItem(
          value: role.name,
          child: Text(role.name),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null && value.isNotEmpty) {
          onSelect(options.firstWhere((e) => e.name == value));
        }
      },
    );
  }
}
