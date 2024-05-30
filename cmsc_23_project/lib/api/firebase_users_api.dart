import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class FirebaseUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> addUser(Map<String, dynamic> user) async {
    try {
      await db.collection("users").add(user);

      return "Successfully added!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllUsers() {
    return db.collection("users").snapshots();
  }

  Future<String> deleteUser(String id) async {
    try {
      await db.collection("users").doc(id).delete();

      return "Successfully deleted!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Future<String> addDonationToUser(String userId, String donationId) async {
    try {
      await db.collection("users").doc(userId).update({
        'listDonations': FieldValue.arrayUnion([donationId])
      });
      return "Successfully added donation to user!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Future<String> getOrgId(String userId) async {
    try {
      DocumentSnapshot docSnapshot =
          await db.collection("users").doc(userId).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data =
            docSnapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('orgDetails')) {
          return data['orgDetails']['reference'];
        } else {
          return "User is not an organization";
        }
      }
      return 'not found';
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Future<String?> uploadImage(File file, String folderPath) async {
    try {
      String fileName = Path.basename(file.path);
      Reference ref = storage.ref('org_proof_of_legitimacy/$fileName');
      if (folderPath == 'donations') {
        ref = storage.ref('donations/$fileName');
      }

      await ref.putFile(file);
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } on FirebaseException catch (e) {
      print('Error occurred while uploading the file: $e');
      return null;
    }
  }

  Future<void> addImageReference(String url, String fileName) async {
    try {
      await db.collection('images').add({
        'url': url,
        'fileName': fileName,
      });
    } catch (e) {
      print('Error occurred while adding the reference to Firestore: $e');
    }
  }
}
