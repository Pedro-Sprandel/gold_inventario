import 'package:flutter/material.dart';
import 'package:goldinventory/components/back_button_top_bar.dart';
import 'package:goldinventory/components/users/user_edit_form.dart';
import 'package:goldinventory/services/users.dart';

class UserScreen extends StatelessWidget {
  final UserModel user;

  const UserScreen({super.key, required this.user});

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
            UserEditForm(user: user),
          ],
        ),
      ),
    );
  }
}
