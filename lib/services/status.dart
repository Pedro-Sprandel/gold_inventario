import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goldinventory/models/response.dart';

List<Map<String, String>> stauts = [
  {'name': 'Ativo', 'cor': '#004042'},
  {'name': 'Parado', 'cor': '#004042'},
  {'name': 'Em manutenção', 'cor': '#004042'}
];

class Status {
  final String id;
  final String name;
  final int backgroundColor;
  final int textColor;

  Status({
    this.id = "",
    required this.name,
    required this.backgroundColor,
    required this.textColor,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'backgroundColor': backgroundColor,
      'textColor': textColor,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map, uid) {
    return Status(
      id: uid,
      name: map['name'],
      backgroundColor: map['backgroundColor'],
      textColor: map['textColor'],
    );
  }
}

Future<Response> getStatus() async {
  try {
    CollectionReference statusRef =
        FirebaseFirestore.instance.collection('status');

    QuerySnapshot snapshot = await statusRef.get();

    List<Status> status = snapshot.docs
        .map(
          (doc) => Status.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();

    return Response(data: status, success: true);
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: ${e.message}');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Response> addStatus(Status status) async {
  try {
    await FirebaseFirestore.instance.collection('status').doc().set(
      {
        'name': status.name,
        'backgroundColor': status.backgroundColor,
        'textColor': status.textColor
      },
    );

    return Response(success: true, message: 'Status adicionado com sucesso!');
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: ${e.message}');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Response> updateStatus(Status updatedData) async {
  try {
    await FirebaseFirestore.instance
        .collection('status')
        .doc(updatedData.id)
        .update({
      'name': updatedData.name,
      'backgroundColor': updatedData.backgroundColor,
      'textColor': updatedData.textColor,
    });

    return Response(success: true, message: 'Status atualizado com sucesso');
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: ${e.message}');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Response> deleteStatus(String id) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('items')
        .where('status', isEqualTo: id)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return Response(
        success: false,
        message:
            'Não é possível deletar. Existem itens associados a este status.',
      );
    }

    await FirebaseFirestore.instance.collection('status').doc(id).delete();

    return Response(success: true, message: 'Status deletado com sucesso');
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: ${e.message}');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Status?> getStatusById(String id) async {
  try {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('status').doc(id).get();

    Status status = Status.fromMap(doc.data() as Map<String, dynamic>, id);

    return status;
  } catch (e) {
    return null;
  }
}
