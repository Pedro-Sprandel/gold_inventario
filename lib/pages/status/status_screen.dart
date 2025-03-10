import 'package:flutter/material.dart';
import 'package:goldinventory/components/back_button_top_bar.dart';
import 'package:goldinventory/components/status/status_list.dart';
import 'package:goldinventory/pages/status/sign_new_status_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StatusScreen extends StatelessWidget {
  StatusScreen({super.key});

  final GlobalKey<StatusListState> _statusListKey =
      GlobalKey<StatusListState>();

  void _onClickSignNewStatus(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignNewStatusScreen(),
      ),
    ).then(
      (value) => {
        if (value == 'completed') {_statusListKey.currentState?.loadStatus()}
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Status', style: TextStyle(fontSize: 20)),
                  TextButton(
                    onPressed: () => _onClickSignNewStatus(context),
                    style: TextButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
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
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              StatusList(key: _statusListKey),
            ],
          ),
        ),
      ),
    );
  }
}
