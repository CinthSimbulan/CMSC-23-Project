import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseOrgAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addOrg(
    Map<String, dynamic> org,
  ) async {
    try {
      DocumentReference orgDoc = await db.collection("organizations").add(org);
      return orgDoc.id; //id of the organization
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

  //Add image reference to the donation details
  Future<String> addImageToDonation(String orgId, String donationId) async {
    try {
      //get reference to the image in the 'donations' folder
      firebase_storage.Reference storageRef =
          firebase_storage.FirebaseStorage.instance.ref().child('donations');
      //get the url of the image
      String url = await storageRef.getDownloadURL();

      //update the donation details with the url of the image
      await db
          .collection("organizations")
          .doc(orgId)
          .collection("donations")
          .doc(donationId)
          .update({"details.photo": url});

      return "Photo Reference Successfully added!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }
}
