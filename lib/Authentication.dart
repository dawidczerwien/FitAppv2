import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);
  final FirebaseAuth auth = FirebaseAuth.instance;
  final referenceDatabase = FirebaseDatabase.instance;

  String inputData() {
    final User user = auth.currentUser;
    final email = user.email;
    return email;
  }

  String getUserName() {
    return auth.currentUser.email.split('@')[0];
  }

  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final ref = referenceDatabase.reference();

      ref
          .child('users')
          .child(auth.currentUser.uid)
          .set({'email': email, 'userId': auth.currentUser.uid});

      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> sendResetPasswordEmail({String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
