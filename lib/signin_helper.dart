import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';

const USER_ID = 'USER_ID';
const USER_NAME = 'USER_NAME';
const USER_EMAIL = 'USER_EMAIL';
// const USER_PHONE = 'USER_PHONE';
const USER_IMG = 'USER_IMG';

class GoogleSignInHelper {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign In process
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        // User canceled the sign-in process
        return null;
      }

      // Obtain GoogleSignInAuthentication object
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      // Create GoogleAuthCredential using the obtained authentication object
      final googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // Sign in to Firebase using GoogleAuthCredential
      final UserCredential authResult =
          await _auth.signInWithCredential(googleAuthCredential);

      return authResult.user;
    } catch (error) {
      // Handle errors
      print("Google Sign-In Error: $error");
      return null;
    }
  }

  Future<void> signOut() async {
    EasyLoading.show(status: 'Signing out');
    await _googleSignIn.signOut();
    await _auth.signOut();
    EasyLoading.dismiss();
  }

  bool isUserLoggedIn() {
    final user = _auth.currentUser;

    return user != null;
  }

  Future<User?> getUserData() async {
    return _auth.currentUser;
  }
}
