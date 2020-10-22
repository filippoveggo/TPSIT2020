import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
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
          //Spacer(),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_buttonPressed)
                StreamBuilder(
                  stream: changeColors(),
                  initialData: null,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    return Container(
                      width: 300.0,
                      height: 300.0,
                      decoration: BoxDecoration(
                        color: colors[snapshot.data],
                        shape: BoxShape.circle,
                      ),
                    );
                  },
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
                              onPressed: () {
                                changeColors();
                                setState(() {
                                  _buttonPressed = false;
                                });
                              },
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
                              onPressed:() => setState((){
                                _buttonPressed = true;
                              })
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
          //Spacer(),
        ],
      ),
    ); //
  }
}
