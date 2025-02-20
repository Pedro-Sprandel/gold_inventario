import 'package:cloud_firestore/cloud_firestore.dart';

String getFormattedDate(Timestamp timestamp) {
  final DateTime dateTime = timestamp.toDate();

  final String day = dateTime.day.toString().padLeft(2, '0');
  final String month = dateTime.month.toString().padLeft(2, '0');
  final String year = dateTime.year.toString();
  final String hour = dateTime.hour.toString().padLeft(2, '0');
  final String minute = dateTime.minute.toString().padLeft(2, '0');

  return '$day/$month/$year - $hour:$minute';
}
