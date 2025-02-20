import 'package:flutter/material.dart';
import 'package:goldinventory/services/types.dart';

class FilterTypeSelect extends StatelessWidget {
  const FilterTypeSelect({
    super.key,
    required this.value,
    required this.onSelect,
    required this.options,
  });

  final ItemType? value;
  final List<ItemType> options;
  final Function(ItemType) onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 28,
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          fillColor: Color.fromARGB(255, 205, 206, 209),
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          contentPadding: EdgeInsets.only(left: 8),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
        hint: const Text(
          'Tipo',
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
        focusColor: Colors.transparent,
        isExpanded: true,
        value: value?.name,
        items: options.map((status) {
          return DropdownMenuItem(
            value: status.name,
            child: Text(
              overflow: TextOverflow.visible,
              status.name,
              maxLines: 1,
              style: const TextStyle(fontSize: 12),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null && value.isNotEmpty) {
            onSelect(options.firstWhere((e) => e.name == value));
          }
        },
      ),
    );
  }
}
