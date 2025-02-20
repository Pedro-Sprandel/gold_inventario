import 'package:flutter/material.dart';
import 'package:goldinventory/components/inventory/search.dart';
import 'package:goldinventory/components/inventory/inventory_list.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/pages/inventory/item_screen.dart';
import 'package:goldinventory/services/items.dart';
import 'package:goldinventory/services/locations.dart';
import 'package:goldinventory/services/status.dart';
import 'package:goldinventory/services/types.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key, required this.listKey, this.qrCode});

  final GlobalKey listKey;
  final String? qrCode;

  @override
  State<Inventory> createState() => InventoryState();
}

class InventoryState extends State<Inventory> {
  final TextEditingController _searchController = TextEditingController();
  String? _searchText;
  ItemType? _typeFilter;
  Location? _locationFilter;
  Status? _statusFilter;

  void _onChangeSearchText(value) {
    setState(() {
      _searchText = value;
    });
  }

  void _onSelectType(ItemType value) {
    setState(() {
      _typeFilter = value;
    });
  }

  void _onSelectLocation(Location value) {
    setState(() {
      _locationFilter = value;
    });
  }

  void _onSelectStatus(Status status) {
    setState(() {
      _statusFilter = status;
    });
  }

  void _clearFilters() {
    setState(() {
      _typeFilter = null;
      _locationFilter = null;
      _statusFilter = null;
    });
  }

  void processQrCode(qr) async {
    Response response = await getItemByCode(qr);

    if (response.success) {
      if (response.data is List) {
        _searchController.text = qr;
      } else if (response.data is Map && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemScreen(item: response.data),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.qrCode == null) return;
    processQrCode(widget.qrCode);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Search(
          controller: _searchController,
          onChanged: _onChangeSearchText,
          onSelectType: _onSelectType,
          onSelectLocation: _onSelectLocation,
          onSelectStatus: _onSelectStatus,
          clearFilters: _clearFilters,
        ),
        InventoryList(
          key: widget.listKey,
          searchText: _searchText,
          typeFilter: _typeFilter,
          locationFilter: _locationFilter,
          statusFilter: _statusFilter,
        ),
      ],
    );
  }
}
