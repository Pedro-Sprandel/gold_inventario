import 'package:flutter/material.dart';
import 'package:goldinventory/components/status/status_tag.dart';
import 'package:goldinventory/services/status.dart';

class StatusSelect extends StatelessWidget {
  const StatusSelect({
    super.key,
    required this.options,
    required this.value,
    required this.onSelect,
  });

  final List<Status> options;
  final Status? value;
  final Function(Status) onSelect;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: -20),
          labelText: 'Status',
          border: const OutlineInputBorder(),
          labelStyle: const TextStyle(color: Color.fromARGB(255, 12, 12, 12)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.tertiary))),
      hint: const Text('Selecione o status',
          style: TextStyle(color: Colors.black)),
      focusColor: Colors.transparent,
      isExpanded: false,
      value: value?.name,
      items: options.map((status) {
        return DropdownMenuItem(
          value: status.name,
          child: StatusTag(
              text: status.name,
              backgroundColor: Color(status.backgroundColor),
              textColor: Color(status.textColor)),
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
