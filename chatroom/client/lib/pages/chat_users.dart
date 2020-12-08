import 'dart:convert';
import 'dart:io';
import 'package:bubble/bubble.dart';
import 'package:chatroom/models/message_model.dart';
import 'package:flutter/material.dart';

class ChatUsersScreen extends StatefulWidget {
  final String username;

  ChatUsersScreen({Key key, @required this.username}) : super(key: key);

  @override
  _ChatUsersScreenState createState() => _ChatUsersScreenState();
}

class _ChatUsersScreenState extends State<ChatUsersScreen> {
  TextEditingController _messageController;
  Socket _socket;
  List<MessageModel> _messages = [];
  bool _loading = true;

  BubbleStyle _styleSomebody = BubbleStyle(
    nip: BubbleNip.leftTop,
    color: Colors.white,
    margin: BubbleEdges.only(top: 8.0, right: 50.0),
    alignment: Alignment.topLeft,
  );

  BubbleStyle _styleMe = BubbleStyle(
    nip: BubbleNip.rightTop,
    color: Color.fromARGB(255, 225, 255, 199),
    margin: BubbleEdges.only(top: 8.0, left: 50.0),
    alignment: Alignment.topRight,
  );

  @override
  void initState() {
    super.initState();
    _startClient();
    _messageController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    _chatList(),
                    _bottomChatArea(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _chatList() {
    return Expanded(
      child: Container(
        child: ListView.builder(
          cacheExtent: 100,
          reverse: false,
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          itemCount: _messages.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildSingleMessage(index);
          },
        ),
      ),
    );
  }

  Widget _bottomChatArea() {
    return Container(
      child: Row(
        children: <Widget>[
          _chatTextArea(),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.teal[900],
            ),
            onPressed: () async {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }

  Widget _chatTextArea() {
    return Expanded(
      child: TextField(
        controller: _messageController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.teal[900],
              width: 0.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.teal[900],
              width: 2.0,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(10.0),
          hintText: 'Type message...',
        ),
      ),
    );
  }

  _sendMessage() {
    final message = MessageModel(
        username: widget.username, content: _messageController.text);
    _socket.write(message.toJson());
    this.setState(() => _messages.add(message));
    _messageController.clear();
  }

  Widget _buildSingleMessage(int index) {
    return widget.username == _messages[index].username
        ? Bubble(
            style: _styleMe,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _messages[index].content,
                ),
              ],
            ),
          )
        : Bubble(
            style: _styleSomebody,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _messages[index].username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _messages[index].content,
                ),
              ],
            ),
          );
  }

  _startClient() {
    Socket.connect('10.0.2.2', 4567).then((Socket sock) {
      _socket = sock;
      _socket.listen(
        dataHandler,
        onError: errorHandler,
        onDone: doneHandler,
        cancelOnError: false,
      );
      setState(() {
        _loading = false;
      });
    }).catchError((e) {
      print("Unable to connect: $e");
    });
  }

  void dataHandler(data) {
    print(String.fromCharCodes(data).trim());
    setState(() {
      _messages.add(
          MessageModel.fromJson(jsonDecode(String.fromCharCodes(data).trim())));
    });
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void doneHandler() {
    _socket.destroy();
  }
}
