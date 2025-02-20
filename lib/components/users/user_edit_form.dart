import 'package:flutter/material.dart';
import 'package:goldinventory/components/input.dart';
import 'package:goldinventory/components/roles/role_select.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/providers/user_provider.dart';
import 'package:goldinventory/services/roles.dart';
import 'package:goldinventory/utils/snack_bar.dart';
import 'package:goldinventory/services/users.dart';
import 'package:provider/provider.dart';

class UserEditForm extends StatefulWidget {
  final UserModel user;

  const UserEditForm({super.key, required this.user});

  @override
  State<UserEditForm> createState() => _UserEditFormState();
}

class _UserEditFormState extends State<UserEditForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  Role? _selectedRole;
  List<Role> _roles = [];
  bool isActive = true;

  Future<Role?> getUserRole(String id) async {
    Response response = await getRoleById(id);

    if (response.success) {
      return Role(
        id: response.data?.id,
        name: response.data?.name,
        locations: response.data?.locations,
        permissions: response.data?.permissions,
      );
    } else if (mounted) {
      showSnackbar(context, false, 'Erro ao carregar cargo do usuário');
    }

    return null;
  }

  void onLoad() async {
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _selectedRole = await getUserRole(widget.user.role.id);
    isActive = widget.user.status == 'active';

    loadRoles();
  }

  @override
  void initState() {
    super.initState();
    onLoad();
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

  void changeSelectedRole(Role role) {
    _selectedRole = role;
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() != true ||
        !_roles.contains(_selectedRole)) return;

    UserModel data = UserModel(
      id: widget.user.id,
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      role: getRef('roles', _selectedRole!.id),
      status: widget.user.status,
    );

    Response response = await updateUser(data);

    if (!context.mounted) return;

    showSnackbar(context, response.success, response.message);

    if (response.success) {
      Navigator.pop(context, 'completed');
    }
  }

  void _onChangeUserStatus(BuildContext context) async {
    Response response;

    if (isActive) {
      response = await deactivateUser(widget.user.id);
    } else {
      response = await activateUser(widget.user.id);
    }

    if (!context.mounted) return;

    showSnackbar(context, response.success, response.message);

    setState(() {
      isActive = !isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final bool canDeactivate = userProvider.user?.id != widget.user.id;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Input(label: "Nome", controller: _nameController, isRequired: true),
          const SizedBox(height: 16),
          Input(label: "Email", controller: _emailController, isRequired: true),
          const SizedBox(height: 16),
          Input(
            label: "Telefone",
            controller: _phoneController,
            isRequired: true,
          ),
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
                'Salvar',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 12, 12, 12)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (canDeactivate)
            SizedBox(
              width: double.infinity,
              height: 46,
              child: TextButton(
                onPressed: () => _onChangeUserStatus(context),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: BorderSide(
                      width: 2,
                      color: isActive ? Colors.redAccent : Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  isActive ? 'Desativar usuário' : 'Ativar usuário',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.redAccent : Colors.blue,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 4),
          if (canDeactivate)
            const Text(
              'Usuários desativados não poderão entrar no sistema.',
              style: TextStyle(fontSize: 12),
            ),
        ],
      ),
    );
  }
}
