import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_users_api.dart';

class UsersListProvider with ChangeNotifier {
  FirebaseUserAPI firebaseService = FirebaseUserAPI();
  late Stream<QuerySnapshot> _usersStream;

  UsersListProvider() {
    fetchUsers();
  }
  // getter
  Stream<QuerySnapshot> get user => _usersStream;

  void fetchUsers() {
    _usersStream = firebaseService.getAllUsers();
    notifyListeners();
  }

  // void addTodo(Todo item) async {
  //   String message = await firebaseService.addTodo(item.toJson(item));
  //   print(message);
  //   notifyListeners();
  // }

  // void editTodo(String id, String newTitle) async {
  //   await firebaseService.editTodo(id, newTitle);
  //   notifyListeners();
  // }

  void deleteUser(String id) async {
    await firebaseService.deleteUser(id);
    notifyListeners();
  }

  // void toggleStatus(String id, bool status) async {
  //   await firebaseService.toggleStatus(id, status);
  //   notifyListeners();
  // }
}
