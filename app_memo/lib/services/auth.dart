import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInEmailPassword({
    @required emailText,
    @required passText,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: emailText, password: passText);
      User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
    }
  }
}
