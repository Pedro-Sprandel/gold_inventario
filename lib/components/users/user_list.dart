import 'package:flutter/material.dart';
import 'package:goldinventory/components/list_card.dart';
import 'package:goldinventory/pages/users/user_screen.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/services/users.dart';
import 'package:goldinventory/utils/snack_bar.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => UserListState();
}

class UserListState extends State<UserList> {
  List<UserModel> _users = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void loadUsers() async {
    Response usersResponse = await getUsers(context);

    if (!usersResponse.success) {
      if (!mounted) return;

      showSnackbar(context, false, usersResponse.message);
    } else {
      setState(() {
        _users = usersResponse.data;
      });
    }
  }

  void _onClickUser(UserModel user) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => UserScreen(user: user))).then(
      (result) {
        if (result == 'completed') {
          loadUsers();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ..._users.map((UserModel user) => Column(children: [
            ListCard(
              onPressed: () => _onClickUser(user),
              child: Text(
                user.name,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 12)
          ]))
    ]);
  }
}
