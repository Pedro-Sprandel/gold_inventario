import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> isFieldUnique(
    String collection, String fieldName, String value) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection(collection)
      .where(fieldName, isEqualTo: value)
      .get();

  return querySnapshot.docs.isEmpty;
}
