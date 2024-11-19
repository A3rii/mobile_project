import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Signup method
  Future<void> signup({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account with this email already exists.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      } else {
        message = 'An unexpected error occurred. Please try again.';
      }
      throw Exception(message); // Throw the error to be caught in the UI layer
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        message = 'Invalid Credential.';
      } else {
        message = 'An unexpected error occurred. Please try again.';
      }
      throw Exception(message); // Throw the error to be caught in the UI layer
    }
  }

  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(e); // Throw the error to be caught in the UI layer
    }
  }
}
