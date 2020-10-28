import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool _buttonPressed = false;

  List colors = [Colors.red, Colors.green, Colors.yellow];
  Random random = new Random();

  Future<int> randomColors() async {
    Random rnd = Random();
    int s = 200 + rnd.nextInt(500);
    int index;
    await Future.delayed(
        Duration(milliseconds: s), () => index = rnd.nextInt(3));
    return index;
  }

  Stream<int> changeColors() async* {
    while (_buttonPressed) {
      yield await randomColors();
    }
  }

  Future<int> randomColorToGuess() async {
    Random rnd = Random();
    int s = 200 + rnd.nextInt(500);
    int index;
    //await if () {
      
    //};
    return index;
  }

  Stream<int> colorToGuess() async* {
    while (_buttonPressed) {
      yield await randomColorToGuess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Clock",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder(
                  stream: colorToGuess(),
                  initialData: 1,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    return Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: new BoxDecoration(
                        color: colors[snapshot.data],
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Column(
                    children: [
                      Text(
                        "Score",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25.0),
                      ),
                      Text(
                        "1",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: StreamBuilder(
                      stream: changeColors(),
                      initialData: 1,
                      builder:
                          (BuildContext context, AsyncSnapshot<int> snapshot) {
                        return Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: new BoxDecoration(
                            color: colors[snapshot.data],
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  StreamBuilder(
                    stream: changeColors(),
                    initialData: 1,
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      return Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: new BoxDecoration(
                          color: colors[snapshot.data],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: StreamBuilder(
                      stream: changeColors(),
                      initialData: 1,
                      builder:
                          (BuildContext context, AsyncSnapshot<int> snapshot) {
                        return Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: new BoxDecoration(
                            color: colors[snapshot.data],
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  StreamBuilder(
                    stream: changeColors(),
                    initialData: 1,
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      return Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: new BoxDecoration(
                          color: colors[snapshot.data],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.deepPurple,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.play_arrow, color: Colors.white),
                    onPressed: () {
                      changeColors();
                      setState(() {
                        _buttonPressed = true;
                      });
                    },
                  ),
                ),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.pause, color: Colors.grey[700]),
                    onPressed: () => setState(() {
                      _buttonPressed = false;
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ); //
  }
}
