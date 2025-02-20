import 'package:flutter/material.dart';
import 'package:goldinventory/components/back_button_top_bar.dart';
import 'package:goldinventory/components/itemTypes/type_edit_form.dart';
import 'package:goldinventory/services/types.dart';

class TypeEditScreen extends StatelessWidget {
  final ItemType type;

  const TypeEditScreen({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 60, left: 24, bottom: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BackButtonTopBar(),
            const SizedBox(height: 24),
            TypeEditForm(type: type),
          ],
        ),
      ),
    );
  }
}
