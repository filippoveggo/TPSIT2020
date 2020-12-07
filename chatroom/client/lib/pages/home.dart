import 'dart:async';
import 'dart:io';

import 'package:chatroom/pages/chat_users.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage() : super();

  static const String ROUTE_ID = 'home_screen';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _usernameController;
  Socket socket;
  List messages;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatroom"),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6.0),
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(20.0),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            OutlineButton(
              child: Text("Login"),
              onPressed: () {
                _loginBtnTap();
              },
            ),
          ],
        ),
      ),
    );
  }

  _loginBtnTap() {
    if (_usernameController.text.isEmpty) {
      return;
    }
    _startClient();
  }

  _openChatUsers(context) async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatUsersScreen(
          username: _usernameController.text,
          socket: socket, 
          messages: messages,
        ),
      ),
    );
  }

  _startClient() {
    print("Siamo fuori");
    Socket.connect('10.0.2.2', 4567).then((Socket sock) {
      socket = sock;
      socket.listen(
        dataHandler,
        onError: errorHandler,
        onDone: doneHandler,
        cancelOnError: false,
      );
      _openChatUsers(context);
    }).catchError((e) {
      print("Unable to connect: $e");
    });
    //  stdin.listen(
    //      (data) => socket.write(new String.fromCharCodes(data).trim() + '\n'));
  }

  void dataHandler(data) {
    print(String.fromCharCodes(data).trim());
    messages.add(String.fromCharCodes(data).trim());
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void doneHandler() {
    socket.destroy();
    exit(0);
  }
}
