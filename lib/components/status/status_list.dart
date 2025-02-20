import 'package:flutter/material.dart';
import 'package:goldinventory/components/list_card.dart';
import 'package:goldinventory/components/status/status_tag.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/pages/status/status_edit_screen.dart';
import 'package:goldinventory/services/status.dart';

class StatusList extends StatefulWidget {
  const StatusList({super.key});

  @override
  State<StatusList> createState() => StatusListState();
}

class StatusListState extends State<StatusList> {
  List<Status> _status = [];

  @override
  void initState() {
    super.initState();
    loadStatus();
  }

  void loadStatus() async {
    Response response = await getStatus();

    if (response.success) {
      setState(() {
        _status = response.data;
      });
    }
  }

  void _onClickStatus(Status status) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StatusEditScreen(
          status: status,
        ),
      ),
    ).then(
      (value) => {
        if (value == 'completed') {loadStatus()}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._status.map(
          (status) => Column(
            children: [
              ListCard(
                child: StatusTag(
                  text: status.name,
                  backgroundColor: Color(status.backgroundColor),
                  textColor: Color(status.textColor),
                ),
                onPressed: () => _onClickStatus(status),
              ),
              const SizedBox(height: 12),
            ],
          ),
        )
      ],
    );
  }
}
