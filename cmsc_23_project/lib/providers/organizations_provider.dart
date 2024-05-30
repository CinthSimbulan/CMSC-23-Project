import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc_23_project/api/firebase_org_api.dart';
import 'package:cmsc_23_project/models/donation_model.dart';
import 'package:cmsc_23_project/models/organization_model.dart';
import 'package:cmsc_23_project/models/users_model.dart';
import 'package:flutter/material.dart';
import '../api/firebase_users_api.dart';

class OrganizationProvider extends ChangeNotifier {
  // FirebaseUserAPI firebaseService = FirebaseUserAPI();
  late FirebaseOrgAPI firebaseService;
  late Stream<QuerySnapshot> _orgsStream;

  OrganizationProvider() {
    firebaseService = FirebaseOrgAPI();
    fetchOrgs();
  }
  // getter
  Stream<QuerySnapshot> get org => _orgsStream;

  // void fetchOrgs() {
  //   _orgsStream = firebaseService.getAllOrg();

  //   notifyListeners();
  // }

  Future<Map<String, dynamic>> fetchOrgs() async {
    Map<String, dynamic> orgs = await firebaseService.fetchAllOrg();
    print(orgs);
    notifyListeners();
    return orgs;
  }

  Future<String> addOrg(Organization org) async {
    String message = await firebaseService.addOrg(
      org.toJson(org),
    );
    print(message);

    notifyListeners();
    return message;
  }

  Future<String> addDonation(String orgId, Donations donation) async {
    String message =
        await firebaseService.addDonation(orgId, donation.toJson(donation));
    print(message);
    notifyListeners();
    return (message);
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

  void deleteOrg(String id) async {
    await firebaseService.deleteOrg(id);
    notifyListeners();
  }

  // void toggleStatus(String id, bool status) async {
  //   await firebaseService.toggleStatus(id, status);
  //   notifyListeners();
  // }
}
