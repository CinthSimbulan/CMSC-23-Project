import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc_23_project/models/users_model.dart';
import 'package:flutter/material.dart';
import '../api/firebase_users_api.dart';

class UsersListProvider extends ChangeNotifier {
  // FirebaseUserAPI firebaseService = FirebaseUserAPI();
  late FirebaseUserAPI firebaseService;
  late Stream<QuerySnapshot> _usersStream;

  UsersListProvider() {
    firebaseService = FirebaseUserAPI();
    fetchUsers();
  }
  // getter
  Stream<QuerySnapshot> get user => _usersStream;

  void fetchUsers() {
    _usersStream = firebaseService.getAllUsers();
    notifyListeners();
  }

  void addUser(myUser user) async {
    String message = await firebaseService.addUser(user.toJson(user));
    print(message);
    notifyListeners();
  }

  void addDonationToUser(String userId, String donationId) async {
    String message =
        await firebaseService.addDonationToUser(userId, donationId);
    print(message);
    notifyListeners();
  }

  Future<String> fetchOrgId(String userId) async {
    String message = await firebaseService.getOrgId(userId);
    print(message);
    notifyListeners();
    return message;
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
