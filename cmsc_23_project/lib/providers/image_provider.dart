import 'dart:io';

import 'package:cmsc_23_project/api/firebase_users_api.dart';
import 'package:flutter/material.dart';

//provider for uploading images
class ImageUploadProvider extends ChangeNotifier {
  late FirebaseUserAPI firebaseService;

  ImageUploadProvider() {
    firebaseService = FirebaseUserAPI();
  }

  Future<String> uploadImage(File image, String folderPath) async {
    String? message = await firebaseService.uploadImage(image, folderPath);
    print(message);
    notifyListeners();
    return message ?? "Error uploading image";
  }
}
