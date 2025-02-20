import 'package:flutter/material.dart';
import 'package:goldinventory/components/button.dart';
import 'package:goldinventory/components/input.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/services/types.dart';
import 'package:goldinventory/utils/snack_bar.dart';

class TypeRegistrationForm extends StatefulWidget {
  const TypeRegistrationForm({super.key});

  @override
  TypeRegistrationFormState createState() => TypeRegistrationFormState();
}

class TypeRegistrationFormState extends State<TypeRegistrationForm> {
  final TextEditingController _nameController = TextEditingController();

  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  void _onClickAddNewType(BuildContext context, String name) async {
    if (_formKey.currentState?.validate() != true) return;

    Response response = await addNewType(name);

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
          isLoading
              ? const CircularProgressIndicator()
              : Button(
                  text: 'Salvar',
                  color: const Color.fromARGB(255, 255, 255, 8),
                  onPressed: (context) => {
                    setState(() {
                      isLoading = true;
                    }),
                    _onClickAddNewType(
                      context,
                      _nameController.text,
                    ),
                    setState(() {
                      isLoading = false;
                    }),
                  },
                )
        ],
      ),
    );
  }
}
