import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goldinventory/components/button.dart';
import 'package:goldinventory/components/image_picker_button.dart';
import 'package:goldinventory/components/input.dart';
import 'package:goldinventory/components/itemTypes/type_select.dart';
import 'package:goldinventory/components/locations/location_select.dart';
import 'package:goldinventory/components/status/status_select.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/providers/user_provider.dart';
import 'package:goldinventory/services/items.dart';
import 'package:goldinventory/services/locations.dart';
import 'package:goldinventory/services/status.dart';
import 'package:goldinventory/services/types.dart';
import 'package:goldinventory/utils/snack_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ItemRegistrationForm extends StatefulWidget {
  const ItemRegistrationForm({super.key});

  @override
  State<ItemRegistrationForm> createState() => ItemRegistrationFormState();
}

class ItemRegistrationFormState extends State<ItemRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final picker = ImagePicker();

  List<Location> _locations = [];
  Location? _selectedLocation;

  List<Status> _status = [];
  Status? _selectedStatus;

  List<ItemType> _types = [];
  ItemType? _selectedType;

  File? _selectedImage;
  String? _fileName;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadLocations();
    loadStatus();
    loadTypes();
  }

  void loadLocations() async {
    Response response = await getLocations(context);

    if (response.success) {
      setState(() {
        _locations = response.data;
      });
    }
  }

  void loadStatus() async {
    Response response = await getStatus();

    if (response.success) {
      setState(() {
        _status = response.data;
      });
    }
  }

  void loadTypes() async {
    Response response = await getTypes();

    if (response.success) {
      setState(() {
        _types = response.data;
      });
    }
  }

  void _onSelectLocation(Location value) {
    setState(() {
      _selectedLocation = value;
    });
  }

  void _onSelectStatus(Status value) {
    setState(() {
      _selectedStatus = value;
    });
  }

  void _onSelectType(ItemType value) {
    setState(() {
      _selectedType = value;
    });
  }

  void _onSubmitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() {
      isLoading = true;
    });

    final serverTimestamp = Timestamp.now();

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    Item data = Item(
      name: _nameController.text,
      code: _codeController.text,
      location: _selectedLocation,
      status: _selectedStatus,
      type: _selectedType,
      image: _fileName,
      activityHistory: [
        Activity(
          action: 'create',
          performedBy: userProvider.user?.name ?? "Anônimo",
          timestamp: serverTimestamp,
        )
      ],
    );

    Response response = await addItem(data, _selectedImage);

    if (!context.mounted) return;

    setState(() {
      isLoading = false;
    });

    showSnackbar(context, response.success, response.message);

    if (response.success) {
      Navigator.pop(context, 'completed');
    }
  }

  void _onPressedImagePicker() async {
    Response response = await selectImage();

    if (mounted && !response.success) {
      showSnackbar(context, false, response.message);
    }

    setState(() {
      _selectedImage = response.data['file'];
      _fileName = response.data['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Input(label: 'Nome*', controller: _nameController, isRequired: true),
          const SizedBox(height: 16),
          Input(
              label: 'Código*', controller: _codeController, isRequired: true),
          const SizedBox(height: 16),
          LocationSelect(
            options: _locations,
            value: _selectedLocation,
            onSelect: (value) => _onSelectLocation(value),
          ),
          const SizedBox(height: 16),
          StatusSelect(
            options: _status,
            value: _selectedStatus,
            onSelect: (value) => _onSelectStatus(value),
          ),
          const SizedBox(height: 16),
          TypesSelect(
            options: _types,
            value: _selectedType,
            onSelect: (value) => _onSelectType(value),
          ),
          const SizedBox(height: 16),
          ImagePickerButton(
            fileName: _fileName,
            image: _selectedImage,
            onPressed: _onPressedImagePicker,
          ),
          const SizedBox(height: 16),
          isLoading
              ? const CircularProgressIndicator()
              : Button(
                  text: 'Cadastrar',
                  color: const Color.fromARGB(255, 255, 255, 8),
                  onPressed: (context) => {
                    setState(() {
                      isLoading = true;
                    }),
                    _onSubmitForm(context),
                    setState(() {
                      isLoading = false;
                    }),
                  },
                ),
        ],
      ),
    );
  }
}
