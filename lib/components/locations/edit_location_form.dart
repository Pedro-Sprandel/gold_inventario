import 'package:flutter/material.dart';
import 'package:goldinventory/components/button.dart';
import 'package:goldinventory/components/input.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/services/locations.dart';
import 'package:goldinventory/utils/snack_bar.dart';

class EditLocationForm extends StatefulWidget {
  final Location location;

  const EditLocationForm({
    super.key,
    required this.location,
  });

  @override
  State<EditLocationForm> createState() => EditLocationFormState();
}

class EditLocationFormState extends State<EditLocationForm> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.location.name;
  }

  void _onClickUpdateType(BuildContext context, String name) async {
    Response response = await updateLocation(
      Location(id: widget.location.id, name: name),
    );

    if (!context.mounted) return;

    showSnackbar(context, response.success, response.message);

    if (response.success) {
      Navigator.pop(context, 'completed');
    }
  }

  void _onDeleteLocation(BuildContext context, String uid) async {
    Response response = await deleteLocation(uid);

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
              'Você tem certeza de que deseja excluir esta localidade?'),
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
                _onDeleteLocation(context, uid);
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
    return Column(
      children: [
        Input(label: 'Nome', controller: _nameController),
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
                showDeleteConfirmationDialog(context, widget.location.id),
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              side: const BorderSide(width: 2, color: Colors.redAccent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              'Deletar localidade',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }
}
