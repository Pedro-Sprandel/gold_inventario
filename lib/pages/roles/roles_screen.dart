import 'package:flutter/material.dart';
import 'package:goldinventory/components/back_button_top_bar.dart';
import 'package:goldinventory/components/roles/role_list.dart';
import 'package:goldinventory/pages/roles/sign_new_role_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RolesScreen extends StatelessWidget {
  RolesScreen({super.key});

  final GlobalKey<RoleListState> _rolesListKey = GlobalKey<RoleListState>();

  void _onClickSignNewRole(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignNewRoleScreen()),
    ).then(
      (result) => {
        if (result == 'completed') {_rolesListKey.currentState?.loadRoles()}
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
                const Text('Cargos', style: TextStyle(fontSize: 20)),
                TextButton(
                    onPressed: () => _onClickSignNewRole(context),
                    style: TextButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cadastrar novo cargo',
                            style: TextStyle(color: Colors.white)),
                        SizedBox(width: 8),
                        FaIcon(
                          FontAwesomeIcons.plus,
                          color: Colors.white,
                          size: 16,
                        )
                      ],
                    ))
              ]),
              const SizedBox(height: 12),
              RoleList(key: _rolesListKey)
            ],
          ),
        ),
      ),
    );
  }
}
