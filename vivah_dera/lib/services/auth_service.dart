import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw 'Google Sign In was cancelled';

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw 'Failed to sign in with Google: ${e.toString()}';
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.status != LoginStatus.success) {
        throw 'Facebook Sign In was cancelled or failed';
      }

      final OAuthCredential credential = FacebookAuthProvider.credential(
        loginResult.accessToken?.toString() ??
            '', // Convert AccessToken to string
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw 'Failed to sign in with Facebook: ${e.toString()}';
    }
  }
}
