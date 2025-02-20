import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goldinventory/components/button.dart';
import 'package:goldinventory/components/status/status_select.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/providers/user_provider.dart';
import 'package:goldinventory/services/items.dart';
import 'package:goldinventory/services/status.dart';
import 'package:goldinventory/utils/snack_bar.dart';
import 'package:provider/provider.dart';

Map<String, dynamic> _generateDetails(
    Map<String, dynamic> oldData, Map<String, dynamic> newData) {
  Map<String, dynamic> changes = {};

  newData.forEach((key, newValue) {
    bool needToMap = key == 'location' || key == 'type' || key == 'status';
    var oldValue = oldData.containsKey(key) ? oldData[key] : null;

    if (oldValue != newValue) {
      changes[key] = {
        'old': needToMap && oldValue != null ? oldValue.toMap() : oldValue,
        'new': needToMap && newValue != null ? newValue.toMap() : newValue
      };
    }
  });

  return changes;
}

class ChangeStatusForm extends StatefulWidget {
  const ChangeStatusForm({super.key, required this.item});

  final Item item;

  @override
  State<ChangeStatusForm> createState() => ChangeStatusFormState();
}

class ChangeStatusFormState extends State<ChangeStatusForm> {
  final _formKey = GlobalKey<FormState>();

  List<Status> _status = [];
  Status? _selectedStatus;

  @override
  void initState() {
    super.initState();

    loadStatus();
    _selectedStatus = widget.item.status;
  }

  void loadStatus() async {
    Response response = await getStatus();

    if (response.success) {
      setState(() {
        _status = response.data;
      });
    }
  }

  void _onSelectStatus(Status value) {
    setState(() {
      _selectedStatus = value;
    });
  }

  void _onSubmitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() != true) return;

    Item current = widget.item;

    Map<String, dynamic> details = _generateDetails(current.toMap(), {
      'status': _selectedStatus,
    });

    if (details.isEmpty) {
      return showSnackbar(context, false, 'Altere algo antes de atualizar');
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    Item data = Item(
      id: widget.item.id!,
      name: widget.item.name,
      code: widget.item.code,
      location: widget.item.location,
      status: _selectedStatus,
      type: widget.item.type,
      image: widget.item.image,
      activityHistory: [
        ...current.activityHistory,
        Activity(
          action: 'update',
          performedBy: userProvider.user?.name ?? "Anônimo",
          timestamp: Timestamp.now(),
          details: details,
        ),
      ],
    );

    Response response = await updateItem(data, null);

    if (!context.mounted) return;

    showSnackbar(context, response.success, response.message);

    if (response.success) {
      Navigator.pop(context, data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          StatusSelect(
            options: _status,
            value: _selectedStatus,
            onSelect: (value) => _onSelectStatus(value),
          ),
          const SizedBox(height: 16),
          Button(
            text: 'Salvar',
            color: const Color.fromARGB(255, 255, 255, 8),
            onPressed: (context) => _onSubmitForm(context),
          )
        ],
      ),
    );
  }
}
