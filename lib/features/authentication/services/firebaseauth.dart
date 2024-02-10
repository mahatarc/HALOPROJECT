import 'package:cloud_firestore/cloud_firestore.dart';
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



// Function to update user role in Firestore
Future<void> updateUserRole(String userId, String newRole) async {
  try {
    // Get reference to the user document in Firestore
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    // Update the role field
    await userRef.update({'role': newRole});
  } catch (error) {
    // Handle error
    print('Error updating user role: $error');
    throw error; // Throw error to handle it in the calling function
  }
}

