import 'package:flutter/material.dart';
import 'package:goldinventory/components/button.dart';
import 'package:goldinventory/components/input.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/services/locations.dart';
import 'package:goldinventory/utils/snack_bar.dart';

class NewLocationForm extends StatelessWidget {
  NewLocationForm({super.key});
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  void _onClickAdd(BuildContext context, String name) async {
    if (_formKey.currentState?.validate() != true) return;

    Response response = await addLocation(name);

    if (!context.mounted) return;

    showSnackbar(context, response.success, response.message);

    if (response.success) {
      Navigator.pop(context, 'completed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Input(
            label: 'Nome',
            controller: _nameController,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          Button(
              text: 'Adicionar',
              color: const Color.fromARGB(255, 255, 255, 8),
              onPressed: (context) =>
                  _onClickAdd(context, _nameController.text))
        ],
      ),
    );
  }
}
