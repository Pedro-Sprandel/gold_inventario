import 'package:flutter/material.dart';
import 'package:goldinventory/components/back_button_top_bar.dart';
import 'package:goldinventory/components/inventory/change_status_form.dart';
import 'package:goldinventory/services/items.dart';

class ChangeStatusItemScreen extends StatefulWidget {
  const ChangeStatusItemScreen({super.key, required this.item});

  final Item item;

  @override
  State<ChangeStatusItemScreen> createState() => ChangeStatusItemScreenState();
}

class ChangeStatusItemScreenState extends State<ChangeStatusItemScreen> {
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
            ChangeStatusForm(item: widget.item),
          ],
        ),
      ),
    );
  }
}
