import 'package:flutter/material.dart';
import 'package:goldinventory/components/inventory/item_card.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/providers/user_provider.dart';
import 'package:goldinventory/services/items.dart';
import 'package:goldinventory/services/locations.dart';
import 'package:goldinventory/services/status.dart';
import 'package:goldinventory/services/types.dart';
import 'package:goldinventory/utils/snack_bar.dart';
import 'package:provider/provider.dart';

class InventoryList extends StatefulWidget {
  const InventoryList({
    super.key,
    required this.searchText,
    required this.typeFilter,
    required this.locationFilter,
    required this.statusFilter,
  });

  final String? searchText;
  final ItemType? typeFilter;
  final Location? locationFilter;
  final Status? statusFilter;

  @override
  State<InventoryList> createState() => InventoryListState();
}

class InventoryListState extends State<InventoryList> {
  List<Item> _items = [];
  List<Item> _filteredItems = [];

  bool _isLoading = true;

  void loadInventory() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    Response response = await getItems(userProvider.role!.locations);

    if (response.success && mounted) {
      setState(() {
        _items = response.data;
        _filterItems();
      });
    } else if (mounted) {
      showSnackbar(context, false, response.message);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _filterItems() {
    setState(() {
      final searchLower = widget.searchText?.toLowerCase() ?? '';

      _filteredItems = _items.where((item) {
        final matchesSearch = widget.searchText == null ||
            item.name.toLowerCase().contains(searchLower) ||
            item.code.toLowerCase().contains(searchLower);

        final matchesType = widget.typeFilter == null ||
            item.type?.name == widget.typeFilter?.name;

        final matchesLocation = widget.locationFilter == null ||
            item.location?.name == widget.locationFilter?.name;

        final matchesStatus = widget.statusFilter == null ||
            item.status?.name == widget.statusFilter?.name;

        return matchesSearch && matchesType && matchesLocation && matchesStatus;
      }).toList();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadInventory();
  }

  @override
  void didUpdateWidget(covariant InventoryList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if ((oldWidget.searchText != widget.searchText) ||
        (oldWidget.locationFilter != widget.locationFilter) ||
        (oldWidget.typeFilter != widget.typeFilter) ||
        (oldWidget.statusFilter != widget.statusFilter)) {
      _filterItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return _isLoading
            ? const Padding(
                padding: EdgeInsets.only(top: 48),
                child: CircularProgressIndicator(),
              )
            : _filteredItems.isNotEmpty
                ? Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double spacing = constraints.maxWidth < 400 ? 8 : 32;
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: spacing,
                            mainAxisSpacing: spacing,
                            childAspectRatio: 0.95,
                          ),
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            return ItemCard(
                              item: _filteredItems[index],
                              onReload: loadInventory,
                            );
                          },
                        );
                      },
                    ),
                  )
                : const Center(
                    child: Text('Nenhum item encontrado'),
                  );
      },
    );
  }
}
