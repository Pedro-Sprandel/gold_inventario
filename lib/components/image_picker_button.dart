import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ImagePickerButton extends StatelessWidget {
  const ImagePickerButton({
    super.key,
    this.image,
    this.fileName,
    required this.onPressed,
  });

  final File? image;
  final String? fileName;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          children: [
            fileName != null
                ? Text(fileName ?? "",
                    style: const TextStyle(color: Colors.black))
                : const Text(
                    'Selecione uma imagem',
                    style: TextStyle(color: Colors.black),
                  ),
            const SizedBox(width: 12),
            const FaIcon(
              FontAwesomeIcons.upload,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
