import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Location {
  final String id;
  final String name;

  const Location({this.id = "", required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Location.fromMap(Map<String, dynamic> doc, String uid) {
    return Location(id: uid, name: doc['name']);
  }
}

Future<Response> getLocations(BuildContext context,
    {bool? getAll = false}) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  List<dynamic>? userLocations = userProvider.role?.locations;

  try {
    QuerySnapshot snapshot;

    if (getAll == true) {
      snapshot = await FirebaseFirestore.instance.collection('locations').get();
    } else {
      if (userLocations == null || userLocations.isEmpty) {
        return Response(
            success: false,
            message: 'Erro: Nenhuma localização associada ao usuário');
      }

      snapshot = await FirebaseFirestore.instance
          .collection('locations')
          .where(FieldPath.documentId, whereIn: userLocations)
          .get();
    }

    List<Location> locations = snapshot.docs
        .map((doc) =>
            Location.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    return Response(success: true, data: locations);
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: ${e.message}');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Response> addLocation(String name) async {
  try {
    await FirebaseFirestore.instance.collection('locations').doc().set(
      {'name': name},
    );

    return Response(
      success: true,
      message: 'Localidade adicionada com sucesso',
    );
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: ${e.message}');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Response> updateLocation(Location updatedLocation) async {
  try {
    await FirebaseFirestore.instance
        .collection('locations')
        .doc(updatedLocation.id)
        .update({'name': updatedLocation.name});

    return Response(
      success: true,
      message: 'Localidade atualizada com sucesso',
    );
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: ${e.message}');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Response> deleteLocation(String id) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('items')
        .where('location', isEqualTo: id)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return Response(
        success: false,
        message:
            'Não é possível deletar. Existem itens associados a esta localidade.',
      );
    }

    await FirebaseFirestore.instance.collection('locations').doc(id).delete();

    return Response(
      success: true,
      message: 'Localidade deletada com sucesso',
    );
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: ${e.message}');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Location?> getLocationById(String id) async {
  try {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('locations').doc(id).get();

    Location location =
        Location.fromMap(doc.data() as Map<String, dynamic>, id);

    return location;
  } catch (e) {
    return null;
  }
}

Future<Response> getLocationsByName(List<String> names) async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('locations')
        .where('name', whereIn: names)
        .get();

    List<Location> locations = snapshot.docs
        .map((doc) =>
            Location.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    return Response(success: true, data: locations);
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: ${e.message}');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}
