import 'package:flutter/material.dart';
import 'package:goldinventory/components/input.dart';
import 'package:goldinventory/components/status/color_picker.dart';
import 'package:goldinventory/components/status/status_registration_form.dart';
import 'package:goldinventory/components/status/status_tag.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/services/status.dart';
import 'package:goldinventory/utils/snack_bar.dart';

class StatusEditForm extends StatefulWidget {
  final Status status;

  const StatusEditForm({super.key, required this.status});

  @override
  StatusEditFormState createState() => StatusEditFormState();
}

class StatusEditFormState extends State<StatusEditForm> {
  final TextEditingController _nameController = TextEditingController();
  late Color _selectedColor;
  late Color _selectedTextColor;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.status.name;
    _selectedColor = Color(widget.status.backgroundColor);
    _selectedTextColor = Color(widget.status.textColor);
  }

  void _onChangeColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  void _onChangeTextColor(Color color) {
    setState(() {
      _selectedTextColor = color;
    });
  }

  void _submitForm(
    BuildContext context,
    String name,
    Color backgroundColor,
    Color textColor,
  ) async {
    Response response = await updateStatus(Status(
      id: widget.status.id,
      name: name,
      backgroundColor: backgroundColor.value,
      textColor: textColor.value,
    ));

    if (!context.mounted) return;

    showSnackbar(context, response.success, response.message);

    if (response.success) {
      Navigator.pop(context, 'completed');
    }
  }

  void _onDeleteRole(context) async {
    Response response = await deleteStatus(widget.status.id);

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
          content:
              const Text('Você tem certeza de que deseja excluir este status?'),
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
                _onDeleteRole(context);
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Input(
          label: 'Nome',
          controller: _nameController,
          onChanged: (value) => setState(() => {}),
          maxLength: 16,
        ),
        const SizedBox(height: 12),
        ColorPicker(
          label: 'Cor de fundo',
          colors: colors,
          selectedColor: _selectedColor,
          onChangeColor: _onChangeColor,
        ),
        ColorPicker(
          label: 'Cor do texto',
          colors: const [Colors.white, Colors.black],
          selectedColor: _selectedTextColor,
          onChangeColor: _onChangeTextColor,
        ),
        const SizedBox(height: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Preview'),
            StatusTag(
              text: _nameController.text,
              backgroundColor: _selectedColor,
              textColor: _selectedTextColor,
            )
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: TextButton(
            onPressed: () => _submitForm(
              context,
              _nameController.text,
              _selectedColor,
              _selectedTextColor,
            ),
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 255, 8),
              side: const BorderSide(width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              'Salvar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 12, 12, 12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: TextButton(
            onPressed: () =>
                showDeleteConfirmationDialog(context, widget.status.id),
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              side: const BorderSide(width: 2, color: Colors.redAccent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              'Deletar status',
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
