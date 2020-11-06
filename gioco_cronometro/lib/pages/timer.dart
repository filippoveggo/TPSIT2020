import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:numberpicker/numberpicker.dart';

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
    int _currentValue = 1;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          NumberPicker.integer(
              initialValue: _currentValue,
              minValue: 0,
              maxValue: 100,
              onChanged: (newValue) =>
                  setState(() => _currentValue = newValue)),
          Text("Current number: $_currentValue"),
        ],
      ),
    );
  }
}
