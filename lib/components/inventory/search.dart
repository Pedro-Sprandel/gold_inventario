import 'dart:async';
import 'package:flutter/material.dart';
import 'package:goldinventory/components/itemTypes/filter_type_select.dart';
import 'package:goldinventory/components/locations/filter_location_select.dart';
import 'package:goldinventory/components/status/filter_status_select.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/services/locations.dart';
import 'package:goldinventory/services/status.dart';
import 'package:goldinventory/services/types.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Search extends StatefulWidget {
  const Search({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSelectType,
    required this.onSelectLocation,
    required this.onSelectStatus,
    required this.clearFilters,
  });

  final TextEditingController controller;
  final Function(String) onChanged;
  final Function(ItemType) onSelectType;
  final Function(Location) onSelectLocation;
  final Function(Status) onSelectStatus;
  final VoidCallback clearFilters;

  @override
  State<Search> createState() => SearchState();
}

class SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  Status? _selectedStatus;
  List<Status> _statuses = [];

  ItemType? _selectedType;
  List<ItemType> _types = [];

  Location? _selectedLocation;
  List<Location> _locations = [];

  void _onChange(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      widget.onChanged(value);
    });
  }

  void _onRemoveText() {
    _controller.text = "";
  }

  void loadTypes() async {
    Response response = await getTypes();

    if (response.success) {
      setState(() {
        _types = response.data;
      });
    }
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
        _statuses = response.data;
      });
    }
  }

  void _onClearFilters() {
    widget.clearFilters();
    setState(() {
      _selectedStatus = null;
      _selectedType = null;
      _selectedLocation = null;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTypes();
    loadLocations();
    loadStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: const Color.fromARGB(255, 205, 206, 209),
            ),
            child: TextField(
              controller: _controller,
              onChanged: (value) => _onChange(value),
              decoration: InputDecoration(
                hintText: 'Pesquise aqui...',
                contentPadding: const EdgeInsets.only(top: 12, left: 20),
                border: InputBorder.none,
                suffixIcon: TextButton(
                  onPressed: _onRemoveText,
                  child: const FaIcon(
                    FontAwesomeIcons.x,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FilterTypeSelect(
              options: _types,
              value: _selectedType,
              onSelect: (ItemType type) {
                widget.onSelectType(type);
                setState(() {
                  _selectedType = type;
                });
              },
            ),
            FilterLocationSelect(
              options: _locations,
              value: _selectedLocation,
              onSelect: (Location location) {
                widget.onSelectLocation(location);
                setState(() {
                  _selectedLocation = location;
                });
              },
            ),
            FilterStatusSelect(
              options: _statuses,
              value: _selectedStatus,
              onSelect: (Status status) {
                widget.onSelectStatus(status);
                setState(() {
                  _selectedStatus = status;
                });
              },
            ),
            TextButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Color.fromARGB(255, 205, 206, 209),
                ),
                overlayColor: WidgetStatePropertyAll(Colors.transparent),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                ),
                minimumSize: WidgetStatePropertyAll(Size(72, 28)),
              ),
              onPressed: _onClearFilters,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Limpar',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 12),
                  FaIcon(FontAwesomeIcons.x, color: Colors.black, size: 10),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
