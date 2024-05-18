import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cmsc_23_project/api/firebase_auth_api.dart';

class UserAuthProvider with ChangeNotifier {
  late Stream<User?> _userStream;
  late FirebaseAuthApi authService;

  UserAuthProvider() {
    authService = FirebaseAuthApi();
    _userStream = authService.fetchUser();
  }

  Stream<User?> get userStream => _userStream;
  User? get user => authService.getUser();

  Future<void> signUp(String email, String password) async {
    await authService.signUp(email, password);
  }

  Future<String> signIn(String email, String password) async {
    try {
      await authService.signIn(email, password);
      return "Success";
    } on FirebaseException catch (e) {
      return "Error: ${e.code} : ${e.message}";
    } catch (e) {
      return "Error : $e";
    }
  }

  Future<void> signOut() async {
    await authService.signOut();
  }
}
