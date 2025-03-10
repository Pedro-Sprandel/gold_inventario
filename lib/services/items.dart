import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:goldinventory/models/response.dart';
import 'package:goldinventory/services/locations.dart';
import 'package:goldinventory/services/status.dart';
import 'package:goldinventory/services/types.dart';
import 'package:image_picker/image_picker.dart';

class Activity {
  final String action;
  final String performedBy;
  final String? observation;
  final Timestamp timestamp;
  final Map<String, dynamic>? details;

  Activity({
    required this.action,
    required this.performedBy,
    required this.timestamp,
    this.details,
    this.observation,
  });

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'performedBy': performedBy,
      'timestamp': timestamp,
      'details': details,
      'observation': observation,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      action: map['action'],
      performedBy: map['performedBy'],
      timestamp: map['timestamp'],
      details: map['details'],
      observation: map['observation'],
    );
  }
}

class Item {
  final String? id;
  final String name;
  final String code;
  final dynamic location;
  final dynamic status;
  final dynamic type;
  final String? image;
  List<Activity> activityHistory;

  Item({
    this.id,
    required this.name,
    required this.code,
    this.location,
    this.status,
    this.type,
    this.image,
    required this.activityHistory,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'location': location,
      'status': status,
      'type': type,
      'image': image,
      'activityHistory': activityHistory.map((e) => e.toMap()).toList()
    };
  }

  factory Item.fromMap(Map<String, dynamic> map, String uid) {
    return Item(
      id: uid,
      name: map['name'],
      code: map['code'],
      location: map['location'],
      status: map['status'],
      type: map['type'],
      image: map['image'],
      activityHistory: map['activityHistory'] != null
          ? List<Activity>.from(
              map['activityHistory'].map(
                (e) => Activity(
                  action: e['action'],
                  performedBy: e['performedBy'],
                  timestamp: e['timestamp'],
                  details: e['details'],
                ),
              ),
            )
          : [],
    );
  }
}

Future<Response> getItems(List<dynamic>? locations) async {
  try {
    CollectionReference itemsRef =
        FirebaseFirestore.instance.collection('items');
    late QuerySnapshot snapshot;

    if (locations != null) {
      snapshot = await itemsRef.where('location', whereIn: locations).get();
    } else {
      snapshot = await itemsRef.get();
    }

    List<Item> items = await Future.wait(snapshot.docs.map((data) async {
      Map<String, dynamic> itemData = data.data() as Map<String, dynamic>;

      final locationResponse =
          await getLocationById(itemData['location'] ?? "");
      final statusResponse = await getStatusById(itemData['status'] ?? "");
      final typeResponse = await getTypeById(itemData['type'] ?? "");

      return Item(
        id: data.id,
        name: itemData['name'],
        code: itemData['code'],
        location: locationResponse,
        status: statusResponse,
        type: typeResponse,
        image: itemData['image'],
        activityHistory: itemData['activityHistory'] != null
            ? List<Activity>.from(
                itemData['activityHistory'].map((e) => Activity.fromMap(e)))
            : [],
      );
    }).toList());

    return Response(success: true, data: items);
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: ${e.message}');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Response> selectImage() async {
  final picker = ImagePicker();

  try {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return Response(success: false, message: 'Imagem inválida');
    }

    File imageFile = File(pickedFile.path);

    return Response(
      success: true,
      data: {'file': imageFile, 'name': pickedFile.name},
    );
  } catch (e) {
    return Response(success: false, message: e.toString());
  }
}

Future<Response> addItem(Item data, File? imageFile) async {
  try {
    String? imageUrl;

    if (imageFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${data.name}${data.code}.jpg');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
      imageUrl = await snapshot.ref.getDownloadURL();
    }

    await FirebaseFirestore.instance.collection('items').doc().set(
      {
        'name': data.name,
        'code': data.code,
        'location': data.location?.id,
        'status': data.status?.id,
        'type': data.type?.id,
        'image': imageUrl,
        'activityHistory': data.activityHistory.map((e) => e.toMap()).toList(),
      },
    );

    return Response(success: true, message: 'Item adicionado com sucesso');
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: ${e.message}');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Response> updateItem(Item data, File? imageFile) async {
  try {
    String? imageUrl = data.image;

    if (imageFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${data.name}${data.code}.jpg');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
      imageUrl = await snapshot.ref.getDownloadURL();
    }

    Map<String, dynamic> newData = {
      'name': data.name,
      'code': data.code,
      'location': data.location?.id,
      'status': data.status?.id,
      'type': data.type?.id,
      'image': imageUrl,
      'activityHistory': data.activityHistory.map((e) => e.toMap()).toList(),
    };

    await FirebaseFirestore.instance
        .collection('items')
        .doc(data.id)
        .update(newData);

    return Response(
        success: true, message: 'Item atualizado com sucesso', data: newData);
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: ${e.message}');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Response> deleteItem(String id) async {
  try {
    await FirebaseFirestore.instance.collection('items').doc(id).delete();

    return Response(success: true, message: 'Item deletado com sucesso');
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: ${e.message}');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Response> getItemById(String id) async {
  try {
    final snapshot =
        await FirebaseFirestore.instance.collection('items').doc(id).get();

    final Map<String, dynamic>? item = snapshot.data();

    if (item == null) {
      return Response(success: false, message: 'Item nulo');
    }

    return Response(success: true, data: item);
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: ${e.message}');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}

Future<Response> getItemByCode(String code) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('items')
        .where('code', isEqualTo: code)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return Response(
          success: false, message: 'Produto de código $code não encontrado');
    }

    final Map<String, dynamic> itemData = querySnapshot.docs.first.data();

    final locationResponse = await getLocationById(itemData['location'] ?? "");
    final statusResponse = await getStatusById(itemData['status'] ?? "");
    final typeResponse = await getTypeById(itemData['type'] ?? "");

    return Response(
      success: true,
      data: Item(
        name: itemData['name'],
        code: itemData['code'],
        activityHistory: itemData['activityHistory'] != null
            ? List<Activity>.from(
                itemData['activityHistory'].map((e) => Activity.fromMap(e)))
            : [],
        image: itemData['image'],
        location: locationResponse,
        status: statusResponse,
        type: typeResponse,
      ),
    );
  } on FirebaseException catch (e) {
    return Response(success: false, message: 'Erro: ${e.message}');
  } catch (e) {
    return Response(success: false, message: 'Erro desconhecido: $e');
  }
}
