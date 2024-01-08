import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<User?> signupwithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Error");
    }
    return null;
  }

  Future<User?> signInwithEmailandPassword(
      String email, String password) async {
    try {
      print('i m here');
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print(credential);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    return null;
  }
}
