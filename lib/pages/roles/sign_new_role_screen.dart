import 'package:flutter/material.dart';
import 'package:goldinventory/components/back_button_top_bar.dart';
import 'package:goldinventory/components/roles/role_registration_form.dart';

class SignNewRoleScreen extends StatelessWidget {
  const SignNewRoleScreen({super.key});

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
            RoleRegistrationForm()
          ],
        ),
      ),
    );
  }
}
