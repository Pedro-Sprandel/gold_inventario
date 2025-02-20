import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, bool success, String? message) {
  if (message == null) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: success
          ? Theme.of(context).colorScheme.onPrimaryContainer
          : Colors.redAccent,
    ),
  );
}
