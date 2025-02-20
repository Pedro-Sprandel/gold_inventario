import 'package:flutter/material.dart';
import 'package:goldinventory/components/input.dart';
import 'package:goldinventory/components/status/color_picker.dart';
import 'package:goldinventory/components/status/status_tag.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/services/status.dart';
import 'package:goldinventory/utils/snack_bar.dart';

List<Color> colors = [
  Colors.white,
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.purple,
  Colors.black,
];

class StatusRegistrationForm extends StatefulWidget {
  const StatusRegistrationForm({super.key});

  @override
  State<StatusRegistrationForm> createState() => StatusRegistrationFormState();
}

class StatusRegistrationFormState extends State<StatusRegistrationForm> {
  final TextEditingController _nameController = TextEditingController();
  Color _selectedColor = Colors.green;
  Color _selectedTextColor = Colors.white;

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
    Response response = await addStatus(Status(
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
      ],
    );
  }
}
