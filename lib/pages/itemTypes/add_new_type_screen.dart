import 'package:flutter/material.dart';
import 'package:goldinventory/components/back_button_top_bar.dart';
import 'package:goldinventory/components/itemTypes/type_registration_form.dart';

class AddNewTypeScreen extends StatelessWidget {
  const AddNewTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const Padding(
        padding: EdgeInsets.only(top: 60, left: 24, bottom: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackButtonTopBar(),
            SizedBox(height: 24),
            TypeRegistrationForm()
          ],
        ),
      ),
    );
  }
}
