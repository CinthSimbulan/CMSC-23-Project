import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthApi {
  late FirebaseAuth authService;
  FirebaseAuthApi() {
    authService = FirebaseAuth.instance;
  }

  Stream<User?> fetchUser() {
    return authService.authStateChanges();
  }

  User? getUser() {
    return authService.currentUser;
  }

  Future<String> signUp(String email, String password) async {
    try {
      await authService.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Success";
    } on FirebaseException catch (e) {
      return ('${e.message}');
      // print('Firebase Exception: ${e.code} : ${e.message}');
    } catch (e) {
      return ('Error 001: $e');
      // print('Error 001: $e');
    }
  }

  Future<String> signIn(String email, String password) async {
    try {
      await authService.signInWithEmailAndPassword(
          email: email, password: password);
      return "Success";
    } on FirebaseException catch (e) {
      return ('Firebase Exception: ${e.code} : ${e.message}');
    } catch (e) {
      return ('Error 001: $e');
    }
  }

  Future<void> signOut() async {
    await authService.signOut();
  }
}
