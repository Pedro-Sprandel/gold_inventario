import 'package:flutter/material.dart';
import 'package:goldinventory/components/button.dart';
import 'package:goldinventory/components/input.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/services/types.dart';
import 'package:goldinventory/utils/snack_bar.dart';

class TypeEditForm extends StatefulWidget {
  final ItemType type;

  const TypeEditForm({
    super.key,
    required this.type,
  });

  @override
  State<TypeEditForm> createState() => TypeEditFormState();
}

class TypeEditFormState extends State<TypeEditForm> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.type.name;
  }

  void _onClickUpdateType(BuildContext context, String name) async {
    if (_formKey.currentState?.validate() != true) return;

    ItemType updatedData = ItemType(id: widget.type.id, name: name);

    Response response = await updateType(updatedData);

    if (!context.mounted) return;

    showSnackbar(context, response.success, response.message);

    if (response.success) {
      Navigator.pop(context, 'completed');
    }
  }

  void _onDeleteRole(BuildContext context, String uid) async {
    Response response = await deleteType(uid);

    if (!context.mounted) return;

    showSnackbar(context, response.success, response.message);

    Navigator.pop(context);

    if (response.success) {
      Navigator.pop(context, 'completed');
    }
  }

  void showDeleteConfirmationDialog(BuildContext context, String uid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: const Text(
              'Você tem certeza de que deseja excluir este tipo de equipamento?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: Colors.transparent),
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                _onDeleteRole(context, uid);
              },
              style: TextButton.styleFrom(backgroundColor: Colors.redAccent),
              child:
                  const Text('Excluir', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
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
            text: 'Salvar',
            color: const Color.fromARGB(255, 255, 255, 8),
            onPressed: (context) =>
                _onClickUpdateType(context, _nameController.text),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: TextButton(
              onPressed: () =>
                  showDeleteConfirmationDialog(context, widget.type.id),
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: const BorderSide(width: 2, color: Colors.redAccent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text(
                'Deletar tipo',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
