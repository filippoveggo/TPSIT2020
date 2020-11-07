import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key key}) : super(key: key);

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  // valore del counter per il timer
  int counter = 0;

  // valori per il picker iniziale
  String _hours = '00';
  String _minutes = '00';
  String _seconds = '00';

  bool _showPicker = true;

  StreamSubscription _timerStreamSubscription;

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
          Spacer(),
          buildTimer(),
          Spacer(),
        ],
      ),
    );
  }

  Center buildTimer() {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_showPicker)
                CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hms,
                  onTimerDurationChanged: (value) {
                    setState(() {
                      counter = value.inSeconds;
                      print(counter);
                    });
                  },
                ),
              if (!_showPicker)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '$_hours' + " hours ",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                      child: Text(
                        '$_minutes' + " min. ",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '$_seconds' + " sec.",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
            ],
          ),
          SizedBox(
            height: 100.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: _startTimer,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.pause,
                  color: Color.fromRGBO(230, 57, 70, 1.0),
                ),
                onPressed: _pauseTimer,
              ),
              Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(230, 57, 70, 1.0),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.restore,
                    color: Colors.white,
                  ),
                  onPressed: _resetTimer,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Stream<int> get timerStream async* {
    // durata di ogni 'tick'
    Duration interval = Duration(seconds: 1);

    while (true) {
      if (counter > 0) {
        yield counter;
        await Future.delayed(interval);
        yield counter--;
      } else {
        _showPicker = true;
        break;
      }
    }
  }

  /// Fa partire il timer, imposta la variabile button pressed a true
  void _startTimer() {
    _showPicker = false;
    _timerStreamSubscription = timerStream.listen((event) {
      setState(() {
        setState(() {
          _hours =
              ((counter / (60 * 60)) % 60).floor().toString().padLeft(2, '0');

          _minutes = ((counter / 60) % 60).floor().toString().padLeft(2, '0');

          _seconds = ((counter % 60)).floor().toString().padLeft(2, '0');
        });
      });
    });

    setState(() {
      _hours = '00';
      _minutes = '00';
      _seconds = '00';
    });
  }

  /// Resetta il timer, imposta tutte le sue variabili ai valori iniziali
  void _resetTimer() {
    _showPicker = true;
    _timerStreamSubscription.cancel();

    setState(() {
      _hours = '00';
      _minutes = '00';
      _seconds = '00';
      counter = 0;
    });
  }

  void _pauseTimer() {
    if (_timerStreamSubscription.isPaused) {
      _timerStreamSubscription.resume();
    } else {
      _timerStreamSubscription.pause();
    }
  }
}
