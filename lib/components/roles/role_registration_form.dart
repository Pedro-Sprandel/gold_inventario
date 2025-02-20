import 'package:flutter/material.dart';
import 'package:goldinventory/components/button.dart';
import 'package:goldinventory/components/input.dart';
import 'package:goldinventory/components/switch_tile.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/services/locations.dart';
import 'package:goldinventory/services/roles.dart';
import 'package:goldinventory/utils/snack_bar.dart';
import 'package:multiselect/multiselect.dart';

class RoleRegistrationForm extends StatefulWidget {
  const RoleRegistrationForm({super.key});

  @override
  State<RoleRegistrationForm> createState() => _RoleRegistrationFormState();
}

class _RoleRegistrationFormState extends State<RoleRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  bool _canCreate = false;
  bool _canEdit = false;
  bool _canChangeStatus = false;
  bool _canConfigure = false;
  bool _canControlUsers = false;

  List<Location> locations = [];
  List<Location> selectedLocations = [];

  void _onClickSignNewRole(BuildContext context) async {
    if (_formKey.currentState?.validate() != true) return;
    if (selectedLocations.isEmpty) {
      return showSnackbar(context, false, 'Selecione ao menos uma localidade');
    }

    Role data = Role(
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

    Response response = await registerRole(data);

    if (!context.mounted) return;

    showSnackbar(context, response.success, response.message);

    if (response.success) {
      Navigator.pop(context, 'completed');
    }
  }

  void onChangedSelect(List<String> values) async {
    Response response = await getLocationsByName(values);

    if (response.success) {
      setState(() {
        selectedLocations = response.data;
      });
    } else if (mounted) {
      showSnackbar(context, false, response.message);
    }
  }

  void loadLocations() async {
    Response response = await getLocations(context, getAll: true);

    if (response.success) {
      List<Location> allLocations = response.data;
      setState(() {
        locations = allLocations;
      });
    } else if (mounted) {
      showSnackbar(context, false, 'Erro: ${response.message}');
    }
  }

  @override
  void initState() {
    super.initState();
    loadLocations();
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
          const SizedBox(height: 16),
          Button(
            text: 'Cadastrar',
            color: const Color.fromARGB(255, 255, 255, 8),
            onPressed: (context) => _onClickSignNewRole(context),
          )
        ],
      ),
    );
  }
}
