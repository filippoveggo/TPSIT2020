import 'package:app_memo/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
  }

  final AuthService _auth = AuthService();

  TextEditingController emailText = TextEditingController();
  TextEditingController passText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TextField(
              controller: emailText,
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passText,
              obscureText: true,
            ),
            RaisedButton(
              child: Container(
                height: 50.0,
                child: Center(
                  child: Text('Login'),
                ),
              ),
              onPressed: () async {
                dynamic result = await _auth.signInEmailPassword(
                    emailText: emailText.text, passText: passText.text);
                if (result == null) {
                  print('error');
                } else {
                  print('Succes');
                  print(result);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void loginUser(BuildContext context) async {
    //final User firebaseUser = (
    //  await _firebaseAuth.signInWithEmailAndPassword(email: emailText.text,
    //  password: passText.text,
    //  ).catchError((errMsg){
    //    print(errMsg);
    //  })
    //),
  }
}
