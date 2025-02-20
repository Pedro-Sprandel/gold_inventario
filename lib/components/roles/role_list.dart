import 'package:flutter/material.dart';
import 'package:goldinventory/components/list_card.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/pages/roles/role_screen.dart';
import 'package:goldinventory/services/roles.dart';

class RoleList extends StatefulWidget {
  const RoleList({super.key});

  @override
  State<RoleList> createState() => RoleListState();
}

class RoleListState extends State<RoleList> {
  List<Role> _roles = [];

  @override
  void initState() {
    super.initState();
    loadRoles();
  }

  void loadRoles() async {
    Response response = await getRoles();

    if (response.success) {
      setState(() {
        _roles = response.data;
      });
    }
  }

  void _onClickRole(Role role) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoleScreen(role: role),
      ),
    ).then(
      (result) {
        if (result == 'completed') {
          loadRoles();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._roles.map(
          (role) => Column(
            children: [
              ListCard(
                onPressed: () => _onClickRole(role),
                child: Text(
                  role.name,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        )
      ],
    );
  }
}
