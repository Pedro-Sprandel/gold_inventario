import 'package:flutter/material.dart';
import 'package:goldinventory/components/list_card.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/pages/itemTypes/type_edit_screen.dart';
import 'package:goldinventory/services/types.dart';

class TypesList extends StatefulWidget {
  const TypesList({super.key});

  @override
  State<TypesList> createState() => TypesListState();
}

class TypesListState extends State<TypesList> {
  List<ItemType> types = [];

  @override
  void initState() {
    super.initState();
    loadTypes();
  }

  void loadTypes() async {
    Response response = await getTypes();

    if (response.success) {
      setState(() {
        types = response.data;
      });
    }
  }

  void _onClickType(ItemType type) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TypeEditScreen(type: type),
      ),
    ).then(
      (value) => {
        if (value == 'completed') {loadTypes()}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...types.map(
          (type) => Column(
            children: [
              ListCard(
                onPressed: () => _onClickType(type),
                child: Text(
                  type.name,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 12,
              )
            ],
          ),
        )
      ],
    );
  }
}
