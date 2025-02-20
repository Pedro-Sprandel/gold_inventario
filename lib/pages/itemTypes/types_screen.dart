import 'package:flutter/material.dart';
import 'package:goldinventory/components/back_button_top_bar.dart';
import 'package:goldinventory/components/itemTypes/types_list.dart';
import 'package:goldinventory/pages/itemTypes/add_new_type_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TypesScreen extends StatelessWidget {
  TypesScreen({super.key});

  final GlobalKey<TypesListState> _typesListKey = GlobalKey<TypesListState>();

  void _onClickAddNewType(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTypeScreen(),
      ),
    ).then((value) => {
          if (value == 'completed') {_typesListKey.currentState?.loadTypes()}
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 60, left: 24, bottom: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BackButtonTopBar(),
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Tipos de equipamento',
                  style: TextStyle(fontSize: 20)),
              TextButton(
                  onPressed: () => _onClickAddNewType(context),
                  style: TextButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.onPrimaryContainer),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Cadastrar novo',
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
            TypesList(key: _typesListKey),
          ],
        ),
      ),
    );
  }
}
