import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BackButtonTopBar extends StatelessWidget {
  const BackButtonTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context, 'completed'),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FaIcon(FontAwesomeIcons.arrowLeft, size: 16, color: Theme.of(context).colorScheme.tertiary),
          const SizedBox(width: 4),
          Text('Voltar', style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.tertiary))
        ]
      )
    );
  }
}