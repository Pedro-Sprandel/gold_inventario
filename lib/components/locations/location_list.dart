import 'package:flutter/material.dart';
import 'package:goldinventory/components/list_card.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/pages/locations/location_screen.dart';
import 'package:goldinventory/services/locations.dart';

class LocationList extends StatefulWidget {
  const LocationList({super.key});

  @override
  State<LocationList> createState() => LocationListState();
}

class LocationListState extends State<LocationList> {
  List<Location> _locations = [];

  @override
  void initState() {
    super.initState();
    loadLocations();
  }

  void loadLocations() async {
    Response response = await getLocations(context);

    if (response.success) {
      setState(() {
        _locations = response.data;
      });
    }
  }

  void _onClickLocation(Location location) {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LocationScreen(location: location)))
        .then((value) => {
              if (value == 'completed') {loadLocations()}
            });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._locations.map(
          (location) => Column(
            children: [
              ListCard(
                onPressed: () => _onClickLocation(location),
                child: Text(
                  location.name,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 12)
            ],
          ),
        )
      ],
    );
  }
}
