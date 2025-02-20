import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goldinventory/models/response.dart';

class UserModel {
  String id;
  final String name;
  final String email;
  final String phone;
  final DocumentReference role;
  final String status;

  UserModel({
    this.id = "",
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      id: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? '',
      status: map['status'] ?? '',
    );
  }
}

Future<Response> getUsers(BuildContext context) async {
  try {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');

    QuerySnapshot snapshot = await usersRef.get();

    List<UserModel> users = snapshot.docs
        .map((doc) =>
            UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    return Response(data: users, success: true);
  } on FirebaseException catch (e) {
    String message;
    if (e.code == 'permission-denied') {
      message = 'Você não tem permissão para listar usuários.';
    } else if (e.code == 'unavailable') {
      message =
          'O Serviço firestore está fora do ar, aguarde e tente novamente';
    } else if (e.code == 'not-found') {
      message = 'Não foi possível encontrar os dados';
    } else {
      message = 'Erro desconhecido: ${e.message}';
    }

    return Response(success: false, message: message);
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Response> registerUser(UserModel data, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: data.email,
      password: password,
    );

    String uid = userCredential.user!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': data.name,
      'email': data.email,
      'phone': data.phone,
      'role': data.role,
      'status': data.status,
    });

    return Response(success: true, message: 'Usuário cadastrado com sucesso!');
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      return Response(success: false, message: 'Este e-mail já está em uso.');
    } else {
      return Response(success: false, message: 'Erro: ${e.message}');
    }
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Response> updateUser(UserModel updatedData) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(updatedData.id)
        .update({
      'name': updatedData.name,
      'email': updatedData.email,
      'phone': updatedData.phone,
      'role': updatedData.role,
      'status': updatedData.status,
    });

    return Response(success: true, message: 'Usuário atualizado com sucesso!');
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: ${e.message}');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Response> activateUser(String id) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(id).update(
      {'status': 'active'},
    );

    return Response(success: true, message: 'Usuário ativado com sucesso');
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: ${e.message}');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Response> deactivateUser(String id) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(id).update(
      {'status': 'inactive'},
    );

    return Response(success: true, message: 'Usuário desativado com sucesso');
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: ${e.message}');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}
