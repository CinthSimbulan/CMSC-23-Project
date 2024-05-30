import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseOrgAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // Future<String> addTodo(Map<String, dynamic> todo) async {
  //   try {
  //     await db.collection("todos").add(todo);

  //     return "Successfully added!";
  //   } on FirebaseException catch (e) {
  //     return "Error in ${e.code}: ${e.message}";
  //   }
  // }
  Future<String> addOrg(
    Map<String, dynamic> org,
  ) async {
    try {
      DocumentReference orgDoc = await db.collection("organizations").add(org);

      // if (donations != null) {
      //   //create a subcollection for donations within this document
      //   CollectionReference donationSubCollection =
      //       orgDoc.collection("donations");
      //   await donationSubCollection.add(null);
      // }
      return orgDoc.id; //id of the organization
      // return "Successfully added!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllOrg() {
    return db.collection("organizations").snapshots();
  }

  // get all documents in the 'organizations' collection
  Future<Map<String, dynamic>> fetchAllOrg() {
    return db.collection("organizations").doc().get().then((value) {
      return value.data() as Map<String, dynamic>;
    });
  }

  Future<String> deleteOrg(String id) async {
    try {
      await db.collection("organizations").doc(id).delete();

      return "Successfully deleted!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Future<String> addDonation(
      String orgId, Map<String, dynamic> donation) async {
    try {
      DocumentReference orgDoc = await db
          .collection("organizations")
          .doc(orgId)
          .collection("donations")
          .add(donation);

      return orgDoc.id; // id of the donation
      // return "Successfully added!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  // Future<String> editTodo(String id, String title) async {
  //   try {
  //     await db.collection("todos").doc(id).update({"title": title});

  //     return "Successfully edited!";
  //   } on FirebaseException catch (e) {
  //     return "Error in ${e.code}: ${e.message}";
  //   }
  // }

  // Future<String> toggleStatus(String id, bool value) async {
  //   try {
  //     await db.collection("todos").doc(id).update({"completed": value});

  //     return "Successfully toggled!";
  //   } on FirebaseException catch (e) {
  //     return "Error in ${e.code}: ${e.message}";
  //   }
  // }
}
