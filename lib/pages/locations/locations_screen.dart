import 'package:flutter/material.dart';
import 'package:goldinventory/components/back_button_top_bar.dart';
import 'package:goldinventory/components/locations/location_list.dart';
import 'package:goldinventory/pages/locations/add_new_location_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LocationsScreen extends StatelessWidget {
  LocationsScreen({super.key});
  final GlobalKey<LocationListState> _locationListKey =
      GlobalKey<LocationListState>();

  void _onClickAddNewLocation(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const AddNewLocationScreen())).then(
      (value) => {
        if (value == 'completed')
          {_locationListKey.currentState?.loadLocations()}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 60, left: 24, bottom: 24, right: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackButtonTopBar(),
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Localidades', style: TextStyle(fontSize: 20)),
                TextButton(
                    onPressed: () => _onClickAddNewLocation(context),
                    style: TextButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cadastrar',
                            style: TextStyle(color: Colors.white)),
                        SizedBox(width: 8),
                        FaIcon(
                          FontAwesomeIcons.plus,
                          color: Colors.white,
                          size: 16,
                        )
                      ],
                    ))
              ]),
              const SizedBox(height: 12),
              LocationList(key: _locationListKey),
            ],
          ),
        ),
      ),
    );
  }
}
