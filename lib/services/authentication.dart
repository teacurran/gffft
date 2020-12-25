import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  User getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<void> sendPhoneVerification(String phoneNumber);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;
    return user.uid;
  }

  User getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendPhoneVerification(String phoneNumber) async {
    _firebaseAuth.verifyPhoneNumber(phoneNumber: phoneNumber,
        timeout: new Duration(seconds: 60),
        codeSent: (String code, [int _code]) {
          print(code);
          print(_code);
        },
        verificationCompleted: (AuthCredential credentials) {
          print(credentials);
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception.message);
        },
        codeAutoRetrievalTimeout: (String c) {
          print(c);
        }
      );
  }

  Future<void> sendEmailVerification() async {
    getCurrentUser().sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    getCurrentUser().emailVerified;
  }
}
