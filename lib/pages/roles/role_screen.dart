import 'package:flutter/material.dart';
import 'package:goldinventory/components/back_button_top_bar.dart';
import 'package:goldinventory/components/roles/role_edit_form.dart';
import 'package:goldinventory/services/roles.dart';

class RoleScreen extends StatelessWidget {
  final Role role;

  const RoleScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 60, left: 24, bottom: 24, right: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackButtonTopBar(),
              const SizedBox(height: 24),
              RoleEditForm(role: role)
            ],
          ),
        ),
      ),
    );
  }
}
