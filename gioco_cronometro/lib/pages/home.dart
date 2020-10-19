import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _buttonPressed = false;

  List colors = [Colors.red, Colors.green, Colors.yellow];
  Random random = new Random();

  int index = 0;

  Future<int> randomColors() async {
    Random rnd = Random();
    int s = 200 + rnd.nextInt(500);
    await Future.delayed(Duration(milliseconds: s), () => index = rnd.nextInt(3));
    return index;
  }

  Stream<int> changeColors() async* {
    while (_buttonPressed) {
      yield await randomColors();
    }
  }

 //void startChangingColors() {
 //  Random rnd = new Random();
 //}


 //void changeColors() {
 //  setState(() => index = random.nextInt(3));
 //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
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
          Spacer(),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 300.0,
                  height: 300.0,
                  decoration: new BoxDecoration(
                    color: colors[index],
                    shape: BoxShape.circle,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 40.0, 0.0),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: Colors.red,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.play_arrow, color: Colors.white),
                              onPressed: () => changeColors(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40.0, 50.0, 0.0, 0.0),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.pause, color: Colors.grey[700]),
                              onPressed: () => {_buttonPressed = true},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    ); //
  }
}
