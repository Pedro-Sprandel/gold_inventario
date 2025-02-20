import 'package:flutter/material.dart';
import 'package:goldinventory/components/input.dart';
import 'package:goldinventory/components/switch_tile.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/providers/user_provider.dart';
import 'package:goldinventory/services/locations.dart';
import 'package:goldinventory/services/roles.dart';
import 'package:goldinventory/utils/snack_bar.dart';
import 'package:multiselect/multiselect.dart';
import 'package:provider/provider.dart';

class RoleEditForm extends StatefulWidget {
  final Role role;

  const RoleEditForm({super.key, required this.role});

  @override
  State<RoleEditForm> createState() => _RoleEditFormState();
}

class _RoleEditFormState extends State<RoleEditForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  bool _canCreate = false;
  bool _canEdit = false;
  bool _canChangeStatus = false;
  bool _canConfigure = false;
  bool _canControlUsers = false;

  List<Location> locations = [];
  List<Location> selectedLocations = [];

  void loadLocations() async {
    Response response = await getLocations(context, getAll: true);

    if (response.success) {
      List<Location> allLocations = response.data;
      List<Location> userLocations = allLocations
          .where((e) => widget.role.locations.contains(e.id))
          .toList();
      setState(() {
        locations = allLocations;
        selectedLocations = userLocations;
      });
    } else if (mounted) {
      showSnackbar(context, false, 'Erro: ${response.message}');
    }
  }

  @override
  void initState() {
    super.initState();
    loadLocations();
    _nameController = TextEditingController(text: widget.role.name);
    _canCreate = widget.role.permissions['canCreate'] ?? false;
    _canEdit = widget.role.permissions['canEdit'] ?? false;
    _canChangeStatus = widget.role.permissions['canChangeStatus'] ?? false;
    _canConfigure = widget.role.permissions['canConfigure'] ?? false;
    _canControlUsers = widget.role.permissions['canControlUsers'] ?? false;
  }

  void _submitForm(context) async {
    if (_formKey.currentState?.validate() != true) return;
    if (selectedLocations.isEmpty) {
      return showSnackbar(context, false, 'Selecione ao menos uma localidade');
    }

    Role data = Role(
      id: widget.role.id,
      name: _nameController.text,
      locations: selectedLocations.map((e) => e.id).toList(),
      permissions: {
        'canCreate': _canCreate,
        'canEdit': _canEdit,
        'canChangeStatus': _canChangeStatus,
        'canConfigure': _canConfigure,
        'canControlUsers': _canControlUsers
      },
    );

    Response response = await updateRole(data);

    if (!context.mounted) return;

    showSnackbar(context, response.success, response.message);

    if (response.success) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.loadUser();
      Navigator.pop(context, 'completed');
    }
  }

  void _onDeleteRole(BuildContext context, String uid) async {
    Response response = await deleteRole(uid);

    if (!context.mounted) return;

    showSnackbar(context, response.success, response.message);

    Navigator.pop(context);

    if (response.success) {
      Navigator.pop(context, 'completed');
    }
  }

  void showDeleteConfirmationDialog(BuildContext context, String uid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content:
              const Text('Você tem certeza de que deseja excluir este cargo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: Colors.transparent),
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                _onDeleteRole(context, uid);
              },
              style: TextButton.styleFrom(backgroundColor: Colors.redAccent),
              child:
                  const Text('Excluir', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Input(
            label: 'Nome do cargo',
            controller: _nameController,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          SwitchTile(
            title: "Criar itens",
            value: _canCreate,
            onChanged: (bool value) {
              setState(() {
                _canCreate = value;
              });
            },
          ),
          const SizedBox(height: 16),
          SwitchTile(
            title: 'Editar itens',
            value: _canEdit,
            onChanged: (bool value) {
              setState(() {
                _canEdit = value;
              });
            },
          ),
          const SizedBox(height: 16),
          SwitchTile(
            title: 'Alterar status de itens',
            value: _canChangeStatus,
            onChanged: (bool value) {
              setState(() {
                _canChangeStatus = value;
              });
            },
          ),
          const SizedBox(height: 16),
          SwitchTile(
            title: 'Configurar opções',
            value: _canConfigure,
            onChanged: (bool value) {
              setState(() {
                _canConfigure = value;
              });
            },
          ),
          const SizedBox(height: 16),
          SwitchTile(
            title: 'Controle de usuários e cargos',
            value: _canControlUsers,
            onChanged: (bool value) {
              setState(() {
                _canControlUsers = value;
              });
            },
          ),
          const SizedBox(height: 16),
          DropDownMultiSelect(
            options: locations.map((e) => e.name).toList(),
            selectedValues: selectedLocations.map((e) => e.name).toList(),
            whenEmpty: 'Selecione as localidades',
            onChanged: (List<String> x) => setState(() {
              selectedLocations = locations
                  .where((element) => x.contains(element.name))
                  .toList();
            }),
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(style: BorderStyle.none),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(style: BorderStyle.none),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 20,
              ),
            ),
          ),
          const SizedBox(height: 12),
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
          SizedBox(
            width: double.infinity,
            height: 46,
            child: TextButton(
              onPressed: () =>
                  showDeleteConfirmationDialog(context, widget.role.id),
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: const BorderSide(width: 2, color: Colors.redAccent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text(
                'Deletar cargo',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
