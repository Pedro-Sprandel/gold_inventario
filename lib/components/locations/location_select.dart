import 'package:flutter/material.dart';
import 'package:goldinventory/services/locations.dart';

class LocationSelect extends StatelessWidget {
  const LocationSelect({
    super.key,
    required this.options,
    required this.value,
    required this.onSelect,
  });

  final List<Location> options;
  final Location? value;
  final Function(Location) onSelect;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
          labelText: 'Localidade',
          border: const OutlineInputBorder(),
          labelStyle: const TextStyle(color: Color.fromARGB(255, 12, 12, 12)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.tertiary))),
      hint: const Text('Selecione o localidade',
          style: TextStyle(color: Colors.black)),
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
