import 'dart:async';

import 'package:app_memo/login_page.dart';
import 'package:app_memo/services/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<User> loginStateSubscription;

  @override
  void initState() {
    AuthState authState = Provider.of<AuthState>(context, listen: false);
    loginStateSubscription = authState.currentUser.listen((event) {
      if (event == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginPage(),
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
      appBar: AppBar(
        title: Text(
          'App Memo',
          style: TextStyle(
            color: Color.fromRGBO(35, 31, 32, 1.0),
          ),
        ),
        backgroundColor: Color.fromRGBO(104, 225, 253, 1.0),
        actions: [
          StreamBuilder<User>(
            stream: authState.currentUser,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              return Row(
                children: [
                  TextButton(
                    onPressed: () => authState.logout(),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(35, 31, 32, 1.0),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(104, 225, 253, 1.0)),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          snapshot.data.photoURL.replaceAll('s96', 's400')),
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
