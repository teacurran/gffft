import 'package:firebase_auth/firebase_auth.dart';
import 'package:gffft/src/constants.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendSignInWithEmailLink(String email) async {

    return _auth.sendSignInLinkToEmail(
        email: email, actionCodeSettings: ActionCodeSettings(
      url: Constants.projectUrl,
      androidInstallApp: true,
      androidMinimumVersion: '21',
      androidPackageName: 'com.approachingpi.gffft',
      handleCodeInApp: true,
      iOSBundleId: 'com.approachingpi.gffft',
    ));
  }

  Future<UserCredential> signInWithEmailLink(String email, String link) async {
    return _auth.signInWithEmailLink(email: email, emailLink: link);
  }

  Future<void> verifyPhoneNumber(
      String phone,
      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
      PhoneCodeSent codeSent,
      Duration duration,
      PhoneVerificationCompleted verificationCompleted,
      PhoneVerificationFailed verificationFailed) async {
    return _auth.verifyPhoneNumber(
        phoneNumber: phone,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        codeSent: codeSent,
        timeout: duration,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed);
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    return _auth.signInWithCredential(credential);
  }

  User getCurrentUser() {
    return _auth.currentUser;
  }
}