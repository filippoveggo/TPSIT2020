import 'dart:async';

import 'package:app_memo/features/home/home_page.dart';
import 'package:app_memo/services/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  StreamSubscription<User> loginStateSubscription;

  @override
  void initState() {
    AuthState authState = Provider.of<AuthState>(context, listen: false);
    loginStateSubscription = authState.currentUser.listen((event) {
      if (event != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    loginStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 4.0),
                child: Text(
                  'App Memo',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(35, 31, 32, 1.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Custodisci i tuoi memo',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.normal,
                    color: Color.fromRGBO(35, 31, 32, 0.7),
                  ),
                ),
              ),
              AspectRatio(
                child: SvgPicture.asset('./assets/illustrations/Reading.svg'),
                aspectRatio: 1.0,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('LOGIN', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.black,
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(104, 225, 253, 1.0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                  ),
                  onPressed: () => authState.loginGoogle(),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    //return SafeArea(
    //  child: Scaffold(
    //    body: Column(
    //      children: [
    //        TextField(
    //          controller: emailText,
    //          keyboardType: TextInputType.emailAddress,
    //        ),
    //        TextField(
    //          controller: passText,
    //          obscureText: true,
    //        ),
    //        ElevatedButton(
    //          child: Container(
    //            height: 50.0,
    //            child: Center(
    //              child: Text('Login'),
    //            ),
    //          ),
    //          onPressed: () async {
    //            dynamic result = await _auth.signInEmailPassword(
    //                emailText: emailText.text, passText: passText.text);
    //            if (result == null) {
    //              print('error');
    //            } else {
    //              print('Succes');
    //              print(result);
    //            }
    //          },
    //        ),
    //      ],
    //    ),
    //  ),
    //);
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
