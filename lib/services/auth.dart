import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/providers/user_provider.dart';
import 'package:goldinventory/utils/snack_bar.dart';
import 'package:provider/provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

User? getCurrentUser() {
  return _auth.currentUser;
}

Future<Response> signIn(
    BuildContext context, String email, String password) async {
  try {
    UserCredential response = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (context.mounted) {
      await Provider.of<UserProvider>(context, listen: false).loadUser();
    }

    String userId = response.user?.uid ?? '';

    if (userId.isNotEmpty) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        String? status = userDoc['status'] as String?;
        if (status != 'active') {
          await _auth.signOut();
          if (context.mounted) {
            showSnackbar(context, false,
                'Sua conta está inativa. Entre em contato com o suporte.');
          }
          return Response(
            success: false,
            message: 'Sua conta está inativa. Entre em contato com o suporte.',
          );
        }
      } else {
        await _auth.signOut();
        if (context.mounted) {
          showSnackbar(
              context, false, 'Usuário não encontrado no banco de dados.');
        }
        return Response(
          success: false,
          message: 'Usuário não encontrado no banco de dados.',
        );
      }
    }

    return Response(success: true, data: response.user?.uid);
  } on FirebaseAuthException catch (e) {
    String errorMessage;

    switch (e.code) {
      case 'invalid-email':
        errorMessage = 'O endereço de email é inválido.';
        break;
      case 'user-not-found':
        errorMessage =
            'Usuário não encontrado. Verifique o email e tente novamente.';
        break;
      case 'invalid-credential':
        errorMessage = 'Senha incorreta. Tente novamente.';
        break;
      case 'user-disabled':
        errorMessage = 'Esta conta foi desativada.';
        break;
      case 'too-many-requests':
        errorMessage =
            'Muitas tentativas de login. Tente novamente mais tarde.';
        break;
      case 'operation-not-allowed':
        errorMessage = 'Login com email e senha não está habilitado.';
        break;
      default:
        errorMessage = 'Erro ao fazer login. Tente novamente mais tarde.';
    }

    return Response(success: false, message: errorMessage);
  }
}

void logout(BuildContext context) async {
  await _auth.signOut();

  if (context.mounted) {
    Provider.of<UserProvider>(context, listen: false).clearUser();
  }
}
