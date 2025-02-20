import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:goldinventory/services/roles.dart';
import 'package:goldinventory/services/users.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  Role? _role;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? get user => _user;
  Role? get role => _role;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          _user = UserModel.fromMap(
              userDoc.data() as Map<String, dynamic>, userDoc.id);

          DocumentSnapshot roleDoc =
              await _firestore.collection('roles').doc(_user!.role.id).get();

          _role =
              Role.fromMap(roleDoc.data() as Map<String, dynamic>, roleDoc.id);
        }
      } catch (e) {
        print("Erro ao carregar usuário: $e");
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  bool canChangeStatus() {
    return _role?.permissions['canChangeStatus'] ?? false;
  }

  bool canConfigure() {
    return _role?.permissions['canConfigure'] ?? false;
  }

  bool canControlUsers() {
    return _role?.permissions['canControlUsers'] ?? false;
  }

  bool canCreate() {
    return _role?.permissions['canCreate'] ?? false;
  }

  bool canEdit() {
    return _role?.permissions['canEdit'] ?? false;
  }
}
