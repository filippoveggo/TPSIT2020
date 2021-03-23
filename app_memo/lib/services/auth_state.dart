import 'package:app_memo/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthState {
  final authService = AuthService();
  final googleSignIn = GoogleSignIn(scopes: ['email']);

  Stream<User> get currentUser => authService.currentUser;

  loginGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      //Firebase Sig-in
      final result = await authService.signInWithGoogle(credential);
      print('${result.user.displayName}');

    } catch (e) {
      print(e);
    }

  }

  logout() {
    authService.logout();
  }

}