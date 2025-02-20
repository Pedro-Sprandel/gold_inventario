import 'package:flutter/material.dart';
import 'package:goldinventory/pages/itemTypes/types_screen.dart';
import 'package:goldinventory/pages/locations/locations_screen.dart';
import 'package:goldinventory/pages/roles/roles_screen.dart';
import 'package:goldinventory/pages/status/status_screen.dart';
import 'package:goldinventory/pages/users/users_screen.dart';
import 'package:goldinventory/providers/user_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

Map<String, Widget> pages = {
  'Localidades': LocationsScreen(),
  'Status': StatusScreen(),
  'Tipos de equipamentos': TypesScreen(),
  'Usuários': UsersScreen(),
  'Cargos': RolesScreen(),
};

class Config extends StatefulWidget {
  const Config({super.key});

  @override
  State<Config> createState() => ConfigState();
}

class ConfigState extends State<Config> {
  void _onClickConfigTile(BuildContext context, String label) {
    Widget? page = pages[label];

    if (page == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Padding(
        padding:
            const EdgeInsets.only(top: 18, left: 24, bottom: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            !userProvider.canConfigure()
                ? const Center(
                    child: Text(
                        'Você não tem permissão para alterar configurações do aplicativo.'),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Controle de opções',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ConfigTile(
                          label: 'Localidades', onPressed: _onClickConfigTile),
                      const SizedBox(height: 8),
                      ConfigTile(
                          label: 'Status', onPressed: _onClickConfigTile),
                      const SizedBox(height: 8),
                      ConfigTile(
                        label: 'Tipos de equipamentos',
                        onPressed: _onClickConfigTile,
                      )
                    ],
                  ),
            const SizedBox(height: 24),
            if (userProvider.canControlUsers())
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Permissões',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ConfigTile(label: 'Usuários', onPressed: _onClickConfigTile),
                  const SizedBox(height: 8),
                  ConfigTile(label: 'Cargos', onPressed: _onClickConfigTile)
                ],
              ),
          ],
        ));
  }
}

class ConfigTile extends StatelessWidget {
  final String label;
  final Function(BuildContext, String) onPressed;

  const ConfigTile({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed(context, label);
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        iconColor: Theme.of(context).colorScheme.tertiary,
      ),
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.tertiary),
              ),
              const FaIcon(FontAwesomeIcons.chevronRight, size: 18)
            ],
          ),
        ),
      ),
    );
  }
}
