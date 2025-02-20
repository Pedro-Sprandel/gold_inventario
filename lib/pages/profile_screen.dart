import 'package:flutter/material.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/providers/user_provider.dart';
import 'package:goldinventory/services/auth.dart';
import 'package:goldinventory/services/roles.dart';
import 'package:goldinventory/services/users.dart';
import 'package:goldinventory/utils/snack_bar.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  UserModel? user;
  Role? userRole;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (user == null && userProvider.user != null) {
      setState(() {
        user = userProvider.user;
      });

      if (userProvider.user?.role != null) {
        loadUserRole(userProvider.user!.role.id);
      }
    }
  }

  void loadUserRole(String roleId) async {
    Response response = await getRoleById(roleId);

    if (response.success) {
      setState(() {
        userRole = response.data;
      });
    } else if (mounted) {
      showSnackbar(context, false, response.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return user != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FieldTile(label: 'Nome', value: user!.name),
              const SizedBox(height: 16),
              FieldTile(label: 'Telefone', value: user!.phone),
              const SizedBox(height: 16),
              FieldTile(label: 'E-mail', value: user!.email),
              const SizedBox(height: 16),
              FieldTile(
                label: 'Cargo',
                value: userRole != null ? userRole!.name : 'Carregando...',
              ),
              const SizedBox(height: 16),
              const Text(
                  'Algum dado errado? Contate um administrador para alterar'),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => logout(context),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(width: 2, color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const SizedBox(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent),
                  ),
                ),
              ),
            ],
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}

class FieldTile extends StatelessWidget {
  const FieldTile({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 205, 206, 209),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: Colors.black),
          ),
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
