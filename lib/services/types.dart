import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goldinventory/models/response.dart';

class ItemType {
  final String id;
  final String name;

  const ItemType({
    this.id = "",
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory ItemType.fromMap(Map<String, dynamic> map, String uid) {
    return ItemType(id: uid, name: map['name']);
  }
}

Future<Response> getTypes() async {
  try {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('types').get();

    List<ItemType> data = snapshot.docs
        .map((doc) =>
            ItemType.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    return Response(success: true, data: data);
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: $e');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Response> addNewType(String name) async {
  try {
    await FirebaseFirestore.instance.collection('types').doc().set(
      {'name': name},
    );

    return Response(success: true, message: 'Tipo adicionado com sucesso');
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: $e');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Response> updateType(ItemType data) async {
  try {
    await FirebaseFirestore.instance.collection('types').doc(data.id).update(
      {'name': data.name},
    );

    return Response(
      success: true,
      message: 'Tipo de equipamento atualizado com sucesso',
    );
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: $e');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Response> deleteType(String id) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('items')
        .where('type', isEqualTo: id)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return Response(
        success: false,
        message:
            'Não é possível deletar. Existem itens associados a este tipo.',
      );
    }

    await FirebaseFirestore.instance.collection('types').doc(id).delete();

    return Response(
      success: true,
      message: 'Tipo de equipamento deletado com sucesso',
    );
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: $e');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<ItemType?> getTypeById(String id) async {
  try {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('types').doc(id).get();

    ItemType status = ItemType.fromMap(doc.data() as Map<String, dynamic>, id);

    return status;
  } catch (e) {
    return null;
  }
}
