import 'package:flutter/material.dart';
import 'package:goldinventory/components/back_button_top_bar.dart';
import 'package:goldinventory/components/users/user_list.dart';
import 'package:goldinventory/pages/users/sign_new_user_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UsersScreen extends StatelessWidget {
  UsersScreen({super.key});

  final GlobalKey<UserListState> _userListKey = GlobalKey<UserListState>();

  void _onClickSignNewUser(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignNewUserScreen()),
    ).then(
      (result) => {
        if (result == 'completed') {_userListKey.currentState?.loadUsers()}
      },
    );
  }

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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Usuários', style: TextStyle(fontSize: 20)),
                TextButton(
                    onPressed: () => _onClickSignNewUser(context),
                    style: TextButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cadastrar novo usuário',
                            style: TextStyle(color: Colors.white)),
                        SizedBox(width: 8),
                        FaIcon(FontAwesomeIcons.plus,
                            color: Colors.white, size: 16)
                      ],
                    ))
              ]),
              const SizedBox(height: 12),
              UserList(key: _userListKey)
            ],
          ),
        ),
      ),
    );
  }
}
