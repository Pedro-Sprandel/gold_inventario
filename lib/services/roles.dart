import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goldinventory/models/response.dart';

class Role {
  String id;
  String name;
  List<dynamic> locations;
  Map<String, bool> permissions;

  Role({
    this.id = "",
    required this.name,
    required this.locations,
    required this.permissions,
  });

  factory Role.fromMap(Map<String, dynamic> map, String uid) {
    return Role(
      id: uid,
      name: map['name'] ?? '',
      locations: map['locations'],
      permissions: Map<String, bool>.from(map['permissions'] ?? {}).map(
        (key, value) => MapEntry(key, value),
      ),
    );
  }
}

Future<Response> getRoles() async {
  try {
    CollectionReference rolesRef =
        FirebaseFirestore.instance.collection('roles');

    QuerySnapshot snapshot = await rolesRef.get();

    List<Role> roles = snapshot.docs
        .map((doc) => Role.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    return Response(data: roles, success: true);
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

Future<Response> getRolesNames(BuildContext context) async {
  try {
    CollectionReference rolesRef =
        FirebaseFirestore.instance.collection('roles');

    QuerySnapshot snapshot = await rolesRef.get();

    List<String> names =
        snapshot.docs.map((doc) => doc['name'] as String).toList();

    return Response(data: names, success: true);
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

Future<Response> registerRole(Role data) async {
  try {
    await FirebaseFirestore.instance.collection('roles').doc().set({
      'name': data.name,
      'permissions': data.permissions,
      'locations': data.locations,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return Response(success: true, message: "Cargo criado com sucesso");
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: ${e.message}');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Response> updateRole(Role updatedData) async {
  try {
    await FirebaseFirestore.instance
        .collection('roles')
        .doc(updatedData.id)
        .update(
      {
        'name': updatedData.name,
        'permissions': updatedData.permissions,
        'locations': updatedData.locations
      },
    );

    return Response(success: true, message: 'Cargo atualizado com sucesso!');
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: ${e.message}');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Response> deleteRole(String id) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: getRef('roles', id))
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return Response(
        success: false,
        message:
            'Não é possível deletar. Existem usuários associados a este cargo.',
      );
    }

    await FirebaseFirestore.instance.collection('roles').doc(id).delete();

    return Response(success: true, message: 'Cargo deletado com sucesso');
  } on FirebaseException catch (e) {
    String message;

    if (e.code == 'permission-denied') {
      message = 'Você não tem permissão para excluir este cargo.';
    } else if (e.code == 'not-found') {
      message = 'Cargo não encontrado.';
    } else if (e.code == 'unavailable') {
      message = 'O serviço do Firestore está temporariamente indisponível.';
    } else {
      message = 'Erro ao excluir o cargo: ${e.message}';
    }

    return Response(success: false, message: message);
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido $e');
  }
}

Future<Response> getRoleById(String id) async {
  try {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('roles').doc(id).get();

    return Response(
      success: true,
      data: Role.fromMap(snapshot.data() as Map<String, dynamic>, id),
    );
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: ${e.message}');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

DocumentReference getRef(String collection, String uid) {
  DocumentReference docRef =
      FirebaseFirestore.instance.collection(collection).doc(uid);

  return docRef;
}
