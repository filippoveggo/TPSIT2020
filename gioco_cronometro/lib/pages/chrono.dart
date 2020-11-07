import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChronoPage extends StatefulWidget {
  const ChronoPage({Key key}) : super(key: key);

  @override
  _ChronoPageState createState() => _ChronoPageState();
}

class _ChronoPageState extends State<ChronoPage> {
  bool _enable = true;
  bool _buttonPressed = false;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';
  int counter = 0;

  Stream<int> timedCounter() async* {
    Duration interval = Duration(seconds: 1);
    while (_buttonPressed) {
      await Future.delayed(interval);
      secondsStr = ((counter % 60)).floor().toString().padLeft(2, '0');
      minutesStr = ((counter / 60) % 60).floor().toString().padLeft(2, '0');
      hoursStr =
          ((counter / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
      yield counter++;
    }
  }

  @override
  Widget build(BuildContext context) {
    var _startOnPressed;
    var _resetOnPressed;
    var _pauseButtonPressed;

    if (_enable) {
      _startOnPressed = () {
        setState(() {
          _buttonPressed = true;
          _enable = !_enable;
        });
      };
    } else {
      _pauseButtonPressed = () {
        setState(() {
          _buttonPressed = false;
          _enable = !_enable;
        });
      };
    }
    _resetOnPressed = () {
      setState(() {
        if (!_enable) {
          _enable = !_enable;
        }
        _buttonPressed = false;
        counter = 0;
        hoursStr = '00';
        minutesStr = '00';
        secondsStr = '00';
      });
    };
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
          Spacer(),
          Center(
            child: Column(
              children: [
                StreamBuilder(
                  stream: timedCounter(),
                  initialData: 0,
                  builder:
                      (BuildContext context, AsyncSnapshot<int> snapshot) {
                    return Text(
                      "$hoursStr:$minutesStr:$secondsStr",
                      style: TextStyle(
                        fontSize: 90.0,
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 8.0),
                        onPressed: _startOnPressed,
                        color: Colors.indigo,
                        child: Text(
                          'START',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      //SizedBox(width: 40.0),
                      RaisedButton(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 8.0),
                        onPressed: _resetOnPressed,
                        color: Color.fromRGBO(69, 123, 157, 1.0),
                        child: Text(
                          'RESET',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      //SizedBox(width: 40.0),
                      RaisedButton(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 8.0),
                        onPressed: _pauseButtonPressed,
                        color: Color.fromRGBO(230, 57, 70, 1.0),
                        child: Text(
                          'PAUSE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
