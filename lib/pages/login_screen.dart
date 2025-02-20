import 'package:flutter/material.dart';
import 'package:goldinventory/components/input.dart';
import 'package:goldinventory/components/password_input.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/providers/user_provider.dart';
import 'package:goldinventory/services/auth.dart';
import 'package:goldinventory/utils/snack_bar.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _onSignIn(BuildContext context) async {
    Response response = await signIn(
      context,
      _emailController.text,
      _passwordController.text,
    );

    if (!context.mounted) return;

    if (!response.success) {
      Provider.of<UserProvider>(context, listen: false).clearUser();
    }

    showSnackbar(context, false, response.message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 229, 230, 240),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Input(
                label: 'Email',
                controller: _emailController,
                isEmail: true,
                isRequired: true,
              ),
              const SizedBox(height: 16),
              PasswordInput(controller: _passwordController, isRequired: true),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: TextButton(
                  onPressed: () => _onSignIn(context),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 8),
                    side: const BorderSide(width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 12, 12, 12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Não tem conta? Solicite a um administrador.',
                  style: TextStyle(
                      fontSize: 12, color: Color.fromARGB(255, 12, 12, 12))),
            ],
          ),
        ),
      ),
    );
  }
}
