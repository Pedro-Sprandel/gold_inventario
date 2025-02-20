import 'package:flutter/material.dart';
import 'package:goldinventory/components/input.dart';
import 'package:goldinventory/components/roles/role_select.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/utils/generate_password.dart';
import 'package:goldinventory/components/password_input.dart';
import 'package:goldinventory/services/roles.dart';
import 'package:goldinventory/utils/snack_bar.dart';
import 'package:goldinventory/services/users.dart';

class UserRegistrationForm extends StatefulWidget {
  const UserRegistrationForm({super.key});

  @override
  State<UserRegistrationForm> createState() => _UserRegistrationFormState();
}

class _UserRegistrationFormState extends State<UserRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(
    text: generatePassword(),
  );
  final TextEditingController _phoneController = TextEditingController();

  Role? _selectedRole;
  List<Role> _roles = [];

  void changeSelectedRole(Role role) {
    _selectedRole = role;
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() != true ||
        !_roles.contains(_selectedRole)) return;

    UserModel data = UserModel(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      role: getRef('roles', _selectedRole?.id ?? ""),
      status: 'active',
    );

    Response response = await registerUser(data, _passwordController.text);

    if (!context.mounted) return;

    showSnackbar(context, response.success, response.message);

    if (response.success) {
      Navigator.pop(context, 'completed');
    }
  }

  void loadRoles() async {
    Response response = await getRoles();

    if (!response.success) {
      if (!mounted) return;

      return showSnackbar(context, false, response.message);
    }

    setState(() {
      _roles = response.data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadRoles();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          Input(label: 'Nome*', controller: _nameController, isRequired: true),
          const SizedBox(height: 16),
          Input(
              label: 'Telefone*',
              controller: _phoneController,
              isRequired: true,
              isPhone: true),
          const SizedBox(height: 16),
          Input(
              label: 'Email*',
              controller: _emailController,
              isRequired: true,
              isEmail: true),
          const SizedBox(height: 16),
          PasswordInput(
              controller: _passwordController,
              isRequired: true,
              showCopy: true,
              isObscure: false),
          const SizedBox(height: 16),
          RoleSelect(
            options: _roles,
            value: _selectedRole,
            onSelect: changeSelectedRole,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: TextButton(
              onPressed: () => _submitForm(context),
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 8),
                side: const BorderSide(width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text(
                'Cadastrar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 12, 12, 12),
                ),
              ),
            ),
          ),
        ]));
  }
}
